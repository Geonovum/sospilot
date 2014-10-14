#
#    Copyright (c) 2014 Just van den Broecke <just@justobjects.nl>
#
#
"""Waether API fetcher for the weewx weather system"""

from __future__ import with_statement
import math
import time
from urllib2 import Request, urlopen, URLError, HTTPError
import urllib

import weeutil.weeutil
import weewx.abstractstation
import weewx.wxformulas
from weewx.units import Converter

def loader(config_dict, engine):

    station = WeatherAPIStation(**config_dict['WeatherAPI'])

    return station

class WeatherAPIStation(weewx.abstractstation.AbstractStation):
    """Station simulator by querying weather APIs"""

    def __init__(self, **stn_dict):
        """Initialize the simulator

        NAMED ARGUMENTS:

        loop_interval: The time (in seconds) between emitting LOOP packets. [Optional. Default is 2.5]

        mode: Required. One of either:
            'simulator': Real-time simulator. It will sleep between emitting LOOP packets.
            'generator': Emit packets as fast as it can (useful for testing).
        """
        self.loop_interval = float(stn_dict.get('loop_interval', 2.5))
        self.the_time = time.time()

    def genLoopPackets(self):

        while True:

            # http://api.openweathermap.org/data/2.5/find?q=Otterlo&units=imperial

            json_data = self.read_from_url('http://api.openweathermap.org/data/2.5/weather?q=Otterlo,nl&units=imperial')
            self.the_time = time.time()
            if json_data is not None:
                data_dict = self.parse_data(json_data)
                if data_dict is not None:
                    packet = self.createpacket(data_dict)
                    print("Created packet: %s", str(packet))
                    yield packet

            # Determine how long to sleep
            # We are in real time mode. Try to keep synched up with the
            # wall clock
            # sleep_time = self.the_time + self.loop_interval - time.time()
            # if sleep_time > 0:

            time.sleep(self.loop_interval)

    def read_from_url(self, url, parameters=None):
        """
        Read the data from the URL.
        :param url: the url to fetch
        :param parameters: optional dict of query parameters
        :return:
        """
        # log.info('Fetch data from URL: %s ...' % url)

        req = Request(url)
        try:
            # Urlencode optional parameters
            query_string = None
            if parameters:
                query_string = urllib.urlencode(parameters)

            response = urlopen(req, query_string)
        except HTTPError as e:
            print('HTTPError fetching from URL %s: code=%d e=%s' % (url, e.code, e))
            return None
        except URLError as e:
            print('URLError fetching from URL %s: reason=%s e=%s' % (url, e.reason, e))
            return None
        else:
                # everything is fine
            return response.read()

    def parse_data(self, json_string):
        # One-time read/parse only
        try:
            import json
            file_data = json.loads(json_string)

        except Exception, e:
            print('Cannot parse JSON from %s, err= %s' % (json_string, str(e)))
            raise e

        return file_data

    def createpacket(self, rsp_dict):
    # {"coord": {
    #     "lon": 5.77,
    #     "lat": 52.1
    # },
    #     "sys": {
    #         "type": 1,
    #         "id": 5207,
    #         "message": 0.6065,
    #         "country": "Netherlands",
    #         "sunrise": 1413266452,
    #         "sunset": 1413305086
    #     },
    #     "weather": [
    #         {
    #             "id": 503,
    #             "main": "Rain",
    #             "description": "very heavy rain",
    #             "icon": "10n"
    #         },
    #         {
    #             "id": 701,
    #             "main": "Mist",
    #             "description": "mist",
    #             "icon": "50n"
    #         }
    #     ],
    #     "base": "cmc stations",
    #     "main": {
    #         "temp": 286.87,
    #         "pressure": 1005,
    #         "humidity": 93,
    #         "temp_min": 286.15,
    #         "temp_max": 287.75
    #     },
    #     "wind": {
    #         "speed": 5.7,
    #         "deg": 200
    #     },
    #     "rain": {
    #     "1h": 47.27
    # }, "clouds": {
    #     "all": 90
    # }, "dt": 1413313501, "id": 2749203, "name": "Ede", "cod": 200}
        # outTemp    : Observation(magnitude=20.0,  average= 50.0, period=24.0, phase_lag=14.0, start=start_ts),
        #                      'inTemp'     : Observation(magnitude=5.0,   average= 68.0, period=24.0, phase_lag=12.0, start=start_ts),
        #                      'barometer'  : Observation(magnitude=1.0,   average= 30.1, period=48.0, phase_lag= 0.0, start=start_ts),
        #                      'pressure'   : Observation(magnitude=1.0,   average= 30.1, period=48.0, phase_lag= 0.0, start=start_ts),
        #                      'windSpeed'  : Observation(magnitude=5.0,   average=  5.0, period=48.0, phase_lag=24.0, start=start_ts),
        #                      'windDir'    : Observation(magnitude=180.0, average=180.0, period=48.0, phase_lag= 0.0, start=start_ts),
        #                      'windGust'   : Observation(magnitude=6.0,   average=  6.0, period=48.0, phase_lag=24.0, start=start_ts),
        #                      'windGustDir': Observation(magnitude=180.0, average=180.0, period=48.0, phase_lag= 0.0, start=start_ts),
        #                      'outHumidity': Observation(magnitude=30.0,  average= 50.0, period=48.0, phase_lag= 0.0, start=start_ts),
        #                      'radiation'  : Solar(magnitude=1000.0, solar_start=6.0, solar_length=12.0),
        #                      'UV'         : Solar(magnitude=14,     solar_start=6.0, solar_length=12.0),
        #                      'rain'       : Rain(rain_start=0, rain_length=3, total_rain=0.2, loop_interval=self.loop_interval)}
        packet = {'dateTime': int(self.the_time+0.5), 'usUnits' : weewx.US }
        main = rsp_dict['main']
        packet['outTemp'] = main['temp']
        # packet['barometer'] = main['temp']
        # p_m = (1016.5, 'mbar', 'group_pressure')
        # c = Converter()
        # print c.convert(p_m)
        # (30.020673360897813, 'inHg', 'group_pressure')

        c = Converter()
        p_m = (main['pressure'], 'mbar', 'group_pressure')
        pressure, units, group = c.convert(p_m)

        packet['barometer'] = pressure
        packet['pressure'] = pressure
        packet['outHumidity'] = main['humidity']
        wind = rsp_dict['wind']
        # p_m = (wind['speed'], 'meter_per_second', 'group_speed')
        # speed, units, group = c.convert(p_m)

        packet['windSpeed'] = wind['speed']
        # packet['windGust'] = wind['temp']
        packet['windDir'] = wind['deg']
        # packet['windGust'] = main['temp']

        packet['rainRate'] = rsp_dict['rain']['1h']

        packet['windchill'] = weewx.wxformulas.windchillF(packet['outTemp'], packet['windSpeed'])
        packet['dewpoint']  = weewx.wxformulas.dewpointF(packet['outTemp'], packet['outHumidity'])
        packet['heatindex'] = weewx.wxformulas.heatindexF(packet['outTemp'], packet['outHumidity'])
        return packet

    def getTime(self):
        return self.the_time

    @property
    def hardware_name(self):
        return "WeatherAPI"


if __name__ == "__main__":

    station = WeatherAPIStation(mode='simulator',loop_interval=2.0)
    for packet in station.genLoopPackets():
        print weeutil.weeutil.timestamp_to_string(packet['dateTime']), packet


