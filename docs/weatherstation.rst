.. _weatherstation:

Weather Station
===============

This chapter describes the hard/software setup of a weather station whose measurements are
to be exposed via OGC protocols like WMS, WFS and in particular SOS.

Introduction
------------

In 2008/2009 Geonovum acquired a
`Davis Vantage Pro II Weather station <http://www.davisnet.com/weather/products/vantage-pro-professional-weather-stations.asp>`_.
This station was/is mounted on the roof of Geonovum building. The outside station-sensors measure
barometric pressure, temperature, humidity, rainfall, wind speed and direction. Data is continuously
sent (wireless, via RF) to a base station, a.k.a. the "console". The console
has a `Davis WeatherLink® <http://www.davisnet.com/weather/products/weather-reporting-software.asp>`_
hard/software add-on that is able to act as a data-logger and provides connectivity over USB.

Data from the weather station was extracted and published to the 52N SOS via a special purpose
PC application. The results of this project have been described in
a `Geo-Info magazine article (2010-1) <http://www.geo-info.nl/download/?id=15311409&download=1>`_.

As part of the SOSPilot project, we will now "revive" the Davis
Weather station and connect its data stream to the SOSPilot infrastructure simliar
to the RIVM AQ datastream. Eventually, the goal is to expose the station weather data to OGC services like
WMS, WFS and in particular SOS.

As we cannot connect the weather base station (USB),
directly to the SOSPilot server "in the cloud",
an intermediate "middleman" hard/software component will be required.
The main functions of this component are to acquire data from the base station and to
transform and publish this data to the SOSPilot server (VPS).

To this end a `Raspberry Pi <http://www.raspberrypi.org/>`_ (RPi) microcomputer has been chosen.
The RPi is a cheap (around $25,-) credit-card-sized microcomputer that can run free OS-es like Linux (`Raspbian <http://www.raspbian.org/>`_,
a Debian version)
and allows connectivity to USB, WIFI, GSM etc. The RPi is
`popular with weather amateurs <https://www.google.nl/search?q=Raspberry+Pi+Weather+Station&oq=Raspberry+Pi+Weather+Station>`_
(and various other IoT projects as well).

Architecture
------------

The overall hard/software architecture is depicted below.


.. figure:: _static/weather-hwsw-pictarch.png
   :align: center

   *Figure 1 - Global Setup from Weather Station Through OGC Services*

These components and their interconnections operate as follows.

The Davis weather station is connected to a `Raspberry Pi <http://www.raspberrypi.org/>`_ (RPi) micro computer via
USB trough the `Davis WeatherLink® <http://www.davisnet.com/weather/products/weather-reporting-software.asp>`_.

The RPi runs the `Raspbian <http://www.raspbian.org/>`_ OS with the weather data software
`weewx <http://weewx.com>`_.  The weewx daemon continuously reads raw weather sample data from the Davis weather station
and stores this data locally in a (SQLite or MySQL) database. These measurements, called weewx `Archive Records` are
typically a 5-minute summary of multiple samples (weewx `Loop Records`) collected every few seconds.

An ETL process based on `Stetl <http:/www.stetl.org>`_ transforms and syncs data
from the SQLite `weather archive database` to a remote PostgreSQL server
in a "Cloud Server" (the Ubuntu VPS used in the project).

Other weewx plugins generate reports with statistics and summaries. These are synced regularly to be viewed
as webpages in a browser.

The VPS runs GeoServer to serve the weather data directly from the Postgres/PostGIS
database, using specialized PostgreSQL VIEWs, as WMS, WMS-Time and WFS.

In addition the VPS runs a Stetl ETL process that transforms and and publishes
the weather data from PostgreSQL using the SOS-T protocol
to the 52North Sensor Web Application server.
The latter provides a SOS (Sensor Observation Service). Via the web browser various WMS/WFS
and SOS client applications are invoked.

All client applications
can be found and accessed via the project landing page: `sensors.geonovum.nl <http://sensors.geonovum.nl>`_:

* weather reports via: `sensors.geonovum.nl/weewx <http://sensors.geonovum.nl/weewx>`_
* WMS/WMS-Time/WFS via: `sensors.geonovum.nl/heronviewer <http://sensors.geonovum.nl/heronviewer>`_
* SOS via SOS client apps: `sensors.geonovum.nl <http://sensors.geonovum.nl>`_


Raspberry Pi
------------

A Raspberry Pi will be setup as a headless (no GUI) server. Via a USB Cable the Pi will be connected to the Davis datalogger cable.
The Pi will run a Debian Linux version (Raspbian) with the free `weewx` weather server and
archiver. `weewx` will fetch samples from the Davis, storing its summaries regularly (typically every 5 mins) in
a MySQL or SQLLite `archive table`.
weewx can also can publish data to community Weather networks like Wunderground.

See the `raspberrypi-install section <raspberrypi-install.html>`_ for the full hardware setup and software installation
of the RPi for the project.

Weather Software
----------------

The choice is `weewx <http://www.weewx.com>`_ with SQLlite. `weewx` is installed as part of the
`raspberrypi-install <raspberrypi-install.html>`_. The configuration is maintained in
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
