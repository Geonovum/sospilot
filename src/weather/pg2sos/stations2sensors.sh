#!/bin/bash
#
# ETL for reading PG stations data and transforming/publishing to SOS sensors.
#

# Usually requried in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

stetl_cmd=stetl

# debugging
# stetl_cmd=../../../../stetl/git/stetl/main.py

# Set Stetl options

. ../options.sh

options=$options
$stetl_cmd -c stations2sensors.cfg -a "$pg_options $sos_options"

