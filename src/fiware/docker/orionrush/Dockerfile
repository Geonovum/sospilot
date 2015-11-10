FROM fiware/orion
MAINTAINER Just van den Broecke for Geonovum  www.geonovum.nl

ENV MONGODB_HOST mongodb

WORKDIR /opt

RUN \
	# within docker_orion_1 running container
	# Dependencies
		yum -y install npm  && \
	# yum -y install redis   (gave errors see below)
	yum -y install wget  && \
	wget http://download.redis.io/releases/redis-2.8.3.tar.gz  && \
	tar xzvf redis-2.8.3.tar.gz  && \
	cd redis-2.8.3 && \
	make && \
	make install && \
	# /etc/init.d/redis start  (no daemon installed)
	redis-server redis.conf & && \
	# Rush
	cd /opt && \
	curl https://codeload.github.com/telefonicaid/Rush/tar.gz/1.8.3 > Rush-1.8.3.tar.gz  && \
	tar xzvf Rush-1.8.3.tar.gz  && \
	cd Rush-1.8.3 && \
	npm install --production && \
	# set mongodb host as linked in docker-compose iota.yml
	export RUSH_GEN_MONGO=${MONGODB_HOST} && \
	bin/listener & && \
	bin/consumer &

WORKDIR /
ENTRYPOINT ["/usr/bin/contextBroker","-fg","-multiservice","-rush","localhost:5001","-logDir","/var/log/contextBroker"]
EXPOSE 1026


