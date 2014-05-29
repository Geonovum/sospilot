#!/bin/sh
#
# All ETL for Harvesting and Measurements
#

# Usually required in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

options="database=sensors host=localhost user=postgres password=postgres schema=rivm_lml"

logdir=/var/log/sospilot

stetl -c harvester.cfg -a "$options"            >> $logdir/harvester.log 2>&1

stetl -c files2measurements.cfg -a "$options"   >> $logdir/files2measurements.log 2>&1
