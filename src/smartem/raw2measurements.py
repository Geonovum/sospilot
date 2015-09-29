# -*- coding: utf-8 -*-
#
# Filter to consume raw lines of Smart Emission data, assembling these, producing a record.
#


# Author: Just van den Broecke - 2015

from stetl.util import Util
from stetl.filter import Filter
from stetl.packet import FORMAT

from datetime import datetime

log = Util.get_log("SmartemFileInput")

# Typically raw stream of lines per measurement record
# 07/24/2015 07:24:49,P.UnitSerialnumber,1
# 07/24/2015 07:24:49,S.Longitude,5914101
# 07/24/2015 07:24:49,S.Latitude,53949944
# 07/24/2015 07:24:49,S.SatInfo,90889
# 07/24/2015 07:24:49,S.O3,162
# 07/24/2015 07:24:49,S.BottomSwitches,0
# 07/24/2015 07:24:49,S.RGBColor,16772502
# 07/24/2015 07:24:49,S.LightsensorBlue,92
# 07/24/2015 07:24:49,S.LightsensorGreen,145
# 07/24/2015 07:24:49,S.LightsensorRed,156
# 07/24/2015 07:24:49,S.AcceleroZ,754
# 07/24/2015 07:24:49,S.AcceleroY,513
# 07/24/2015 07:24:49,S.AcceleroX,511
# 07/24/2015 07:24:49,S.NO2,90
# 07/24/2015 07:24:49,S.CO,31718
# 07/24/2015 07:24:49,S.Altimeter,118
# 07/24/2015 07:24:49,S.Barometer,101101
# 07/24/2015 07:24:49,S.LightsensorBottom,26
# 07/24/2015 07:24:49,S.LightsensorTop,226
# 07/24/2015 07:24:49,S.Humidity,47970
# 07/24/2015 07:24:49,S.TemperatureAmbient,299362
# 07/24/2015 07:24:49,S.TemperatureUnit,305400
# 07/24/2015 07:24:49,S.SecondOfDay,33928
# 07/24/2015 07:24:49,S.RtcDate,1012101
# 07/24/2015 07:24:49,S.RtcTime,596252
# 07/24/2015 07:24:49,P.SessionUptime,60731
# 07/24/2015 07:24:49,P.BaseTimer,9
# 07/24/2015 07:24:49,P.ErrorStatus,0
# 07/24/2015 07:24:49,P.Powerstate,79
#
# The record produced here is:
# {'co': 31718, 'sessionuptime': 60731, 'temperatureunit': 305400,
# 'datetime': '07/24/2015 07:24:49', 'acceleroy': 513, 'accelerox': 511,
# 'acceleroz': 754, 'rgbcolor': 16772502, 'powerstate': 79, 'satinfo': 90889,
# 'no2': 90, 'lightsensorbottom': 26, 'errorstatus': 0, 'unit': 1,
# 'latitude': 53949944, 'o3': 162, 'basetimer': 9, 'barometer': 101101,
# 'rtctime': 596252, 'bottomswitches': 0, 'lightsensorgreen': 145,
# 'altimeter': 118, 'lightsensorred': 156, 'rtcdate': 1012101,
# 'lightsensorblue': 92, 'secondofday': 33928, 'longitude': 5914101,
# 'humidity': 47970, 'temperatureambient': 299362, 'lightsensortop': 226}
#
class Raw2RecordFilter(Filter):
    """
    Filter to consume raw lines of Smart Emission data, assembling these, producing a record.
    """

    def __init__(self, configdict, section):
        Filter.__init__(self, configdict, section, consumes=FORMAT.line_stream, produces=FORMAT.record)
        self.current_record = None
        
    def invoke(self, packet):
        if packet.is_end_of_doc() or packet.is_end_of_stream():
            packet.data = self.record_end()
            return packet

        if packet.data is None:
            return packet

        # 1. split the line into 3 tokens
        line = packet.data
        tokens = line.split(',')
        packet.data = None
        if len(tokens) != 3:
            return packet

        # Line with P.UnitSerialnumber indicates start of a new record, like
        # 07/24/2015 07:24:49,P.UnitSerialnumber,1
        if tokens[1] == 'P.UnitSerialnumber':
            packet.data = self.record_end()
            self.record_start(tokens)
        elif self.current_record:
            self.record_add(tokens)
            packet.data = None

        return packet
    
    def record_add(self, tokens):
        self.current_record[tokens[1].split('.')[1].lower()] = int(tokens[2])

    def record_start(self, tokens):
        self.current_record = {'unit': int(tokens[2]), 'datetime': tokens[0]}
        
    def record_end(self):
        record = self.current_record
        self.current_record = None
        return record

