#!/bin/bash
# 
# Usually required in order to have Python find your package                                                                                                          
export PYTHONPATH=.:$PYTHONPATH

# set postgres credentials and options in $pg_options
options_file=options-`hostname`.args

logdir=/var/log/sospilot/smartem

stetl -c files2measurements.cfg -a "$options_file"   >> $logdir/files2measurements.log 2>&1

