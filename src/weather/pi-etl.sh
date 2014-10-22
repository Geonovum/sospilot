#!/bin/bash
#

# Kill possible hanging background SSH tunnel
pstree -p sadmin | grep 'ssh(' | cut -d'(' -f2 | cut -d')' -f1|xargs kill -9 > /dev/null 2>&1

# Setup SSH tunnel to remote host
ssh -f -L 5432:sensors:5432 sadmin@sensors -4 -g -N
ps aux | grep 5432
sleep 5

# Do the ETL
./weewx2postgis.sh

# Kill the background SSH tunnel
pstree -p sadmin | grep 'ssh(' | cut -d'(' -f2 | cut -d')' -f1|xargs kill -9

