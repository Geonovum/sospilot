#!/bin/bash
# resets all RIVM-related ETL (Step 1 and Step 2 ETL)
# Use with care as ALL DATA WILL BE DELETED!!!
#

. options.sh

# Drop the schema to delete all
psql -f db-schema-drop.sql sensors

# Insert all stations from CSV
cd ../../data/rivm-lml/stations
./stations2postgis.sh
cd -

# Redefine tables and VIEWs (needs stations table)
psql -f db-schema.sql sensors
