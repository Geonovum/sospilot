.. _rio:

====================
FI-WARE - Evaluation
====================

Starting in october 2015 the SOSPilot platform was
extended to use FI-WARE

The Plan
========

# register at lab.fiware.org (justb4)
# get connected to public services in Lab
# basic Context Broker (Orion) interaction
# publish temperatures to IDAS using UltraLight protocol
# get temperatures from Orion CB
# show in Wirecloud Mashup


Installing FIWARE - with Docker
===============================

See http://www.slideshare.net/dmoranj/iot-agents-introduction

Install Docker
--------------

See https://docs.docker.com/installation/ubuntulinux. Install via Docker APT repo.

Steps. ::

	# Kernel version
	$ uname -r
	3.13.0-66-generic

	# Add key
	apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

	# Add to repo by putting this line in /etc/apt/sources.list.d/docker.list
	add deb https://apt.dockerproject.org/repo ubuntu-trusty main to

	$ apt-get update
	$ apt-cache policy docker-engine

	# install docker engine
	apt-get update
	apt-get install docker-engine

	# test
	docker run hello-world
	docker run -it ubuntu bash

Docker-compose. https://docs.docker.com/compose/install. Easiest via ``pip``. ::

	$ pip install docker-compose

Install FIWARE for IoT
----------------------

Installing FIWARE components to realize IoT setup: IoT Agent, Orion CB with MongoDB persistence.
Intro: http://www.slideshare.net/dmoranj/iot-agents-introduction

Docker compose for fiware-IoTAgent-Cplusplus: https://github.com/telefonicaid/fiware-IoTAgent-Cplusplus/tree/develop/docker

Steps. Follow: https://github.com/telefonicaid/fiware-IoTAgent-Cplusplus/blob/develop/docker/readme.md ::

	mkdir -p /opt/fiware/iotagent
	cd /opt/fiware/iotagent
	git clone https://github.com/telefonicaid/fiware-IoTAgent-Cplusplus iotacpp

	#
	cd /opt/fiware/iotagent/iotacpp/docker

	# Private docker config ?? (Gave problems)
	cp -r iotacpp/docker .

Networking from outside to docker containers. See http://blog.oddbit.com/2014/08/11/four-ways-to-connect-a-docker.
Make two utilities, ``docker-pid`` and ``docker-ip`` in ``/opt/bin``.  ::

	#!/bin/sh

	exec docker inspect --format '{{ .State.Pid }}' "$@"

	#!/bin/sh

	exec docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"

But simpler is to follow: https://docs.docker.com/userguide/dockerlinks/ and even easier via ``docker-compose`` ``iota.yaml``:
https://docs.docker.com/compose/yml. Use the ``ports`` property:
"Expose ports. Either specify both ports (HOST:CONTAINER), or just the container port (a random host port will be chosen)."
So our iota.yml becomes:

.. literalinclude:: ../src/fiware/docker/iota.yaml
    :language: yaml

