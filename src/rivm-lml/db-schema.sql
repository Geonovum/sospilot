-- Database defs for LML RIVM data

-- Raw file table, data harvesting from RIVM Apache SOS server
DROP TABLE IF EXISTS rivm_lml.lml_files CASCADE;
CREATE TABLE rivm_lml.lml_files (
  gid serial,
  insert_time timestamp default current_timestamp,
  file_name character varying (32),
  file_data text,
  PRIMARY KEY (gid)
);

-- File may only occur once in table, error if trying to insert multiple times
DROP INDEX IF EXISTS rivm_lml.lml_files_idx;
CREATE UNIQUE INDEX rivm_lml.lml_files_idx ON lml_files USING btree (file_name) ;

-- Raw measurements table - data from lml_files transformed via ETL
DROP TABLE IF EXISTS rivm_lml.measurements CASCADE;
CREATE TABLE rivm_lml.measurements (
  gid serial,
  file_name character varying (32),
  insert_time timestamp default current_timestamp,

  component character varying (8),
  station_id character varying (8),
  sample_id  character varying (32),
  sample_time timestamp,
  sample_value real,
  validated integer,
  PRIMARY KEY (gid)
);

-- Measurement may only occur once in table, error if trying to insert multiple times
DROP INDEX IF EXISTS sample_id_idx;
CREATE UNIQUE INDEX sample_id_idx ON rivm_lml.measurements USING btree (sample_id) ;

-- ETL progress tabel, houdt bij voor ieder ETL proces ("worker") wat het
-- laatst verwerkte record id is van hun bron tabel.
DROP TABLE IF EXISTS rivm_lml.etl_progress CASCADE;
CREATE TABLE rivm_lml.etl_progress (
  gid serial,
  worker character varying (25),
  source_table  character varying (25),
  last_id  integer,
  last_update timestamp,
  PRIMARY KEY (gid)
);

-- Define workers
INSERT INTO rivm_lml.etl_progress (worker, source_table, last_id, last_update)
        VALUES ('files2measurements', 'lml_files', -1, current_timestamp);
INSERT INTO rivm_lml.etl_progress (worker, source_table, last_id, last_update)
        VALUES ('measurements2sos', 'measurements', -1, current_timestamp);

-- Stations table
-- Already Generated from CSV via ogr2ogr
-- create a view with active stations
DROP VIEW IF EXISTS rivm_lml.active_stations CASCADE;
CREATE VIEW rivm_lml.active_stations AS
   SELECT * FROM rivm_lml.stations WHERE activity_end is NULL;

-- VIEWS measurements with stations to create tables for e.g. WFS/WMS(-Time)

-- The selector using INNER JOIN on stations
-- SELECT m.file_name, m.insert_time, m.component, m.station_id, m.sample_id, m.sample_time, m.sample_value, m.validated,
--   s.point, s.local_id, s.eu_station_code, s.municipality, s.altitude, s.area_classification, s.activity_begin, s.activity_end
--    FROM rivm_lml.measurements as m
--      INNER JOIN rivm_lml.stations as s ON m.station_id = s.natl_station_code;


DROP VIEW IF EXISTS rivm_lml.measurements_stations CASCADE;
CREATE VIEW rivm_lml.measurements_stations AS
   SELECT m.gid, m.station_id, s.name, s.municipality, m.component, m.sample_time, m.sample_value, s.point, s.lon, s.lat, m.validated,
          m.file_name, m.insert_time, m.sample_id,
          s.local_id, s.eu_station_code, s.altitude, s.area_classification,
          s.activity_begin, s.activity_end
          FROM rivm_lml.measurements as m
            INNER JOIN rivm_lml.stations as s ON m.station_id = s.natl_station_code;

-- Laatste 24 uur aan metingen voor station en component
-- SELECT  * FROM  rivm_lml.measurements
--   WHERE sample_time >  current_timestamp::timestamp without time zone - '1 day'::INTERVAL
--      AND component = 'NO' AND station_id = '136' order by sample_time desc;

-- Laatste meting voor station en component
-- SELECT  * FROM  rivm_lml.measurements
--   WHERE sample_time >  current_timestamp::timestamp without time zone - '1 day'::INTERVAL
--      AND component = 'NO' AND station_id = '136' order by sample_time desc limit 1;

