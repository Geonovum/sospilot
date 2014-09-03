#!/bin/bash
#
# Usually required in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

# set postgres credentials and options in $pg_options
# . pgcreds.sh

logdir=/var/log/sospilot

stetl_cmd=stetl

# debugging
stetl_cmd=../../../../stetl/git/stetl/main.py

$stetl_cmd -c dataflow-D.cfg
