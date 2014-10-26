#!/bin/bash
#
# ETL for reading PG data and transforming/publishing to a SOS.
#

# Usually requried in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

stetl_cmd=stetl

# debugging
# stetl_cmd=../../../../stetl/git/stetl/main.py

# Set Stetl options

. ../options.sh

options=$options
$stetl_cmd -c pg2sos.cfg -a "$pg_options $sos_options"




