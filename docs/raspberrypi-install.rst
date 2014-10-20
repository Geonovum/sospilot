.. _raspberrypiinst:


************************
Raspberry Pi Install Log
************************

Below the setup and installation of the Raspberry Pi for the weather station is described.

Conventions
===========

General conventions.

Directories
-----------

The following

* ``/opt`` additionele, handmatig geinstalleerde software
* ``/opt/<leverancier of product>/<product-versie>`` installatie dirs voor additionele, handmatig geinstalleerde software
* ``/opt/download`` downloads voor additionele, handmatig geinstalleerde software
* ``/opt/bin`` eigen additionele shell scripts (bijv. backup)
* ``/var/sensors`` alle eigen (geo)data, configuraties, tilecaches, packed backups to be transfered
* ``/var/www`` alle web applicaties/sites
* ``/var/www/sensors.geonovum.nl/site`` sensors website (platte HTML)
* ``/var/www/sensors.geonovum.nl/webapps`` alle Tomcat applicaties: GeoServer, GeoWebCache, deegree etc
* ``/var/www/sensors.geonovum.nl/cgi-bin`` proxy en python scripts
* ``/home/sadmin`` home dir beheer account

Onder ``/opt/<leverancier of product>`` kan vaak ook een dynamic link staan naar de laatste versie
van een product, bijvoorbeeld ``/opt/nlextract/active`` is een dynlink naar een versie van NLExtract bijvoorbeeld
naar ``/opt/nlextract/1.1.5``.

Voeg ook toe in ``/etc/profile`` zodat de scripts in ``/opt/bin`` gevonden worden  ::

  export PATH=/opt/bin:${PATH}

Omdat de meeste toepassingen gebruik maken van Apache Virtual Hosts met een prefix op ``sensors``, zoals
bijvoorbeeld `inspire.sensors <http://inspire.sensors>`_ is hier ook een conventie op zijn plaats:

 * ``/etc/apache2/sites-available/sensors.geonovum.nl.conf`` bevat de Apache configuratie
 * ``/var/www/sensors.geonovum.nl`` bevat de website content (HTML etc)

System
------

Aangeschaft 16 okt 2014, geleverd 17 okt 2014 from http://www.kiwi-electronics.nl. ::

    Raspberry Pi Model B+ bundle                    € 68,95
      - with 2A power adapter
      - microSD 32GB Transcend class 10
      - Color case: Transparant Multicomp enclosure

    Wi-Pi Draadloze USB Adapter voor Raspberry Pi   € 18,95

    Specs:
    Chip Broadcom BCM2835 SoC
    Core architecture ARM11
    CPU 700 MHz Low Power ARM1176JZFS Applications Processor
    GPU Dual Core VideoCore IV® Multimedia Co-Processor
    Provides Open GL ES 2.0, hardware-accelerated OpenVG, and
    1080p30 H.264 high-profile decode
    Capable of 1Gpixel/s, 1.5Gtexel/s or 24GFLOPs with texture filtering
    and DMA infrastructure
    Memory 512MB SDRAM
    Operating System Boots from Micro SD card, running Linux operating system
    Dimensions 85 x 56 x 17mm
    Power Micro USB socket 5V, 2A

    Connectors:
    Ethernet 10/100 BaseT Ethernet socket
    Video Output HDMI (rev 1.3 & 1.4)
    Composite RCA (PAL and NTSC)
    Audio Output 3.5mm jack, HDMI
    USB 4 x USB 2.0 Connector
    GPIO Connector 40-pin 2.54 mm (100 mil) expansion header: 2x20 strip
    Providing 27 GPIO pins as well as +3.3 V, +5 V and GND supply lines
    Camera Connector 15-pin MIPI Camera Serial Interface (CSI-2)
    JTAG Not populated
    Display Connector Display Serial Interface (DSI) 15 way flat flex cable connector
    with two data lanes and a clock lane
    Memory Card Slot SDIO


