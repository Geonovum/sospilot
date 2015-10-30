#!/bin/bash
#
# Copyright 2015 Telefonica Investigación y Desarrollo, S.A.U
#
# This file is part of fiware-IoTAgentCplusPlus (FI-WARE project).

# Adapted 30.10.2015 by
# Just van den Broecke - Geonovum: Rewrite from RPM spec file to Ubuntu install script

#Summary:       IoT - IoTAgent
#Name:          @CPACK_PACKAGE_NAME@-base
#Version:       @CPACK_PACKAGE_VERSION@
#Release:       @CPACK_PACKAGE_RELEASE@
#License:       PDI
#BuildRoot:     @CMAKE_CURRENT_BINARY_DIR@/pack/Linux/RPM/%{name}
#BuildArch:     x86_64
#AutoReqProv:   no
#Prefix: /usr/local/iot
#Group:         PDI-IoT
#
#%description
#IoT - IoTAgent Base

#requires:
#%define _rpmdir @CMAKE_CURRENT_BINARY_DIR@/pack/Linux/RPM
#%define _rpmfilename %{name}-@CPACK_PACKAGE_FILE_NAME@.rpm
#%define _unpackaged_files_terminate_build 0
#%define _topdir @CMAKE_CURRENT_BINARY_DIR@/pack/Linux/RPM

# %define _owner iotagent
_owner=iotagent

# _localstatedir is a system var that goes to /var

#%define _log_dir %{_localstatedir}/log/iot
#%define _run_dir %{_localstatedir}/run/iot
_log_dir=/var/log/iot
_run_dir=/var/run/iot

# Git and build root dir
IOTAGENT_SOURCE_DIR=/opt/fiware/iotagent/iotacpp
CMAKE_BUILD_TYPE=Release

# -------------------------------------------------------------------------------------------- #
# Pre-install section:
# -------------------------------------------------------------------------------------------- #
#%pre

echo "[INFO] Creating ${_owner} user"
#getent group ${_owner} >/dev/null || groupadd -r ${_owner}
#getent passwd ${_owner} >/dev/null || useradd -r -g ${_owner} -m -s /bin/bash -c 'IoTAgent account' ${_owner}
groupadd -r ${_owner}
useradd -r -g ${_owner} -m -s /bin/false -c 'IoTAgent account' ${_owner}

# -------------------------------------------------------------------------------------------- #
# Install section:
# -------------------------------------------------------------------------------------------- #
#%install

echo "[INFO] Installing the ${_owner}"

pwd
#mkdir -p /usr/local/iot/bin
mkdir -p /usr/local/iot/bin
# cp ${IOTAGENT_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}/iotagent  /usr/local/iot/bin
cp ${IOTAGENT_SOURCE_DIR}/bin/${CMAKE_BUILD_TYPE}/iotagent  /usr/local/iot/bin

mkdir -p /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/lib/${CMAKE_BUILD_TYPE}/libiota.so /usr/local/iot/lib
# cp -P @INSTALL_PION@ /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/pion/share/pion/plugins/HelloService.so /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/pion/share/pion/plugins/CookieService.so /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/pion/share/pion/plugins/EchoService.so /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/pion/share/pion/plugins/AllowNothingService.so /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/pion/share/pion/plugins/FileService.so /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/pion/share/pion/plugins/LogService.so /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/pion/share/pion/plugins/hasCreateAndDestroy.so /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/pion/share/pion/plugins/hasNoCreate.so /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/pion/share/pion/plugins/hasCreateButNoDestroy.so /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/pion/lib/libpion-5.0.so /usr/local/iot/lib

# cp -P @INSTALL_LOG4CPLUS@ /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/log4cplus/lib/liblog4cplus-1.1.so /usr/local/iot/lib

# cp -P @INSTALL_MONGOCLIENT@ /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/mongo-driver/lib/libmongoclient.so /usr/local/iot/lib

