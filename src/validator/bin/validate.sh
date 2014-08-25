#!/bin/bash
#
# Validates one or more XML files
#
# Author: Just van den Broecke
#

BASEDIR=`dirname $0`/..
BASEDIR=`(cd "$BASEDIR"; pwd)`
CLASSDIR=${BASEDIR}/src

java -cp ${CLASSDIR} Validate $@