.. figure:: _static/rasp-pi-all-s.jpg
   :align: center

   *Figure 1 - Raspberry Pi Package*

See also https://www.adafruit.com/datasheets/pi-specs.pdf

Hardware Setup
--------------

Multicomp enclosure install: https://www.youtube.com/watch?v=1uFMFZMGO_A

OS Setup
--------

SD card appeared to be non-readable. Reformatted and put NOOBS (probably could have put
Raspbian directly) on card. Described here http://www.raspberrypi.org/help/noobs-setup . We will install
the Raspbian OS, a Debian Linux variant for the Pi::

    format SD card using  https://www.sdcard.org/downloads/formatter_4
    select complete format
    unpack NOOBS and put files on card
    put card in Pi and Reboot
    select Raspian
    Standard install steps
    NB the password to be entered is for the user 'pi' not root!
    user pi is sudoer
    root password may be set using sudo passwd root
    chosen non-GUI at startup, can always get GUI via startx command

Wifi Setup
----------

Wifi setup with WiPi. See doc
http://www.element14.com/community/servlet/JiveServlet/downloadBody/49107-102-1-257014/Wi_Pi.User_Manual.pdf
Steps. ::

    $ root@raspberrypi:~# sudo nano /etc/network/interfaces

The file will already have a network entry for the localhost, or loopback network interface, and the
Ethernet socket, known as eth0. We’re going to add a new interface called wlan0,
There are two slightly different ways of editing this file, depending on which of type broad types of
encryption is in use on the WiFi network you wish to connect to.
In the case of WPA/WPA2, add the following lines to the end of the interfaces document:  ::

    auto wlan0
    iface wlan0 inet dhcp
    wpa-ssid <name of your WiFi network>
    wpa-psk <password of your WiFi network>

In the case of WEP, add the following instead

    auto wlan0
    iface wlan0 inet dhcp
    wireless-essid <name of your WiFi network>
    wireless-key <password of your WiFi network>

Result in `/etc/network/interfaces` ::

    root@georasp:~# cat /etc/network/interfaces
    auto lo

    iface lo inet loopback
    iface eth0 inet dhcp

    # allow-hotplug wlan0
    # iface wlan0 inet manual
    # wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
    iface default inet dhcp

    auto wlan0
    iface wlan0 inet dhcp
    wpa-ssid <name of your WiFi network>
    wpa-psk <password of your WiFi network>


But to have mutiple WLANs and not have passwords in files, this approach is more flexible and more secure.
http://www.geeked.info/raspberry-pi-add-multiple-wifi-access-points/

Our `/etc/network/interfaces` is now ::

    auto lo

    iface lo inet loopback
    # allow-hotplug eth0
    iface eth0 inet dhcp

    allow-hotplug wlan0
    auto wlan0
    iface wlan0 inet dhcp

    pre-up wpa_supplicant -Dwext -i wlan0 -c /etc/wpa_supplicant.conf -B

And in the file  `/etc/wpa_supplicant.conf` configure multiple WIFI stations. For each station generate a PSK as follows
` wpa_passphrase <ssid> <passphrase>`.  `/etc/wpa_supplicant.conf` will become something like: ::

    ctrl_interface=/var/run/wpa_supplicant
    #ap_scan=2

    network={
           ssid="<station #1 name>"
           scan_ssid=1
           proto=WPA RSN
           key_mgmt=WPA-PSK
           pairwise=CCMP TKIP
           group=CCMP TKIP
           psk=<generated PSK #1>
    }

    network={
           ssid="<station #2 name>"
           scan_ssid=1
           proto=WPA RSN
           key_mgmt=WPA-PSK
           pairwise=CCMP TKIP
           group=CCMP TKIP
           psk=<generated PSK #2>
    }

The latter approach with `wpa_supplicant` did somehow not work so we remained
in the first simple approach without `wpa_supplicant`, only a simple `/etc/network/interfaces` config.

Hostname
--------

In ``/etc/hostname`` set to ``georasp``..

