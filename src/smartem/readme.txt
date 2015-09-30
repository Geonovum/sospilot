Sources for ETL of Smart Emission project Nijmegen.

Uses host-specific variables for databases, passwords etc.
To use define a file on your host called options-<your host>.sh
Take the example file options-sunda.sh for initial values and adapt to your host.

NB for now only raw files are processed, i.e. ETL Step 1 (Harvesting, harvester.* files) is not yet performed.

Only ETL Steps 2 and 3.

Step 2: files2measurements: put files+stations in regular DB tables (DB sensors, schema: smartem)
Step 3: publish stations and observations from tables in Step2 to SOS

------------------------------
Data stats, op 30 sept 2015:

- 175122 measurements in DB. Deze naar SOS gepubliceerd.

- inlezen raw data in Postgres database: 5 minuten

- publiceren naar SOS 10 minuten per 10000, plm 3 uur voor 175122 observaties

- per station
SELECT count(*), station_id from Smartem.measurements group by station_id

station_id	count
3           7150
8           24470
9           53228
1           63454
5           58
10          26762


-----------------------------
Get data via REST
Zie doc http://sensorweb.demo.52north.org/sensorwebclient-webapp-stable/api-doc/

- Search (vindt procedures, timeseries etc gerelateerd aan Smart Emission)
http://sensors.geonovum.nl/sos/api/v1/search?q=SmartEmission

- Stations
http://sensors.geonovum.nl/sos/api/v1/stations
http://sensors.geonovum.nl/sos/api/v1/stations/67
http://sensors.geonovum.nl/sos/api/v1/stations/68
http://sensors.geonovum.nl/sos/api/v1/stations/69

- Procedures  (Sensor stations)
http://sensors.geonovum.nl/sos/api/v1/procedures
http://sensors.geonovum.nl/sos/api/v1/procedures/119
http://sensors.geonovum.nl/sos/api/v1/procedures/120
http://sensors.geonovum.nl/sos/api/v1/procedures/121
http://sensors.geonovum.nl/sos/api/v1/procedures/122
http://sensors.geonovum.nl/sos/api/v1/procedures/123
http://sensors.geonovum.nl/sos/api/v1/procedures/124
http://sensors.geonovum.nl/sos/api/v1/procedures/125

- Offerings
http://sensors.geonovum.nl/sos/api/v1/offerings
http://sensors.geonovum.nl/sos/api/v1/offerings/120
http://sensors.geonovum.nl/sos/api/v1/offerings/121
http://sensors.geonovum.nl/sos/api/v1/offerings/123
http://sensors.geonovum.nl/sos/api/v1/offerings/125

- Timeseries Data
http://sensors.geonovum.nl/sos/api/v1/timeseries/

# metadata Unit-10 O3 procedure 125
http://sensors.geonovum.nl/sos/api/v1/timeseries/259

# metadata Unit-10 NO2 procedure 125
# Heeft data van: 2015-07-21 10:47:57 t/m 2015-07-28 07:11:08
http://sensors.geonovum.nl/sos/api/v1/timeseries/260

# Get data in ISO_8601 timerange spec: https://en.wikipedia.org/wiki/ISO_8601#Time_intervals
http://sensors.geonovum.nl/sos/api/v1/timeseries/260/getData?timespan=2015-07-21TZ/2015-07-28TZ

# CO SmartEmission-Unit-10 procedure 125
http://sensors.geonovum.nl/sos/api/v1/timeseries/261



