# COnvert stations.csv to PostGIS
# Uses ogr2ogr with VRT option to map CSV to spatial dataset
# see stations.vrt for this mapping
#

# Host-specific environment settings
source options-`hostname`.args

ogr2ogr -overwrite -f "PostgreSQL" -lco FID=gid -lco OVERWRITE=yes -lco GEOMETRY_NAME=point -lco SCHEMA=$pg_schema \
 PG:"host=$pg_host dbname=$pg_database port=$pg_port user=$pg_user  password=$pg_password" \
  stations.vrt -nln stations