Accounts
--------

Twee standaard accounts: ``root`` ("root admin") en ``sadmin`` ("sensors admin"). NB de account ``root``
wordt (door Ubuntu) nooit aangemaakt als login account!

Het beheer-account ``root`` heeft root-rechten.

Het account ``sadmin`` heeft ook wat rechten maar minder.
Het account ``sadmin`` heeft lees/schrijfrechten op directories voor custom installaties (zie onder).


Software Installation
---------------------

Via Ubuntu/Debian `Advanced Packaging Tool (APT) <http://en.wikipedia.org/wiki/Advanced_Packaging_Tool>`_ .
Hiermee is op zeer eenvoudige wijze niet alleen alle software, inclusief de meeste GIS tools
gemakkelijk te installeren, maar ook up-to-date te houden. Bijvoorbeeld een complete Java installatie gaat met :
``apt-get install sun-java6-jdk``. APT wordt altijd door het ``root`` account (met root via sudo of sudo -i) uitgevoerd.

Alleen in een uiterst geval waarbij een software product niet in het APT systeem zit of niet
in een gewenste versie is een handmatige ("custom") installatie gedaan. Hierbij is de volgende conventie aangehouden:
custom installaties worden door het account ``root``.

Backup
------

TODO vooral de weewx DB!

Disk Gebruik
------------

Op 20.10.14. ::

    Filesystem      Size  Used Avail Use% Mounted on
    rootfs           28G  2.6G   24G  10% /
    /dev/root        28G  2.6G   24G  10% /
    devtmpfs        215M     0  215M   0% /dev
    tmpfs            44M  268K   44M   1% /run
    tmpfs           5.0M     0  5.0M   0% /run/lock
    tmpfs            88M     0   88M   0% /run/shm
    /dev/mmcblk0p5   60M  9.6M   50M  17% /boot


Server Software - General
=========================

Install of standard packages.

nginx Web Server
----------------

As Apache2 seems to have a relative large footprint, many prefer `nginx <http://nginx.com/>`_ as webserver on RPi.

Setup. ::

    apt-get install nginx

    # start/stop server
    /etc/init.d/nginx start
    /etc/init.d/nginx stop

Config under `/etc/nginx` especially, default website at `/etc/nginx/sites-available/default` ::

    server {
            #listen   80; ## listen for ipv4; this line is default and implied
            #listen   [::]:80 default_server ipv6only=on; ## listen for ipv6

            root /usr/share/nginx/www;
            index index.html index.htm;

            # Make site accessible from http://localhost/
            server_name localhost;

            location / {
                    # First attempt to serve request as file, then
                    # as directory, then fall back to displaying a 404.
                    try_files $uri $uri/ /index.html;
                    # Uncomment to enable naxsi on this location
                    # include /etc/nginx/naxsi.rules
            }

            location /doc/ {
                    alias /usr/share/doc/;
                    autoindex on;
                    allow 127.0.0.1;
                    allow ::1;
                    deny all;
            }
    }

Installatie - Project Software
==============================

Software en documentatie voor project, bijv `weewx` config, zit in Geonovum GitHub: https://github.com/Geonovum/sospilot

We installeren deze onder ``/opt/geonovum/sospilot`` ::

    cd /opt/geonovum/sospilot
    git clone https://github.com/Geonovum/sospilot.git git

NB alle documentatie (Sphinx) wordt automatisch gepubliceerd naar ReadTheDocs.org:
http://sospilot.readthedocs.org via een GitHub Post-commit hook.


Server Software - Geo
=====================

Not yet.

Installation - Weather Software
===============================

weewx - Weather Station server
------------------------------

Used for testing `weewx <http://www.weewx.com>`_.

Dir: `/opt/weewx`. We do custom install as user `sadmin` in order to make tweaking easier.

See http://www.weewx.com/docs/setup.htm

