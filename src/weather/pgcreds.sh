export PGUSER=postgres
export PGPASSWORD=postgres

export pg_options="host=localhost port=5432 weewx_db=../../data/weewx/weewx.sdb user=$PGUSER password=$PGPASSWORD database=sensors schema=weather"
