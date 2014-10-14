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

Mobile networking

* USB 3G Modem - Huawei - most probably E3131 (of Wifi networking)

Wifi Networking

* Draadloze USB Adapter voor Raspberry `Pi Wi-Pi  <http://www.kiwi-electronics.nl/raspberry-pi/raspberry-pi-accessoires/wi-pi-draadloze-usb-adapter-voor-raspberry-pi>`_ (EUR 18,95).

Connection Weather Station

* USB Cable (USB A Male both sides??) with ferrite noise suppressor : http://www.allekabels.nl/usb-20-kabel/172/1043113/usb-20-kabel-professioneel.html (EUR 17,95)
* powered USB hub. Why? See http://www.weewx.com/docs/usersguide.htm#Raspberry_Pi

Software

* OS: Raspbian Debian Wheezy (sept 2014) - Free
* Open source software for weather station: `weewx <http://www.weewx.com>`_ with SQLlite  - free
* `wview`, kan gebruik maken van archive SQLite DB van weewx: http://www.wviewweather.com

Links
-----

* http://garethhowell.com/wp/connect-raspberry-pi-3g-network
* http://www.jamesrobertson.eu/blog/2014/jun/24/setting-up-a-huawei-e3131-to-work-with-a.html
* http://christianscode.blogspot.nl/2012/11/python-huawei-e3131-library.html
* Reverse tunneling to access the Pi from outside: http://www.thirdway.ch/En/projects/raspberry_pi_3g/index.php
* Use `autossh` to maintain tunnel: http://unix.stackexchange.com/questions/133863/permanent-background-ssh-connection-to-create-reverse-tunnel-what-is-correct-wa
