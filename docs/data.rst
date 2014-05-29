.. _data:

===============
Data Management
===============

This chapter describes all technical aspects related to data within the SOSPilot project. The "data"
as mentioned here is all related to LML RIVM data, i.e. Dutch Air Quality Data.

* obtaining raw source data: measurements, stations etc.
* data transformation (ETL) for various (OWS) services, INSPIRE and E-reporting
* tooling (databases and ETL-tools) for the above

Source code for data management and ETL can be found in GitHub: https://github.com/Geonovum/sospilot/tree/master/src

Architecture
============

Figure 1 sketches the overall SOSPilot architecture with emphasis on the flow of data (arrows).
Circles depict harvesting/ETL processes. Server-instances are in rectangles. Datastores
the "DB"-icons.

.. figure:: _static/sospilot-arch1.jpg
   :align: center

   *Figure 1 - Overall Architecture*


ETL Design
==========

Three main ETL steps with three datastores:

#. Harvest source data from RIVM e.g. from  http://geluid.rivm.nl/sos and store locally
#. Transform local source data to intermediate “core” AQDB
#. “Core DB” naar 52N SOS DB, evt later naar IPR/INSPIRE XML


The dataflow is as follows:

#. The File Harvester fetches XML files with AQ/LML measurements from the RIVM server
#. The File Harvester puts these files as XML blobs 1-1 in a database
#. The AQ ETL process reads these file blobs and transforms these to the Core AQ DB (Raw Measurements)
#. The Core AQ DB contains measurements + stations in regular tables 1-1 with original data, adding also a Time column
#. The Core AQ DB can be used for OWS (WMS/WFS) services via GeoServer (possibly using VIEW by Measurements/Stations JOIN)
#. The SOS ETL process transforms core AQ data to the 52North SOS DB schema (how? directly, WFS or REST?)
#. These three processes run continuously (via cron)
#. Each process always knows its progress and where it needs to resume, even after it has been stopped (by storing a 'timestamp' in Progress table)


De 3 ETL-processen (bijv via cron) houden steeds hun laatste sync-time bij in DB.

Advantages of this approach:

* backups of source data possible
* in case of (design) errors we can always reset the 'progress timestamp(s)' and restart anew
* simpler ETL scripts than “all-in-one", e.g. from “Core AQ DB” to "52N SOS DB" may even be in plain SQL
* migration with changed in 52N SOS DB schema simpler
* prepared for op IPR/INSPIRE ETL (source is Core OM DB)
* OWS server (WMS/WFS evt WCS) can directly use op Core OM DB (possibly via Measurements/Stations JOIN VIEW evt, see below)

The Open Source ETL tool `Stetl, Streaming ETL <http://www.stetl.org>`_  , is used for most of the transformation steps.

ETL Step 1. - Harvester
-----------------------

The RIVM data server provides measurements of the past month in a collection
of XML files served by an Apache HTTP server. See figure below.

.. figure:: _static/lml-raw-file-listing-xml.jpg
   :align: center

   *Figure - Apache Server Raw File Listing*

The LML Harvester will continuously read these XML files and store
these in the DB as XML Blobs with their filename.

.. figure:: _static/lml-raw-file-record-xml.jpg
   :align: center

   *Figure - Raw File Record Harvested into DB*

This can be effected by a simple Stetl process activated every 30 mins via the linux
``cron`` service. Stetl has a built-in module for Apache dir listing reading.
Only a derived version needed to be developed in order to track which files have been
read already. This is implemented in the file https://github.com/Geonovum/sospilot/blob/master/src/rivm-lml/apachedirinput.py.

Note: there are two data streams with AQ Data from RIVM: "XML" oriented and "SOS" oriented. We will use the "XML" oriented
as the file format is simpler to process and less redundant with station info. The URL is
http://test.lml.rivm.nl/xml, later to become http://lml.rivm.nl/xml.

For completeness, the "SOS" oriented are identical
in measurements, though not rounded, but that should be within error range:
http://test.lml.rivm.nl/sos, later to become http://lml.rivm.nl/sos.

