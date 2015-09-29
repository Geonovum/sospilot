#!/bin/bash
# resets all SmartEm-related ETL (Step 1 and Step 2 ETL)
# Use with care as ALL DATA WILL BE DELETED!!!
#

# . options.sh
source options-`hostname`.args
export PGPASSWORD=$pg_password
export PGUSER=$pg_user
export PGHOST=$pg_host

# Drop the schema to delete all
psql -f db/db-schema-drop.sql sensors

# Insert all stations from CSV
./stations2postgis.sh

# Redefine tables and VIEWs (needs stations table)
psql -f db/db-schema.sql sensors
