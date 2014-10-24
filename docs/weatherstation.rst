.. _weatherstation:

Weather Station
===============

As part of the SOSPilot project, the plan is to connect the existing
Geonovum  `Davis Vantage Pro II Weather station <http://www.davisnet.com/weather/products/vantage-pro-professional-weather-stations.asp>`_
to the SOS and WMS/WFS servers and public weather services.
Below the realization and results are described.

History
-------

In 2008/2009 Geonovum had acquired a Davis Vantage Pro II Weather station. This station
was/is mounted on the roof of Geonovum building. This tsation measures
barometric pressure, temperature, humidity, rainfall, wind speed and direction. Data from the weather station was extracted and
published to the 52N SOS. The station is also registered in the national gespatial catalog, Nationaal Georegister (NGR).

The results of this project have been described in
a `Geo-Info magazine article (2010-1) <http://www.geo-info.nl/download/?id=15311409&download=1>`_.

Architecture
------------

The overall architecture is depicted in Figure 1 below.


.. figure:: _static/weather-hwsw-pictarch.png
   :align: center

   *Figure 1 - Global Setup from Weather Station Through OGC Services*

In summary the overall architecture in hard/software is as follows.
The Davis weather station is connected to a `Raspberry Pi <http://www.raspberrypi.org/>`_ (RPi) micro computer via
USB. The RPi runs the Raspbian OS with the weather data software
deamon `weewx <http://weewx.com>`_.  ``weewx`` reads out the raw weather from the Davis weather station
and stores this data locally in a (SQLite)  `weather archive database`.

An ETL process based on `Stetl <http:/www.stetl.org>`_ transforms and syncs data
from the `weather archive database` to a remote PostgreSQL server
in a "Cloud Server" (Ubuntu VPS). The VPS runs GeoServer that serves the weather data directly fromthe Postgres/PostGIS
database as WMS, WMS-Time and WFS.
In addition the VPS runs a Stetl ETL process that transformsand and publishes
the weather data from PostgreSQL via SOS-T to the 52North Sensor Web Application server.
The latter provides a SOS (Sensor Observation Service). Via the webbrowser various WMS/WFS and SOS client applications
are run.

Raspberry Pi
------------

A Raspberry Pi will be setup as a headless (no GUI) server. Via a USB Cable the Pi will be connected to the Davis datalogger cable.
The Pi will run a Debian Linux version (Raspbian) with the free `weewx` weather server and
archiver. `weewx` will fetch data from the Davis, storing this in MySQL or SQLLite.
It can also can publish data to community Weather networks like Wunderground.

Raspberry Pi core,
bijv `RPi Kit van Kiwi Elektronics <http://www.kiwi-electronics.nl/raspberry-pi/board-and-kits/raspberry-pi-model-b-plus-bundel-met-voeding-en-noobs-op-microsd>`_ (EUR 59,95):

* Raspberry Pi Model B+ 512MB
* transparant Multicomp enclosure
* 5.2V 2A microUSB power adapter
* microSD card 32GB - Class 10

User access (but not required once having setup as we access via SSH).

* USB mouse
* USB keyboard
* monitor with HDMI input
* HDMI cable

Mobile networking (not)

* USB 3G Modem - Huawei - most probably E3131 (of Wifi networking)

Wifi Networking:

* Draadloze USB Adapter voor Raspberry `Pi Wi-Pi  <http://www.kiwi-electronics.nl/raspberry-pi/raspberry-pi-accessoires/wi-pi-draadloze-usb-adapter-voor-raspberry-pi>`_ (EUR 18,95).

Connection to Davis Weather Station WeatherLink USB adapter:

* USB Cable (USB A Male B Mini) with ferrite noise suppressor : http://www.allekabels.nl/usb-20-kabel/172/1043120/usb-20-mini-kabel-professioneel.html (EUR 17,95)
* powered USB hub. Why? See http://www.weewx.com/docs/usersguide.htm#Raspberry_Pi

Software:

* OS: Raspbian Debian Wheezy (sept 2014) - Free
* Open source software for weather station: `weewx <http://www.weewx.com>`_ with SQLlite  - free
* `wview`, kan gebruik maken van archive SQLite DB van weewx: http://www.wviewweather.com ??

Best option for now seems to be to use Pi with WIFI i.s.o. mobile data.

See `raspberrypi-install <raspberrypi-install.html>`_ for the basic installation of the RPi for the project.

Weather Software
----------------

The choice is `weewx <http://www.weewx.com>`_ with SQLlite. `weewx` is installed as part of the
`raspberrypi-install <raspberrypi-install.html`_. The configuration is maintained in
GitHub https://github.com/Geonovum/sospilot/tree/master/src/weewx/davis. After a first test
using our WeatherStationAPI custom driver the Geonovum Davis weather station will be connected.
The web reporting is synced by `weewx` every 5 mins to to our main website:
http://sensors.geonovum.nl/weewx. This will take about 125kb each 5 mins.

Data ETL
--------

`weewx` stores 'archive' data within a SQLite DB file `weewx.sdb`. Statistical
data is derived from this data. Within `weewx.sdb` there is a single table `archive`.
The database/table structure. ::

    # test
    sqlite3 weewx.sdb
    SQLite version 3.7.13 2012-06-11 02:05:22
    Enter ".help" for instructions
    Enter SQL statements terminated with a ";"
    sqlite> .schema
    CREATE TABLE archive (`dateTime` INTEGER NOT NULL UNIQUE PRIMARY KEY,
    `usUnits` INTEGER NOT NULL,
    `interval` INTEGER NOT NULL,
    `barometer` REAL, `pressure`
    REAL, `altimeter` REAL, `inTemp` REAL,
    `outTemp` REAL, `inHumidity` REAL, `outHumidity` REAL,
    `windSpeed` REAL, `windDir` REAL, `windGust` REAL, `windGustDir`
    REAL, `rainRate` REAL, `rain` REAL, `dewpoint` REAL, `windchill` REAL,
    `heatindex` REAL, `ET` REAL, `radiation` REAL, `UV` REAL, `extraTemp1` REAL,
    `extraTemp2` REAL, `extraTemp3` REAL, `soilTemp1` REAL, `soilTemp2` REAL, `soilTemp3` REAL,
    `soilTemp4` REAL, `leafTemp1` REAL, `leafTemp2` REAL, `extraHumid1` REAL, `extraHumid2` REAL,
    `soilMoist1` REAL, `soilMoist2` REAL, `soilMoist3` REAL, `soilMoist4` REAL, `leafWet1` REAL,
    `leafWet2` REAL, `rxCheckPercent` REAL, `txBatteryStatus` REAL, `consBatteryVoltage` REAL,
    `hail` REAL, `hailRate` REAL, `heatingTemp` REAL, `heatingVoltage` REAL, `supplyVoltage` REAL,
    `referenceVoltage` REAL, `windBatteryStatus` REAL, `rainBatteryStatus` REAL, `outTempBatteryStatus` REAL,
    `inTempBatteryStatus` REAL);

Links
-----

* http://garethhowell.com/wp/connect-raspberry-pi-3g-network
* http://www.jamesrobertson.eu/blog/2014/jun/24/setting-up-a-huawei-e3131-to-work-with-a.html
* http://christianscode.blogspot.nl/2012/11/python-huawei-e3131-library.html
* Reverse tunneling to access the Pi from outside: http://www.thirdway.ch/En/projects/raspberry_pi_3g/index.php
* Use `autossh` to maintain tunnel: http://unix.stackexchange.com/questions/133863/permanent-background-ssh-connection-to-create-reverse-tunnel-what-is-correct-wa
