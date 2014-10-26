#!/bin/sh
#
# Sets host-specific variables
# To add your localhost add options-<your hostname>.sh in this directory

# All file locations are relative to the specific ETL subdirs like weewx2pg
. ../options-`hostname`.sh

export weewx_options="weewx_db=$WEEWX_DB"
export pg_options="host=localhost port=5432 user=$PGUSER password=$PGPASSWORD database=sensors schema=weather"
export sos_options="sos_host=sensors.geonovum.nl sos_port=80 sos_user=$SOSUSER sos_password=$SOSPASSWORD sos_path=/sos/service"
