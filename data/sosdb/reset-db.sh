tcdown
rm /var/www/sensors.geonovum.nl/webapps/sos/cache.tmp
psql -U sensors sensors < empty-dm-dump.sql
tcup

