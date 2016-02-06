import os, sys
from functools import wraps, update_wrapper
from datetime import datetime
from flask import Flask, render_template, session, redirect, url_for, escape, request, make_response

if __name__ != '__main__':
    # When run with WSGI in Apache we need path extension to find Python modules relative to index.py
    sys.path.insert(0, os.path.dirname(__file__))

from postgis import PostGIS
from config import config

app = Flask(__name__)
app.debug = True
application = app


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

# Shorthand to create proper JSON HTTP response
def make_json_response(json_doc):
    response = make_response(json_doc)
    response.headers["Content-Type"] = "application/json"
    return response

# Documentation
@app.route('/')
@nocache
def home():
    return render_template('home.html')


# Get list of all stations with locations
@app.route('/api/v1/stations')
@nocache
def stations():
    # Do query from DB
    db = PostGIS(config)
    stations_list = db.do_query('SELECT * from stations', 'stations')

    # Construct the response: JSON doc via Jinja2 template with JSON content type
    json_doc = render_template('stations.json', stations=stations_list)
    return make_json_response(json_doc)


# Get last values for single station
# Example: /api/v1/timeseries?station=23&expanded=true
@app.route('/api/v1/timeseries')
@nocache
def timeseries(package=None):
    timeseries_list = []
    station = request.args.get('station', None)
    if station:
        db = PostGIS(config)
        timeseries_list = db.do_query('SELECT * from v_last_measurements WHERE device_id = %s' % station, 'v_last_measurements')

    # Construct the response: JSON doc via Jinja2 template with JSON content type
    json_doc = render_template('timeseries.json', timeseries=timeseries_list)
    return make_json_response(json_doc)

if __name__ == '__main__':
    # Run as main via python index.py
    app.run(debug=True, host='0.0.0.0')
