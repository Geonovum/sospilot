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

log = Util.get_log("LmlFileDbInput")

class LmlFileDbInput(PostgresDbInput):
    """
    Reads RIVM raw AQ/LML file data from lml_files table and converts to record_array
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

        # Get last processed id of lml_files table
        rowcount = self.db.execute(self.progress_query)
        progress_rec = self.db.cursor.fetchone()
        self.last_id = progress_rec[3]
        log.info('progress record: %s' % str(progress_rec))

        # Fetch next batch of lml_files records
        lml_file_recs = self.do_query(self.query % self.last_id)
        log.info('read lml_file_recs: %d' % len(lml_file_recs))

        # No more records to process?
        if len(lml_file_recs) == 0:
            packet.set_end_of_stream()
            log.info('Nothing to do. All file_records done')
            return packet

        # Process lml_files records and create recordlist
        record_list = []
        file_format = self.cfg.get('file_format')
        for file_rec in lml_file_recs:
            gid = file_rec.get('gid')
            file_name = file_rec.get('file_name')

            log.info('process: file_rec gid=%d file=%s' % (gid, file_name))

            # Remember last id processed for next query
            self.last_id = gid

            # Parse file data and create a record from XML DOM
            xml_doc = None
            file_data = file_rec.get('file_data')
            if file_data is None or len(file_data) == 0:
                log.warn("cannot process file '%s' error: %s, skipping..." % (file_name, 'no data in file'))
                continue

            try:
                xml_doc = etree.fromstring(file_data)
            except Exception, e:
                log.warn("cannot parse file '%s' error: %s, skipping..." % (file_name, str(e)))
                continue

            # There are two broad file formats from RIVM: 'xml' and 'sos'. The data is the same
            # only the XML format and thus handling is different
            if file_format == 'rivm_xml':
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

                    record['file_name'] = file_name

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

            elif file_format == 'rivm_sos':
                measurements = xml_doc.xpath('/ROWSET/*')

                # Extract date-time string and component name once from file-name
                # 2014070708-PM10.xml becomes date_str=2014070708 component=PM10
                date_str, _, component = file_name[:-4].rpartition('-')

                for measurement in measurements:

                    # first check if there is a valid sample value
                    # for benzeen and e.g. PM2.5 most values are less than zero
                    sample_value = measurement.xpath("MWAA_WAARDE/text()")[0]
                    if sample_value[0:1] == '-':
                        continue

                    record = dict()
                    # <?xml version="1.0"?>
                    # <ROWSET>
                    #  <ROW>
                    #   <OPST_OPDR_ORGA_CODE>DCMR</OPST_OPDR_ORGA_CODE>
                    #   <STAT_NUMMER>NL01483</STAT_NUMMER>
                    #   <STAT_NAAM>Botlek-Spoortunnel</STAT_NAAM>
                    #   <MCLA_CODE>stad verkeer</MCLA_CODE>
                    #   <MWAA_WAARDE>60.3</MWAA_WAARDE>
                    #   <MWAA_BEGINDATUMTIJD>20140707070000</MWAA_BEGINDATUMTIJD>
                    #   <MWAA_EINDDATUMTIJD>20140707080000</MWAA_EINDDATUMTIJD>
                    #  </ROW>
                    #  <ROW>
                    #   <OPST_OPDR_ORGA_CODE>DCMR</OPST_OPDR_ORGA_CODE>
                    #   <STAT_NUMMER>NL01485</STAT_NUMMER>
                    #   <STAT_NAAM>Hoogvliet-Leemkuil</STAT_NAAM>
                    #   <MCLA_CODE>stad achtergr</MCLA_CODE>
                    #   <MWAA_WAARDE>17.5</MWAA_WAARDE>
                    #   <MWAA_BEGINDATUMTIJD>20140707070000</MWAA_BEGINDATUMTIJD>
                    #   <MWAA_EINDDATUMTIJD>20140707080000</MWAA_EINDDATUMTIJD>
                    #  </ROW>

                    record['file_name'] = file_name


                    # station_id variants: '318' or  'NL01485'  or 'NL49551'
                    # always take last three digits?
                    record['station_id'] = measurement.xpath("STAT_NUMMER/text()")[0][-3:]
                    record['component'] = component
                    record['validated'] = 0
                    record['sample_value'] = sample_value

                    dt = datetime.strptime(date_str, '%Y%m%d%H')
                    record['sample_time'] = dt

                    # Create a unique id for the sample station-component-time
                    record['sample_id'] = record['station_id'] + '-' + record['component'] + '-' + date_str
                    record_list.append(record)

        packet.data = record_list

        # Always stop after batch, otherwise we would continue forever
        packet.set_end_of_stream()

        return packet
