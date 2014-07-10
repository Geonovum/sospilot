# COnvert stations.csv to PostGIS
# Uses ogr2ogr with VRT option to map CSV to spatial dataset
# see stations.vrt for this mapping
#


ogr2ogr -overwrite -f "PostgreSQL" -lco FID=gid -lco OVERWRITE=yes -lco GEOMETRY_NAME=point -lco SCHEMA=knmi \
 PG:"host=localhost dbname=sensors port=5432 user=postgres  password=postgres" \
  stations.vrt -nln stations

# update stations set station_code = station_code % 6000;
