#!/usr/bin/env python
#
# aps2raster - convert RIVM RIO output file (.aps) to a GeoTIFF coverage file (.tif)
#
# Author: Just van den Broecke - 2015
# License: GPL
#
# This utility reads an .aps file, parsing its first line as metadata and the
# remaining lines as arrays of floats. These arrays are put into a 2-dimensional array.
# The GDAL library is used to create a 1-band GeoTIFF coverage file from this 2-dim array. Elements of the
# APS metadata provide input parameters for the GDAL functions, in particular the origin and
# pixelsize. Projection is fixed at the Dutch EPSG:28992 (RD) projection. Although the APS
# data are floats, they are rounded and converted to ints (0-255) in order to fit into the GeoTIFF.
# Negative values in the APS data like -999.0 are assumed to be 0 (TODO: maybe GDAL.NO_DATA later).
import sys
import gdal,osr
import numpy as np

def array2raster(out_file, origin, pixel_width, pixel_height, array, epsg_code):
    cols = array.shape[1]
    rows = array.shape[0]
    origin_x = origin[0]
    origin_y = origin[1]
    n_bands = 1

    driver = gdal.GetDriverByName('GTiff')

    # Create raster with 1-band and 1-byte cells
    out_raster = driver.Create(out_file, cols, rows, n_bands, gdal.GDT_Int16)

    # affine transformation coefficients
    out_raster.SetGeoTransform((origin_x, pixel_width, 0, origin_y, 0, pixel_height))

    # Write array data to first rasterband
    out_band = out_raster.GetRasterBand(1)
    out_band.SetNoDataValue(-999)
    out_band.WriteArray(array)

    # Project
    out_raster_srs = osr.SpatialReference()
    out_raster_srs.ImportFromEPSG(epsg_code)
    out_raster.SetProjection(out_raster_srs.ExportToWkt())

    # Writeout
    out_band.FlushCache()

def parse_aps_meta(meta_line):
    # APS Header
    #  Y M  D  H  C   unit  sys comment   format  proj  orig_x  orig_y  cols rows  pix_w  pix_h
    # 15 9 16 10 NO2 ug/m3 RIO uurwaarden f7.1    1     0.000   620.000 70    80   4.000 4.000

    # Remove excess whitespace
    meta_line = " ".join(meta_line.split())

    # Now split with single whitespace
    meta_arr = meta_line.split(' ')

    # Build-up dict from array, do conversions where needed
    meta = dict()

    meta['year'] = int(meta_arr[0])
    meta['month'] = int(meta_arr[1])
    meta['day'] = int(meta_arr[2])
    meta['hour'] = int(meta_arr[3])
    meta['component'] = meta_arr[4]
    meta['unit'] = meta_arr[5]
    meta['system'] = meta_arr[6]
    meta['comment'] = meta_arr[7]
    meta['cell_format'] = meta_arr[8]

    # Code voor coordinatenstelsel
    # 1. Amersfoortse coordinaten
    # 2. Geografische coordinaten
    # 3. Projectie op 50 NB (shifted pole) 4. projectie op 60 NB (shifted pole) 5. EMEP-coordinaten
    # 6. IE-coordinaten (EMEP/2.)
    # 7. OECD-coordinaten (EMEP/3.)
    meta['projection'] = int(meta_arr[9])

    # Upper left of upper left pixel
    meta['origin_x'] = float(meta_arr[10])*1000
    meta['origin_y'] = float(meta_arr[11])*1000

    meta['columns'] = int(meta_arr[12])
    meta['rows'] = int(meta_arr[13])
    meta['pixel_width'] = float(meta_arr[14])*1000
    meta['pixel_height'] = float(meta_arr[15])*1000

    return meta

def read_aps_file(file_path):
    file = open(file_path, 'r')

    # First line is meta-info: read and parse
    line = file.readline()
    meta = parse_aps_meta(line)

    # Start with zeroed 2-dim array
    raster_array = np.zeros((meta['rows'], meta['columns']))

    # Fill array from lines in file, each line is a row to be put in 2-dim array
    # Cells are floats, to be rounded and converted later to ints
    line_count = 0
    while line and len(line) > 0 and line_count < meta['rows']:
        line = file.readline()

        # Parse line into array of floats
        line_arr = np.fromstring(line, dtype=np.float32, sep=' ')

        # Add to 2-dim array
        raster_array[line_count] = line_arr
        line_count += 1

    return meta, raster_array

if __name__ == "__main__":
    args = sys.argv

    in_file = args[1] # '../../data/rivm-rio/output/2015091611_no2.aps'
    out_file = args[2] # 'aps_no2.tif'

    aps_meta, aps_array = read_aps_file(in_file)
    origin = (aps_meta['origin_x'], aps_meta['origin_y'], 0)
    pixel_width = aps_meta['pixel_width']
    pixel_height = -aps_meta['pixel_height']

    # http://docs.scipy.org/doc/numpy/reference/generated/numpy.around.html
    # Round all floats first
    aps_array = np.around(aps_array)

    # http://stackoverflow.com/questions/7994133/fast-in-place-replacement-of-some-values-in-a-numpy-array
    # Make negative values zero NB maybe need NO_VALUE
    # aps_array[aps_array < 0] = 0

    # COnvert rounded floats to ints
    aps_array = aps_array.astype(int)

    # Debug: convert to oridinary Python list (array)
    # aps_list = aps_array.tolist()

    # Convert to raster file
    array2raster(out_file, origin, pixel_width, pixel_height, aps_array, 28992)

