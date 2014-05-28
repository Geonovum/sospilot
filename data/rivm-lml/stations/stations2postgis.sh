# COnvert stations.csv to PostGIS
# Uses ogr2ogr with VRT option to map CSV to spatial dataset
# see stations.vrt for this mapping
#
ogr2ogr -overwrite -f "PostgreSQL" -lco FID=gid -lco OVERWRITE=yes -lco GEOMETRY_NAME=point -lco SCHEMA=rivm_lml \
 PG:"host=localhost dbname=sensors port=5432 user=postgres  password=postgres" \
  stations.vrt -nln stations

