#! /bin/sh
# Author: Just van den Broecke <justb4@gmail.com>
# Restart weewx if not running.
#

WEEWX_HOME=/opt/weewx/weewxinst
WEEWX_BIN=$WEEWX_HOME/bin/weewxd

NPROC=`ps ax | grep $WEEWX_BIN | grep $NAME.pid | wc -l`
if [ $NPROC -gt 1 ]; then
    echo "weewx running multiple times on `date`! Attempting restart." >> /var/log/weewxcheck.log
    /etc/init.d/weewx restart
elif [ $NPROC = 1 ]; then
    echo "Weewx is ok: $status"
else
    echo "weewx not running on `date`! Attempting restart." >> /var/log/weewxcheck.log
    /etc/init.d/weewx restart
fi