Steps. ::

    # Install Dependencies
    # required packages:
    apt-get install python-configobj
    apt-get install python-cheetah
    apt-get install python-imaging
    apt-get install fonts-freefont-ttf  # Fonts in reporting

    # optional for extended almanac information:
    apt-get install python-dev
    apt-get install python-setuptools
    easy_install pip
    pip install pyephem

    # Weewx install after download
    cd /opt/weewx
    tar xzvf archive/weewx-2.7.0.tar.gz
    ln -s weewx-2.7.0 weewx

    cd weewx

    # Change install dir in setup.cfg as follows
    # Configuration file for weewx installer. The syntax is from module
    # ConfigParser. See http://docs.python.org/library/configparser.html

    [install]

    # Set the following to the root directory where weewx should be installed
    home = /opt/weewx/weewxinst

    # Given the value of 'home' above, the following are reasonable values
    prefix =
    exec-prefix =
    install_lib = %(home)s/bin
    install_scripts = %(home)s/bin

    # build en install in /opt/weewx/weewxinst
    ./setup.py build
    ./setup.py install

    # test install
    # change
    cd /opt/weewx/weewxinst
    change station_type = Simulator in weewx.conf

    # link met aangepaste configs uit Geonovum GitHub (na backup oude versies)
    ln -s /opt/geonovum/sospilot/git/src/weewx/test/weewx.conf /opt/weewx/weewxinst
    ln -s /opt/geonovum/sospilot/git/src/weewx/test/skin.conf /opt/weewx/weewxinst/skins/Standard
    ln -s /opt/geonovum/sospilot/git/src/weewx/test/weatherapidriver.py /opt/weewx/weewxinst/bin/user

    # test OK
    sadmin@georasp /opt/weewx/weewxinst $ ./bin/weewxd weewx.conf
    LOOP:   2014-10-19 16:18:50 CEST (1413728330) {'heatindex': 32.67858297022247, 'barometer': 31.099999998967093, 'windchill': 32.67858297022247,
    'dewpoint': 27.203560993945757, 'outTemp': 32.67858297022247, 'outHumidity': 79.99999996901272, 'UV': 2.5568864075841278,
    'radiation': 182.63474339886625, 'rain': 0, 'dateTime': 1413728330, 'windDir': 359.9999998140763, 'pressure': 31.099999998967093,
    'windSpeed': 5.164547900449179e-09, 'inTemp': 63.00000002065819, 'windGust': 6.197456769996279e-09, 'usUnits': 1, 'windGustDir': 359.9999998140763}
    LOOP:   2014-10-19 16:18:52 CEST (1413728332) {'heatindex': 32.67676549144743, 'barometer': 31.099999990703814, 'windchill': 32.67676549144743,
    'dewpoint': 27.20178958368346, 'outTemp': 32.67676549144743, 'outHumidity': 79.99999972111442, 'UV': 2.555313141990661,
    'radiation': 182.52236728504724, 'rain': 0, 'dateTime': 1413728332, 'windDir': 359.9999983266865, 'pressure': 31.099999990703814,
    'windSpeed': 4.648092932768577e-08, 'inTemp': 63.00000018592372, 'windGust': 5.577711537085861e-08, 'usUnits': 1, 'windGustDir': 359.9999983266865}

    # install weewx daemon in /etc/init.d (als root)
    # aanpassen settings in daemon in GitHub  /opt/geonovum/sospilot/git/src/weewx/test/weewx-daemon.sh

    # PATH should only include /usr/* if it runs after the mountnfs.sh script
    WEEWX_HOME=/opt/weewx/weewxinst
    PATH=/sbin:/usr/sbin:/bin:/usr/bin
    WEEWX_BIN=$WEEWX_HOME/bin/weewxd
    WEEWX_CFG=$WEEWX_HOME/weewx.conf
    DESC="weewx weather system"
    NAME=weewx
    WEEWX_USER=sadmin:sadmin
    PIDFILE=$WEEWX_HOME/$NAME.pid
    DAEMON=$WEEWX_BIN
    DAEMON_ARGS="--daemon --pidfile=$PIDFILE $WEEWX_CFG"
    SCRIPTNAME=/etc/init.d/$NAME

    cp /opt/geonovum/sospilot/git/src/weewx/davis/weewx-deamon.sh /etc/init.d/weewx
    update-rc.d weewx defaults
    /etc/init.d/weewx start
    /etc/init.d/weewx status
    * Status of weewx weather system: running

    # weewx log bekijken
    tail -f /var/log/syslog

    # memory in gaten houden
      PID USER      PR  NI    VIRT    RES    SHR  S  %CPU %MEM     TIME+ COMMAND
     4688 sadmin    20   0    170936  36776  4608 S   0.0  0.5   3:15.23 weewxd  (16.10.14 16:22)

    # nginx ontsluiting
    location /weewx {
        alias /opt/weewx/weewxinst/public_html;
        autoindex on;
        allow 127.0.0.1;
        allow ::1;
        allow all;
    }

