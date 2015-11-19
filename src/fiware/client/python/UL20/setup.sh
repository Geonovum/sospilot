python CreateService.py fiwareiot 4jggokgpepnvsb2uv4s40d59ov 185.21.189.59 1026
python RegisterDevice.py GEONOVUM_TEMP DavisDev TempGeonovumEnt
python SendObservation.py DavisDev 'temp|11#pos|52.152435,5.37241'

# Populate generic device/sensor
# DEVICE_ANY requires: device_name, entity_name, object_id, sensor_type, sensor_unit, place_name, "lat,lon"
python RegisterDevice.py DEVICE_ANY NexusTempDev1 NexusEnt1 t temperature int Boshut  "52.091223,5.763600"
python SendObservation.py NexusTempDev1 't|12'
python ListDevices.py