Now start. ::

	# Start containers
	$ docker-compose -f iota.yaml up -d iotacpp

	# Stopping
    $ docker-compose -f iota.yaml stop

	# check
	$ docker images
	REPOSITORY              TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
	fiware/orion            latest              a5f228ae72c3        19 hours ago        277.1 MB
	telefonicaiot/iotacpp   latest              583fbe68b08e        28 hours ago        2.092 GB
	mongo                   2.6                 dd4b3c1d1e51        5 days ago          392.8 MB
	ubuntu                  latest              1d073211c498        6 days ago          187.9 MB
	hello-world             latest              0a6ba66e537a        2 weeks ago         960 B

	$ docker ps
	CONTAINER ID        IMAGE                   COMMAND                  CREATED              STATUS              PORTS                                                                      NAMES
	1c9dceec8ec8        telefonicaiot/iotacpp   "/docker-entrypoint.s"   6 seconds ago        Up 5 seconds        0.0.0.0:32772->1883/tcp, 0.0.0.0:8000->8080/tcp, 0.0.0.0:32771->8081/tcp   docker_iotacpp_1
	7f463ea679b6        fiware/orion            "/usr/bin/contextBrok"   About a minute ago   Up 5 seconds        0.0.0.0:32770->1026/tcp                                                    docker_orion_1
	41028cff906b        mongo:2.6               "/entrypoint.sh --sma"   29 hours ago         Up 6 seconds        27017/tcp                                                                  docker_mongodb_1

	# get into a container with bash
	docker exec -it docker_orion_1 bash
    [root@1c9dceec8ec8 /]# ps -elf
    F S UID        PID  PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD
    4 S root         1     0  0  80   0 - 50812 hrtime 15:19 ?        00:00:00 /usr/bin/contextBroker -fg -multiservice
    4 S root       976     0  0  80   0 -  3374 wait   15:35 ?        00:00:00 bash
    0 R root      1021   976  0  80   0 -  3846 -      15:36 ?        00:00:00 ps -elf

	[root@1c9dceec8ec8 /]# cat /etc/hosts
	172.17.0.41	1c9dceec8ec8
	127.0.0.1	localhost
	::1	localhost ip6-localhost ip6-loopback
	fe00::0	ip6-localnet
	ff00::0	ip6-mcastprefix
	ff02::1	ip6-allnodes
	ff02::2	ip6-allrouters
	172.17.0.40	mongodb 41028cff906b docker_mongodb_1
	172.17.0.40	mongodb_1 41028cff906b docker_mongodb_1
	172.17.0.40	docker_mongodb_1 41028cff906b
	172.17.0.40	docker_mongodb_1.bridge
	172.17.0.41	docker_orion_1.bridge
	172.17.0.41	docker_orion_1
	172.17.0.40	docker_mongodb_1
	172.17.0.42	docker_iotacpp_1
	172.17.0.42	docker_iotacpp_1.bridge

	# Check Orion
	$ curl 172.17.0.41:1026/statistics
	<orion>
	  <versionRequests>0</versionRequests>
	  <statisticsRequests>1</statisticsRequests>
	  <uptime_in_secs>1472</uptime_in_secs>
	  <measuring_interval_in_secs>1472</measuring_interval_in_secs>
	  <subCacheRefreshs>3</subCacheRefreshs>
	  <subCacheInserts>0</subCacheInserts>
	  <subCacheRemoves>0</subCacheRemoves>
	  <subCacheUpdates>0</subCacheUpdates>
	  <subCacheItems>0</subCacheItems>
	</orion>

	# Check iot agent iotacpp
	$ docker exec -it docker_iotacpp_1 bash
	[root@8e317c6b9405 /]# ps -elf
	F S UID        PID  PPID  C PRI  NI ADDR SZ WCHAN  STIME TTY          TIME CMD
	4 S root         1     0  0  80   0 -  4821 poll_s 15:49 ?        00:00:00 /sbin/init
	1 S root        74     1  0  80   0 -  2673 poll_s 15:49 ?        00:00:00 /sbin/udevd -d
	5 S iotagent   292     1  0  80   0 - 12087 poll_s 15:49 ?        00:00:00 /usr/sbin/mosquitto -d -c /etc/iot/mosquitto.conf
	0 S iotagent   312     1  0  80   0 - 186499 futex_ 15:49 ?       00:00:00 /usr/local/iot/bin/iotagent -n IoTPlatform -v ERROR -i 0.0.0.0 -p 8080 -d /usr/local/iot/lib -c /etc/iot/config.json
	0 S root       365     1  0  80   0 -  1028 hrtime 15:50 ?        00:00:00 /sbin/mingetty /dev/tty[1-6]
	4 S root       366     0  1  80   0 - 27087 wait   15:50 ?        00:00:00 bash
	0 R root       378   366  0  80   0 - 27557 -      15:50 ?        00:00:00 ps -elf
	[root@8e317c6b9405 /]# curl -g -X GET http://127.0.0.1:8080/iot/about
	Welcome to IoTAgents  identifier:IoTPlatform:8080  1.3.0 commit 128.g14ee433 in Oct 28 2015
	[root@8e317c6b9405 /]#

	# and from outside
	curl -g -X GET http://sensors.geonovum.nl:8000/iot/about
	Welcome to IoTAgents  identifier:IoTPlatform:8080  1.3.0 commit 128.g14ee433 in Oct 28 2015



