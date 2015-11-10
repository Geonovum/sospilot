#!/bin/bash

YAML=iotarush.yaml
docker-compose -f ${YAML} stop
docker rm -v $(docker ps -a -q -f status=exited)
docker-compose -f ${YAML} up -d
docker ps

