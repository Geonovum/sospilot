# -*- coding: utf-8 -*-
#
# RawSensorLastInput: harvest raw last values from CityGIS Sensor REST API.
#
# Author:Just van den Broecke

import json
import time
from datetime import datetime, timedelta
from stetl.util import Util
from stetl.inputs.httpinput import HttpInput
from stetl.packet import FORMAT
from sensorconverters import convert

log = Util.get_log("RawSensorLastInput")


class RawSensorLastInput(HttpInput):
    """
    Raw Sensor REST API (CityGIS) version for HttpInput
    """

    def __init__(self, configdict, section, produces=FORMAT.record_array):
        HttpInput.__init__(self, configdict, section, produces)
        self.device_ids = []
        self.base_url = self.url
        # Outputs to be gathered, with some metadata
        self.outputs = [
            {
                'name': 's_co',
                'id': 1,
                'label': 'CO',
                'unit': 'ug/m3'
            },
            {
                'name': 's_co2',
                'id': 2,
                'label': 'CO2',
                'unit': 'ppm'
            },
            {
                'name': 's_no2',
                'id': 3,
                'label': 'NO2',
                'unit': 'ug/m3'
            },
            {
                'name': 's_o3',
                'id': 4,
                'label': 'O3',
                'unit': 'ug/m3'
            },
            {
                'name': 's_temperatureambient',
                'id': 5,
                'label': 'Temperatuur',
                'unit': 'Celsius'
            },
            {
                'name': 's_barometer',
                'id': 6,
                'label': 'Luchtdruk',
                'unit': 'HectoPascal'
            },
            {
                'name': 's_humidity',
                'id': 7,
                'label': 'Luchtvochtigheid',
                'unit': 'Procent'
            },
            {
                'name': 't_audio0',
                'id': 8,
                'label': 'Audio 0-40Hz',
                'unit': 'dB(A)'
            },
            {
                'name': 't_audioplus1',
                'id': 9,
                'label': 'Audio 40-80Hz',
                'unit': 'dB(A)'
            },
            {
                'name': 't_audioplus2',
                'id': 10,
                'label': 'Audio 80-160Hz',
                'unit': 'dB(A)'
            },
            {
                'name': 't_audioplus3',
                'id': 11,
                'label': 'Audio 160-315Hz',
                'unit': 'dB(A)'
            },
            {
                'name': 't_audioplus4',
                'id': 12,
                'label': 'Audio 315-630Hz',
                'unit': 'dB(A)'
            },
            {
                'name': 't_audioplus5',
                'id': 13,
                'label': 'Audio 630Hz-1.25kHz',
                'unit': 'dB(A)'
            },
            {
                'name': 't_audioplus6',
                'id': 14,
                'label': 'Audio 1.25-2.5kHz',
                'unit': 'dB(A)'
            },
            {
                'name': 't_audioplus7',
                'id': 15,
                'label': 'Audio 2.5-5kHz',
                'unit': 'dB(A)'
            },
            {
                'name': 't_audioplus8',
                'id': 16,
                'label': 'Audio 5-10kHz',
                'unit': 'dB(A)'
            },
            {
                'name': 't_audioplus9',
                'id': 17,
                'label': 'Audio 10-20kHz',
                'unit': 'dB(A)'
            },
            {
                'name': 't_audioplus10',
                'id': 18,
                'label': 'Audio 20-25kHz',
                'unit': 'dB(A)'
            },
            # Virtual outputs, i.e. added here for ease of interpretation
            {
                'name': 't_audiomax',
                'id': 19,
                'label': 'Audio Maxvalue',
                'unit': 'dB(A)'
            },
            {
                'name': 't_audiomax_octave',
                'id': 20,
                'label': 'Audio Maxvalue Octave',
                'unit': 'int'
            },
            {
                'name': 't_audiomax_octband',
                'id': 21,
                'label': 'Audio Maxvalue Band in Octave',
                'unit': 'int'
            },
            {
                'name': 't_audiolevel',
                'id': 22,
                'label': 'Audio/Noise Level 1-5',
                'unit': 'int'
            }
        ]

    def init(self):
        # One time: get all device ids
        self.base_url = self.url
        devices_url = self.base_url + '/devices'
        log.info('Init: fetching device list from URL: "%s" ...' % devices_url)
        json_str = self.read_from_url(devices_url)
        json_obj = self.parse_json_str(json_str)
        device_urls = json_obj['devices']
        for d in device_urls:
            self.device_ids.append(d.split('/')[-1])

        self.device_idx = 0
        log.info('Found %4d devices: %s' % (len(self.device_ids), str(self.device_ids)))

    def before_invoke(self, packet):
        """
        Called just before Component invoke.
        """

        # Set the next "last values" URL for device and increment to next
        self.url = self.base_url + '/devices/%s/last' % self.device_ids[self.device_idx]
        self.device_idx += 1

        # The base method read() will fetch self.url until it is set to None
        if self.device_idx == len(self.device_ids):
            # All devices read
            self.url = None

        return True

    def exit(self):
        # done
        log.info('Exit')

    def parse_json_str(self, raw_str):
        # Parse JSON from data string
        json_obj = None
        try:
            json_obj = json.loads(raw_str)
        except Exception, e:
            log.error('Cannot parse JSON from %s, err= %s' % (raw_str, str(e)))
            raise e

        return json_obj

    # Convert observations to array of records, one for each designated (see self.outputs) output
    def format_data(self, data):

        # Convert/split response into an array of device_output records
        # {u'p_basetimer': 6,
        # u'p_coheatermode': 184549611,
        # u'v_audioplus9': 2960427, u'v_audioplus8': 2763049, u's_audioplus4': 2368291,
        # u's_audioplus2': 2433311, u'v_audioplus3': 2302754, u'v_audioplus2': 2236447, u'v_audioplus1': 2171422,
        # u'v_audioplus7': 2631462, u'v_audioplus6': 2434084, u'v_audioplus5': 2631463, u'v_audioplus4': 2368034,
        # u't_audioplus2': 2434339,
        # u'p_errorstatus': 0,
        # u's_rain': 0, u'id': u'25',
        # u's_lightsensorbottom': 0, u't_audioplus4': 2565414, u'p_11': 35253,
        # u's_temperatureunit': 289400,
        # u'p_unitserialnumber': 25,
        # u't_audioplus7': 2959143, u'p_17': 184549867, u'p_18': 184549867, u'p_19': 167772308,
        # u't_audioplus6': 2500133, u'u_audio0': 1645568, u's_coresistance': 362528, u's_rgbcolor': 16771796,
        # u's_audioplus8': 2828841, u's_lightsensorgreen': 11, u'p_totaluptime': 1741354, u'p_sessionuptime': 310354,
        # u't_audioplus8': 2828842, u's_co': 35936, u's_satinfo': 99082,
        # u's_latitude': 54345494, u't_audioplus1': 2369314,
        # u's_audioplus1': 2368543, u't_audioplus3': 2434086, u's_audioplus3': 2434083, u't_audioplus5': 2697512,
        # u's_audioplus5': 2697000, u's_audioplus6': 2434085, u's_audioplus7': 2762535, u't_audioplus9': 2960684,
        # u's_audioplus9': 2960427, u'u_audioplus5': 2500133, u'p_powerstate': 1935, u'p_temporarilyenablebasetimer': 1,
        # u's_o3': 39, u's_rtcdate': 1056819, u's_no2resistance': 549228, u's_barometer': 101788, u't_audio0': 2435072,
        # u's_temperatureambient': 275962, u's_secondofday': 64127, u's_lightsensorblue': 10, u's_acceleroy': 527,
        # u's_accelerox': 510, u's_humidity': 77961, u's_acceleroz': 763, u's_audio0': 1842688, u's_no2': 32,
        # u's_longitude': 6113060, u'v_audio0': 1908736, u's_lightsensortop': 15, u's_co2': 418000,
        # u'p_controllerreset': 322372921, u's_rtctime': 1126447, u'u_audioplus2': 1974301, u'u_audioplus3': 2170401,
        # u'u_audioplus1': 1974556, u'u_audioplus6': 2433828, u'u_audioplus7': 2565925, u'u_audioplus4': 2171169,
        # u'time': u'2016-02-03T16:47:51.3844629Z', u'u_audioplus8': 2763049, u'u_audioplus9': 2960427,
        # u's_lightsensorred': 12, u's_o3resistance': 414489}
        #
        # -- Map this to
        # CREATE TABLE smartem_rt.device_output (
        # gid serial,
        # unique_id character varying (16),
        # insert_time timestamp default current_timestamp,
        # device_id integer,
        # device_name character varying (32),
        # id integer,
        # name character varying,
        # label character varying,
        # unit  character varying,
        # time timestamp,
        # value_raw integer,
        # value_stale integer,
        # value real,
        # altitude integer default 0,
        # point geometry(Point,4326),
        # PRIMARY KEY (gid)
        # );

        # Parse JSON from data string fetched by base method read()
        json_obj = self.parse_json_str(data)

        # Base data for all records
        base_record = {}
        base_record['device_id'] = json_obj['p_unitserialnumber']
        base_record['device_name'] = 'station %d' % base_record['device_id']

        # Unix timestamp to calculate "stale state (0/1)" i.e. if a station has been
        # active over the last N hours (now 2). We keep all last values but flag inactive stations.
        base_record['time'] = convert(json_obj, 'time')
        utc_then = datetime.utcnow() - timedelta(hours=2)
        tstamp_sample = time.mktime(base_record['time'].timetuple())
        tstamp_then = time.mktime(utc_then.timetuple())
        base_record['value_stale'] = 0
        if tstamp_sample < tstamp_then:
            base_record['value_stale'] = 1

        # Point location
        if 's_longitude' in json_obj and 's_latitude' in json_obj:
            lon = convert(json_obj, 's_longitude')
            lat = convert(json_obj, 's_latitude')
            if lon is None or lat is None:
                return []
            base_record['point'] = 'SRID=4326;POINT(%f %f)' % (lon, lat)

        # No use without a location
        if 'point' not in base_record:
            return []

        # GPS height. TODO use air pressure
        base_record['altitude'] = 0
        if 's_altimeter' in json_obj:
            base_record['altitude'] = json_obj['s_altimeter']

        # Gather result as array of records, one for each output-observation
        result = []
        for output in self.outputs:
            # First all common attrs (device_id, time, staleness etc)
            record = base_record.copy()
            name = output['name']
            if name in json_obj:
                record['id'] = output['id']
                record['unique_id'] = '%d-%d' % (record['device_id'], record['id'])
                record['name'] = name
                record['label'] = output['label']
                record['unit'] = output['unit']
                record['value_raw'] = json_obj[name]
                record['value'] = convert(json_obj, name)

                if record['value'] is None:
                    continue

                if name == 't_audiolevel':
                    # highest dB value
                    record['value_raw'] = json_obj['t_audiomax']

                result.append(record)

        return result
