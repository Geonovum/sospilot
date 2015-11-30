FROM fiware/orion
MAINTAINER Just van den Broecke for Geonovum  www.geonovum.nl

ENV MONGODB_HOST mongodb
ENV REDIS_VERSION 2.8.3
ENV RUSH_VERSION 1.8.3
ENV RUSH_LISTEN_PORT 5001

WORKDIR /opt

RUN \
	# Dependencies
	yum -y install npm  && \
	# yum -y install redis   (gave errors see below)
	yum -y install wget  && \
	wget http://download.redis.io/releases/redis-${REDIS_VERSION}.tar.gz  && \
	tar xzvf redis-${REDIS_VERSION}.tar.gz  && \
	cd redis-${REDIS_VERSION} && \
	make && \
	make install && \
	# /etc/init.d/redis start  (no daemon installed)
	# Rush
	cd /opt && \
	curl https://codeload.github.com/telefonicaid/Rush/tar.gz/${RUSH_VERSION} > Rush-${RUSH_VERSION}.tar.gz  && \
	tar xzvf Rush-${RUSH_VERSION}.tar.gz  && \
	cd Rush-${RUSH_VERSION} && \
	npm install --production
	# set mongodb host as linked in docker-compose iota.yml
	# export RUSH_GEN_MONGO=${MONGODB_HOST}
	# bin/listener
	# bin/consumer

WORKDIR /

COPY docker-entrypoint.sh /
COPY server.key /
COPY server.crt /
COPY server.csr /

RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 1026


