#!/bin/bash
#
# Script to invoke ETL on the Raspberry Pi
# Uses an SSH tunnel to connect to Postgres on the VPS
#

# Kill possible (hanging) background SSH tunnel
function killTunnel() {
    pstree -p sadmin | grep 'ssh(' | cut -d'(' -f2 | cut -d')' -f1|xargs kill -9 > /dev/null 2>&1
}


# Kill possible (hanging) background SSH tunnel
killTunnel

# Setup SSH tunnel to remote host
ssh -f -L 5432:sensors:5432 sadmin@sensors -4 -g -N
sleep 10
ps aux | grep 5432

# Do the ETL
./weewx2pg.sh

# Kill the background SSH tunnel
killTunnel

