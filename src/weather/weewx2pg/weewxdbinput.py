# -*- coding: utf-8 -*-
#
# WeewxDbInput: reads raw weewx archive records from SQLite and converts to Python record array (list of dict)
#
# Author:Just van den Broecke

from stetl.util import Util
from stetl.inputs.dbinput import SqliteDbInput
from stetl.postgis import PostGIS
import time
import datetime

log = Util.get_log("WeewxDbInput")

class WeewxDbInput(SqliteDbInput):
    """
    Reads weewx raw archive records from SQLite.
    """
    def __init__(self, configdict, section):
        SqliteDbInput.__init__(self, configdict, section)
        self.progress_query = self.cfg.get('progress_query')
        self.progress_update = self.cfg.get('progress_update')

        # Connect only once to DB
        log.info('Init: connect to Postgres DB')
        self.progress_db = PostGIS(self.cfg.get_dict())
        self.progress_db.connect()

    def exit(self):
        # Disconnect from DB when done
        log.info('Exit: disconnect from DB')
        self.progress_db.disconnect()

    def after_chain_invoke(self, packet):
        """
        Called right after entire Component Chain invoke.
        Used to update last id of processed file record.
        """
        # last_datetime.datetime.fromtimestamp(self.last_id).strftime('%Y-%m-%d %H:%M:%S')
        ts_local = time.strftime("%Y-%m-%d %H:%M:%S %Z", time.localtime(self.last_id))

        log.info('Updating progress table ts_unix=%d ts_local=%s' % (self.last_id, ts_local))
        self.progress_db.execute(self.progress_update % (self.last_id, ts_local))
        self.progress_db.commit(close=False)
        log.info('Update progress table ok')
        return True

    def read(self, packet):

        # Get last processed id of archive table
        self.progress_db.execute(self.progress_query)
        progress_rec = self.progress_db.cursor.fetchone()
        self.last_id = progress_rec[3]
        log.info('progress record: %s' % str(progress_rec))

        # Fetch next batch of archive records
        archive_recs = self.do_query(self.query % self.last_id)

        log.info('read archive_recs: %d' % len(archive_recs))

        # No more records to process?
        if len(archive_recs) == 0:
            packet.set_end_of_stream()
            log.info('Nothing to do. All file_records done')
            return packet

         # Remember last id processed for next query
        self.last_id = archive_recs[len(archive_recs)-1].get('dateTime')

        packet.data = archive_recs

        # Always stop after batch, otherwise we would continue forever
        packet.set_end_of_stream()

        return packet
