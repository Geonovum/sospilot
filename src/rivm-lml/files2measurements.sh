#!/bin/bash
#
# ETL for harvesting LML measurement XML files from RIVM
#

# Usually requried in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

stetl_cmd=stetl

# debugging
# stetl_cmd=../../../../stetl/git/stetl/main.py

# Host-specific Postgres credentials in $pg_options
. options.sh

options="$pg_options"

$stetl_cmd -c files2measurements.cfg -a "$options"


