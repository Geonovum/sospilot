#! /bin/sh
# Author: Just van den Broecke <justb4@gmail.com>
# Status of RPi main resources. Post to VPS if possible.
#

log=/var/log/rpistatus.txt
remote=sadmin@sensors:/var/www/sensors.geonovum.nl/site/pi

echo "Status of `hostname` on date: `date`" > $log
uptime  >> $log 2>&1

echo "\n=== weewx ===" >> $log
/etc/init.d/weewx status >> $log
echo "archive stat: `ls -l /opt/weewx/weewxinst/archive`" >> $log 2>&1
echo "archive recs: `sqlite3 /opt/weewx/weewxinst/archive/weewx.sdb 'select count(*) from archive'`" >> $log 2>&1

echo "\n=== restarts ===" >> $log
echo "weewx:" >> $log
wc -l /var/log/weewxcheck.log | cut -d'/' -f1 >> $log 2>&1
echo "\nWifi:" >> $log
wc -l /var/log/wificheck.log  | cut -d'/' -f1 >> $log 2>&1

echo "\n=== bandwidth (vnstat)" >> $log
vnstat >> $log 2>&1

echo "\n=== network (ifconfig)" >> $log
ifconfig >> $log 2>&1

echo "\n=== disk usage (df -h) ===" >> $log
df -h >> $log 2>&1

echo "\n=== memory (free -m)===" >> $log
free -m >> $log 2>&1

scp $log $remote
