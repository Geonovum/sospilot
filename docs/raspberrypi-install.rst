.. _raspberrypiinst:


*************************
Raspberry Pi Installation
*************************

Below the setup and installation of the Raspberry Pi (RPi) for ``weewx`` weather software with the Davis Vantage Pro2
weather station is described.

Conventions
===========

General conventions.

Directories
-----------

We keep the following directory conventions:

* ``/opt`` additional, manually installed software
* ``/opt/<product>/<product-version>`` subdires e.g. ``/opt/weewx/weewx-2.7.0``
* ``/opt/bin`` own shell scripts
* ``/opt/geonovum/sospilot/git`` all project software synced with GitHub https://github.com/Geonovum/sospilot
* ``/home/sadmin`` home dir beheer account

Under ``/opt/<product>/<product-version>`` we often make a dynamic link to the latest version
of a product, for example ``/opt/weewx/weewx`` is a dynlink to
``/opt/weewx/weewx-2.7.0``.

Add to ``/etc/profile``  ::

  export PATH=${PATH}:/opt/bin

System
------

Ordered Oct 16, 2014. Delivered Oct 17, 2014. From http://www.kiwi-electronics.nl.


.. figure:: _static/rasp-pi-all-s.jpg
   :align: center

   *Figure 1 - Raspberry Pi Package through Install*

Specs. ::

    Raspberry Pi Model B+ bundle                    € 68,95
      - with 2A power adapter
      - microSD 32GB Transcend class 10
      - Color case: Transparant Multicomp enclosure

    Wi-Pi Draadloze USB Adapter voor Raspberry Pi   € 18,95

    Belkin 4-Port Powered Mobile USB 2.0 Hub        € 16,95

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


See also https://www.adafruit.com/datasheets/pi-specs.pdf. The Belkin 4-Port Powered Mobile USB
is recommended when attaching WiPi and Davis USB devices, as the RPi may have loss USB-power issues.

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

Result in ``/etc/network/interfaces`` ::

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

And in the file  ``/etc/wpa_supplicant.conf`` configure multiple WIFI stations. For each station generate a PSK as follows
``wpa_passphrase <ssid> <passphrase>``.  ``/etc/wpa_supplicant.conf`` will become something like: ::

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

The latter approach with ``wpa_supplicant`` did somehow not work so we remained
in the first simple approach without ``wpa_supplicant``, only a simple ``/etc/network/interfaces`` config.

Bogger: Wifi seems to go down from time to time with ``wlan0: CTRL-EVENT-DISCONNECTED reason=4`` in syslog.
Will use a script in cron to always keep Wifi up.
For topic see http://www.raspberrypi.org/forums/viewtopic.php?t=54001&p=413095.
See script at https://github.com/Geonovum/sospilot/blob/master/src/raspberry/wificheck.sh and Monitoring section below.

Hostname
--------

In ``/etc/hostname`` set to ``georasp``..

Accounts
--------

Two standard accounts: ``root`` ("root admin") en ``sadmin`` ("sensors admin"). NB account ``root``
is never a login account on Ubuntu/Debian!

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

Software - General
==================

Install of standard packages.

nginx Web Server
----------------

As Apache2 seems to have a relative large footprint, many prefer `nginx <http://nginx.com/>`_ as webserver on RPi.
(Though for now, no webserver is used nor required). Setup. ::

    apt-get install nginx

    # start/stop server
    /etc/init.d/nginx start
    /etc/init.d/nginx stop

Config under ``/etc/nginx`` especially, default website at ``/etc/nginx/sites-available/default`` ::

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

Installation - Project Software
===============================

Software and documentation for the project, e.g. ``weewx`` config, are in the project
GitHub: https://github.com/Geonovum/sospilot

Installed under ``/opt/geonovum/sospilot`` ::

    cd /opt/geonovum/sospilot
    git clone https://github.com/Geonovum/sospilot.git git

NB all documentation (Sphinx) is automagically published after each Git commit/push
to ReadTheDocs.org: http://sospilot.readthedocs.org via a standard GitHub Post-commit hook.

The following refresh script is handy to undo local changes and sync with master. ::

    # Refresh from original Repo
    # WARNING will remove all local changes!!!
    # except for files not in Git

    git fetch --all
    git reset --hard origin/master

See https://github.com/Geonovum/sospilot/blob/master/refresh-git.sh

Installation - Weather Software
===============================

weewx - Weather Station server
------------------------------

Home: `weewx <http://www.weewx.com>`_.

Install under ``/opt/weewx``. Custom install as user `sadmin` in order to facilitate custimization.

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

Extra voor TFA Nexus Pro
------------------------

