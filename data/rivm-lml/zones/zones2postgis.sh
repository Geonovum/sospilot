# Convert zones and agglomerations from Netherlands from Shapefile to Postgis
#
# From http://cdr.eionet.europa.eu/nl/eu/aqd/b/envu9_csq
# Downloaded on aug 25, 2014
#
# Description	Data flow B Zones and agglomerations
# Obligations	(B) Information on zones and agglomerations (Article 6)
# Period	2013 - Whole Year
# Coverage	Netherlands
# Reported	2014/08/05 13:45:7.951058 GMT+2
# Status	Task(s) waiting to be assigned: Redeliver or Finish

ogr2ogr -overwrite -f "PostgreSQL" -lco FID=gid -lco OVERWRITE=yes -lco PRECISION=NO -lco GEOMETRY_NAME=geom -lco SCHEMA=rivm_lml \
 PG:"host=localhost dbname=sensors port=5432 user=postgres password=postgres" \
  airquality_zone_agglomeration_v2013.shp -nln zones -nlt MULTIPOLYGON


