-- Database defs for real-time Smart Emission data

DROP SCHEMA IF EXISTS smartem_rt CASCADE;
CREATE SCHEMA smartem_rt;

-- Raw device realtime output table - data one2one from rawsensor api
DROP TABLE IF EXISTS smartem_rt.last_device_output CASCADE;
CREATE TABLE smartem_rt.last_device_output (
  gid serial,
  unique_id character varying (16),
  insert_time timestamp default current_timestamp,
  device_id integer,
  device_name character varying (32),
  id integer,
  name character varying,
  label character varying,
  unit  character varying,
  time timestamp,
  value_raw integer,
  value real,
  altitude integer default 0,
  point geometry(Point,4326),
  PRIMARY KEY (gid)
);

DROP INDEX IF EXISTS last_device_output_uid_idx;
CREATE UNIQUE INDEX last_device_output_uid_idx ON smartem_rt.last_device_output USING btree (unique_id) ;
DROP INDEX IF EXISTS last_device_output_geom_idx;
CREATE INDEX last_device_output_geom_idx ON smartem_rt.last_device_output USING gist (point);

DROP VIEW IF EXISTS smartem_rt.stations CASCADE;
CREATE VIEW smartem_rt.stations AS
  SELECT DISTINCT on (d.device_id) d.gid, d.device_id, d.device_name, d.point, d.altitude, d.time AT TIME ZONE 'GMT' as last_update, ST_X(point) as lon, ST_Y(point) as lat  FROM smartem_rt.last_device_output as d order by d.device_id;

-- Laatste Metingen
DROP VIEW IF EXISTS smartem_rt.v_last_measurements;
CREATE VIEW smartem_rt.v_last_measurements AS
  SELECT device_id, device_name, id, label, unit,
    name, value_raw, time AT TIME ZONE 'GMT' AS sample_time, value as sample_value, point, gid, unique_id,
    ST_X(point) as lon, ST_Y(point) as lat, EXTRACT(epoch from time AT TIME ZONE 'GMT' ) AS timestamp
  FROM smartem_rt.last_device_output ORDER BY device_id, gid DESC;

-- Laatste Metingen per Component
DROP VIEW IF EXISTS smartem_rt.v_last_measurements_CO;
CREATE VIEW smartem_rt.v_last_measurements_CO AS
  SELECT device_id, device_name, id, label, unit,
    name, value_raw, time AT TIME ZONE 'GMT' AS sample_time, value as sample_value, point, gid, unique_id
  FROM smartem_rt.last_device_output WHERE name = 's_co' ORDER BY device_id, gid DESC;

DROP VIEW IF EXISTS smartem_rt.v_last_measurements_CO2;
CREATE VIEW smartem_rt.v_last_measurements_CO2 AS
  SELECT device_id, device_name, id, label, unit,
    name, value_raw, time AT TIME ZONE 'GMT' AS sample_time, value as sample_value, point, gid, unique_id
  FROM smartem_rt.last_device_output WHERE name = 's_co2' ORDER BY device_id, gid DESC;

DROP VIEW IF EXISTS smartem_rt.v_last_measurements_NO2;
CREATE VIEW smartem_rt.v_last_measurements_NO2 AS
  SELECT device_id, device_name, id, label, unit,
    name, value_raw, time AT TIME ZONE 'GMT' AS sample_time, value as sample_value, point, gid, unique_id
  FROM smartem_rt.last_device_output WHERE name = 's_no2' ORDER BY device_id, gid DESC;

DROP VIEW IF EXISTS smartem_rt.v_last_measurements_O3;
CREATE VIEW smartem_rt.v_last_measurements_O3 AS
  SELECT device_id, device_name, id, label, unit,
    name, value_raw, time AT TIME ZONE 'GMT' AS sample_time, value as sample_value, point, gid, unique_id
  FROM smartem_rt.last_device_output WHERE name = 's_o3' ORDER BY device_id, gid DESC;

DROP VIEW IF EXISTS smartem_rt.v_last_measurements_temperature;
CREATE VIEW smartem_rt.v_last_measurements_temperature AS
  SELECT device_id, device_name, id, label, unit,
    name, value_raw, time AT TIME ZONE 'GMT' AS sample_time, value as sample_value, point, gid, unique_id
  FROM smartem_rt.last_device_output WHERE name = 's_temperatureambient' ORDER BY device_id, gid DESC;

DROP VIEW IF EXISTS smartem_rt.v_last_measurements_humidity;
CREATE VIEW smartem_rt.v_last_measurements_humidity AS
  SELECT device_id, device_name, id, label, unit,
    name, value_raw, time AT TIME ZONE 'GMT' AS sample_time, value as sample_value, point, gid, unique_id
  FROM smartem_rt.last_device_output WHERE name = 's_humidity' ORDER BY device_id, gid DESC;

DROP VIEW IF EXISTS smartem_rt.v_last_measurements_barometer;
CREATE VIEW smartem_rt.v_last_measurements_barometer AS
  SELECT device_id, device_name, id, label, unit,
    name, value_raw, time AT TIME ZONE 'GMT' AS sample_time, value as sample_value, point, gid, unique_id
  FROM smartem_rt.last_device_output WHERE name = 's_barometer' ORDER BY device_id, gid DESC;

