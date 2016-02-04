#!/bin/bash
#
# ETL for harvesting LML measurement XML files from SmartEm
#

# Usually requried in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

stetl_cmd=stetl

# debugging
# stetl_cmd=../../../../stetl/git/stetl/main.py

# Host-specific Postgres credentials in $pg_options
options_file=options-`hostname`.args

$stetl_cmd -c last.cfg -a "$options_file"

