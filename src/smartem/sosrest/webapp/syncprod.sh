#/bin/bash

sudo rsync -vr ./ /var/www/dashboard
sudo rm /var/www/dashboard/*.pyc
sudo chown -R gis:gis /var/www/dashboard
