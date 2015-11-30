#!/bin/bash

REDIS_HOME=/opt/redis-${REDIS_VERSION}
RUSH_HOME=/opt/Rush-${RUSH_VERSION}

cd ${REDIS_HOME}
redis-server redis.conf > /var/log/redis.log 2>&1 &

cd ${RUSH_HOME}
export RUSH_GEN_MONGO=${MONGODB_HOST}
cp /server.crt /server/csr .

bin/listener > /var/log/rush-listener.log 2>&1 &
bin/consumer > /var/log/rush-consumer.log 2>&1 &

/usr/bin/contextBroker -dbhost ${MONGODB_HOST} -fg -multiservice -rush localhost:5001 -logDir /var/log/contextBroker


