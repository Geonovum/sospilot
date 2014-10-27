#!/bin/bash
#
# ETL for converting station table to OWS SOS sensors.
#

# Usually requried in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

stetl_cmd=stetl

# debugging
# stetl_cmd=../../../../stetl/git/stetl/main.py

# Host-specific Postgres credentials in $pg_options
. options.sh

options="$pg_options $sos_options"

$stetl_cmd -c stations2sensors.cfg -a "$options"


