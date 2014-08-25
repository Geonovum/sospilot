#!/bin/bash
#
# Validates one  XML file gotten through http
#
# Author: Just van den Broecke
#

BASEDIR=`dirname $0`/..
BASEDIR=`(cd "$BASEDIR"; pwd)`

VALIDATOR=${BASEDIR}/bin/validate.sh
FILE=val.gml

echo "Get $1 into $FILE"
wget -O $FILE $1
echo "Validating $FILE"
$VALIDATOR val.gml




