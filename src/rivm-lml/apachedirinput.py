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
    RIVM LML version for ApacheDirInput: check for each file is already in DB.
    """
    def __init__(self, configdict, section, produces=FORMAT.record):
        ApacheDirInput.__init__(self, configdict, section, produces)
        self.query = self.cfg.get('query')
        self.db = None

    def no_more_files(self):
        done = self.file_index == len(self.file_list) - 1

        if done is True and self.db is not None:
            self.db.disconnect()

        return done

    def filter_file(self, file_name):
        """
        Filter the file_name, e.g. to suppress reading if already present in DB.
        :param file_name:
        :return string or None:
        """
        if file_name is None:
            return None

        # Only connect once to DB
        if self.db is None:
            self.db = PostGIS(self.cfg.get_dict())
            self.db.connect()

        # Create and execure SELECT query for file_name
        query = self.query % file_name
        rowcount = self.db.execute(query)
        if rowcount > 0:
            log.info('file %s already present' % file_name)
            return None

        # Not yet present
        return file_name