TE923 driver. Nodig `pyusb` ::

    pip install pyusb
    # geeft: DistributionNotFound: No distributions matching the version for pyusb

    # tweede try:
    apt-get install python-usb
    Reading package lists... Done
    Building dependency tree
    Reading state information... Done
    The following NEW packages will be installed:
      python-usb
    0 upgraded, 1 newly installed, 0 to remove and 5 not upgraded.
    Need to get 17.7 kB of archives.
    After this operation, 132 kB of additional disk space will be used.
    Get:1 http://mirrordirector.raspbian.org/raspbian/ wheezy/main python-usb armhf 0.4.3-1 [17.7 kB]
    Fetched 17.7 kB in 0s (37.9 kB/s)
    Selecting previously unselected package python-usb.
    (Reading database ... 83706 files and directories currently installed.)
    Unpacking python-usb (from .../python-usb_0.4.3-1_armhf.deb) ...
    Setting up python-usb (0.4.3-1) ...

    # root@otterpi:/opt/weewx/weewxinst# lsusb
    Bus 001 Device 002: ID 0424:9514 Standard Microsystems Corp.
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 001 Device 003: ID 0424:ec00 Standard Microsystems Corp.
    Bus 001 Device 004: ID 05e3:0608 Genesys Logic, Inc. USB-2.0 4-Port HUB
    Bus 001 Device 005: ID 1130:6801 Tenx Technology, Inc.
    Bus 001 Device 006: ID 148f:5370 Ralink Technology, Corp. RT5370 Wireless Adapter

    # nu andere error van weewx
    Dec 10 15:02:51 otterpi weewx[2645]: te923: Found device on USB bus=001 device=005
    Dec 10 15:02:51 otterpi weewx[2645]: te923: Unable to claim USB interface 0: could not claim interface 0: Operation not permitted
    Dec 10 15:02:51 otterpi weewx[2645]: wxengine: Unable to open WX station hardware: could not claim interface 0: Operation not permitted
    Dec 10 15:02:51 otterpi weewx[2645]: wxengine: Caught WeeWxIOError: could not claim interface 0: Operation not permitted
    Dec 10 15:02:51 otterpi weewx[2645]:     ****  Exiting...

    # may have to do with udev usb rules
    http://www.tdressler.net/ipsymcon/te923.html

    vi /etc/udev/rules.d/99-te923.rules
    Inhalt:
    ATTRS{idVendor}=="1130", ATTRS{idProduct}=="6801", MODE="0660", GROUP="plugdev", RUN="/bin/sh -c 'echo -n $id:1.0 > /sys/bus/usb/drivers/usbhid/unbind'"

    udevadm control --reload-rules

    adduser sadmin plugdev

Installation - Weather Hardware
===============================

The Davis weather station is mounted on the Geonovum roof. The Vantage Pro2 console
is connected via RF to the outside station. The console includes Weatherlink for archiving
and USB connectivity. Via the console the station can be configured. Via weewx the status can be obtained

Several sensors seem to be non-active. ::

    ./wee_config_vantage --info --config /opt/weewx/weewxinst/weewx.conf
    Using configuration file /opt/weewx/weewxinst/weewx.conf.
    Querying...
    Davis Vantage EEPROM settings:

        CONSOLE TYPE:                   VantagePro2

        CONSOLE FIRMWARE:
          Date:                         Jul 14 2008
          Version:                      1.80

        CONSOLE SETTINGS:
          Archive interval:             1800 (seconds)
          Altitude:                     98 (meter)
          Wind cup type:                large
          Rain bucket type:             0.2 MM
          Rain year start:              10
          Onboard time:                 2014-11-03 14:48:51

        CONSOLE DISPLAY UNITS:
          Barometer:                    hPa
          Temperature:                  degree_10F
          Rain:                         mm
          Wind:                         km_per_hour

        CONSOLE STATION INFO:
          Latitude (onboard):           +52.2
          Longitude (onboard):          +5.4
          Use manual or auto DST?       AUTO
          DST setting:                  N/A
          Use GMT offset or zone code?  ZONE_CODE
          Time zone code:               21
          GMT offset:                   N/A

        TRANSMITTERS:
          Channel 1:                    iss
          Channel 2:                    (N/A)
          Channel 3:                    (N/A)
          Channel 4:                    (N/A)
          Channel 5:                    (N/A)
          Channel 6:                    (N/A)
          Channel 7:                    (N/A)
          Channel 8:                    (N/A)

        RECEPTION STATS:
          Total packets received:       109
          Total packets missed:         3
          Number of resynchronizations: 0
          Longest good stretch:         41
          Number of CRC errors:         0

        BAROMETER CALIBRATION DATA:
          Current barometer reading:    29.405 inHg
          Altitude:                     98 feet
          Dew point:                    255 F
          Virtual temperature:          -89 F
          Humidity correction factor:   23
          Correction ratio:             1.005
          Correction constant:          +0.000 inHg
          Gain:                         0.000
          Offset:                       9.000

        OFFSETS:
          Wind direction:               +0 deg
          Inside Temperature:           +0.0 F
          Inside Humidity:              +0%
          Outside Temperature:          -1.0 F
          Outside Humidity:             +0%

