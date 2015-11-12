#!/bin/bash

YAML=/opt/geonovum/sospilot/git/src/fiware/docker/iotarush.yaml

docker-compose -f ${YAML} stop
docker rm -v docker_iotacpp_1
docker rm -v docker_orion_1
# docker rm -v $(docker ps -a -q -f status=exited)
docker-compose -f ${YAML} up -d
docker ps
