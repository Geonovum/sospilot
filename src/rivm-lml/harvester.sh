#!/bin/sh
#
# ETL for harvesting LML measurement XML files from RIVM
#

# Usually requried in order to have Python find your package
PYTHONPATH=.:$PYTHONPATH

stetl_cmd=stetl

# debugging
# stetl_cmd=../../../../stetl/git/stetl/main.py

options="database=sensors host=localhost user=postgres password=postgres schema=rivm_lml"

$stetl_cmd -c harvester.cfg -a "$options"