Also http://www.weewx.com/docs/usersguide.htm#wee_config_vantage to clear archive and set archive
interval to 5 mins.

Problem: temperature and humidity sensors not working! Working after 3 hours on 20:00, then failing at 0800.
Also low station battery message.

May also be the Davis Supercap Problem: http://vp-kb.wikispaces.com/Supercap+fault

Installation - ETL Tools
========================


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

Postgres Client
---------------

Just need `psql` for now plus libs (`psycopg2`) for Stetl.  ::

    apt-get  install postgresql-client

GDAL/OGR
--------

Volgens de website `<www.gdal.org>`_.

*GDAL is a translator library for raster geospatial data
formats that is released under an X/MIT style Open Source license by the
Open Source Geospatial Foundation. The related OGR library (which lives within the GDAL source tree)
provides a similar capability for simple features vector data.*

Installatie is simpel via APT. ::

    $ apt-get install gdal-bin python-gdal

    # Error...! 2e keer gaat goed na  apt-get update --fix-missing
    Fetched 15.6 MB in 18s (838 kB/s)
    Failed to fetch http://mirrordirector.raspbian.org/raspbian/pool/main/m/mysql-5.5/mysql-common_5.5.38-0+wheezy1_all.deb  404  Not Found
    Failed to fetch http://mirrordirector.raspbian.org/raspbian/pool/main/m/mysql-5.5/libmysqlclient18_5.5.38-0+wheezy1_armhf.deb  404  Not Found

    Setting up libgeos-3.3.3 (3.3.3-1.1) ...
    Setting up proj-bin (4.7.0-2) ...
    Setting up gdal-bin (1.9.0-3.1) ...
    python-gdal_1.9.0-3.1_armhf.deb


Stetl - Streaming ETL
---------------------

Zie http://stetl.org

First all dependencies!  ::

    apt-get install python-pip python-lxml libgdal-dev python-psycopg2

Normaal doen we ``pip install stetl`` maar nu even install uit Git vanwege
te verwachten updates. Install vanuit GitHub versie onder ``/opt/stetl/git`` (als user `sadmin`). ::

    $ mkdir /opt/stetl
    $ cd /opt/stetl
    $ git clone https://github.com/justb4/stetl.git git
    $ cd git
    $ python setup.py install  (als root)

    $ stetl -h
    # 2014-10-21 18:40:37,819 util INFO Found cStringIO, good!
    # 2014-10-21 18:40:38,585 util INFO Found lxml.etree, native XML parsing, fabulous!
    # 2014-10-21 18:40:41,636 util INFO Found GDAL/OGR Python bindings, super!!
    # 2014-10-21 18:40:41,830 main INFO Stetl version = 1.0.7rc13


Installatie Testen. ::

    $ which stetl
    # /usr/local/bin/stetl

    cd /opt/stetl/git/examples/basics
    ./runall.sh
    # OK!

Python Jinja2
-------------

Needed for Stetl Jinja2 templating Filter. ::

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

Installation - Maintenance
==========================

Remote Access
-------------

The RPi is not accessible from outside the LAN. For small maintenance purposes we may setup a
reverse SSH tunnel such that we can access the RPi from a known system, 'remote', to which the RPi can connect via SSH.
This way the RPi is only accessible from 'remote' and the communication is encrypted.

Setting up and maintaining a tunnel is best done with ``autossh``.
See more info at http://linuxaria.com/howto/permanent-ssh-tunnels-with-autossh

Steps as follows. ::

    # install autossh
    $ apt-get install autossh

    # add user without shell on RPi and remote
    useradd -m -s /bin/false autossh

    # Generate keys op RPi
    ssh-keygen -t rsa

    # store on remote in /home/autossh/.ssh/authorized_keys

    # add to /etc/rc.local on RPi/opt/bin/start-tunnels.sh with content
    sleep 120
    export AUTOSSH_LOGFILE=/var/log/autossh/autossh.log
    export AUTOSSH_PIDFILE=/var/run/autossh/autossh.pid
    # export AUTOSSH_POLL=60
    # export AUTOSSH_FIRST_POLL=30
    # export AUTOSSH_GATETIME=30
    export AUTOSSH_DEBUG=1
    rm -rf /var/run/autossh
    mkdir  /var/run/autossh
    chown autossh:autossh /var/run/autossh

    su -s /bin/sh autossh -c
      'autossh -M 0 -q -f -N -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -R <localport>:localhost:22 autossh@<remote>'

