#!/bin/sh
#
# stations.json is gotten from a WFS.
#
rm stations.json

wget -O stations.json 'http://sensors.geonovum.nl/gs/ows?service=WFS&request=GetFeature&typeName=sensors:active_stations&outputformat=JSON&srsName=EPSG:4326'