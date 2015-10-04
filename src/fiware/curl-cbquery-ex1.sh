curl orion.lab.fi-ware.org:1026/ngsi10/contextEntities/urn:smartsantander:testbed:357 \
   -X GET -s -S --header 'Content-Type: application/json'  --header 'Accept: application/json' \
   --header  "X-Auth-Token: $AUTH_TOKEN" | python -mjson.tool

#sunda:fiware just$ ./curl-cbquery-ex1.sh
#{
#    "contextElement": {
#        "attributes": [
#            {
#                "metadatas": [
#                    {
#                        "name": "code",
#                        "type": "",
#                        "value": "deg"
#                    }
#                ],
#                "name": "Latitud",
#                "type": "urn:x-ogc:def:phenomenon:IDAS:1.0:latitude",
#                "value": "43.46323"
#            },
#            {
#                "metadatas": [
#                    {
#                        "name": "code",
#                        "type": "",
#                        "value": "deg"
#                    }
#                ],
#                "name": "Longitud",
#                "type": "urn:x-ogc:def:phenomenon:IDAS:1.0:longitude",
#                "value": "-3.80882"
#            },
#            {
#                "name": "TimeInstant",
#                "type": "urn:x-ogc:def:trs:IDAS:1.0:ISO8601",
#                "value": "2015-10-03T13:17:42.000000Z"
#            },
#            {
#                "metadatas": [
#                    {
#                        "name": "code",
#                        "type": "",
#                        "value": "%"
#                    }
#                ],
#                "name": "batteryCharge",
#                "type": "urn:x-ogc:def:phenomenon:IDAS:1.0:batteryCharge",
#                "value": "73"
#            },
#            {
#                "name": "city_location",
#                "type": "city",
#                "value": "Madrid"
#            },
#            {
#                "metadatas": [
#                    {
#                        "name": "code",
#                        "type": "",
#                        "value": "dB"
#                    }
#                ],
#                "name": "sound",
#                "type": "urn:x-ogc:def:phenomenon:IDAS:1.0:sound",
#                "value": "50"
#            },
#            {
#                "name": "temperature",
#                "type": "float",
#                "value": "23.8"
#            }
#        ],
#        "id": "urn:smartsantander:testbed:357",
#        "isPattern": "false",
#        "type": "santander:soundacc"
#    },
#    "statusCode": {
#        "code": "200",
#        "reasonPhrase": "OK"
#    }
#}
