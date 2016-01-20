-- Database defs for Smart Emissiondata

-- Raw device info table - data one2one from rawsensor api
DROP TABLE IF EXISTS smartem.device_meta CASCADE;
CREATE TABLE smartem.device_meta (
  gid serial,
--   file_name character varying (32),
  insert_time timestamp default current_timestamp,
  device_id character varying (8),
  output_id character varying (32),
  label character varying (32),
  unit  character varying (24),
  PRIMARY KEY (gid)
);

-- Raw timeseries table - data one2one from rawsensor api
DROP TABLE IF EXISTS smartem.rawtimeseries CASCADE;
CREATE TABLE smartem.rawtimeseries (
  gid serial,
--   file_name character varying (32),
  insert_time timestamp default current_timestamp,
  device_id character varying (8),
  timeseries_id integer,  -- 2016011822
  output_id character varying (32),
  sample_uuid  character varying (24),
  sample_time timestamp,
  sample_value integer,
  PRIMARY KEY (gid)
);

-- Raw Measurement may only occur once in table, error if trying to insert multiple times
DROP INDEX IF EXISTS rawsample_id_idx;
CREATE UNIQUE INDEX rawsample_id_idx ON smartem.rawtimeseries USING btree (sample_id) ;

-- Refined/aggregated measurements table - extracted data from rawmeasurements table validated/aggregated via ETL
DROP TABLE IF EXISTS smartem.measurements CASCADE;
CREATE TABLE smartem.measurements (
  gid serial,
--   file_name character varying (32),
  insert_time timestamp default current_timestamp,

  component character varying (8),
  device_id character varying (8),
  sample_id  character varying (32),
  sample_time timestamp,
  sample_value_ppb real,
  sample_value real,
  PRIMARY KEY (gid)
);

-- Refined Measurement may only occur once in table, error if trying to insert multiple times
DROP INDEX IF EXISTS sample_id_idx;
CREATE UNIQUE INDEX sample_id_idx ON smartem.measurements USING btree (sample_id) ;

-- ETL progress tabel, houdt bij voor ieder ETL proces ("worker") wat het
-- laatst verwerkte record id is van hun bron tabel.
DROP TABLE IF EXISTS smartem.etl_progress CASCADE;
CREATE TABLE smartem.etl_progress (
  gid serial,
  worker character varying (25),
  source_table  character varying (25),
  last_id  integer,
  last_update timestamp,
  PRIMARY KEY (gid)
);

-- Define workers
INSERT INTO smartem.etl_progress (worker, source_table, last_id, last_update)
        VALUES ('files2measurements', 'smartem_files', -1, current_timestamp);
INSERT INTO smartem.etl_progress (worker, source_table, last_id, last_update)
        VALUES ('measurements2sos', 'measurements', -1, current_timestamp);


DROP VIEW IF EXISTS smartem.measurements_devices CASCADE;
CREATE VIEW smartem.measurements_devices AS
   SELECT m.gid, m.device_id, s.name, s.municipality, m.component, m.sample_time, m.sample_value, m.sample_value_ppb, s.point, s.lon, s.lat,
          m.insert_time, m.sample_id,
          s.unit_id, s.altitude
          FROM smartem.measurements as m
            INNER JOIN smartem.devices as s ON m.device_id = s.unit_id;

-- Laatste 24 uur aan metingen voor device en component
-- SELECT  * FROM  smartem.measurements
--   WHERE sample_time >  current_timestamp::timestamp without time zone - '1 day'::INTERVAL
--      AND component = 'NO' AND device_id = '136' order by sample_time desc;

-- Laatste meting voor device en component
-- SELECT  * FROM  smartem.measurements
--   WHERE sample_time >  current_timestamp::timestamp without time zone - '1 day'::INTERVAL
--      AND component = 'NO' AND device_id = '136' order by sample_time desc limit 1;

-- last measured sample value per device for component
-- SELECT DISTINCT ON (device_id)  device_id, municipality, gid, sample_time , sample_value
--      FROM smartem.measurements_devices WHERE component = 'SO2' ORDER BY device_id, gid DESC;

-- Metingen per Component
DROP VIEW IF EXISTS smartem.v_measurements_CO;
CREATE VIEW smartem.v_measurements_CO AS
  SELECT device_id,
    name, municipality, date_trunc('hour'::text, sample_time) AS sample_time, sample_value, point, gid, sample_id
  FROM smartem.measurements_devices WHERE component = 'CO';


DROP VIEW IF EXISTS smartem.v_measurements_NO2;
CREATE VIEW smartem.v_measurements_NO2 AS
  SELECT  device_id,
    name, municipality, date_trunc('hour'::text, sample_time) AS sample_time, sample_value, point, gid, sample_id
  FROM smartem.measurements_devices WHERE component = 'NO2';

DROP VIEW IF EXISTS smartem.v_measurements_O3;
CREATE VIEW smartem.v_measurements_O3 AS
  SELECT  device_id,
    name, municipality, date_trunc('hour'::text, sample_time) AS sample_time, sample_value, point, gid, sample_id
  FROM smartem.measurements_devices WHERE component = 'O3';


-- Laatste Metingen per Component
DROP VIEW IF EXISTS smartem.v_last_measurements_CO;
CREATE VIEW smartem.v_last_measurements_CO AS
  SELECT DISTINCT ON (device_id) device_id,
    name, municipality, sample_time, sample_value, point, gid, sample_id
  FROM smartem.measurements_devices WHERE component = 'CO' ORDER BY device_id, gid DESC;

DROP VIEW IF EXISTS smartem.v_last_measurements_NO2;
CREATE VIEW smartem.v_last_measurements_NO2 AS
  SELECT DISTINCT ON (device_id) device_id,
    name, municipality, sample_time, sample_value, point, gid, sample_id
  FROM smartem.measurements_devices WHERE component = 'NO2' ORDER BY device_id, gid DESC;

DROP VIEW IF EXISTS smartem.v_last_measurements_O3;
CREATE VIEW smartem.v_last_measurements_O3 AS
  SELECT DISTINCT ON (device_id) device_id,
    name, municipality, sample_time, sample_value, point, gid, sample_id
  FROM smartem.measurements_devices WHERE component = 'O3' ORDER BY device_id, gid DESC;
