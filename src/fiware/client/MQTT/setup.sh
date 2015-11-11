#!/bin/bash

# see https://github.com/telefonicaid/fiware-IoTAgent-Cplusplus/blob/develop/doc/MQTT_protocol.md
DEVICE_ID=DavisMQTTDev
# device file devic_id enity_id
python RegisterDevice.py GEONOVUM_MQTT_TEMP ${DEVICE_ID} TempGeonovumMQTTEnt

# mosquitto_pub -h $HOST_IOTAGENT_MQTT -t <api_key>/mydevicemqtt/t -m 44.4 -u <api_key>
# API_KEY=4jggokgpepnvsb2uv4s40d59ov
API_KEY=7qqa9uvkgketabc8ui4knu1onv
mosquitto_pub -r -d -h sensors.geonovum.nl -p 1883 -u ${API_KEY} -t ${API_KEY}/${DEVICE_ID}/temp -m "11"
