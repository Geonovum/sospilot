To create "clean" version of eionet RIVM stations understood by ogr2ogr:

* remove excess quotes, e.g. """
- replace in CSV header "Pos" with Y,X
- replace space between coordinates with comma: e.g ,51.566389 4.932792, becomes ,51.566389,4.932792,

Test by uploading in e.g. Geoviewer: http://kadviewer.kademo.nl
