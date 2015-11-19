Client for MQTT to IotAgentCpp server

Before observations can be sent a Service
needs to be created and a Device(s) registered.

See setup.sh for an example

The Service creation and Device provisioning uses the Admin API
of the IotAgentCpp server. MQTT is only used to send observations.

The helper .py programs are ported from FIWARE FIGWAY Sensors_UL20
code.

TWO VERY IMPORTANT DIFFERENCES WITH UL20:

1) in the payload when creating the Service the floowing field needs to be set:
"resource": "/iot/mqtt" otherwise the Device cannot be registered ("protocol is not correct" error).
See also this issue:
https://github.com/telefonicaid/fiware-IoTAgent-Cplusplus/issues/254

2) Also in the Device Template (see here under devices/) the "protocol": "PDI-IoTA-MQTT-UltraLight" needs to be present.



