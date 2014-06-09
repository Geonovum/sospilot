# -*- coding: utf-8 -*-
#
# ApacheDirInput: access remote Apache dir over HTTP and fetch file-data from it.
#
# Author:Just van den Broecke

from stetl.util import Util, etree
from stetl.inputs.dbinput import PostgresDbInput
from stetl.packet import FORMAT
from stetl.postgis import PostGIS

from datetime import datetime

log = Util.get_log("MeasurementsDbInput")

class MeasurementsDbInput(PostgresDbInput):
    """
    Reads RIVM raw AQ/LML file data from measurementss table and converts to recordlist
    """
    def __init__(self, configdict, section):
        PostgresDbInput.__init__(self, configdict, section)
        self.progress_query = self.cfg.get('progress_query')
        self.progress_update = self.cfg.get('progress_update')
        self.db = None

    def after_chain_invoke(self, packet):
        """
        Called right after entire Component Chain invoke.
        Used to update last id of processed file record.
        """
        log.info('Updating progress table with last_id= %d' % self.last_id)
        self.db.execute(self.progress_update % self.last_id)
        self.db.commit(close=False)
        log.info('Update progress table ok')
        return True

    def read(self, packet):

        # Get last processed id of measurementss table
        rowcount = self.db.execute(self.progress_query)
        progress_rec = self.db.cursor.fetchone()
        self.last_id = progress_rec[3]
        log.info('progress record: %s' % str(progress_rec))

        # Fetch next batch of measurementss records
        measurements_recs = self.do_query(self.query % self.last_id)

        log.info('read measurements_recs: %d' % len(measurements_recs))
        # No more records to process?
        if len(measurements_recs) == 0:
            packet.set_end_of_stream()
            log.info('Nothing to do. All file_records done')
            return packet

         # Remember last id processed for next query
        self.last_id = measurements_recs[len(measurements_recs)-1].get('gid')

        packet.data = measurements_recs

        # Always stop after batch, otherwise we would continue forever
        packet.set_end_of_stream()

        return packet
