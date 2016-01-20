# -*- coding: utf-8 -*-
#
# RawSensorInput: harvest raw timeseries from CityGIS Sensor REST API.
# Use PostGIS DB to track progress of harvesting.
#
# Author:Just van den Broecke

from stetl.util import Util
from stetl.inputs.httpinput import HttpInput
from stetl.packet import FORMAT
from stetl.postgis import PostGIS


log = Util.get_log("RawSensorInput")

class RawSensorInput(HttpInput):
    """
    Raw Sensor REST API (CityGIS) version for HttpInput: adds check for each file if it is already in DB.
    """
    def __init__(self, configdict, section, produces=FORMAT.record):
        HttpInput.__init__(self, configdict, section, produces)
        self.query = self.cfg.get('query')
        self.db = None

    def init(self):
        # Connect only once to DB
        log.info('Init: connect to DB')
        self.db = PostGIS(self.cfg.get_dict())
        self.db.connect()

        # Let superclass read file list from Apache URL
        HttpInput.init(self)

    def exit(self):
        # Disconnect from DB when done
        log.info('Exit: disconnect from DB')
        self.db.disconnect()

    def no_more_files(self):
        return self.file_index == len(self.file_list) - 1

    def filter_file(self, file_name):
        """
        Filter the file_name, e.g. to suppress reading if already present in DB.
        :param file_name:
        :return string or None:
        """
        if file_name is None or file_name == 'actueel.xml':
            return None

        # Populate and execute SELECT query for file_name
        query = self.query % file_name
        rowcount = self.db.execute(query)
        if rowcount > 0:
            log.info('file %s already present' % file_name)
            return None

        # Not yet present
        return file_name

