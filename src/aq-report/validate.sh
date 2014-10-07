#!/bin/sh
#
# Schema validation can be done using the XML schema validator under
# ../../src/validator
# The validator will fetch all XSDs and parse the doc against the schema's.

validate=../../src/validator/bin/validate.sh

# Can validate multiple files, advantage: XSDs are fetched only once.
$validate output/dataflow-D.xml output/dataflow-B.xml  output/dataflow-C.xml
