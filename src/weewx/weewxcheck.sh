#! /bin/sh
# Author: Just van den Broecke <justb4@gmail.com>
# Restart weewx if not running.
#

status=`/etc/init.d/weewx status | cut -d':' -f3`
echo ".$status."

if [ "$status" = " not running." ] ; then
    echo "weewx not running on `date`! Attempting restart." >> /var/log/weewxcheck.log
    /etc/init.d/weewx restart
else
    echo "Weewx is ok: $status"
fi
