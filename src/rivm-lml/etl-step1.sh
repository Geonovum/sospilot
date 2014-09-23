#!/bin/bash
#
# Usually required in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

# set postgres credentials and options in $pg_options
. pgcreds.sh

logdir=/var/log/sospilot

stetl -c harvester.cfg -a "$pg_options"            >> $logdir/harvester.log 2>&1
