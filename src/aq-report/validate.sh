#!/bin/sh
#
# Schema validation can be done using the XML schema validator under
# ../../src/validator
# The validator will fetch all XSDs and parse the doc against the schema's.

validate=../../src/validator/bin/validate.sh

$validate output/dataflow-D.xml
