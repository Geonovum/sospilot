#!/bin/bash
#
# Usually required in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

# set postgres credentials and options in $pg_options
. pgcreds.sh

logdir=/var/log/sospilot

http_options="http_host=sensors.geonovum.nl http_port=80 http_user=postgres http_password=postgres  http_path=/sos/service"

stetl -c measurements2sos.cfg -a "$pg_options $http_options"  >> $logdir/measurements2sos.log 2>&1
