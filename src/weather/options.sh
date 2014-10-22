#!/bin/sh
#
# Sets host-specific variables
# To add your localhost add options-<your hostname>.sh in this directory
. options-`hostname`.sh

export options="host=localhost port=5432 weewx_db=$WEEWX_DB user=$PGUSER password=$PGPASSWORD database=sensors schema=weather"
