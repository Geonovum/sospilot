export LD_LIBRARY_PATH=/usr/local/iot/lib

/usr/local/iot/bin/iotagent -n qa -i  0.0.0.0 -d /usr/local/iot/lib -c ./config.json -v DEBUG