# @INSTALL_BOOST@
#cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/src/boost/bin.v2/libs/test/build/gcc-4.8/release/threading-multi/libboost_prg_exec_monitor.so.1.55.0 /usr/local/iot/lib
#cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/src/boost/bin.v2/libs/test/build/gcc-4.8/release/threading-multi/libboost_unit_test_framework.so.1.55.0 /usr/local/iot/lib
#cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/src/boost/bin.v2/libs/regex/build/gcc-4.8/release/threading-multi/libboost_regex.so.1.55.0 /usr/local/iot/lib
#cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/src/boost/bin.v2/libs/date_time/build/gcc-4.8/release/threading-multi/libboost_date_time.so.1.55.0 /usr/local/iot/lib
#cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/src/boost/bin.v2/libs/thread/build/gcc-4.8/release/threading-multi/libboost_thread.so.1.55.0 /usr/local/iot/lib
#cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/src/boost/bin.v2/libs/system/build/gcc-4.8/debug/threading-multi/libboost_system.so.1.55.0 /usr/local/iot/lib
#cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/src/boost/bin.v2/libs/system/build/gcc-4.8/release/threading-multi/libboost_system.so.1.55.0 /usr/local/iot/lib
#cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/src/boost/bin.v2/libs/filesystem/build/gcc-4.8/release/threading-multi/libboost_filesystem.so.1.55.0 /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/lib/libboost_system.so.1.55.0 /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/lib/libboost_filesystem.so.1.55.0 /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/lib/libboost_prg_exec_monitor.so.1.55.0 /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/lib/libboost_regex.so.1.55.0 /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/lib/libboost_unit_test_framework.so.1.55.0 /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/lib/libboost_date_time.so.1.55.0 /usr/local/iot/lib
cp ${IOTAGENT_SOURCE_DIR}/build/${CMAKE_BUILD_TYPE}/third_party/boost/lib/libboost_thread.so.1.55.0 /usr/local/iot/lib


mkdir -p /etc/iot
cp ${IOTAGENT_SOURCE_DIR}/src/services/date_time_zonespec.csv /etc/iot
cp ${IOTAGENT_SOURCE_DIR}/schema/*.schema /etc/iot
cp ${IOTAGENT_SOURCE_DIR}/tests/iotagent/devices.json /etc/iot

mkdir -p /usr/local/iot/config
cp ${IOTAGENT_SOURCE_DIR}/rpm/SOURCES/config/iotagent_protocol.conf /usr/local/iot/config
cp ${IOTAGENT_SOURCE_DIR}/rpm/SOURCES/config/iotagent_manager.conf /usr/local/iot/config

mkdir -p /usr/local/iot/init.d
cp ${IOTAGENT_SOURCE_DIR}/rpm/SOURCES/init.d/iotagent /usr/local/iot/init.d

mkdir -p /etc/cron.d
cp ${IOTAGENT_SOURCE_DIR}/rpm/SOURCES/cron.d/cron-logrotate-iotagent-size /etc/cron.d

mkdir -p /etc/logrotate.d
cp ${IOTAGENT_SOURCE_DIR}/rpm/SOURCES/logrotate.d/logrotate-iotagent-daily  /etc/logrotate.d

# -------------------------------------------------------------------------------------------- #
# Post-Install section:
# -------------------------------------------------------------------------------------------- #
# %post

echo "[INFO] Creating log directory..."
mkdir -p ${_log_dir}
chown ${_owner}:${_owner} ${_log_dir}

echo "[INFO] Creating run directory..."
mkdir -p ${_run_dir}
chown ${_owner}:${_owner} ${_run_dir}

echo "[INFO] Creating links..."
ln -s /usr/local/iot/init.d/iotagent /etc/init.d/iotagent

# -------------------------------------------------------------------------------------------- #
# pre-uninstall section:
# -------------------------------------------------------------------------------------------- #
#%preun
#if [ $1 = 0 ]; then
#
#echo "[INFO] Deleting ${_owner} user..."
#getent passwd ${_owner} > /dev/null && userdel -r ${_owner}
#
#echo "[INFO] Deleting ${_owner} directories..."
#rm /etc/init.d/iotagent
#rm -rf ${_log_dir}
#rm -rf ${_run_dir}
#rm -rf /etc/iot
#
#echo "[INFO] Done!"
#
#fi
# -------------------------------------------------------------------------------------------- #
# post-uninstall section:
# clean section:
# -------------------------------------------------------------------------------------------- #
#%postun
#
#%clean
#rm -rf

# -------------------------------------------------------------------------------------------- #
# Files to add to the RPM
# -------------------------------------------------------------------------------------------- #
#%files
#%defattr(755,${_owner},${_owner},755)
#/etc/iot
#/etc/cron.d
#/etc/logrotate.d
#/usr/local/iot/
#%attr(600, root, root) /etc/cron.d/cron-logrotate-iotagent-size
#%attr(644, root, root) /etc/logrotate.d/logrotate-iotagent-daily
#
#%changelog
#@BASECHANGELOG@
