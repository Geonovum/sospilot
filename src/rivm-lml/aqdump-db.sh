#!/bin/bash
# Dumps all aq data in Postgres from LML and other projects.
#


. options.sh

outdir=/var/www/sensors.geonovum.nl/site/aqdump

/bin/rm -rf ${outdir}
mkdir -p ${outdir}/lml/shape
mkdir -p ${outdir}/lml/csv
mkdir -p ${outdir}/smartemission/shape
mkdir -p ${outdir}/smartemission/csv

components="nh3 no no2 so2 o3 pm10 pm25 co"
# components="nh3 co"
for comp in $components
do
  outfile=${outdir}/lml/shape/lml-${comp}.shp
  sql="SELECT * FROM rivm_lml.v_measurements_$comp"
  pg="host=${PGHOST} user=${PGUSER} dbname=sensors password=${PGPASSWORD}"
  ogr2ogr -f "ESRI Shapefile" ${outfile}  PG:"${pg}" -sql "$sql"

  outfile=${outdir}/lml/csv/lml-${comp}.csv
  ogr2ogr -f CSV ${outfile}  PG:"${pg}" -sql "$sql" -lco GEOMETRY=AS_XY
done

components="no2 co o3"
for comp in $components
do
  outfile=${outdir}/smartemission/shape/smartem-${comp}.shp
  sql="SELECT * FROM smartem.v_measurements_$comp"
  pg="host=${PGHOST} user=${PGUSER} dbname=sensors password=${PGPASSWORD}"
  ogr2ogr -f "ESRI Shapefile" ${outfile}  PG:"${pg}" -sql "$sql"

  outfile=${outdir}/smartemission/csv/smartem-${comp}.csv
  ogr2ogr -f CSV ${outfile}  PG:"${pg}" -sql "$sql" -lco GEOMETRY=AS_XY
done

pushd ${outdir}
/opt/bin/zipdir lml ${outdir}/lml.zip
/opt/bin/zipdir smartemission ${outdir}/smartemission.zip
popd
