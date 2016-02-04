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