Now we can login to the RPi, but only from 'remote' with ``ssh <user>@localhost -p <localport>``.

Monitoring
----------

As the RPi will be running headless and unattended within a LAN, it is of utmost importance
that 'everything remains running'. To this end cronjobs are run with the following crontab file. ::

    # Cronfile for keeping stuff alive on unattended Raspberry Pi
    # Some bit crude like reboot, but effective mostly
    # Author: Just van den Broecke <justb4@gmail.com>
    #
    SHELL=/bin/sh
    PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
    SRC=/opt/geonovum/sospilot/git/src

    # Do checks on weewx and network every N mins
    */6  * * * * $SRC/weewx/weewxcheck.sh
    */10 * * * * $SRC/raspberry/wificheck.sh
    */15 * * * * $SRC/raspberry/rpistatus.sh
    0   4  * * *   shutdown -r +5
    0   3  * * *   $SRC/weewx/backup-weewx.sh

The `weewx` daemon appears to be stopping randomly. Not clear why, but looks like this happens
when there are network problems. To check and restart if needed the following script is run. ::

    #! /bin/sh
    # Author: Just van den Broecke <justb4@gmail.com>
    # Restart weewx if not running.
    #

    WEEWX_HOME=/opt/weewx/weewxinst
    WEEWX_BIN=$WEEWX_HOME/bin/weewxd

    NPROC=`ps ax | grep $WEEWX_BIN | grep $NAME.pid | wc -l`
    if [ $NPROC -gt 1 ]; then
        echo "weewx running multiple times on `date`! Attempting restart." >> /var/log/weewxcheck.log
        /etc/init.d/weewx restart
    elif [ $NPROC = 1 ]; then
        echo "Weewx is ok: $status"
    else
        echo "weewx not running on `date`! Attempting restart." >> /var/log/weewxcheck.log
        /etc/init.d/weewx restart
    fi

Restarts are also logged so we can see how often this happens.

The WiPi seems to have stability problems. This is a whole area of investigation on
WIFI-stations/drivers/parameters etc, that could take days if not weeks... For now a script
is run, that checks if the WIfi (`wlan0` device) is up or else restarts the interface/Wifi.
For topic see http://www.raspberrypi.org/forums/viewtopic.php?t=54001&p=413095.
See script at https://github.com/Geonovum/sospilot/blob/master/src/raspberry/wificheck.sh ::

    #!/bin/bash
    ##################################################################
    # NOTE! THIS IS A MODIFIED VERSION OF THE ORIGINAL PROGRAM
    # WRITTEN BY KEVIN REED.  TO GET THE ORIGINAL PROGRAM SEE
    # THE URL BELOW:
    #
    # A Project of TNET Services, Inc
    #
    # Title:     WiFi_Check
    # Author:    Kevin Reed (Dweeber)
    #            dweeber.dweebs@gmail.com
    #            Small adaptions by Just van den Broecke <justb4@gmail.com>
    # Project:   Raspberry Pi Stuff
    #
    # Copyright: Copyright (c) 2012 Kevin Reed <kreed@tnet.com>
    #            https://github.com/dweeber/WiFi_Check
    #
    # Purpose:
    #
    # Script checks to see if WiFi has a network IP and if not
    # restart WiFi
    #
    # Uses a lock file which prevents the script from running more
    # than one at a time.  If lockfile is old, it removes it
    #
    # Instructions:
    #
    # o Install where you want to run it from like /usr/local/bin
    # o chmod 0755 /usr/local/bin/WiFi_Check
    # o Add to crontab
    #
    # Run Every 5 mins - Seems like ever min is over kill unless
    # this is a very common problem.  If once a min change */5 to *
    # once every 2 mins */5 to */2 ...
    #
    # */5 * * * * /usr/local/bin/WiFi_Check
    #
    ##################################################################
    # Settings
    # Where and what you want to call the Lockfile
    lockfile='/var/run/WiFi_Check.pid'

    # Which Interface do you want to check/fix
    wlan='wlan0'

    # Which address do you want to ping to see if you can connect
    pingip='194.109.6.93'

    ##################################################################
    echo
    echo "Starting WiFi check for $wlan"
    date
    echo

    # Check to see if there is a lock file
    if [ -e $lockfile ]; then
        # A lockfile exists... Lets check to see if it is still valid
        pid=`cat $lockfile`
        if kill -0 &>1 > /dev/null $pid; then
            # Still Valid... lets let it be...
            #echo "Process still running, Lockfile valid"
            exit 1
        else
            # Old Lockfile, Remove it
            #echo "Old lockfile, Removing Lockfile"
            rm $lockfile
        fi
    fi
    # If we get here, set a lock file using our current PID#
    #echo "Setting Lockfile"
    echo $$ > $lockfile

    # We can perform check
    echo "Performing Network check for $wlan"
    /bin/ping -c 2 -I $wlan $pingip > /dev/null 2> /dev/null
    if [ $? -ge 1 ] ; then
        echo "Network connection down on `date`! Attempting reconnection." >> /var/log/wificheck.log
        /sbin/ifdown $wlan
        sleep 10
        /sbin/ifup --force $wlan
    else
        echo "Network is Okay"
    fi


    # Check is complete, Remove Lock file and exit
    #echo "process is complete, removing lockfile"
    rm $lockfile
    exit 0

    ##################################################################
    # End of Script


