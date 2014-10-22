-- Resets ETL Step: from weeewx (SQLite on Raspberry Pi to Postgres on VPS)

UPDATE weather.etl_progress SET (last_id, last_update) = (0, current_timestamp) WHERE worker = 'weewx2archive';

TRUNCATE weather.weewx_archive CASCADE;
