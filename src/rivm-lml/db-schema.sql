-- Database defs for LML RIVM data

-- Raw file table, data harvesting from RIVM Apache SOS server
DROP TABLE IF EXISTS lml_files;
CREATE TABLE lml_files (
  gid serial,
  insert_time timestamp default current_timestamp,
  file_name character varying (32),
  file_data text,
  PRIMARY KEY (gid)
);

DROP INDEX IF EXISTS lml_files_idx;

-- File may only occur once in table, error if trying to insert multiple times
CREATE UNIQUE INDEX lml_files_idx ON lml_files USING btree (file_name) ;

-- TODO

-- Raw measurements table - data from lml_files transformed via ETL (TBD)
DROP TABLE IF EXISTS measurements;
CREATE TABLE measurements (
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

DROP INDEX IF EXISTS sample_id_idx;

-- File may only occur once in table, error if trying to insert multiple times
CREATE UNIQUE INDEX sample_id_idx ON measurements USING btree (sample_id) ;

-- ETL progres tabel, houdt bij voor ieder ETL proces ("worker") wat het
-- laatst verwerkte record id is van hun bron tabel.
DROP TABLE IF EXISTS etl_progress;
CREATE TABLE etl_progress (
  gid serial,
  worker character varying (25),
  source_table  character varying (25),
  last_id  integer,
  last_update timestamp,
  PRIMARY KEY (gid)
);

INSERT INTO etl_progress (worker, source_table, last_id, last_update)
        VALUES ('files2measurements', 'lml_files', -1, current_timestamp);
INSERT INTO etl_progress (worker, source_table, last_id, last_update)
        VALUES ('measurements2sos', 'measurements', -1, current_timestamp);

-- Stations table
-- Already Generated from CSV via ogr2ogr

-- VIEWS measurements with stations to create tables for e.g. WFS/WMS(-Time)