Installatie - ETL Tools
=======================


XSLT Processor
--------------

Zie `<http://en.wikipedia.org/wiki/XSLT>`_. *XSLT (XSL Transformations) is a declarative,
XML-based language used for the transformation of XML documents into other XML documents.*

Installatie van XSLT processor voor commandline. o.a. gebruikt voor INSPIRE GML transformaties. ::

  apt-get install xsltproc

SQLite
------

`weewx` uses SQLite to store weather records. Command line tools. ::

    apt-get install sqlite3

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

GDAL/OGR
--------

Volgens de website `<www.gdal.org>`_.

*GDAL is a translator library for raster geospatial data
formats that is released under an X/MIT style Open Source license by the
Open Source Geospatial Foundation. The related OGR library (which lives within the GDAL source tree)
provides a similar capability for simple features vector data.*

Installatie is simpel via APT. ::

    $ apt-get install gdal-bin python-gdal

    0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
    Inst gdal-bin (1.10.1+dfsg-5ubuntu1 Ubuntu:14.04/trusty [amd64])
    Conf gdal-bin (1.10.1+dfsg-5ubuntu1 Ubuntu:14.04/trusty [amd64])
    Setting up python-numpy (1:1.8.1-1ubuntu1) ...
    Setting up python-gdal (1.10.1+dfsg-5ubuntu1) ...


Stetl - Streaming ETL
---------------------

Zie http://stetl.org

Eerst alle dependencies!  ::

	apt-get install python-pip
	apt-get install python-lxml
	apt-get install postgresql-server-dev-9.3
	apt-get install python-gdal libgdal-dev
	apt-get install python-psycopg2

Normaal doen we ``pip install stetl`` maar nu even install uit Git vanwege
te verwachten updates.Install vanuit GitHub versie onder ``/opt/stetl/git``. ::

    $ mkdir /opt/stetl
    $ cd /opt/stetl
    $ git clone https://github.com/justb4/stetl.git git
    $ cd git
    $ python setup.py install

    $ stetl -h
    # 2014-05-25 13:43:40,930 util INFO running with lxml.etree, good!
    # 2014-05-25 13:43:40,931 util INFO running with cStringIO, fabulous!
    # 2014-05-25 13:43:40,936 main INFO Stetl version = 1.0.5


Installatie Testen. ::

    $ which stetl
    # /usr/local/bin/stetl

    cd /opt/stetl/git/examples/basics
    ./runall.sh
    # OK!

Python Jinja2
-------------

