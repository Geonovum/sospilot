#!/bin/sh
#
# Sets host-specific variables
# To add your localhost add options-<your hostname>.sh in this directory

# All file locations are relative to the specific ETL subdirs like weewx2pg
. ../options-`hostname`.sh

export options="host=localhost port=5432 weewx_db=$WEEWX_DB user=$PGUSER password=$PGPASSWORD database=sensors schema=weather table=measurements"
