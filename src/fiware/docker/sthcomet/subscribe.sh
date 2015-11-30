#!/bin/bash

ORION_HOST=sensors.geonovum.nl
ORION_PORT=1026
STH_HOST=sensors.geonovum.nl
STH_PORT=8666


curl ${ORION_HOST}:${ORION_PORT}/v1/subscribeContext -s -S --header 'Content-Type: application/json' --header 'Accept: application/json' --header 'Fiware-Service: fiwareiot' --header 'Fiware-ServicePath: /' -d @- <<EOF
{
    "entities": [
        {
            "type": "thing",
            "isPattern": "false",
            "id": "NexusEnt1"
        }
    ],
    "attributes": [],
    "reference": "http://sensors.geonovum.nl:8666/notify",
    "duration": "P1M",
    "notifyConditions": [
        {
            "type": "ONCHANGE",
            "condValues": []
        }
    ],
    "throttling": "PT1S"
}
EOF
