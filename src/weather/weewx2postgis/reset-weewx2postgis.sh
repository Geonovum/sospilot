#!/bin/bash
#
# ETL for reset.
#
# Set Stetl options

. options.sh

options="$options sql_files=reset-weewx2postgis.sql"

echo "options = [$options]"

stetl -c sql-exec.cfg -a "$options"


