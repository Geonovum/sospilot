#!/bin/bash
# 
# Usually required in order to have Python find your package                                                                                                          
export PYTHONPATH=.:$PYTHONPATH

# set postgres credentials and options in $pg_options
. pgcreds.sh

logdir=/var/log/sospilot

stetl -c files2measurements.cfg -a "$pg_options"   >> $logdir/files2measurements.log 2>&1

