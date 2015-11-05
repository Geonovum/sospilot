#!/bin/bash
#
# Copyright 2015 Telefonica Investigación y Desarrollo, S.A.U
#
# This file is part of fiware-IoTAgentCplusPlus (FI-WARE project).

# Adapted 30.10.2015 by
# Just van den Broecke - Geonovum: Rewrite from RPM spec file to Ubuntu install script
# Run install-iotagent-base.sh first!!

#Name:          @CPACK_PACKAGE_NAME@-ul
#Version:       @CPACK_PACKAGE_VERSION@
#Release:       @CPACK_PACKAGE_RELEASE@
#Summary:       IoT - IoTAgent UltraLight 2.0
#Group:         PDI-IoT
#License:       PDI
#BuildArch:     x86_64
#BuildRoot:     @CMAKE_CURRENT_BINARY_DIR@/pack/Linux/RPM/%{name}
#AutoReqProv:   no
#Prefix: /usr/local/iot
#Requires: @CPACK_PACKAGE_NAME@-base
#%define _rpmdir @CMAKE_CURRENT_BINARY_DIR@/pack/Linux/RPM
#%define _rpmfilename %{name}-@CPACK_PACKAGE_FILE_NAME@.rpm
#%define _unpackaged_files_terminate_build 0
#%define _topdir @CMAKE_CURRENT_BINARY_DIR@/pack/Linux/RPM
#%define _owner iotagent
#
#%description
#IoT - IoTAgent UltraLight 2.0

# -------------------------------------------------------------------------------------------- #
# Install section:
# -------------------------------------------------------------------------------------------- #
#%install
#pwd
#mkdir -p %{buildroot}/usr/local/iot/lib
# Git and build root dir
IOTAGENT_SOURCE_DIR=/opt/fiware/iotagent/iotacpp
CMAKE_BUILD_TYPE=Release

cp ${IOTAGENT_SOURCE_DIR}/lib/${CMAKE_BUILD_TYPE}/UL20Service.so /usr/local/iot/lib
#
#mkdir -p %{buildroot}/etc/iot
#
#%clean
#rm -rf %{buildroot}

# -------------------------------------------------------------------------------------------- #
# pre-uninstall section:
# -------------------------------------------------------------------------------------------- #
#%pre

# -------------------------------------------------------------------------------------------- #
# Post-Install section:
# -------------------------------------------------------------------------------------------- #
#%post

# -------------------------------------------------------------------------------------------- #
# Files to add to the RPM
# -------------------------------------------------------------------------------------------- #
#%files
#%defattr(755,%{_owner},%{_owner},755)
#/usr/local/iot/lib/*

#%changelog
#@ULCHANGELOG@