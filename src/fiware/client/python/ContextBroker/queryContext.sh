(curl sensors.geonovum.nl:1026/v1/queryContext -s -S --header 'Content-Type: application/json' \
    --header 'Accept: application/json' --header 'FIWARE-Service: fiwareiot' -d @- | python -mjson.tool) <<EOF
{
    "entities": [
        {

            "isPattern": "true",
            "id": ".*"
        }
    ]
} 
EOF
