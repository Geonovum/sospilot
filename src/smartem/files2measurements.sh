#!/bin/bash
#
# ETL for harvesting LML measurement XML files from SmartEm
#

# Usually requried in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

stetl_cmd=stetl

# debugging
# stetl_cmd=../../../../stetl/git/stetl/main.py

# Host-specific arguments
options_file=options-`hostname`.args

$stetl_cmd -c files2measurements.cfg -a "$options_file"



