. options-`hostname`.sh

export pg_options="host=$PGHOST user=$PGUSER password=$PGPASSWORD port=5432 database=sensors schema=rivm_lml"
export sos_options="http_host=sensors.geonovum.nl http_port=80 http_user=$SOSUSER http_password=$SOSPASSWORD http_path=/sos/service"
