#!/bin/bash

# see https://github.com/telefonicaid/fiware-IoTAgent-Cplusplus/blob/develop/doc/MQTT_protocol.md
# provisioning API: https://github.com/telefonicaid/fiware-IoTAgent-Cplusplus/blob/develop/doc/north_api.md
DEVICE_ID=DavisMQTTDev
ORION_ENTITY=TempGeonovumMQTTEnt
# API_KEY=4jggokgpepnvsb2uv4s40d59ov
API_KEY=7qqa9uvkgketabc8ui4knu1onv
SERVICE_ID=fiwareiot
ORION_HOST=185.21.189.59
ORION_PORT=1026
MQTT_HOST=sensors.geonovum.nl
MQTT_PORT=1883
DEVICE_TEMPLATE=GEONOVUM_MQTT_TEMP

# python CreateService.py ${SERVICE_ID} ${API_KEY} ${ORION_HOST} ${ORION_PORT}

# device file devic_id enity_id
# python RegisterDevice.py ${DEVICE_TEMPLATE} ${DEVICE_ID} ${ORION_ENTITY}

# mosquitto_pub -h $HOST_IOTAGENT_MQTT -t <api_key>/mydevicemqtt/t -m 44.4 -u <api_key>
mosquitto_pub -r -d -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${API_KEY} -t ${API_KEY}/${DEVICE_ID}/temp -m 11
mosquitto_pub -r -d -h ${MQTT_HOST} -p ${MQTT_PORT} -u ${API_KEY} -t ${API_KEY}/${DEVICE_ID}/pos -m '52.152435,5.37241'
