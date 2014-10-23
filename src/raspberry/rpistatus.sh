#! /bin/sh
# Author: Just van den Broecke <justb4@gmail.com>
# Restart weewx if not running.
#

log=/var/log/rpistatus.txt
remote=sadmin@sensors:/var/www/sensors.geonovum.nl/site/pi

echo "Status on date: `date`" > $log

echo "\n=== weewx ===" >> $log
/etc/init.d/weewx status >> $log

echo "\n=== bandwidth (vnstat)" >> $log
ifconfig >> $log 2>&1

echo "\n=== network (ifconfig)" >> $log
ifconfig >> $log 2>&1

echo "\n=== disk usage (df -h) ===" >> $log
df -h >> $log 2>&1

echo "\n=== memory (free -m)===" >> $log
free -m >> $log 2>&1

scp $log $remote
