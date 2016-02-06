#/bin/bash

rsync -e ssh -alzvx --exclude "*.pyc" --exclude "config.py" ./ sadmin@api.smartemission.nl:/var/www/api.smartemission.nl/sosemu/
