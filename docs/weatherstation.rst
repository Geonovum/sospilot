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

Raspberry Pi core,
bijv `RPi Kit van Kiwi Elektronics <http://www.kiwi-electronics.nl/raspberry-pi/board-and-kits/raspberry-pi-model-b-plus-bundel-met-voeding-en-noobs-op-microsd>`_:

* Raspberry Pi Model B+ 512MB
* transparant Multicomp enclosure
* 5.2V 2A microUSB power adapter
* microSD card 32GB - Class 10

User access

* USB mouse
* USB keyboard
* monitor with HDMI input
* HDMI cable

Mobile networking

* USB 3G Modem - Huawei - most probably E3131

Links:

http://garethhowell.com/wp/connect-raspberry-pi-3g-network

http://www.jamesrobertson.eu/blog/2014/jun/24/setting-up-a-huawei-e3131-to-work-with-a.html

http://christianscode.blogspot.nl/2012/11/python-huawei-e3131-library.html


We will need reverse tunneling to access the Pi from outside:
http://www.thirdway.ch/En/projects/raspberry_pi_3g/index.php

Connection Weather Station

* USB Cable with ferrite noise surpressor

Software

* OS: Raspbian Debian Wheezy (sept 2014)
* Open source software for weather station: `weewx <http://www.weewx.com>`_ with SQLlite

