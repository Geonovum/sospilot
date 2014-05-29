# -*- coding: utf-8 -*-
#
# ApacheDirInput: access remote Apache dir over HTTP and fetch file-data from it.
#
# Author:Just van den Broecke

from stetl.util import Util, etree
from stetl.input import Input
from stetl.packet import FORMAT
from stetl.postgis import PostGIS

from datetime import datetime

log = Util.get_log("LmlFileDbInput")

class LmlFileDbInput(Input):
    """
    Reads RIVM raw AQ/LML file data from lml_files table and converts to recordlist
    """
    def __init__(self, configdict, section, produces=FORMAT.record):
        Input.__init__(self, configdict, section, produces)
        self.progress_query = self.cfg.get('progress_query')
        self.progress_update = self.cfg.get('progress_update')
        self.files_query = self.cfg.get('files_query')
        self.db = None

    def init(self):
        # Connect only once to DB
        log.info('Init: connect to DB')
        self.db = PostGIS(self.cfg.get_dict())
        self.db.connect()

    def exit(self):
        # Disconnect from DB when done
        log.info('Exit: disconnect from DB')
        self.db.disconnect()

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

        # Get last processed id of lml_files table
        rowcount = self.db.execute(self.progress_query)
        progress_rec = self.db.cursor.fetchone()
        self.last_id = progress_rec[3]
        log.info('progress record: %s' % str(progress_rec))

        # Fetch next batch of lml_files records
        lml_file_recs_len = self.db.execute(self.files_query % self.last_id)
        lml_file_recs = self.db.cursor.fetchall()
        log.info('read lml_file_recs: %d' % lml_file_recs_len)

        # No more records to process?
        if lml_file_recs_len == 0:
            packet.set_end_of_stream()
            log.info('Nothing to do. All file_records done')
            return packet

        # Process lml_files records and create recordlist
        record_list = []
        for file_rec in lml_file_recs:
            log.info('process: file_rec gid=%d file=%s' % (file_rec[0], file_rec[2]))
            self.last_id = file_rec[0]
            file_data = file_rec[3]

            # Parse file data and create a record
            xml_doc = etree.fromstring(file_data)
            measurements = xml_doc.xpath('/message/body/*')
            for measurement in measurements:
                record = dict()
                # Measurement data XML structue
                #   <meting>
                #    <datum>27/05/2014</datum>
                #    <tijd>14</tijd>
                #    <station>549</station>
                #    <component>PM10</component>
                #    <eenheid>ug/m3</eenheid>
                #    <waarde>10</waarde>
                #    <gevalideerd>0</gevalideerd>
                #   </meting>

                record['file_name'] = file_rec[2]

                # station_id variants: '318' or  'NL01485'  or 'NL49551'
                # always take last three digits?
                record['station_id'] = measurement.xpath("station/text()")[0][-3:]
                record['component'] = measurement.xpath("component/text()")[0]
                record['validated'] = measurement.xpath("gevalideerd/text()")[0]
                record['sample_value'] = measurement.xpath("waarde/text()")[0]

                # 27/05/2014
                datum = measurement.xpath("datum/text()")[0]
                # 14
                tijd = measurement.xpath("tijd/text()")[0]
                dt_str = datum + '-' + tijd
                dt = datetime.strptime(dt_str, '%d/%m/%Y-%H')
                record['sample_time'] = dt

                # Create a unique id for the sample station-component-time
                record['sample_id'] = record['station_id'] + '-' + record['component'] + '-' + dt_str
                record_list.append(record)

        packet.data = record_list

        # Always stop after batch, otherwise we would continue forever
        packet.set_end_of_stream()

        return packet