Nodig voor Stetl Jinja2 templating Filter. ::

    pip install jinja2
    Downloading/unpacking jinja2
      Downloading Jinja2-2.7.3.tar.gz (378kB): 378kB downloaded
      Running setup.py (path:/tmp/pip_build_root/jinja2/setup.py) egg_info for package jinja2

        warning: no files found matching '*' under directory 'custom_fixers'
        warning: no previously-included files matching '*' found under directory 'docs/_build'
        warning: no previously-included files matching '*.pyc' found under directory 'jinja2'
        warning: no previously-included files matching '*.pyc' found under directory 'docs'
        warning: no previously-included files matching '*.pyo' found under directory 'jinja2'
        warning: no previously-included files matching '*.pyo' found under directory 'docs'
    Downloading/unpacking markupsafe (from jinja2)
      Downloading MarkupSafe-0.23.tar.gz
      Running setup.py (path:/tmp/pip_build_root/markupsafe/setup.py) egg_info for package markupsafe

    Installing collected packages: jinja2, markupsafe
      Running setup.py install for jinja2

        warning: no files found matching '*' under directory 'custom_fixers'
        warning: no previously-included files matching '*' found under directory 'docs/_build'
        warning: no previously-included files matching '*.pyc' found under directory 'jinja2'
        warning: no previously-included files matching '*.pyc' found under directory 'docs'
        warning: no previously-included files matching '*.pyo' found under directory 'jinja2'
        warning: no previously-included files matching '*.pyo' found under directory 'docs'
      Running setup.py install for markupsafe

        building 'markupsafe._speedups' extension
        x86_64-linux-gnu-gcc -pthread -fno-strict-aliasing -DNDEBUG -g -fwrapv -O2 -Wall -Wstrict-prototypes -fPIC -I/usr/include/python2.7 -c markupsafe/_speedups.c -o build/temp.linux-x86_64-2.7/markupsafe/_speedups.o
        markupsafe/_speedups.c:12:20: fatal error: Python.h: No such file or directory
         #include <Python.h>
                            ^
        compilation terminated.
        ==========================================================================
        WARNING: The C extension could not be compiled, speedups are not enabled.
        Failure information, if any, is above.
        Retrying the build without the C extension now.


        ==========================================================================
        WARNING: The C extension could not be compiled, speedups are not enabled.
        Plain-Python installation succeeded.
        ==========================================================================
    Successfully installed jinja2 markupsafe
    Cleaning up...

Tot hier gekomen op 19.10.2014
==============================

TODO
====



Installatie - Beheer
====================

Webalizer
---------

Zie `<http://www.mrunix.net/webalizer/>`_.  *The Webalizer is a fast, free web server log file analysis program. It produces highly detailed,
easily configurable usage reports in HTML format, for viewing with a standard web browser.*

Installatie, ::

  $ apt-get install webalizer
  # installeer webalizer configuratie in /etc/webalizer/

  # zorg dat output zichtbaar is via dir onder /var/www/default/sadm/webalizer

  # enable DNS lookups
  touch  /var/cache/webalizer/dns_cache.db

Extra Fonts
-----------

Hoeft blijkbaar niet bij elke Java JDK upgrade...

Installeren  MS fonts zie `<http://corefonts.sourceforge.net>`_
en `<http://embraceubuntu.com/2005/09/09/installing-microsoft-fonts>`_. ::

  apt-get install msttcorefonts
  # installs in /usr/share/fonts/truetype/msttcorefonts

Installeren fonts in Java (for geoserver).

 * Few fonts are included with Java by default, and for most people the the official documentation falls short of a useful explanation.
   It is unclear exactly where Java looks for fonts, so the easiest way to solve this problems is to
   copy whatever you need to a path guaranteed to be read by Java, which in our
   case is ``/usr/lib/jvm/java-7-oracle``

 * First install the fonts you want. The MS Core Fonts
   (Arial, Times New Roman, Verdana etc.) can be installed by following the instructions on
   http://corefonts.sourceforge.net/.

 * Now copy the .ttf files to ``/usr/lib/jvm/java-7-oracle/``  and run (ttmkfdir is obsolete??),
    from http://askubuntu.com/questions/22448/not-all-ttf-fonts-visible-from-the-sun-jdk this install

Commands ::

    mkfontscale
    mkfontdir
    fc-cache -f -v

*All that remains is to restart any Java processes you have running, and the new fonts should be available.*






