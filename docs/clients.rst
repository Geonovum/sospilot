.. _clients:

=======
Clients
=======

This chapter describes how various client applications are realized on top of the
web services In particular:

* WFS and WMS-Time clients
* OWS SOS clients

HeronViewer
===========

Figure 1 depicts a screenshot of the HeronViewer, found at  http://sensors.geonovum.nl/heronviewer .

.. figure:: _static/heronviewer-1.jpg
   :align: center

   *Figure 1 - HeronViewer showing components with time series values*

The HeronViewer is built using the Heron Web Mapping client framework. This is mainly a matter of
providing a configuration of widgets and layer settings.

The main feature of this viewer is that it interacts with the various WMS Layers (see Web Services), using the
OGC standardized WMS Time Dimension, also know as WMS-T.

This viewer uses all standard Heron components, except a for a ``TimeRangePanel``, the slider that
enables the user to go through time. Via WMS-T component measurement values are displayed for that
paricular date and time.


SOS Clients
===========

SensorWebClient (52N)
---------------------

Homepage: https://wiki.52north.org/bin/view/SensorWeb/SensorWebClient
Installation Guide: https://wiki.52north.org/bin/view/SensorWeb/SensorWebClientInstallationGuide

Install Development line from GIT ::

    $ cd /opt/52north/sensorwebclient
    $ git clone https://github.com/ridoo/SensorWebClient.git git
    $ cd git
    # Configure SOS instances within ./sensorwebclient-webapp/src/main/webapp/ds/sos-instances.data.xml
    # Copy ${project_root}/sensorwebclient-build-example.properties to ~/sensorwebclient-build-dev.properties
    # Adapt: ~/sensorwebclient-build-dev.properties
    $ cd sensorwebclient-webapp
    $ mvn -e clean install -P env-dev
    # target war: sensorwebclient-webapp/target/sensorwebclient-webapp-3.3.0-SNAPSHOT.war

    # Deploy in Tomcat
    # Als root:
    $ chown tomcat7:tomcat7
         /opt/52north/sensorwebclient/git/sensorwebclient-webapp/target/sensorwebclient-webapp-3.3.0-SNAPSHOT.war
    $ cp /opt/52north/sensorwebclient/git/sensorwebclient-webapp/target/sensorwebclient-webapp-3.3.0-SNAPSHOT.war
        /var/www/sensors.geonovum.nl/webapps/swc.war

SOS-JS Client (52N)
-------------------

This is a "pure" JavaScript client. It builds on OpenLayers and JQuery.

Homepage: https://github.com/52North/sos-js

*SOS.js is a Javascript library to browse, visualise, and access, data from an Open Geospatial Consortium (OGC)*
*Sensor Observation Service (SOS)....This module is built on top of OpenLayers, for low-level SOS request/response handling.*

This client has components for protocol handling (via OpenLayers), maps and visualization
with plotted graphs and tabular data. There are some examples available.

A live application built by the British Antarctic Survey and can be viewed here: http://basmet.nerc-bas.ac.uk/sos. There
is also an advanced viewer: http://add.antarctica.ac.uk/home/add6

.. figure:: _static/sos-js-bas-map.jpg
   :align: center
   :width: 650 px

   *Figure 2 - app made with SOS-JS by British Antarctic Survey (Map)*


.. figure:: _static/sos-js-bas-plot.jpg
   :align: center
   :width: 650 px

   *Figure 3 - app made with SOS-JS by British Antarctic Survey (Plot)*

We will build a web-app based on the above. This app can be found at: http://sensors.geonovum.nl/sos-js-app
We cannot yet select stations by clcking inthe map, but via the offering list we can
plot a graph for a chemical component for a station during a timeframe.

.. figure:: _static/sos-js-sospilot-map.jpg
   :align: center
   :width: 650 px

   *Figure 4 - app made with SOS-JS for SOSPilot (Map)*


.. figure:: _static/sos-js-sospilot-plot.jpg
   :align: center
   :width: 650 px

   *Figure 5 - app made with SOS-JS for SOSPilot shows NO2 graph for Station Roerdalen,NL00107*





