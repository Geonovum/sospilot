.. _admin:

==============
Administration
==============

This chapter describes the operation and maintenance aspects for the SOSPilot platform. For example:

* how to start stop servers
* managing the ETL
* where to find logfiles

Data Management
===============

The data is harvested and transformed in three ETL steps. See chapter on Data Management.

The ``cron`` job runs under account ``sadmin`` with this cronfile:
https://github.com/Geonovum/sospilot/blob/master/src/rivm-lml/cronfile.txt . LOgfiles are under
``/var/log/sospilot``.

Every 30 minutes all three steps are run (for now) via the script
``https://github.com/Geonovum/sospilot/blob/master/src/rivm-lml/etl-all.sh``.
It is best to stop the cronjob whenever doing any
of the resets below. Also be aware that the ETL steps build up history.

Reset ETL Step 1 - RIVM File Harvester
--------------------------------------

* Empty (not drop) the table ``rivm_lml.lml_files``

The Harvester tracks its progress via the unique file id in ``rivm_lml.lml_files``.

Reset ETL Step 1 - Stations
---------------------------

Whenever there is a new set of stations CSV. This needs to be done. Note: also the SOS Sensor data (see below)
needs to be updated. This may be problematic/refined.  See
https://github.com/Geonovum/sospilot/tree/master/data/rivm-lml/stations

* Drop the table ``rivm_lml.stations``
* check with * ``stations2gml.sh``
* ``stations2postgis.sh``


Reset ETL Step 2 - Files to Core AQ
-----------------------------------

* Reset counter ``last_id`` to ``-1`` in table ``rivm_lml.etl_progress`` for row where worker is ``files2measurements``
* Also you will need to empty (not drop) the table ``rivm_lml.measurements``

Reset ETL Step 3 - SOS-T Sensor Publishing
------------------------------------------

This re-publishes the Stations as Sensors.

* You will need to clear the SOS database (for now, see below)
* run https://github.com/Geonovum/sospilot/blob/master/src/rivm-lml/stations2sensors.sh

Reset ETL Step 3 - SOS-T Observations Publishing
------------------------------------------------

* Reset counter ``last_id`` to ``-1`` in table ``rivm_lml.etl_progress`` for row where worker is ``measurements2sos``
* Also you will need to clear the SOS database

Clean SOS data
--------------

See data and scripts at https://github.com/Geonovum/sospilot/tree/master/data/sosdb. Using this procedure, no
reinstall of the .war file is requried or any other Admin reset (somehow an Admin reset did not work).

As root do

* Stop Tomcat (command ``/opt/bin/tcdown``)
* Clean DB: reinstall PG schema using: https://github.com/Geonovum/sospilot/blob/master/data/sosdb/empty-dm-dump.sql
* Remove ``/var/www/sensors.geonovum.nl/webapps/sos/cache.tmp``.
* Start Tomcat (command ``/opt/bin/tcup``)
* Republish the Sensors (see Stations to Sensors)
* restart the cron (see above)

Web Services
============

The Tomcat server runs both GeoServer and the 52N SOS server. Logfiles in ``/var/log/tomcat/catalina.out``.
Stop/start with shorthand: ``/opt/bin/tcstop`` and ``/opt/bin/tcstart``.

Admin GeoServer: http://sensors.geonovum.nl/gs/web

Admin SOS: http://sensors.geonovum.nl/sos



