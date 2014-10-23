#! /bin/sh
# Author: Just van den Broecke <justb4@gmail.com>
# Restart weewx if not running.
#

status=`/etc/init.d/weewx status | cut -d':' -f3`
echo $status
