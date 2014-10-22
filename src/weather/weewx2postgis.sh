#!/bin/bash
#
# ETL for converting/harvesting weewx archive data into PostGIS
#

# Usually requried in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

stetl_cmd=stetl

# debugging
# stetl_cmd=../../../../stetl/git/stetl/main.py

# Set Stetl options

. pgcreds.sh

$stetl_cmd -c weewx2postgis.cfg -a "$options"


