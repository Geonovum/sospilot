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
  VALUES ('weewx2postgres', 'sqlite_archive', 0, current_timestamp);

-- Raw measurements table - data from weewx weather archive or possibly other source
-- all units in US metrics assumed!
DROP TABLE IF EXISTS weather.measurements CASCADE;
CREATE TABLE weather.measurements (
  dateTime             INTEGER NOT NULL UNIQUE PRIMARY KEY,
  station_code         INTEGER DEFAULT 33,
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


--
-- Name: stations; Type: TABLE; Schema: knmi; Owner: postgres; Tablespace:
--

DROP TABLE IF EXISTS weather.stations CASCADE;
CREATE TABLE weather.stations (
    gid integer NOT NULL UNIQUE PRIMARY KEY,
    point geometry (Point,4326),
    wmo character varying,
    station_code integer,
    name character varying,
    obs_pres integer,
    obs_wind integer,
    obs_temp integer,
    obs_hum integer,
    obs_prec integer,
    obs_rad integer,
    obs_vis integer,
    obs_clouds integer,
    obs_presweather integer,
    obs_snowdepth integer,
    obs_soiltemp integer,
    lon double precision,
    lat double precision,
    height double precision
);

CREATE INDEX stations_point_idx ON stations USING gist (point);

INSERT INTO weather.stations (gid, point, wmo, station_code, name, obs_pres, obs_wind, obs_temp, obs_hum, obs_prec, obs_rad, obs_vis, obs_clouds, obs_presweather, obs_snowdepth, obs_soiltemp, lon, lat, height)
VALUES (1, ST_GeomFromText('POINT(5.372 52.152)', 4326), 'Davis Vantage Pro2', 33,'Geonovum',	1,1,	1,	1,	1,	0,	0,	0,	0,	0,	0, 5.372, 52.152, 32.4);

-- VIEWS

-- SELECT to_timestamp(datetime), "datetime","pressure","outtemp" FROM "weather"."measurements"
DROP VIEW IF EXISTS weather.v_observations CASCADE;
CREATE VIEW weather.v_observations AS
  SELECT
    meas.datetime,
    meas.station_code,
    stations.name as station_name,
    to_timestamp(datetime) as time,
    round(((outtemp-32.0)*5.0/9.0)::numeric) as outtemp_c,
    round((windSpeed*1.61)/3.6::numeric) as windspeed_mps,
    round((windGust*1.61)/3.6::numeric) as windgust_mps,
    round(windDir::numeric) as winddir_deg,
    round(((windchill-32.0)*5.0/9.0)::numeric) as windchill_c,
    meas.rainRate,
    round((pressure*33.8638815)::numeric) as pressure_mbar,
    round(outhumidity::numeric) as outhumidity_perc,
    stations.point as point
  FROM weather.measurements as meas
  INNER JOIN weather.stations AS stations
      ON meas.station_code = stations.station_code ORDER BY datetime DESC;

-- Laatste Metingen per Station
DROP VIEW IF EXISTS weather.v_last_observations CASCADE;
CREATE VIEW weather.v_last_observations AS
  SELECT DISTINCT ON (station_code) station_code,
    station_name,
    datetime,
    time,
    outtemp_c,
    windspeed_mps,
    windgust_mps,
    winddir_deg,
    windchill_c,
    rainRate,
    pressure_mbar,
    outhumidity_perc,
    point
  FROM weather.v_observations;

