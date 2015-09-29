#!/bin/bash
# 
# Usually required in order to have Python find your package                                                                                                          
export PYTHONPATH=.:$PYTHONPATH

# set local options in env
options_file=options-`hostname`.args

logdir=/var/log/sospilot/smartem

# stetl -c harvester.cfg -a "$pg_options"            >> $logdir/harvester.log 2>&1

stetl -c files2measurements.cfg -a "$options_file"   >> $logdir/files2measurements.log 2>&1

stetl -c measurements2sos.cfg -a "$options_file"  >> $logdir/measurements2sos.log 2>&1
