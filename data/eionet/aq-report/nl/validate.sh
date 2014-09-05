# validation can be done using the XML schema validator under
# ../../../../src/validator
# The calidator will fetch all XSDs and parse the doc against the schema's.

validate=../../../../src/validator/bin/validate.sh

$validate REP_D-NL_RIVM_20140805_B-002-fixed.xml REP_D-NL_RIVM_20140805_C-001.xml REP_D-NL_RIVM_20140805_D-002.xml REP_D-NL_RIVM_20140805_E-001-sample.xml