Installing FIWARE - from Source
===============================

Done on the Linux VPS (Ubuntu 14.04). *Abandoned, using Docker now, but kept for reference.*

Orion Context Broker (OCB)
--------------------------

Build from source
~~~~~~~~~~~~~~~~~

On 28.okt.2015. Version: ``0.24.0-next`` (git version: a938e68887fbc7070b544b75873af935d8c596ae). See https://github.com/telefonicaid/fiware-orion/blob/develop/doc/manuals/admin/build_source.md,
but later found: https://github.com/telefonicaid/fiware-orion/blob/develop/scripts/bootstrap/ubuntu1404.sh

Install build deps. ::

    apt-get  install cmake scons libmicrohttpd-dev libboost-all-dev
    # what about libcurl-dev gcc-c++ ???
	apt-get -y install make cmake build-essential scons git libmicrohttpd-dev libboost-dev libboost-thread-dev libboost-filesystem-dev libboost-program-options-dev  libcurl4-gnutls-dev clang libcunit1-dev mongodb-server python python-flask python-jinja2 curl libxml2 netcat-openbsd mongodb valgrind libxslt1.1 libssl-dev libcrypto++-dev

	Setting up libboost1.54-dev (1.54.0-4ubuntu3.1) ...
	Setting up libboost-dev (1.54.0.1ubuntu1) ...

Install the Mongo Driver from source: ::

	mkdir -p /opt/mongodb
    cd /opt/mongodb
	wget https://github.com/mongodb/mongo-cxx-driver/archive/legacy-1.0.2.tar.gz
	tar xfvz legacy-1.0.2.tar.gz
	cd mongo-cxx-driver-legacy-1.0.2
	scons                                         # The build/linux2/normal/libmongoclient.a library is generated as outcome
	sudo scons install --prefix=/usr/local        # This puts .h files in /usr/local/include/mongo and libmongoclient.a in /usr/local/lib

Install rapidjson from sources: ::

	mkdir -p /opt/rapidjson
    cd /opt/rapidjson
	wget https://github.com/miloyip/rapidjson/archive/v1.0.2.tar.gz
	tar xfvz v1.0.2.tar.gz
	sudo mv rapidjson-1.0.2/include/rapidjson/ /usr/local/include

