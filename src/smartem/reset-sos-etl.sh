#!/bin/bash
# resets all 52North SOS-related ETL (Step 3 ETL)
# Use with care as ALL DATA WILL BE DELETED!!!
#
# Run this as Root
#

options_file=options-`hostname`.args

# Stop Tomcat
/etc/init.d/tomcat7 stop

# Drop the schema to delete all
# psql  -f ../../data/sosdb/empty-dm-dump.sql sensors

# Remove the DB/EH cache
# rm /var/www/sensors.geonovum.nl/webapps/sos/cache.tmp

/etc/init.d/tomcat7 start

#
echo " done, now manually run ./stations2sensors.sh after tomcat init finished and reset the etl_progress record..."


