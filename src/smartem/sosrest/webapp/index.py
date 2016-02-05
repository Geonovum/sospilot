import sys
from functools import wraps, update_wrapper
from datetime import datetime
from flask import Flask, render_template, session, redirect, url_for, escape, request, make_response
from postgis import PostGIS

if __name__ != '__main__':
    # When run with WSGI in Apache we need path extension to find Python modules relative to index.py
    sys.path.insert(0, '/var/www/smartemission.nl/sosemu')

try:
    from configparser import ConfigParser
except ImportError:
    from ConfigParser import ConfigParser  # ver. < 3.0

app = Flask(__name__)
app.debug = True
application = app

config = {
    'database': 'sensors',
    'host': 'localhost',
    'port': '5432',
    'schema': 'smartem_rt',
    'user': 'postgres',
    'password': 'postgres'
}

# Wrapper to disable any kind of caching for all pages
# See http://arusahni.net/blog/2014/03/flask-nocache.html
def nocache(view):
    @wraps(view)
    def no_cache(*args, **kwargs):
        response = make_response(view(*args, **kwargs))
        response.headers['Last-Modified'] = datetime.now()
        response.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0, max-age=0'
        response.headers['Pragma'] = 'no-cache'
        response.headers['Expires'] = '-1'
        return response

    return update_wrapper(no_cache, view)


@app.route('/')
@nocache
def home():
    return render_template('home.html')


@app.route('/api/v1/stations')
@nocache
def stations():
    # Do query from DB
    db = PostGIS(config)
    stations_list = db.do_query('SELECT * from stations', 'stations')

    # Construct the response: JSON doc via Jinja2 template with JSOn content type
    json_doc = render_template('stations.json', stations=stations_list)
    response = make_response(json_doc)
    response.headers["Content-Type"] = "application/json"
    return response


@app.route('/api/v1/timeseries')
@nocache
def timeseries(package=None):
    timeseries = []

    return render_template('timeseries.json', timeseries=timeseries)

if __name__ == '__main__':
    # Run as main via python index.py
    app.run(debug=True, host='0.0.0.0')