There also seem to be differences, for example "SOS": ::

    <ROW>
        <OPST_OPDR_ORGA_CODE>RIVM</OPST_OPDR_ORGA_CODE>
        <STAT_NUMMER>633</STAT_NUMMER>
        <STAT_NAAM>Zegveld-Oude Meije</STAT_NAAM>
        <MCLA_CODE>regio achtergr</MCLA_CODE>
        <MWAA_WAARDE>-999</MWAA_WAARDE>
        <MWAA_BEGINDATUMTIJD>20140527120000</MWAA_BEGINDATUMTIJD>
        <MWAA_EINDDATUMTIJD>20140527130000</MWAA_EINDDATUMTIJD>
    </ROW>

vs "XML": ::

    <meting>
        <datum>27/05/2014</datum>
        <tijd>13</tijd>
        <station>633</station>
        <component>CO</component>
        <eenheid>ug/m3</eenheid>
        <waarde>223</waarde>
        <gevalideerd>0</gevalideerd>
    </meting>

Gotcha: there is a file called ``actueel.xml``. This file has to be skipped to avoid double records.

ETL Step 2 - Raw Measurements
-----------------------------

This step produces raw AQ measurements from raw source (file) data into Postgres/PostGIS
tables.

Need to tables: Stations and Metingen. This is a 1:1 transformation from the raw XML.
Station id's are foreign keys in the Metingen table.

Stations
~~~~~~~~

Station info is available from Eionet as a CSV file. Coordinates are in EPSG:4258 (also used in INSPIRE).

To create "clean" version of eionet RIVM stations understood by ogr2ogr to read into PostGIS:

* download CSV from http://cdr.eionet.europa.eu/Converters/run_conversion?file=nl/eu/aqd/d/envurreqq/REP_D-NL_RIVM_20131220_D-001.xml&conv=450&source=remote
* this file saves as ``REP_D-NL_RIVM_20131220_D-001.csv``
* copy to stations.csv for cleaning
* stations.csv: remove excess quotes, e.g. """
* stations.csv: replace in CSV header ``Pos`` with ``Lat,Lon``
* stations.csv: replace space between coordinates with comma: e.g ``,51.566389 4.932792,`` becomes ``,51.566389,4.932792,``
* test result stations.csv by uploading in e.g. Geoviewer: http://kadviewer.kademo.nl
* create or update ``stations.vrt`` for OGR mapping
* use stations2postgis.sh to map to PostGIS table
* use stations2gml.sh to map to GML file

See details in GitHub: https://github.com/Geonovum/sospilot/tree/master/data/rivm-lml/stations

Test first by uploading and viewing in a  geoviewer, for example in http://kadviewer.kademo.nl
See result.

.. figure:: _static/rivm-eionet-stations.jpg
   :align: center

   *Figure - RIVM Eionet Stations uploaded/viewed in Heron-based Viewer*

Reading into PostGIS

.. figure:: _static/stations-postgis.jpg
   :align: center

   *Figure - RIVM Eionet Stations Read into Postgres/PostGIS*

Measurements
~~~~~~~~~~~~

Reading raw measurements from the files stored in the ``lml_files`` table is done with a ``Stetl``
process. A specific Stetl Input module was developed to effect reading and parsing the files
and tracking the last id of the file processed.
https://github.com/Geonovum/sospilot/blob/master/src/rivm-lml/lmlfiledbinput.py

The Stetl process is defined in
https://github.com/Geonovum/sospilot/blob/master/src/rivm-lml/files2measurements.cfg

The invokation of that Stetl process is via shell script:
https://github.com/Geonovum/sospilot/blob/master/src/rivm-lml/files2measurements.sh

The data is stored in the ``measurements`` table, as below. ``station_id`` is a foreign key
into the ``stations`` table.

.. figure:: _static/lml-measurements-records.jpg
   :align: center

   *Figure - LML raw measurements stored in Postgres*

Tracking ETL progress for the worker ``files2measurements`` is done in the ``etl_progress`` table.
The ``last_id`` field is the identifier of the last record in the ``lml_files`` table
processed. On each new run the ETL process starts from new records since that last record.

.. figure:: _static/lml-etl-progress-records.jpg
   :align: center

   *Figure - LML ETL Progress Tracked in Postgres*

ETL Step 3 - SOS ready Data
---------------------------

In this step the Raw Measurements data (see Step 2) is transformed to "SOS Ready Data",
i.e. data that can be handled by the 52North SOS server. Two options:

#. direct transforma into the SOS database of the 52NSOS server
#. via WFS publishing
#. via REST ?