The overall RPi status is checked every 15 mins and the results posted to
the VPS. In particular the network
usage is monitored via `vnstat`. The script can be found at
https://github.com/Geonovum/sospilot/blob/master/src/raspberry/rpistatus.sh and is
as follows. ::

    #! /bin/sh
    # Author: Just van den Broecke <justb4@gmail.com>
    # Status of RPi main resources. Post to VPS if possible.
    #

    log=/var/log/rpistatus.txt
    remote=sadmin@sensors:/var/www/sensors.geonovum.nl/site/pi

    echo "Status of `hostname` on date: `date`" > $log
    uptime  >> $log 2>&1

    echo "\n=== weewx ===" >> $log
    /etc/init.d/weewx status >> $log
    echo "archive stat: `ls -l /opt/weewx/weewxinst/archive`" >> $log 2>&1
    echo "archive recs: `sqlite3 /opt/weewx/weewxinst/archive/weewx.sdb 'select count(*) from archive'`" >> $log 2>&1

    echo "\n=== restarts ===" >> $log
    echo "weewx:" >> $log
    wc -l /var/log/weewxcheck.log | cut -d'/' -f1 >> $log 2>&1
    echo "\nWifi:" >> $log
    wc -l /var/log/wificheck.log  | cut -d'/' -f1 >> $log 2>&1

    echo "\n=== bandwidth (vnstat)" >> $log
    vnstat >> $log 2>&1

    echo "\n=== network (ifconfig)" >> $log
    ifconfig >> $log 2>&1

    echo "\n=== disk usage (df -h) ===" >> $log
    df -h >> $log 2>&1

    echo "\n=== memory (free -m)===" >> $log
    free -m >> $log 2>&1

    scp $log $remote

A typical result is as follows. See http://sensors.geonovum.nl/pi/rpistatus.txt. ::

    Status of georasp on date: Thu Oct 23 13:11:31 CEST 2014
     13:11:31 up 16:39,  3 users,  load average: 0.18, 0.17, 0.16

    === weewx ===
    Status of weewx weather system:: running.
    archive stat: total 196
    -rw-r--r-- 1 sadmin sadmin    189 Oct 20 13:02 one_archive_rec.txt
    -rw-r--r-- 1 sadmin sadmin  43008 Oct 23 13:08 stats.sdb
    -rw-r--r-- 1 sadmin sadmin 145408 Oct 23 13:08 weewx.sdb
    archive recs: 850

    === restarts ===
    weewx:
    0

    Wifi:
    0

    === bandwidth (vnstat)

                          rx      /      tx      /     total    /   estimated
     eth0: Not enough data available yet.
     wlan0:
           Oct '14      1.32 MiB  /    2.34 MiB  /    3.66 MiB  /    3.00 MiB
             today      1.32 MiB  /    2.34 MiB  /    3.66 MiB  /       4 MiB


    === network (ifconfig)
    eth0      Link encap:Ethernet  HWaddr b8:27:eb:12:6a:ef
              UP BROADCAST MULTICAST  MTU:1500  Metric:1
              RX packets:0 errors:0 dropped:0 overruns:0 frame:0
              TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000
              RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

    lo        Link encap:Local Loopback
              inet addr:127.0.0.1  Mask:255.0.0.0
              UP LOOPBACK RUNNING  MTU:65536  Metric:1
              RX packets:16829 errors:0 dropped:0 overruns:0 frame:0
              TX packets:16829 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:0
              RX bytes:2825670 (2.6 MiB)  TX bytes:2825670 (2.6 MiB)

    wlan0     Link encap:Ethernet  HWaddr 00:c1:41:06:0f:42
              inet addr:10.0.0.241  Bcast:10.255.255.255  Mask:255.0.0.0
              UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
              RX packets:52305 errors:0 dropped:0 overruns:0 frame:0
              TX packets:31157 errors:0 dropped:0 overruns:0 carrier:0
              collisions:0 txqueuelen:1000
              RX bytes:9209831 (8.7 MiB)  TX bytes:11348504 (10.8 MiB)


    === disk usage (df -h) ===
    Filesystem      Size  Used Avail Use% Mounted on
    rootfs           28G  3.0G   24G  12% /
    /dev/root        28G  3.0G   24G  12% /
    devtmpfs        215M     0  215M   0% /dev
    tmpfs            44M  276K   44M   1% /run
    tmpfs           5.0M     0  5.0M   0% /run/lock
    tmpfs            88M     0   88M   0% /run/shm
    /dev/mmcblk0p5   60M  9.6M   50M  17% /boot

    === memory (free -m)===
                 total       used       free     shared    buffers     cached
    Mem:           437        224        212          0         33        136
    -/+ buffers/cache:         55        382
    Swap:           99          0         99

