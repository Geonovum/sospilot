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

To be supplied.