Install Google Test/Mock from sources (::

	mkdir -p /opt/googlemock
    cd /opt/googlemock
	wget http://googlemock.googlecode.com/files/gmock-1.5.0.tar.bz2
	tar xfvj gmock-1.5.0.tar.bz2
	cd gmock-1.5.0
	./configure
	make
	sudo make install  # installation puts .h files in /usr/local/include and library in /usr/local/lib
	sudo ldconfig      # just in case... it doesn't hurt :)

Build Orion itself ::

	mkdir -p /opt/fiware/orion/
    cd /opt/fiware/orion/
	git clone https://github.com/telefonicaid/fiware-orion git
    cd git

	# Build errors on linking! libboost regex it seems
	[100%] Building CXX object src/app/contextBroker/CMakeFiles/contextBroker.dir/contextBroker.cpp.o
	Linking CXX executable contextBroker
	/usr/local/lib/libmongoclient.a(dbclient.o): In function `boost::basic_regex<char, boost::regex_traits<char, boost::cpp_regex_traits<char> > >::assign(char const*, char const*, unsigned int)':
	/usr/include/boost/regex/v4/basic_regex.hpp:382: undefined reference to `boost::basic_regex<char, boost::regex_traits<char, boost::cpp_regex_traits<char> > >::do_assign(char const*, char const*, unsigned int)'
	/usr/local/lib/libmongoclient.a(dbclient.o): In function `boost::re_detail::perl_matcher<__gnu_cxx::__normal_iterator<char const*, std::string>, std::allocator<boost::sub_match<__gnu_cxx::__normal_iterator<char const*, std::string> > >, boost::regex_traits<char, boost::cpp_regex_traits<char> > >::unwind_extra_block(bool)':
	/usr/include/boost/regex/v4/perl_matcher_non_recursive.hpp:1117: undefined reference to `boost::re_detail::put_mem_block(void*)'
	/usr/local/lib/libmongoclient.a(dbclient.o): In function `boost::re_detail::cpp_regex_traits_implementation<char>::error_string(boost::regex_constants::error_type) const':
	/usr/include/boost/regex/v4/cpp_regex_traits.hpp:447: undefined reference to `boost::re_detail::get_default_error_string(boost::regex_constants::error_type)'
	/usr/local/lib/libmongoclient.a(dbclient.o): In function `void boost::re_detail::raise_error<boost::regex_traits_wrapper<boost::regex_traits<char, boost::cpp_regex_traits<char> > > >(boost::regex_traits_wrapper<boost::regex_traits<char, boost::cpp_regex_traits<char> > > const&, boost::regex_constants::error_type)':
	/usr/include/boost/regex/pattern_except.hpp:75: undefined reference to `boost::re_detail::raise_runtime_error(std::runtime_error const&)'
	/usr/local/lib/libmongoclient.a(dbclient.o): In function `boost::re_detail::cpp_regex_traits_implementation<char>::error_string(boost::regex_constants::error_type) con

	# appears known problem: https://github.com/telefonicaid/fiware-orion/issues/1162
    # DISTRO 14.04.3_LTS var not in add in src/app/contextBroker/CMakeLists.txt
    # add
    ELSEIF(${DISTRO} STREQUAL "Ubuntu_14.04.3_LTS")
       MESSAGE("contextBroker: Ubuntu ===TEST===== DISTRO: '${DISTRO}'")
       TARGET_LINK_LIBRARIES(contextBroker ${STATIC_LIBS} -lmicrohttpd -lmongoclient -lboost_thread -lboost_filesystem -lboost_system -lboost_regex -lpthread -lssl -lcryp\
    to -lgnutls -lgcrypt)

(Optional but highly recommended) run unit test. Firstly, you have to install MongoDB (as the unit tests rely on mongod running in localhost). ::

	apt-get install mongodb-server
	apt-get install pcre            # otherwise, mongodb crashes in CentOS 6.3
	service mongodb start
	service mongodb status   # to check that mongodb is actually running
	make unit_test

	[----------] Global test environment tear-down
	[==========] 1101 tests from 168 test cases ran. (4985 ms total)
	[  PASSED  ] 1096 tests.
	[  FAILED  ] 5 tests, listed below:
	[  FAILED  ] mongoQueryContextRequest_filters.outsideRange_n
	[  FAILED  ] mongoQueryContextRequest_filters.withoutEntityType
	[  FAILED  ] mongoQueryContextGeoRequest.queryGeoCircleOut
	[  FAILED  ] mongoQueryContextGeoRequest.queryGeoPolygonOut1
	[  FAILED  ] mongoQueryContextGeoRequest.queryGeoPolygonOut2

	5 FAILED TESTS
	YOU HAVE 23 DISABLED TESTS

Also need to fix build error in make unit_tests ::

	ELSEIF(${DISTRO} STREQUAL "Ubuntu_14.04.3_LTS")
	  MESSAGE("contextBroker: Ubuntu ===TEST===== DISTRO: '${DISTRO}'")
	  TARGET_LINK_LIBRARIES(unitTest ${STATIC_LIBS} -lmicrohttpd -lmongoclient -lboost_thread -lboost_filesystem -lboost_system -lboost_regex -lpthread -lssl -lcrypto -lg\
	nutls -lgcrypt)

Install the binary. You can use INSTALL_DIR to set the installation prefix path (default is ``/usr``),
thus the broker is installed in ``$INSTALL_DIR/bin`` directory. ::

	sudo make install INSTALL_DIR=/usr

	#test install
	contextBroker --version
	0.24.0-next (git version: a938e68887fbc7070b544b75873af935d8c596ae)
	Copyright 2013-2015 Telefonica Investigacion y Desarrollo, S.A.U
	Orion Context Broker is free software: you can redistribute it and/or
	modify it under the terms of the GNU Affero General Public License as
	published by the Free Software Foundation, either version 3 of the
	License, or (at your option) any later version.

	Orion Context Broker is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero
	General Public License for more details.

	Telefonica I+D

Running OCB
~~~~~~~~~~~

COnfig in ``/etc/default/contextBroker``. As system service:  ::

	service contextBroker start
	# calls /usr/bin/contextBroker
	ERROR: start-stop-daemon: user 'orion' not found

	# Found info in DockerFile: https://github.com/Bitergia/fiware-chanchan-docker/blob/master/images/fiware-orion/0.22.0/Dockerfile
	# Add user without shell
	useradd -s /bin/false -c "Disabled Orion User" orion

	mkdir -p /var/log/contextBroker
	mkdir -p /var/run/contextBroker
	chown orion:orion /var/log/contextBroker
	chown orion:orion /var/run/contextBroker
	service contextBroker status
	# contextBroker is running

Test with fiware-figway Python client: ::

	sunda:ContextBroker just$ python  GetEntities.py ALL
	* Asking to http://sensors.geonovum.nl:1026/ngsi10/queryContext
	* Headers: {'Fiware-Service': 'fiwareiot', 'content-type': 'application/json', 'accept': 'application/json', 'X-Auth-Token': 'NULL'}
	* Sending PAYLOAD:
	{
	    "entities": [
	        {
	            "type": "",
	            "id": ".*",
	            "isPattern": "true"
	        }
	    ],
	    "attributes": []
	}

	...

	* Status Code: 200
	***** Number of Entity Types: 0

	***** List of Entity Types

	**** Number of Entity IDs: 0

	**** List of Entity IDs

	Do you want me to print all Entities? (yes/no)yes
	<queryContextResponse>
	  <errorCode>
	    <code>404</code>
	    <reasonPhrase>No context element found</reasonPhrase>
	  </errorCode>
	</queryContextResponse>


IoT Agent (CPP version)
-----------------------

From GitHub: https://github.com/telefonicaid/fiware-IoTAgent-Cplusplus, using Docker file
https://github.com/telefonicaid/fiware-IoTAgent-Cplusplus/blob/develop/docker/Dockerfile for inspiration.

Build fiware-IoTAgent-Cplusplus
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

From source.

Steps: ::

	apt-get install -y tar gzip unzip file cpp gcc automake autoconf libtool git scons cmake
	apt-get install -y libssl-dev libbz2-dev zlib1g-dev doxygen

	mkdir -p /opt/fiware/iotagent
	git clone https://github.com/telefonicaid/fiware-IoTAgent-Cplusplus iotacpp
	cd /opt/fiware/iotagent/iotacpp

	# Disable and fix  CMakeLists.txt
	cp CMakeLists.txt CMakeLists.txt.backup
	sed -i CMakeLists.txt -e 's|^add_test|#add_test|g' -e 's|^add_subdirectory(tests)|#add_subdirectory(tests)|g' -e 's|^enable_testing|#enable_testing|g' -e 's|git@github.com:mongodb/mongo-cxx-driver.git|https://github.com/mongodb/mongo-cxx-driver|g'

	# Get version string
	$ source tools/get_version_string.sh
	$ get_rpm_version_string | cut -d ' ' -f 1
	1.3.0

	# Build in Release subdir
	mkdir -p ${CMAKE_CURRENT_SOURCE_DIR}/build/Release
	cd ${CMAKE_CURRENT_SOURCE_DIR}/build/Release
	cmake -DGIT_VERSION=1.3.0 -DGIT_COMMIT=1.3.0 -DMQTT=ON -DCMAKE_BUILD_TYPE=Release  ../../

	# very long build...lots of output...
    $ make install

Create install scripts from RPM spec files.

Running
~~~~~~~

{
    "ngsi_url": {
        "cbroker": "http://127.0.0.1:1026",
        "updateContext": "/NGSI10/updateContext",
        "registerContext": "/NGSI9/registerContext",
        "queryContext": "/NGSI10/queryContext"
    },
    "timeout": 10,
    "http_proxy": "PUBLIC_PROXY_PORT",
    "public_ip": "8081",
    "dir_log": "/var/log/iot/",
    "timezones": "/etc/iot/date_time_zonespec.csv",
    "storage": {
        "host": "localhost",
        "type": "mongodb",
        "port": "27017",
        "dbname": "iot"
    },
   "resources": [
        {
            "resource": "/iot/d",
            "options": {
                "FileName": "UL20Service"
            }
        },
        {
            "resource": "/iot/mqtt",
            "options": {
                "ConfigFile" : "/etc/iot/MqttService.xml",
                "FileName": "MqttService"
            }
         }
   ]
}

cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/cppunit/src/test-cppunit/src/cppunit/.libs/libcppunit-1.12.so.1.0.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/cppunit/lib/libcppunit-1.12.so.1.0.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/src/.libs/libpion-5.0.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/doc/README.solaris /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/services/.libs/HelloService.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/services/.libs/CookieService.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/services/.libs/EchoService.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/services/.libs/CookieService.soT /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/services/.libs/AllowNothingService.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/services/.libs/HelloService.soT /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/services/.libs/AllowNothingService.soT /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/services/.libs/FileService.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/services/.libs/LogService.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/services/.libs/FileService.soT /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/services/.libs/EchoService.soT /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/services/.libs/LogService.soT /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/tests/plugins/.libs/hasCreateAndDestroy.soT /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/tests/plugins/.libs/hasCreateButNoDestroy.soT /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/tests/plugins/.libs/hasCreateAndDestroy.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/tests/plugins/.libs/hasNoCreate.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/tests/plugins/.libs/hasCreateButNoDestroy.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/src/pion-library/tests/plugins/.libs/hasNoCreate.soT /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/share/pion/plugins/HelloService.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/share/pion/plugins/CookieService.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/share/pion/plugins/EchoService.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/share/pion/plugins/AllowNothingService.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/share/pion/plugins/FileService.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/share/pion/plugins/LogService.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/share/pion/plugins/hasCreateAndDestroy.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/share/pion/plugins/hasNoCreate.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/share/pion/plugins/hasCreateButNoDestroy.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/pion/lib/libpion-5.0.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/log4cplus/src/logger-log4cplus-build/src/.libs/liblog4cplus-1.1.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/log4cplus/lib/liblog4cplus-1.1.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/libcares/src/libcares-build/.libs/libcares.so.2.1.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/libcares/lib/libcares.so.2.1.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/src/boost/tools/build/v2/engine/boehm_gc/doc/README.solaris2 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/src/boost/bin.v2/libs/test/build/gcc-4.8/release/threading-multi/libboost_prg_exec_monitor.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/src/boost/bin.v2/libs/test/build/gcc-4.8/release/threading-multi/libboost_unit_test_framework.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/src/boost/bin.v2/libs/regex/build/gcc-4.8/release/threading-multi/libboost_regex.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/src/boost/bin.v2/libs/date_time/build/gcc-4.8/release/threading-multi/libboost_date_time.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/src/boost/bin.v2/libs/thread/build/gcc-4.8/release/threading-multi/libboost_thread.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/src/boost/bin.v2/libs/system/build/gcc-4.8/debug/threading-multi/libboost_system.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/src/boost/bin.v2/libs/system/build/gcc-4.8/release/threading-multi/libboost_system.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/src/boost/bin.v2/libs/filesystem/build/gcc-4.8/release/threading-multi/libboost_filesystem.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/lib/libboost_system.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/lib/libboost_filesystem.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/lib/libboost_prg_exec_monitor.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/lib/libboost_regex.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/lib/libboost_unit_test_framework.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/lib/libboost_date_time.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/boost/lib/libboost_thread.so.1.55.0 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/broker-mqtt/src/broker-mqtt-build/lib/cpp/libmosquittopp.so.1.4.4 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/broker-mqtt/src/broker-mqtt-build/lib/libmosquitto.so.1.4.4 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/broker-mqtt/lib/libmosquittopp.so.1.4.4 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/broker-mqtt/lib/libmosquitto.so.1.4.4 /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/mongo-driver/src/mongo-driver/build/linux2/normal/libmongoclient.so /usr/local/iot/lib
cp ${CMAKE_CURRENT_SOURCE_DIR}/build/Release/third_party/mongo-driver/lib/libmongoclient.so /usr/local/iot/lib

mkdir /var/log/iot/
cp ../../schema/* /etc/iot

Need these files
https://github.com/telefonicaid/fiware-IoTAgent-Cplusplus/tree/develop/rpm/SOURCES
