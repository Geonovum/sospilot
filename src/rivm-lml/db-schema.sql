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

-- Pregress table, table to track progress for ETL (TBD)

-- Stations table (TBD)

-- VIEWS measurements with stations to create tables for e.g. WFS/WMS(-Time)
