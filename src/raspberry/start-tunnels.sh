#! /bin/sh
# Author: Just van den Broecke <justb4@gmail.com>
# Maintain ssh-tunnels with autossh
#

sleep 120
export AUTOSSH_LOGFILE=/var/log/autossh/autossh.log
export AUTOSSH_PIDFILE=/var/run/autossh/autossh.pid
# export AUTOSSH_POLL=60
# export AUTOSSH_FIRST_POLL=30
# export AUTOSSH_GATETIME=30
export AUTOSSH_DEBUG=1

su -s /bin/sh autossh -c 'autossh -M 0 -q -f -N -o "ServerAliveInterval 60" -o "ServerAliveCountMax 3" -R <localport>:localhost:22 autossh@<remote host>'
