#!/bin/bash
#
# Usually required in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

# set postgres credentials and options in $pg_options
options_file=options-`hostname`.args

logdir=/var/log/sospilot/smartem

stetl -c harvester.cfg -a "$options_file"            >> $logdir/harvester.log 2>&1
