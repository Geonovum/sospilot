-- Database defs for Weather data

-- Database reset for schema: weather

DROP SCHEMA weather CASCADE;
CREATE SCHEMA weather;

-- ETL progress tabel, houdt bij voor ieder ETL proces ("worker") wat het
-- laatst verwerkte record id is van hun bron tabel.
DROP TABLE IF EXISTS weather.etl_progress CASCADE;
CREATE TABLE weather.etl_progress (
  gid          SERIAL,
  worker       CHARACTER VARYING(25),
  source_table CHARACTER VARYING(25),
  last_id      INTEGER,
  last_time    CHARACTER VARYING(25) DEFAULT '-',
  last_update  TIMESTAMP,
  PRIMARY KEY (gid)
);

-- Define workers
INSERT INTO weather.etl_progress (worker, source_table, last_id, last_update)
  VALUES ('weewx2archive', 'sqlite_archive', 0, current_timestamp);
INSERT INTO weather.etl_progress (worker, source_table, last_id, last_update)
  VALUES ('archive2measurements', 'weewx_archive', 0, current_timestamp);

-- Raw weewx_archive table - data from weewx weather archive
DROP TABLE IF EXISTS weather.weewx_archive CASCADE;
CREATE TABLE weather.weewx_archive (
  dateTime             INTEGER NOT NULL UNIQUE PRIMARY KEY,
  usUnits              INTEGER NOT NULL,
  interval             INTEGER NOT NULL,
  barometer            REAL,
  pressure             REAL,
  altimeter            REAL,
  inTemp               REAL,
  outTemp              REAL,
  inHumidity           REAL,
  outHumidity          REAL,
  windSpeed            REAL,
  windDir              REAL,
  windGust             REAL,
  windGustDir          REAL,
  rainRate             REAL,
  rain                 REAL,
  dewpoint             REAL,
  windchill            REAL,
  heatindex            REAL,
  ET                   REAL,
  radiation            REAL,
  UV                   REAL,
  extraTemp1           REAL,
  extraTemp2           REAL,
  extraTemp3           REAL,
  soilTemp1            REAL,
  soilTemp2            REAL,
  soilTemp3            REAL,
  soilTemp4            REAL,
  leafTemp1            REAL,
  leafTemp2            REAL,
  extraHumid1          REAL,
  extraHumid2          REAL,
  soilMoist1           REAL,
  soilMoist2           REAL,
  soilMoist3           REAL,
  soilMoist4           REAL,
  leafWet1             REAL,
  leafWet2             REAL,
  rxCheckPercent       REAL,
  txBatteryStatus      REAL,
  consBatteryVoltage   REAL,
  hail                 REAL,
  hailRate             REAL,
  heatingTemp          REAL,
  heatingVoltage       REAL,
  supplyVoltage        REAL,
  referenceVoltage     REAL,
  windBatteryStatus    REAL,
  rainBatteryStatus    REAL,
  outTempBatteryStatus REAL,
  inTempBatteryStatus  REAL
);

DROP TABLE IF EXISTS weather.measurements CASCADE;
CREATE TABLE weather.measurements (
  gid          SERIAL,
  unix_time    INTEGER, -- seconds since 1970
  sample_time  TIMESTAMP,
  insert_time  TIMESTAMP DEFAULT current_timestamp,

  station_id   CHARACTER VARYING(8),
  sample_value REAL,
  PRIMARY KEY (gid)
);

-- Measurement may only occur once in table, error if trying to insert multiple times
DROP INDEX IF EXISTS unix_time_idx;
CREATE UNIQUE INDEX unix_time_idx ON weather.measurements USING BTREE (unix_time);
