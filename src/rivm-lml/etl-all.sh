# Usually required in order to have Python find your package                                                                                                          
export PYTHONPATH=.:$PYTHONPATH

# set postgres credentials and options in $pg_options
. pgcreds.sh

logdir=/var/log/sospilot

stetl -c harvester.cfg -a "$pg_options"            >> $logdir/harvester.log 2>&1

stetl -c files2measurements.cfg -a "$pg_options"   >> $logdir/files2measurements.log 2>&1

http_options="http_host=sensors.geonovum.nl http_port=80 http_user=postgres http_password=postgres  http_path=/sos/service"

stetl -c measurements2sos.cfg -a "$pg_options $http_options"  >> $logdir/measurements2sos.log 2>&1
