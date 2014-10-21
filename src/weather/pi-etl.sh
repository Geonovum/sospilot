#!/bin/bash
#
ssh -f -L 3333:sensors.geonovum.nl:5432 sadmin@185.21.189.59 -4 -g -N
sleep 10
./weewx2postgis.sh
pstree -p sadmin | grep 'ssh(' | cut -d'(' -f2 | cut -d')' -f1|xargs kill -9

