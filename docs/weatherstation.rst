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

Overview
--------

The overall architecture is depicted below.


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

The next sections will expand on this overview.

Architecture
------------

The global architecture is depicted below. In all figures in this section the arrows denote the flow of (weather) data.
Circles denote continuous data transformation processes. Rectangles denote application servers or services.

The figure below depicts the software architecture at the global level.
ETL (Extract, Transform, Load) processes extract and transform raw weather data from the Davis weather station
and publish the transformed data to a variety of application servers/services. Each of these servers/services
will provide standard (web) APIs through which client applications can fetch (weather) data.


.. figure:: _static/weather-sw-overview.png
   :align: center

   *Figure 2 - Global Software Architecture*

* SOS via the `52N SOS application server  <http://52north.org/communities/sensorweb/sos/>`_
* WMS/WMS-Time/WFS via: `GeoServer <http://geoserver.org>`_
* weather reports via standard Apache webserver
* weather APIs via weather-communities like `Weather Underground <http://www.wunderground.com>`_

This global architecture from Figure 2 is expanded into a more detailed design in Figure 3.
This shows the various software and storage components, in particular the realization of the
ETL-processing.

.. figure:: _static/weather-sw-detail.png
   :align: center

   *Figure 3 - Detailed Software Architecture*

The (data) flow in Figure 3 is as follows.

* data is sampled by the ``weewx`` daemon from the Davis Weather station
* weewx stores `archive records` in a SQLite database
* the `Stetl Sync` process reads the latest data from SQLite database
* the `Stetl Sync` publishes these records unaltered to a PostgreSQL database
* several specialized PostgreSQL VIEWs will convert the raw archive data and JOIN data records with Station (location) info
* the PostgreSQL database (VIEWs) serve directly as WMS/WFS Layer datasources for GeoServer
* GeoServer will also provide a WMS-Dimension (-Time) service using the record timestamp column
* the `Stetl SOS` process reads data from PostgreSQL and transforms this data to SOS-T requests, POSTing these via SOS-T to the 552 North SOS
* ``weewx`` also creates and publishes weather data reports in HTML to be serverd by an Apache server
* in addition ``weewx`` may publish weather data to various weather community services like `Weather Underground <http://www.wunderground.com>`_ (optional)

The components are divided over two server machines.

* the Raspberry Pi: ``weewx`` and  `Stetl Sync`
* the Ubuntu Linux VPS: GeoServer, SOS server and Apache server plus the PostgreSQL/PostGIS database and the `Stetl SOS` ETL

Connections between the RPi and the VPS are via SSH. An SSH tunnel (via ``autossh``) is maintained
to provide a secure connection to the PostgreSQL server on the VPS. This way the PostgreSQL server
is never exposed directly via internet.

Each of these components are elaborated further below.


Raspberry Pi
------------

A Raspberry Pi will be setup as a headless (no GUI) server. Via a USB Cable the Pi will be connected to the Davis datalogger cable.
The Pi will run a Debian Linux version (Raspbian) with the free `weewx` weather server and
archiver. `weewx` will fetch samples from the Davis, storing its summaries regularly (typically every 5 mins) in
a MySQL or SQLLite `archive table`. weewx can also can publish data to community Weather networks like Wunderground.


.. figure:: _static/rasp-pi-all-s.jpg
   :align: center

   *Figure 4 - Raspberry Pi Package through Install*

See the `raspberrypi-install section <raspberrypi-install.html>`_ for the full hardware setup and software installation
of the RPi for the project.

Weather Software
----------------

The choice is `weewx <http://www.weewx.com>`_ with SQLlite. `weewx` is installed as part of the
`raspberrypi-install <raspberrypi-install.html>`_. The configuration is maintained in
GitHub https://github.com/Geonovum/sospilot/tree/master/src/weewx/davis. After a first test
using our WeatherStationAPI custom driver, the Geonovum Davis weather station will be connected.
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