Backup
------

*weewx db backup*

Only weewx.sdb the SQLite DB has to be backed up. The stats file will always be regenerated.

See script:
https://github.com/Geonovum/sospilot/blob/master/src/weewx/backup-weewx.sh
added to root cronfile

Local dir: `/opt/weewx/weewxinst/backup`

Backed up to sensors VPS: `/home/sadmin/weewx-backup` dir.

*Pi SD Card Disk Backup*

Follow instructions on http://sysmatt.blogspot.nl/2014/08/backup-restore-customize-and-clone-your.html
to make a restorable .tar.gz (i.s.o. dd diskclone).  ::

    $ apt-get install dosfstools
    # was already installed
    # attach USB SDcardreader with 16GB SD Card
    $ dmesg
    [39798.700351] sd 0:0:0:1: [sdb] 31586304 512-byte logical blocks: (16.1 GB/15.0 GiB)
    [39798.700855] sd 0:0:0:1: [sdb] Write Protect is off
    [39798.700888] sd 0:0:0:1: [sdb] Mode Sense: 03 00 00 00
    [39798.701388] sd 0:0:0:1: [sdb] No Caching mode page found
    [39798.701451] sd 0:0:0:1: [sdb] Assuming drive cache: write through
    [39798.706669] sd 0:0:0:2: [sdc] Attached SCSI removable disk
    [39798.707165] sd 0:0:0:2: Attached scsi generic sg2 type 0
    [39798.709292] sd 0:0:0:1: [sdb] No Caching mode page found
    [39798.709355] sd 0:0:0:1: [sdb] Assuming drive cache: write through
    [39798.710838]  sdb: sdb1
    [39798.714637] sd 0:0:0:1: [sdb] No Caching mode page found
    [39798.714677] sd 0:0:0:1: [sdb] Assuming drive cache: write through
    [39798.714701] sd 0:0:0:1: [sdb] Attached SCSI removable disk
    [39798.715493] scsi 0:0:0:3: Direct-Access     Generic  SM/xD-Picture    0.00 PQ: 0 ANSI: 2
    [39798.718181] sd 0:0:0:3: [sdd] Attached SCSI removable disk
    [39798.724978] sd 0:0:0:3: Attached scsi generic sg3 type 0

    root@georasp:~# df
    Filesystem     1K-blocks    Used Available Use% Mounted on
    rootfs          29077488 3081180  24496200  12% /
    /dev/root       29077488 3081180  24496200  12% /
    devtmpfs          219764       0    219764   0% /dev
    tmpfs              44788     280     44508   1% /run
    tmpfs               5120       0      5120   0% /run/lock
    tmpfs              89560       0     89560   0% /run/shm
    /dev/mmcblk0p5     60479    9779     50700  17% /boot

    root@georasp:~# parted -l
    Model: Generic SD/MMC (scsi)
    Disk /dev/sdb: 16.2GB
    Sector size (logical/physical): 512B/512B
    Partition Table: msdos

    Number  Start   End     Size    Type     File system  Flags
     1      4194kB  16.2GB  16.2GB  primary  fat32        lba


    Model: SD USD (sd/mmc)
    Disk /dev/mmcblk0: 31.3GB
    Sector size (logical/physical): 512B/512B
    Partition Table: msdos

    Number  Start   End     Size    Type      File system  Flags
     1      4194kB  828MB   824MB   primary   fat32        lba
     2      830MB   31.3GB  30.5GB  extended
     5      835MB   898MB   62.9MB  logical   fat32        lba
     6      902MB   31.3GB  30.4GB  logical   ext4
     3      31.3GB  31.3GB  33.6MB  primary   ext4


    root@georasp:~# parted /dev/sdb
    GNU Parted 2.3
    Using /dev/sdb
    Welcome to GNU Parted! Type 'help' to view a list of commands.
    (parted) mklabel msdos
    Warning: The existing disk label on /dev/sdb will be destroyed and all data on this disk will be lost. Do you want to continue?
    Yes/No? Yes
    (parted) mkpart primary fat16 1MiB 64MB
    (parted) mkpart primary ext4 64MB -1s
    (parted) print
    Model: Generic SD/MMC (scsi)
    Disk /dev/sdb: 16.2GB
    Sector size (logical/physical): 512B/512B
    Partition Table: msdos

    Number  Start   End     Size    Type     File system  Flags
     1      1049kB  64.0MB  62.9MB  primary               lba
     2      64.0MB  16.2GB  16.1GB  primary

    (parted) quit
    Information: You may need to update /etc/fstab.

    root@georasp:~# parted -l
    Model: Generic SD/MMC (scsi)
    Disk /dev/sdb: 16.2GB
    Sector size (logical/physical): 512B/512B
    Partition Table: msdos

    Number  Start   End     Size    Type     File system  Flags
     1      1049kB  64.0MB  62.9MB  primary               lba
     2      64.0MB  16.2GB  16.1GB  primary


    Model: SD USD (sd/mmc)
    Disk /dev/mmcblk0: 31.3GB
    Sector size (logical/physical): 512B/512B
    Partition Table: msdos

    Number  Start   End     Size    Type      File system  Flags
     1      4194kB  828MB   824MB   primary   fat32        lba
     2      830MB   31.3GB  30.5GB  extended
     5      835MB   898MB   62.9MB  logical   fat32        lba
     6      902MB   31.3GB  30.4GB  logical   ext4
     3      31.3GB  31.3GB  33.6MB  primary   ext4


    root@georasp:~# mkfs.vfat /dev/sdb1
    mkfs.vfat 3.0.13 (30 Jun 2012)

    root@georasp:~# mkfs.ext4 -j  /dev/sdb2
    mke2fs 1.42.5 (29-Jul-2012)
    warning: 512 blocks unused.

    Filesystem label=
    OS type: Linux
    Block size=4096 (log=2)
    Fragment size=4096 (log=2)
    Stride=0 blocks, Stripe width=0 blocks
    984960 inodes, 3932160 blocks
    196633 blocks (5.00%) reserved for the super user
    First data block=0
    Maximum filesystem blocks=4026531840
    120 block groups
    32768 blocks per group, 32768 fragments per group
    8208 inodes per group
    Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208

    Allocating group tables: done
    Writing inode tables: done
    Creating journal (32768 blocks): done
    Writing superblocks and filesystem accounting information: done

    root@georasp:~# mkdir /tmp/newpi
    root@georasp:~# mount /dev/sdb2 /tmp/newpi
    root@georasp:~# mkdir /tmp/newpi/boot
    root@georasp:~# mount /dev/sdb1 /tmp/newpi/boot

    root@georasp:~# df -h
    Filesystem      Size  Used Avail Use% Mounted on
    rootfs           28G  3.0G   24G  12% /
    /dev/root        28G  3.0G   24G  12% /
    devtmpfs        215M     0  215M   0% /dev
    tmpfs            44M  284K   44M   1% /run
    tmpfs           5.0M     0  5.0M   0% /run/lock
    tmpfs            88M     0   88M   0% /run/shm
    /dev/mmcblk0p5   60M  9.6M   50M  17% /boot
    /dev/sdb2        15G   38M   14G   1% /tmp/newpi
    /dev/sdb1        60M     0   60M   0% /tmp/newpi/boot
    root@georasp:~# crontab -l
    # Cronfile for keeping stuff alive on unattended Raspberry Pi
    # Some bit crude like reboot, but effective mostly
    # Author: Just van den Broecke <justb4@gmail.com>
    #
    SHELL=/bin/sh
    PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
    SRC=/opt/geonovum/sospilot/git/src

    # Do checks on weewx and network every N mins
    */6  * * * * $SRC/weewx/weewxcheck.sh
    */10 * * * * $SRC/raspberry/wificheck.sh
    */15 * * * * $SRC/raspberry/rpistatus.sh
    0   4  * * *   shutdown -r +5
    root@georasp:~# crontab -r
    root@georasp:~# ls
    Desktop
    root@georasp:~# /etc/init.d/weewx stop
    [ ok ] Stopping weewx weather system: weewx.
    root@georasp:~#

    # get the backup tools
    wget -O sysmatt-rpi-tools.zip  https://github.com/sysmatt-industries/sysmatt-rpi-tools/archive/master.zip

    # do rsync
    $ rsync -av --one-file-system / /boot /tmp/newpi/

    # ...wait long time, many files....

    root@georasp:~# df -h
    Filesystem      Size  Used Avail Use% Mounted on
    rootfs           28G  3.0G   24G  12% /
    /dev/root        28G  3.0G   24G  12% /
    devtmpfs        215M     0  215M   0% /dev
    tmpfs            44M  284K   44M   1% /run
    tmpfs           5.0M     0  5.0M   0% /run/lock
    tmpfs            88M     0   88M   0% /run/shm
    /dev/mmcblk0p5   60M  9.6M   50M  17% /boot
    /dev/sdb2        15G  3.0G   11G  22% /tmp/newpi
    /dev/sdb1        60M  9.6M   51M  16% /tmp/newpi/boot

    # NOOBS stuff repair
    $ edit /tmp/newpi/boot/cmdline.txt
    # root=/dev/mmcblk0p6 must become root=/dev/mmcblk0p2
    dwc_otg.lpm_enable=0 console=ttyAMA0,115200 console=tty1 root=/dev/mmcblk0p2 rootfstype=ext4 elevator=deadline rootwait

    # fstab
    # in /tmp/newpi/etc/fstab
    proc            /proc           proc    defaults          0       0
    /dev/mmcblk0p5  /boot           vfat    defaults          0       2
    /dev/mmcblk0p6  /               ext4    defaults,noatime  0       1
    # should become
    proc            /proc           proc    defaults          0       0
    /dev/mmcblk0p1  /boot           vfat    defaults          0       2
    /dev/mmcblk0p   /               ext4    defaults,noatime  0       1


