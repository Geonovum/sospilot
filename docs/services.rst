.. _services:

============
Web Services
============

This chapter describes how the web services are realized on top of the
converted/transformed data. In particular:

* WFS and WMS-Time services
* OWS SOS service

Architecture
============

Figure 1 sketches the overall SOSPilot architecture with emphasis on the flow of data (arrows).
Circles depict harvesting/ETL processes. Server-instances are in rectangles. Datastores
the "DB"-icons.

.. figure:: _static/sospilot-arch1.jpg
   :align: center

   *Figure 1 - Overall Architecture*


WFS and WMS-Time Services
=========================

This describes the realization in GeoServer.  GeoServer can directly generate
OWS services from a PostGIS source. As WFS and WMS always need a geometry-column, we will use
the ``stations`` table and the ``measurements-stations`` VIEW described in the Data Management chapter.

The ``stations`` table looks as follows.

.. figure:: _static/stations-postgis.jpg
   :align: center

   *Figure - RIVM Eionet Stations Read into Postgres/PostGIS*

The ``measurements-stations`` VIEW looks as follows.


.. figure:: _static/lml-measurements-stations-records.jpg
   :align: center

   *Figure - LML Postgres VIEW of combined measurements and stations*

It is quite trivial to create 2 WMS layers and 2 WFS layers via the GeoServer Admin GUI.
The challenge is to do something interesting with the Time aspect (field ``sample_time``) as
all features would be positions at the same (station) point coordinates.

For WMS we can use WMS-Time, for WFS we may provide search forms with queries. Other visualizations
may be interesting like Voronoi diagrams: http://smathermather.wordpress.com/2013/12/21/voronoi-in-postgis/.

The OWS services are available from this URL:
http://sensors.geonovum.nl/gs/sensors/ows

The WFS capabilties: http://sensors.geonovum.nl/gs/wfs?request=GetCapabilities

The WMS Capabilities: http://sensors.geonovum.nl/gs/wms?request=GetCapabilities

Stations Layer
--------------

This is quite trivial: a small flat table with station info and a Point geometry.
The WMS layer may be added to a viewer like the KadViewer: http://kadviewer.kademo.nl or
any other GIS package.

.. figure:: _static/wms-stations-viewer.jpg
   :align: center

   *Figure - GeoServer stations WMS Layer with FeatureInfo*


Measurements Layer
------------------

This layer is created from the ``measurements-stations`` VIEW described above.

A WFS query can be as follows:

.. figure:: _static/lml-measurements-stations-wfsreq.jpg
   :align: center

   *Figure - GeoServer measurements Layer WFS query*


SOS  Services
=============

To be supplied.

"The OGC Sensor Observation Service aggregates readings from live, in-situ and remote sensors.
The service provides an interface to make sensors and sensor data archives accessible via an
interoperable web based interface."

Installatie van de INSPIRE version of SOS server from 52North.

Fix: Make ``DeleteObservation`` operation ``Inactive`` in the Admin, otherwise each observation identifier
ends up as allowed parameter Value in the GetCapabilities document.