# The input record here is like:
# {'co': 31718, 'sessionuptime': 60731, 'temperatureunit': 305400,
# 'datetime': '07/24/2015 07:24:49', 'acceleroy': 513, 'accelerox': 511,
# 'acceleroz': 754, 'rgbcolor': 16772502, 'powerstate': 79, 'satinfo': 90889,
# 'no2': 90, 'lightsensorbottom': 26, 'errorstatus': 0, 'unit': 1,
# 'latitude': 53949944, 'o3': 162, 'basetimer': 9, 'barometer': 101101,
# 'rtctime': 596252, 'bottomswitches': 0, 'lightsensorgreen': 145,
# 'altimeter': 118, 'lightsensorred': 156, 'rtcdate': 1012101,
# 'lightsensorblue': 92, 'secondofday': 33928, 'longitude': 5914101,
# 'humidity': 47970, 'temperatureambient': 299362, 'lightsensortop': 226}
#
# The output records with measurements here is like:
#
# component 'CO',
# station_id 'Unit-1',
# sample_id  '',
# sample_time timestamp,
# sample_value_ppb 31718,
# sample_value 66.32,
#
# component 'NO2',
# station_id 'Unit-1',
# sample_id  '',
# sample_time timestamp,
# sample_value_ppb 90,
# sample_value 124.76,
#
# component 'O3',
# station_id 'Unit-1',
# sample_id  '',
# sample_time timestamp,
# sample_value_ppb 162,
# sample_value 321.34,
#
class Record2MeasurementsFilter(Filter):
    """
    Filter to consume raw records of Smart Emission data, producing one record per chemical component.
    """
    # Only extract these components
    component_names = ['o3', 'no2', 'co']

    # For now a crude conversion (1 atm, 20C)
    ppb_to_ugm3_factor = {'o3': 2.0, 'no2': 1.9, 'co': 1.15}

    def __init__(self, configdict, section):
        Filter.__init__(self, configdict, section, consumes=FORMAT.record, produces=FORMAT.record_array)
        self.current_records = None

    def invoke(self, packet):
        if packet.data is None or packet.is_end_of_doc() or packet.is_end_of_stream():
            packet.data = None
            return packet

        # 1. split the line into 3 tokens
        raw_record = packet.data
        for component_name in Record2MeasurementsFilter.component_names:
            if raw_record.has_key(component_name):
                self.record_add(component_name, raw_record)

        packet.data = self.current_records
        self.current_records = None
        return packet

    def record_add(self, component_name, raw_record):
        if not self.current_records:
            self.current_records = []

        record = dict()

        for k in ['datetime', 'unit', component_name]:
            if raw_record[k] is None or raw_record[k] is '':
                return

        dt_str = raw_record['datetime'] + ' UTC'
        # Format timestamp bijv "07/18/2015 10:03:19 UTC"
        dt = datetime.strptime(dt_str, '%m/%d/%Y %H:%M:%S %Z')
        record['sample_time'] = dt

        record['station_id'] = raw_record['unit']
        record['component'] = component_name.upper()
        record['sample_id'] = str(raw_record['unit']) + '-' + component_name + '-' + str(dt)
        record['sample_time'] = dt
        record['sample_value_ppb'] = raw_record[component_name]
        ppb_val = record['sample_value_ppb']
        if ppb_val == 0 or ppb_val > 100000:
            return

        # Zie http://www.apis.ac.uk/unit-conversion
        # ug/m3 = PPB * moleculair gewicht/moleculair volume
        # waar molec vol = 22.41 * T/273 * 1013/P
        #
        # Typische waarden:
        # Nitrogen dioxide 1 ppb = 1.91 ug/m3  bij 10C 1.98, bij 30C 1.85 --> 1.9
        # Ozone 1 ppb = 2.0 ug/m3  bij 10C 2.1, bij 30C 1.93 --> 2.0
        # Carbon monoxide 1 ppb = 1.16 ug/m3 bij 10C 1.2, bij 30C 1.1 --> 1.15
        #
        # Benzene 1 ppb = 3.24 ug/m3
        # Sulphur dioxide 1 ppb = 2.66 ug/m3
        # For now a crude approximation as the measurements themselves are also not very accurate
        record['sample_value'] = Record2MeasurementsFilter.ppb_to_ugm3_factor[component_name] * ppb_val

        self.current_records.append(record)
