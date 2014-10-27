#!/bin/bash
#
# Usually required in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

# set postgres credentials and options in $pg_options
. options.sh

logdir=/var/log/sospilot

stetl -c measurements2sos.cfg -a "$pg_options $sos_options"  >> $logdir/measurements2sos.log 2>&1
