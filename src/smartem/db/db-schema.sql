-- Database defs for Smart Emissiondata

-- Raw file table, data harvesting from SmartEm Apache SOS server
-- DROP TABLE IF EXISTS smartem.lml_files CASCADE;
-- CREATE TABLE smartem.lml_files (
--   gid serial,
--   insert_time timestamp default current_timestamp,
--   file_name character varying (32),
--   file_data text,
--   PRIMARY KEY (gid)
-- );

-- File may only occur once in table, error if trying to insert multiple times
-- DROP INDEX IF EXISTS smartem.lml_files_idx;
-- CREATE UNIQUE INDEX smartem.lml_files_idx ON lml_files USING btree (file_name) ;

-- Raw measurements table - data from lml_files transformed via ETL
DROP TABLE IF EXISTS smartem.measurements CASCADE;
CREATE TABLE smartem.measurements (
  gid serial,
--   file_name character varying (32),
  insert_time timestamp default current_timestamp,

  component character varying (8),
  station_id character varying (8),
  sample_id  character varying (32),
  sample_time timestamp,
  sample_value_ppb real,
  sample_value real,
  PRIMARY KEY (gid)
);

-- Measurement may only occur once in table, error if trying to insert multiple times
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


DROP VIEW IF EXISTS smartem.measurements_stations CASCADE;
CREATE VIEW smartem.measurements_stations AS
   SELECT m.gid, m.station_id, s.name, s.municipality, m.component, m.sample_time, m.sample_value, m.sample_value_ppb, s.point, s.lon, s.lat,
          m.insert_time, m.sample_id,
          s.unit_id, s.altitude
          FROM smartem.measurements as m
            INNER JOIN smartem.stations as s ON m.station_id = s.unit_id;

-- Laatste 24 uur aan metingen voor station en component
-- SELECT  * FROM  smartem.measurements
--   WHERE sample_time >  current_timestamp::timestamp without time zone - '1 day'::INTERVAL
--      AND component = 'NO' AND station_id = '136' order by sample_time desc;

-- Laatste meting voor station en component
-- SELECT  * FROM  smartem.measurements
--   WHERE sample_time >  current_timestamp::timestamp without time zone - '1 day'::INTERVAL
--      AND component = 'NO' AND station_id = '136' order by sample_time desc limit 1;

-- last measured sample value per station for component
-- SELECT DISTINCT ON (station_id)  station_id, municipality, gid, sample_time , sample_value
--      FROM smartem.measurements_stations WHERE component = 'SO2' ORDER BY station_id, gid DESC;

-- Metingen per Component
DROP VIEW IF EXISTS smartem.v_measurements_CO;
CREATE VIEW smartem.v_measurements_CO AS
  SELECT station_id,
    name, municipality, sample_time, sample_value, point, gid, sample_id
  FROM smartem.measurements_stations WHERE component = 'CO';


DROP VIEW IF EXISTS smartem.v_measurements_NO2;
CREATE VIEW smartem.v_measurements_NO2 AS
  SELECT  station_id,
    name, municipality, sample_time, sample_value, point, gid, sample_id
  FROM smartem.measurements_stations WHERE component = 'NO2';

DROP VIEW IF EXISTS smartem.v_measurements_O3;
CREATE VIEW smartem.v_measurements_O3 AS
  SELECT  station_id,
    name, municipality, sample_time, sample_value, point, gid, sample_id
  FROM smartem.measurements_stations WHERE component = 'O3';


-- Laatste Metingen per Component
DROP VIEW IF EXISTS smartem.v_last_measurements_CO;
CREATE VIEW smartem.v_last_measurements_CO AS
  SELECT DISTINCT ON (station_id) station_id,
    name, municipality, sample_time, sample_value, point, gid, sample_id
  FROM smartem.measurements_stations WHERE component = 'CO' ORDER BY station_id, gid DESC;

DROP VIEW IF EXISTS smartem.v_last_measurements_NO2;
CREATE VIEW smartem.v_last_measurements_NO2 AS
  SELECT DISTINCT ON (station_id) station_id,
    name, municipality, sample_time, sample_value, point, gid, sample_id
  FROM smartem.measurements_stations WHERE component = 'NO2' ORDER BY station_id, gid DESC;

DROP VIEW IF EXISTS smartem.v_last_measurements_O3;
CREATE VIEW smartem.v_last_measurements_O3 AS
  SELECT DISTINCT ON (station_id) station_id,
    name, municipality, sample_time, sample_value, point, gid, sample_id
  FROM smartem.measurements_stations WHERE component = 'O3' ORDER BY station_id, gid DESC;
