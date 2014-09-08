#!/bin/sh
#
# zones.json is gotten from a WFS.
#
echo "1) fetch the zones from the WFS"
rm zones.json

wget -O zones.json 'http://sensors.geonovum.nl/gs/wfs?request=GetFeature&typeName=sensors:zones&outputformat=JSON&srsName=EPSG:4326'

# also: copy theCSV file with extra attributes to another name, because of easier OGR syntax

echo "2) join the CSV file using ogr2ogr"

rm zonesattr.csv
cp Zones_NL-001_upd_fixed.csv zonesattr.csv

rm zones-joined.json

# TODO: use Stetl for this OGR command
ogr2ogr -sql "select * from OGRGeoJSON a left join 'zonesattr.csv'.zonesattr b on a.zone_code = b.zone_code" -f "GeoJSON" zones-joined.json zones.json

echo "3) Finished. Results should be in zones-joined.json"