Overdracht. `/etc/network/interfaces` aanpassen. ::

    # SD-card in USBReader mounten:
    mkdir /tmp/oldpi
    mount /dev/sdb6 /tmp/oldpi
    /tmp/oldpi/etc/network/interfaces

Kiosk Mode
----------

The RPi will be conencted to a TV-screen in a public room at Geonovum (kitchen). As to have
something interesting to see, the Rpi will be put in a "kiosk" mode. This can be
achieved quite simply using a webbrowser and a website. As there is no user interaction
possible via mouse/keyboard this simple setup suffices.

The website will be a continuous change of pages/URLs. For this a simple JavaScript app is made that
changes pages into an `iframe`. See https://github.com/Geonovum/sospilot/blob/master/www/kiosk/index.html.
This app will be published to http://sensors.geonovum.nl/kiosk thus can be updated at all times without
needing access to the RPi. If bandwidth becomes an issue we may move the app to the RPi later.

In order to always start a browser, X-Windows needs to be started at boottime. This is described here:
http://www.opentechguides.com/how-to/article/raspberry-pi/5/raspberry-pi-auto-start.html and here a complete
tutorial https://www.danpurdy.co.uk/web-development/raspberry-pi-kiosk-screen-tutorial

In order to start the browser (Chromium) the following is useful:
https://lokir.wordpress.com/2012/09/16/raspberry-pi-kiosk-mode-with-chromium  and
http://askubuntu.com/questions/487488/how-to-open-chromium-in-full-screen-kiosk-mode-in-minimal-windows-manager-enviro

