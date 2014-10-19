#!/bin/sh

WEEWX=/opt/weewx/weewxinst

# /etc/init.d/weewx stop

cp weewx.conf $WEEWX
cp ../test/weatherapidriver.py $WEEWX/bin/user
rm -rf $WEEWX/skins/byteweather
cp -r byteweather $WEEWX/skins/byteweather

# /etc/init.d/weewx start
