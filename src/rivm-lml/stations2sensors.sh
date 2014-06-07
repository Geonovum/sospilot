#!/bin/sh
#
# ETL for converting station table to OWS SOS sensors.
#

# Usually requried in order to have Python find your package
export PYTHONPATH=.:$PYTHONPATH

stetl_cmd=stetl

# debugging
stetl_cmd=../../../../stetl/git/stetl/main.py

options="database=sensors schema=rivm_lml host=localhost port=80 user=postgres password=postgres http_host=sensors.geonovum.nl http_port=80 http_user=postgres http_password=postgres  http_path=/sos/service"

$stetl_cmd -c stations2sensors.cfg -a "$options"


