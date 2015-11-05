#!/bin/bash

docker-compose -f iota.yaml stop
docker rm -v $(docker ps -a -q -f status=exited)
docker-compose -f iota.yaml up -d
docker ps

