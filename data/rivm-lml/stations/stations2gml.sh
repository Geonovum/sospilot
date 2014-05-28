ogr2ogr -overwrite -f "GML" -lco FID=gid -lco OVERWRITE=yes -lco GEOMETRY_NAME=point  stations.gml stations.vrt -nln stations