-- last measured sample value per station for component
-- SELECT DISTINCT ON (station_id)  station_id, municipality, gid, sample_time , sample_value
--      FROM rivm_lml.measurements_stations WHERE component = 'SO2' ORDER BY station_id, gid DESC;

-- Metingen per Component
DROP VIEW IF EXISTS rivm_lml.v_measurements_CO;
CREATE VIEW rivm_lml.v_measurements_CO AS
  SELECT station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'CO';

DROP VIEW IF EXISTS rivm_lml.v_measurements_NH3;
CREATE VIEW rivm_lml.v_measurements_NH3 AS
  SELECT  station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'NH3';

DROP VIEW IF EXISTS rivm_lml.v_measurements_NO;
CREATE VIEW rivm_lml.v_measurements_NO AS
  SELECT  station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'NO';

DROP VIEW IF EXISTS rivm_lml.v_measurements_NO2;
CREATE VIEW rivm_lml.v_measurements_NO2 AS
  SELECT  station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'NO2';

DROP VIEW IF EXISTS rivm_lml.v_measurements_O3;
CREATE VIEW rivm_lml.v_measurements_O3 AS
  SELECT  station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'O3';

DROP VIEW IF EXISTS rivm_lml.v_measurements_PM25;
CREATE VIEW rivm_lml.v_measurements_PM25 AS
  SELECT  station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'PM2.5';

DROP VIEW IF EXISTS rivm_lml.v_measurements_PM10;
CREATE VIEW rivm_lml.v_measurements_PM10 AS
  SELECT  station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'PM10';

DROP VIEW IF EXISTS rivm_lml.v_measurements_SO2;
CREATE VIEW rivm_lml.v_measurements_SO2 AS
  SELECT  station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'SO2';

-- Laatste Metingen per Component
DROP VIEW IF EXISTS rivm_lml.v_last_measurements_CO;
CREATE VIEW rivm_lml.v_last_measurements_CO AS
  SELECT DISTINCT ON (station_id) station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'CO' ORDER BY station_id, gid DESC;

DROP VIEW IF EXISTS rivm_lml.v_last_measurements_NH3;
CREATE VIEW rivm_lml.v_last_measurements_NH3 AS
  SELECT DISTINCT ON (station_id) station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'NH3' ORDER BY station_id, gid DESC;

DROP VIEW IF EXISTS rivm_lml.v_last_measurements_NO;
CREATE VIEW rivm_lml.v_last_measurements_NO AS
  SELECT DISTINCT ON (station_id) station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'NO' ORDER BY station_id, gid DESC;

DROP VIEW IF EXISTS rivm_lml.v_last_measurements_NO2;
CREATE VIEW rivm_lml.v_last_measurements_NO2 AS
  SELECT DISTINCT ON (station_id) station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'NO2' ORDER BY station_id, gid DESC;

DROP VIEW IF EXISTS rivm_lml.v_last_measurements_O3;
CREATE VIEW rivm_lml.v_last_measurements_O3 AS
  SELECT DISTINCT ON (station_id) station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'O3' ORDER BY station_id, gid DESC;

DROP VIEW IF EXISTS rivm_lml.v_last_measurements_PM25;
CREATE VIEW rivm_lml.v_last_measurements_PM25 AS
  SELECT DISTINCT ON (station_id) station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'PM2.5' ORDER BY station_id, gid DESC;

DROP VIEW IF EXISTS rivm_lml.v_last_measurements_PM10;
CREATE VIEW rivm_lml.v_last_measurements_PM10 AS
  SELECT DISTINCT ON (station_id) station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'PM10' ORDER BY station_id, gid DESC;

DROP VIEW IF EXISTS rivm_lml.v_last_measurements_SO2;
CREATE VIEW rivm_lml.v_last_measurements_SO2 AS
  SELECT DISTINCT ON (station_id) station_id,
    name, municipality, sample_time, sample_value, point, validated, gid, sample_id
  FROM rivm_lml.measurements_stations WHERE component = 'SO2' ORDER BY station_id, gid DESC;

