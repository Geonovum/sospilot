# -*- coding: utf-8 -*-
#
# ApacheDirInput: access remote Apache dir over HTTP and fetch file-data from it.
#
# Author:Just van den Broecke

from stetl.util import Util
from stetl.inputs.httpinput import ApacheDirInput
from stetl.packet import FORMAT
from stetl.postgis import PostGIS


log = Util.get_log("LmlApacheDirInput")

class LmlApacheDirInput(ApacheDirInput):
    """
    RIVM LML version for ApacheDirInput: adds check for each file if it is already in DB.
    """
    def __init__(self, configdict, section, produces=FORMAT.record):
        ApacheDirInput.__init__(self, configdict, section, produces)
        self.query = self.cfg.get('query')
        self.db = None

    def init(self):
        # Connect only once to DB
        log.info('Init: connect to DB')
        self.db = PostGIS(self.cfg.get_dict())
        self.db.connect()

        # Let superclass read file list from Apache URL
        ApacheDirInput.init(self)

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
        if file_name is None:
            return None

        # Populate and execute SELECT query for file_name
        query = self.query % file_name
        rowcount = self.db.execute(query)
        if rowcount > 0:
            log.info('file %s already present' % file_name)
            return None

        # Not yet present
        return file_name

