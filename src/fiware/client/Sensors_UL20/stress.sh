#!/bin/bash

RANGE=12
while true
do
	echo "Press [CTRL+C] to stop.."
    # http://tldp.org/LDP/abs/html/randomvar.html
    temperature=$RANDOM
    let "temperature %= $RANGE"

	# temperature=12
	python SendObservation.py DavisDev "temp|${temperature}#pos|52.152435,5.37241"

	sleep 4
done
