# -*- coding: utf-8 -*-
#
# MeasurementsDbInput: Reads raw weather data from measurements table and converts to recordlist
#
# Author:Just van den Broecke

import time
from stetl.util import Util
from stetl.inputs.dbinput import PostgresDbInput

log = Util.get_log("MeasurementsDbInput")

class MeasurementsDbInput(PostgresDbInput):
    """
    Reads raw weather data from measurements table and converts to recordlist
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
        ts_local = time.strftime("%Y-%m-%d %H:%M:%S %Z", time.localtime(self.last_id))

        self.db.execute(self.progress_update % (self.last_id, ts_local))
        # self.db.execute(self.progress_update % self.last_id)
        self.db.commit(close=False)
        log.info('Update progress table ok')
        return True

    def expand(self, measurements_recs):
        # "http://sensors/weather/obsProperty/outtemp",
        # "http://sensors/weather/obsProperty/windspeed",
        # "http://sensors/weather/obsProperty/winddir",
        # "http://sensors/weather/obsProperty/rainrate",
        # "http://sensors/weather/obsProperty/pressure",
        # "http://sensors/weather/obsProperty/outhumidity"
        # outtemp_c,
        # windspeed_mps,
        # winddir_deg,
        # rainRate,
        # pressure_mbar,
        # outhumidity_perc,
        # <sml:OutputList>
        #      <sml:output name="outtemp">
        #          <swe:Quantity definition="http://sensors/weather/obsProperty/outtemp">
        #              <swe:uom code="deg"/>
        #          </swe:Quantity>
        #      </sml:output>
        #      <sml:output name="windspeed">
        #          <swe:Quantity definition="http://sensors/weather/obsProperty/windspeed">
        #              <swe:uom code="m/s"/>
        #          </swe:Quantity>
        #      </sml:output>
        #      <sml:output name="winddir">
        #          <swe:Quantity definition="http://sensors/weather/obsProperty/winddir">
        #              <swe:uom code="degrees"/>
        #          </swe:Quantity>
        #      </sml:output>
        #      <sml:output name="rainrate">
        #           <swe:Quantity definition="http://sensors/weather/obsProperty/rainrate">
        #               <swe:uom code="mm/h"/>
        #           </swe:Quantity>
        #       </sml:output>
        #      <sml:output name="pressure">
        #           <swe:Quantity definition="http://sensors/weather/obsProperty/pressure">
        #               <swe:uom code="mbar"/>
        #           </swe:Quantity>
        #       </sml:output>
        #      <sml:output name="outhumidity">
        #           <swe:Quantity definition="http://sensors/weather/obsProperty/outhumidity">
        #               <swe:uom code="%"/>
        #           </swe:Quantity>
        #       </sml:output>

        phenomena_uoms = {
            'outtemp_c': 'deg',
            'windspeed_mps': 'm/s',
            'winddir_deg': 'degrees',
            # 'rainrate': 'mm/h',
            'pressure_mbar': 'mbar',
            'outhumidity_perc': '%'
            }

        # Expand to array of records, one record per phenomenon (SOS needs one observed property type per INSERT)
        expanded_recs = []
        for rec in measurements_recs:
            for phenomenon in phenomena_uoms.keys():
                new_rec = dict(rec)
                new_rec['phenomenon'] = phenomenon
                new_rec['uom'] = phenomena_uoms[phenomenon]
                expanded_recs.append(new_rec)

        return expanded_recs

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
        self.last_id = measurements_recs[len(measurements_recs)-1].get('datetime')

        # Expand to array of records, one record per phenomenon
        packet.data = self.expand(measurements_recs)

        # Always stop after batch, otherwise we would continue forever
        packet.set_end_of_stream()

        return packet
