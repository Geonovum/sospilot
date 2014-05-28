To create "clean" version of eionet RIVM stations understood by ogr2ogr to read into PostGIS:

* download CSV from http://cdr.eionet.europa.eu/Converters/run_conversion?file=nl/eu/aqd/d/envurreqq/REP_D-NL_RIVM_20131220_D-001.xml&conv=450&source=remote
* saves as REP_D-NL_RIVM_20131220_D-001
* copy to stations.csv for cleaning
* stations.csv: remove excess quotes, e.g. """
* stations.csv: replace in CSV header "Pos" with Lat,Lon
* stations.csv: replace space between coordinates with comma: e.g ,51.566389 4.932792, becomes ,51.566389,4.932792,
* test result stations.csv by uploading in e.g. Geoviewer: http://kadviewer.kademo.nl
* create or update stations.vrt for OGR mapping
* use stations2postgis.sh to map to PostGIS table
* use stations2gml.sh to map to GML file

