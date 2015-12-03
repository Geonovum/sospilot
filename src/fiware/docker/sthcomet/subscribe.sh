#!/bin/bash

#POST /v1/subscribeContext HTTP/1.1
#Host: sensors.geonovum.nl:1026
#origin: https://mashup.lab.fiware.org
#Cookie: _ga=GA1.2.1632625772.1441807083, policy_cookie=on
#Content-Length: 257
#via: 1.1 mashup.lab.fiware.org (Wirecloud-python-Proxy/1.1)
#accept-language: en-US,en;q=0.8,de;q=0.6,fr;q=0.4,nl;q=0.2,it;q=0.2
#accept-encoding: gzip, deflate
#x-forwarded-host: sensors.geonovum.nl:1026
#x-forwarded-for: 82.217.164.50
#fiware-service: fiwareiot
#accept: application/json
#user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36
#connection: keep-alive
#x-requested-with: XMLHttpRequest
#referer: https://mashup.lab.fiware.org/justb4/NGSI%20Subscription
#content-type: application/json
#
#
#write error to stdout
#
#130.206.084.011.36914-185.021.189.059.01026:
#{"entities":[{"id":".*","isPattern":"true","type":"thing"}],
#"reference":"https://ngsiproxy.lab.fiware.org:443/callbacks/23:33:47-1:23:33:48-1",
#"duration":"PT3H",
#"notifyConditions":[
#{"type":"ONCHANGE","condValues":["position","temperature","organization"]
#}]}
#
#write error to stdout
#
#185.021.189.059.01026-130.206.084.011.36914: HTTP/1.1 200 OK
#Content-Length: 109
#Content-Type: application/json
#Date: Mon, 30 Nov 2015 21:31:14 GMT
#
#{
#  "subscribeResponse" : {
#    "subscriptionId" : "565cc0222b41bbad4c87656f",
#    "duration" : "PT3H"
#  }
#}

ORION_HOST=sensors.geonovum.nl
ORION_PORT=1026
STH_HOST=sensors.geonovum.nl
STH_PORT=8666

#  --header 'Fiware-ServicePath: /'
curl ${ORION_HOST}:${ORION_PORT}/v1/subscribeContext -s -S\
 --header 'Content-Type: application/json' \
 --header 'Accept: application/json' \
 --header 'fiware-service: fiwareiot' \
 -d @- <<EOF
{
    "entities": [
        {
            "type": "thing",
            "isPattern": "true",
            "id": ".*"
        }
    ],
    "reference": "http://sensors.geonovum.nl:8666/notify",
    "duration": "P1Y",
    "notifyConditions": [
        {
            "type": "ONCHANGE",
            "condValues": ["temperature", "humidity", "pm10", "pm2_5"]
        }
    ],
    "throttling": "PT5S"
}
EOF
