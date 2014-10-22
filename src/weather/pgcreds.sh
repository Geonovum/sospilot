# Sets host-specific variables
. options-`hostname`.sh

export options="host=localhost port=5432 weewx_db=$WEEWX_DB user=$PGUSER password=$PGPASSWORD database=sensors schema=weather"