The following was executed. ::

    # install chromium and tools
    apt-get install chromium x11-xserver-utils unclutter

    # enable X desktop at boot
    raspi-config

    # choose option3

    # edit /etc/xdg/lxsession/LXDE/autostart as follows
    @lxpanel --profile LXDE
    @pcmanfm --desktop --profile LXDE
    # @xscreensaver -no-splash
    @xset s off
    @xset -dpms
    @xset s noblank
    @chromium --noerrdialogs --kiosk http://sensors.geonovum.nl/kiosk

    apt-get install tightvncserver
    tightvncserver
    # start als user pi http://www.penguintutor.com/linux/tightvnc
    su pi -c '/usr/bin/tightvncserver :1'

Links
-----

* http://garethhowell.com/wp/connect-raspberry-pi-3g-network
* http://www.jamesrobertson.eu/blog/2014/jun/24/setting-up-a-huawei-e3131-to-work-with-a.html
* http://christianscode.blogspot.nl/2012/11/python-huawei-e3131-library.html
* Reverse tunneling to access the Pi from outside: http://www.thirdway.ch/En/projects/raspberry_pi_3g/index.php
* Use `autossh` to maintain tunnel: http://unix.stackexchange.com/questions/133863/permanent-background-ssh-connection-to-create-reverse-tunnel-what-is-correct-wa
* http://ccgi.peterhurn.plus.com/wordpress/raspberry-pi-weather-station-installation-notes/






