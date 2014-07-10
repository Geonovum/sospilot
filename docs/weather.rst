.. _weather:

============
Weather Data
============

This chapter describes how the SOSPilot platform as developed initially for Air Quality
data can be reused to incorporate (historical) weather data. This has been performed
using Open Data from the Dutch Meteorological Institute (KNMI). The nature of the data and
the required steps are very similar to Air Quality data:

* obtaining raw source data: both time-series measurements and (georeferenced) stations
* data transformation (ETL)
* providing OWS services: WMS-(Time), WFS and SOS
* visualizing via Clients

See also https://github.com/Geonovum/sospilot/issues/17

Source Data
===========

Via http://data.knmi.nl many Open Data sets are available. For our purpose we need:

* georeferenced station data
* (historical) measurements data

Stations
--------

The station data can be found via https://data.knmi.nl/portal/KNMI-DataCentre.html, the dataset name is
``waarneemstations`` .
Within a .tar file the file ``STD___OPER_P___OBS_____L2.nc`` is present.
The format is tricky: a `NetCDF (Network Common Data Form) <http://en.wikipedia.org/wiki/NetCDF>`_  file (.nc extension).

To get the file:

* get metadata XML from data info popup: https://data.knmi.nl/webservices/metadata/getDatasetMetadataXML?datasetName=waarneemstations&datasetVersion=1
* extract Atom URL from metadata XML:  http://data.knmi.nl/inspire/atom?dataset=urn:xkdc:ds:nl.knmi::waarneemstations/1/
* extract download URL from Atom:  http://data.knmi.nl/inspire/download/waarneemstations/1/noversion/0000/00/00/STD___OPER_P___OBS_____L2.nc.zip
* unzip to ``STD___OPER_P___OBS_____L2.nc``

See ETL below how to further handle this data.

Measurements
------------

Historical data per station per decade can be found at http://www.knmi.nl/klimatologie/uurgegevens.
The .zip files contain a .CSV file with all hourly measurements for a station, e.g.
the file ``uurgeg_275_2011-2020.txt`` contains measurements for station 275 (Deelen) between
2011 and 2020, in practice all measurements between 2011 and the day before today until 24:00.
URLs remain constant and are directly accessible, for example for Deelen (station 275):
http://www.knmi.nl/klimatologie/uurgegevens/datafiles/275/uurgeg_275_2011-2020.zip
etc.

Example contents of ``uurgeg_275_2011-2020.txt`` on june 9, 2014. ::

    BRON:
    KONINKLIJK NEDERLANDS METEOROLOGISCH INSTITUUT (KNMI)

    SOURCE:
    ROYAL NETHERLANDS METEOROLOGICAL INSTITUTE (KNMI)

    YYYYMMDD  = datum (YYYY=jaar,MM=maand,DD=dag) / date (YYYY=year,MM=month,DD=day)
    HH        = tijd (HH=uur, UT.12 UT=13 MET, 14 MEZT. Uurvak 05 loopt van 04.00 UT tot 5.00 UT / time (HH uur/hour, UT. 12
    UT=13 MET, 14 MEZT. Hourly division 05 runs from 04.00 UT to 5.00 UT
    DD        = Windrichting (in graden) gemiddeld over de laatste 10 minuten van het afgelopen uur (360=noord, 90=oost,
    180=zuid, 270=west, 0=windstil 990=veranderlijk. Zie http://www.knmi.nl/klimatologie/achtergrondinformatie/windroos.pdf /
     Mean wind direction (in degrees) during the 10-minute period preceding the time of observation (360=north, 90=east,
     180=south, 270=west, 0=calm 990=variable)
    FH        = Uurgemiddelde windsnelheid (in 0.1 m/s). Zie http://www.knmi.nl/klimatologie/achtergrondinformatie/beaufortschaal.pdf
    / Hourly mean wind speed (in 0.1 m/s)
    FF        = Windsnelheid (in 0.1 m/s) gemiddeld over de laatste 10 minuten van het afgelopen uur / Mean wind speed
    (in 0.1 m/s) during the 10-minute period preceding the time of observation
    FX        = Hoogste windstoot (in 0.1 m/s) over het afgelopen uurvak / Maximum wind gust (in 0.1 m/s) during the
    hourly division
    T         = Temperatuur (in 0.1 graden Celsius) op 1.50 m hoogte tijdens de waarneming / Temperature (in 0.1 degrees
    Celsius) at 1.50 m at the time of observation
    T10N      = Minimumtemperatuur (in 0.1 graden Celsius) op 10 cm hoogte in de afgelopen 6 uur / Minimum temperature
    (in 0.1 degrees Celsius) at 0.1 m in the preceding 6-hour period
    TD        = Dauwpuntstemperatuur (in 0.1 graden Celsius) op 1.50 m hoogte tijdens de waarneming / Dew point temperature
     (in 0.1 degrees Celsius) at 1.50 m at the time of observation
    SQ        = Duur van de zonneschijn (in 0.1 uren) per uurvak, berekend uit globale straling  (-1 for <0.05 uur)
    / Sunshine duration (in 0.1 hour) during the hourly division, calculated from global radiation (-1 for <0.05 hour)
    Q         = Globale straling (in J/cm2) per uurvak / Global radiation (in J/cm2) during the hourly division
    DR        = Duur van de neerslag (in 0.1 uur) per uurvak / Precipitation duration (in 0.1 hour) during the hourly division
    RH        = Uursom van de neerslag (in 0.1 mm) (-1 voor <0.05 mm) / Hourly precipitation amount (in 0.1 mm)
    (-1 for <0.05 mm)
    P         = Luchtdruk (in 0.1 hPa) herleid naar zeeniveau, tijdens de waarneming / Air pressure (in 0.1 hPa)
    reduced to mean sea level, at the time of observation
    VV        = Horizontaal zicht tijdens de waarneming (0=minder dan 100m, 1=100-200m, 2=200-300m,..., 49=4900-5000m,
    50=5-6km, 56=6-7km, 57=7-8km, ..., 79=29-30km, 80=30-35km, 81=35-40km,..., 89=meer dan 70km) / Horizontal visibility
    at the time of observation (0=less than 100m, 1=100-200m, 2=200-300m,..., 49=4900-5000m, 50=5-6km, 56=6-7km, 57=7-8km,
    ..., 79=29-30km, 80=30-35km, 81=35-40km,..., 89=more than 70km)
    N         = Bewolking (bedekkingsgraad van de bovenlucht in achtsten), tijdens de waarneming (9=bovenlucht onzichtbaar)
     / Cloud cover (in octants), at the time of observation (9=sky invisible)
    U         = Relatieve vochtigheid (in procenten) op 1.50 m hoogte tijdens de waarneming / Relative atmospheric humidity
     (in percents) at 1.50 m at the time of observation
    WW        = Weercode (00-99), visueel(WW) of automatisch(WaWa) waargenomen, voor het actuele weer of het weer in het
    afgelopen uur. Zie http://www.knmi.nl/klimatologie/achtergrondinformatie/ww_lijst_nederlands.pdf / Present weather code
     (00-99), description for the hourly division. See http://www.knmi.nl/klimatologie/achtergrondinformatie/ww_lijst_engels.pdf
    IX        = Weercode indicator voor de wijze van waarnemen op een bemand of automatisch station (1=bemand gebruikmakend
     van code uit visuele waarnemingen, 2,3=bemand en weggelaten (geen belangrijk weersverschijnsel, geen gegevens), 4=automatisch
     en opgenomen (gebruikmakend van code uit visuele waarnemingen), 5,6=automatisch en weggelaten (geen belangrijk
     weersverschijnsel, geen gegevens), 7=automatisch gebruikmakend van code uit automatische waarnemingen) / Indicator present
     weather code (1=manned and recorded (using code from visual observations), 2,3=manned and omitted (no significant weather
     phenomenon to report, not available), 4=automatically recorded (using code from visual observations), 5,6=automatically
     omitted (no significant weather phenomenon to report, not available), 7=automatically set (using code from automated observations)
    M         = Mist 0=niet voorgekomen, 1=wel voorgekomen in het voorgaande uur en/of tijdens de waarneming /
    Fog 0=no occurrence, 1=occurred during the preceding hour and/or at the time of observation
    R         = Regen 0=niet voorgekomen, 1=wel voorgekomen in het voorgaande uur en/of tijdens de waarneming /
    Rainfall 0=no occurrence, 1=occurred during the preceding hour and/or at the time of observation
    S         = Sneeuw 0=niet voorgekomen, 1=wel voorgekomen in het voorgaande uur en/of tijdens de waarneming /
    Snow 0=no occurrence, 1=occurred during the preceding hour and/or at the time of observation
    O         = Onweer 0=niet voorgekomen, 1=wel voorgekomen in het voorgaande uur en/of tijdens de waarneming /
    Thunder  0=no occurrence, 1=occurred during the preceding hour and/or at the time of observation
    Y         = IJsvorming 0=niet voorgekomen, 1=wel voorgekomen in het voorgaande uur en/of tijdens de waarneming /
    Ice formation 0=no occurrence, 1=occurred during the preceding hour and/or at the time of observation

    # STN,YYYYMMDD,   HH,   DD,   FH,   FF,   FX,    T,  T10,   TD,   SQ,    Q,   DR,   RH,    P,   VV,    N,    U,   WW,   IX,    M,    R,    S,    O,    Y

      275,20110101,    1,  240,   30,   30,   40,   15,     ,   14,    0,    0,    0,    0,10217,    1,    1,   99,   34,    7,    1,    0,    0,    0,    0
      275,20110101,    2,  250,   30,   40,   60,   18,     ,   17,    0,    0,    0,    0,10213,    2,    9,   99,   32,    7,    1,    0,    0,    0,    0
      275,20110101,    3,  250,   40,   40,   70,   21,     ,   20,    0,    0,    0,    0,10210,    2,    5,   99,   33,    7,    1,    0,    0,    0,    0
       .
       .
      275,20140708,   20,  330,   30,   30,   70,  131,     ,  125,    0,    2,    9,    2,10119,   65,    8,   96,   57,    7,    0,    1,    0,    0,    0
      275,20140708,   21,  300,   30,   20,   50,  128,     ,  120,    0,    0,    8,    1,10118,   65,    8,   95,   57,    7,    0,    1,    0,    0,    0
      275,20140708,   22,  300,   30,   30,   50,  128,     ,  120,    0,    0,    0,   -1,10116,   65,    8,   95,   81,    7,    0,    1,    0,    0,    0
      275,20140708,   23,  270,   20,   20,   40,  126,     ,  123,    0,    0,    0,   -1,10115,   59,    8,   98,   61,    7,    0,    1,    0,    0,    0
      275,20140708,   24,  270,   20,   20,   40,  127,  125,  122,    0,    0,    0,   -1,10110,   61,    8,   97,   23,    7,    0,    1,    0,    0,    0

"Live" 10-minute data can be found via
https://data.knmi.nl/portal/KNMI-DataCentre.html, but again in the NetCDF format.
Though downloading is forced via an HTML page with attachment header popup.

Though direct download is possible via the following steps.

* Download the MetaData URL https://data.knmi.nl/webservices/metadata/getDatasetMetadataXML?datasetName=Actuele10mindataKNMIstations&datasetVersion=1
* In the XML an Atom Feed URL for download is found: http://data.knmi.nl/inspire/atom?dataset=urn:xkdc:ds:nl.knmi::Actuele10mindataKNMIstations/1
* The Atom Feed contains a download URL of the form: http://data.knmi.nl/inspire/download/Actuele10mindataKNMIstations/1/noversion/2014/07/09/KMDS__OPER_P___10M_OBS_L2.nc.zip

This pattern ``2014/07/09/KMDS__OPER_P___10M_OBS_L2.nc.zip`` looks like we could download any date
but in reality the current last 10 minutes are always downloaded. The contents of the contained NetCDF file are very similar to
the Stations .nc above. ::

    $ ncdump KMDS__OPER_P___10M_OBS_L2.nc

    netcdf KMDS__OPER_P___10M_OBS_L2 {
    dimensions:
        station = 47 ;
        time = 1 ;
    variables:
        string station(station) ;
            station:long_name = "Station id" ;
            station:cf_role = "timeseries_id" ;
        double time(time) ;
            time:long_name = "time of measurement" ;
            time:standard_name = "time" ;
            time:units = "seconds since 1950-01-01 00:00:00" ;
        string stationname(station) ;
            stationname:long_name = "Station name" ;
        double lat(station) ;
            lat:long_name = "station  latitude" ;
            lat:standard_name = "latitude" ;
            lat:units = "degrees_north" ;
        double lon(station) ;
            lon:long_name = "station longitude" ;
            lon:standard_name = "longitude" ;
            lon:units = "degrees_east" ;
        double height(station) ;
            height:long_name = "Station height" ;
            height:standard_name = "height" ;
            height:units = "m" ;
        double dd(station) ;
            dd:_FillValue = -9999. ;
            dd:standard_name = "wind_from_direction" ;
            dd:units = "degree" ;
            dd:long_name = "Wind Direction 10 Min Average" ;
        double ff(station) ;
            ff:_FillValue = -9999. ;
            ff:standard_name = "wind_speed" ;
            ff:units = "m s-1" ;
            ff:long_name = "Wind Speed at 10m 10 Min Average" ;
        double gff(station) ;
            gff:_FillValue = -9999. ;
            gff:standard_name = "wind_speed_of_gust" ;
            gff:units = "m s-1" ;
            gff:long_name = "Wind Gust at 10m 10 Min Maximum" ;
        double ta(station) ;
            ta:_FillValue = -9999. ;
            ta:standard_name = "air_temperature" ;
            ta:units = "degrees Celsius" ;
            ta:long_name = "Air Temperature 1.5m 10 Min Average" ;
        double rh(station) ;
            rh:_FillValue = -9999. ;
            rh:standard_name = "relative_humidity" ;
            rh:units = "%" ;
            rh:long_name = "Relative Humidity 1.5m 1 Min Average" ;
        double pp(station) ;
            pp:_FillValue = -9999. ;
            pp:standard_name = "air_pressure_at_sea_level" ;
            pp:units = "hPa" ;
            pp:long_name = "Air Pressure at Sea Level 1 Min Average" ;
        double zm(station) ;
            zm:_FillValue = -9999. ;
            zm:standard_name = "visibility_in_air" ;
            zm:units = "m" ;
            zm:long_name = "Meteorological Optical Range 10 Min Average" ;
        char iso_dataset ;
            iso_dataset:title = "KMDS__OPER_P___10M_OBS_L2" ;
            iso_dataset:abstract = "Most recent 10 minute in situ observations of the Dutch meteorological observation network" ;
            iso_dataset:status = "ongoing" ;
            iso_dataset:type = "dataset" ;
            iso_dataset:uid = "c3a312e2-2d8f-440b-ae7d-3406c9fe2f77" ;
            iso_dataset:topic = "atmosphere" ;
            iso_dataset:keyword = "tbd" ;
            iso_dataset:max-x = 10.f ;
            iso_dataset:min-x = 0.f ;
            iso_dataset:max-y = 60.f ;
            iso_dataset:min-y = 40.f ;
            iso_dataset:temporal_extent = "1950-01-01 and ongoing" ;
            iso_dataset:date = "2013-10-10" ;
            iso_dataset:dateType = "publication date" ;
            iso_dataset:statement = "Most recent 10 minute in situ observations in situ observations of the Dutch meteorological observation network" ;
            iso_dataset:code = "TBD" ;
            iso_dataset:codeSpace = "EPSG" ;
            iso_dataset:accessConstraints = "none" ;
            iso_dataset:useLimitation = "none" ;
            iso_dataset:organisationName_dataset = "Royal Netherlands Meteorological Institute (KNMI)" ;
            iso_dataset:email_dataset = "data@knmi.nl" ;
            iso_dataset:role_dataset = "pointOfContact" ;
            iso_dataset:metadata_id = "fbfad5b9-1dd2-425e-bb35-c96386380c0e" ;
            iso_dataset:organisationName_metadata = "Royal Netherlands Meteorological Institute (KNMI)" ;
            iso_dataset:role_metadata = "pointOfContact" ;
            iso_dataset:email_metadata = "data@knmi.nl" ;
            iso_dataset:url_metadata = "http://data.knmi.nl" ;
            iso_dataset:datestamp = "2010-11-01" ;
            iso_dataset:language = "eng" ;
            iso_dataset:metadataStandardName = "ISO 19115" ;
            iso_dataset:metadataStandardNameVersion = "Nederlandse metadatastandaard op ISO 19115 voor geografie 1.2" ;
        char product ;
            product:units = "1" ;
            product:long_name = "ADAGUC Data Products Standard" ;
            product:ref_doc = "ADAGUC Data Products Standard" ;
            product:ref_doc_version = "1.1" ;
            product:format_version = "1.1" ;
            product:originator = "Royal Netherlands Meteorological Institute (KNMI)" ;
            product:type = "P" ;
            product:acronym = "KMDS__OPER_P___10M_OBS_L2" ;
            product:level = "L2" ;
            product:style = "camelCase" ;
        char projection ;
            projection:EPSG_code = "EPSG:4326" ;

    // global attributes:
            :featureType = "timeSeries" ;
            :Conventions = "CF-1.4" ;
            :title = "KMDS__OPER_P___10M_OBS_L2" ;
            :institution = "Royal Netherlands Meteorological Institute (KNMI)" ;
            :source = "Royal Netherlands Meteorological Institute (KNMI)" ;
            :history = "File created from KMDS ASCII file. " ;
            :references = "http://data.knmi.nl" ;
            :comment = "none" ;
    data:

     station = "06201", "06203", "06204", "06205", "06206", "06207", "06208",
        "06210", "06211", "06212", "06225", "06235", "06239", "06240", "06242",
        "06248", "06249", "06251", "06257", "06258", "06260", "06267", "06269",
        "06270", "06273", "06275", "06277", "06278", "06279", "06280", "06283",
        "06286", "06290", "06310", "06319", "06330", "06340", "06343", "06344",
        "06348", "06350", "06356", "06370", "06375", "06377", "06380", "06391" ;

     time = 2036070000 ;

     stationname = "D15-FA-1", "P11-B", "K14-FA-1C", "A12-CPP", "F16-A",
        "L9-FF-1", "AWG-1", "VALKENBURG AWS", "J6-A", "HOORN-A", "IJMUIDEN WP",
        "DE KOOIJ VK", "F3-FB-1", "AMSTERDAM/SCHIPHOL AP", "VLIELAND",
        "WIJDENES WP", "BERKHOUT AWS", "TERSCHELLING HOORN AWS",
        "WIJK AAN ZEE AWS", "HOUTRIBDIJK WP", "DE BILT AWS", "STAVOREN AWS",
        "LELYSTAD AP", "LEEUWARDEN", "MARKNESSE AWS", "DEELEN", "LAUWERSOOG AWS",
        "HEINO AWS", "HOOGEVEEN AWS", "GRONINGEN AP EELDE", "HUPSEL AWS",
        "NIEUW BEERTA AWS", "TWENTE AWS", "VLISSINGEN AWS", "WESTDORPE AWS",
        "HOEK VAN HOLLAND AWS", "WOENSDRECHT", "ROTTERDAM GEULHAVEN",
        "ROTTERDAM THE HAGUE AP", "CABAUW TOWER AWS", "GILZE RIJEN",
        "HERWIJNEN AWS", "EINDHOVEN AP", "VOLKEL", "ELL AWS",
        "MAASTRICHT AACHEN AP", "ARCEN AWS" ;

     lat = 54.325666666667, 52.36, 53.269444444444, 55.399166666667,
        54.116666666667, 53.614444444444, 53.491666666667, 52.170248689194,
        53.824130555556, 52.918055555556, 52.462242867998, 52.926865008825,
        54.853888888889, 52.315408447486, 53.240026656696, 52.632430667762,
        52.642696895243, 53.391265948394, 52.505333893732, 52.648187308904,
        52.098821802977, 52.896643913235, 52.457270486008, 53.223000488316,
        52.701902388132, 52.0548617826, 53.411581103636, 52.434561756559,
        52.749056395511, 53.123676213651, 52.067534268959, 53.194409573306,
        52.27314817052, 51.441334059998, 51.224757511326, 51.990941918858,
        51.447744494043, 51.891830906739, 51.960667359998, 51.969031121385,
        51.564889021961, 51.857593837453, 51.449772459909, 51.658528382201,
        51.196699902606, 50.905256257898, 51.497306260089 ;

     lon = 2.93575, 3.3416666666667, 3.6277777777778, 3.8102777777778,
        4.0122222222222, 4.9602777777778, 5.9416666666667, 4.4294613573587,
        2.9452777777778, 4.1502777777778, 4.5549006792363, 4.7811453228565,
        4.6961111111111, 4.7902228464686, 4.9207907082729, 5.1734739738872,
        4.9787572406902, 5.3458010937365, 4.6029300588208, 5.4003881262577,
        5.1797058644882, 5.383478899702, 5.5196324030324, 5.7515738887123,
        5.8874461671401, 5.8723225499118, 6.1990994508938, 6.2589770334531,
        6.5729701105864, 6.5848470019087, 6.6567253619722, 7.1493220605216,
        6.8908745111116, 3.5958241584686, 3.8609657214986, 4.121849767852,
        4.342014, 4.3126638323991, 4.4469005114756, 4.9259216999194,
        4.9352386335384, 5.1453989235756, 5.3770039280214, 5.7065946674719,
        5.7625447234516, 5.7617834850481, 6.1961067840608 ;

     height = 42.7, 41.84, 41.8, 48.35, 43.4, 44, 40.5, -0.2, 45.7, 50.9, 4,
        1.22, 50.6, -3.35, 10.79, 0.8, -2.4, 0.73, 8.5, 7.25, 1.9, -1.3, -3.66,
        1.22, -3.35, 48.16, 2.9, 3.6, 15.82, 5.18, 29.07, -0.2, 34.75, 8.03,
        1.68, 11.86, 19.2, 3.5, -4.27, -0.71, 14.94, 0.66, 22.56, 21.95, 30,
        114.3, 19.5 ;

     dd = 343.2, 320.3, 0, 355.8, 324.4, 339.8, 340.7, 337.7, 312.1, 331.9,
        335.3, 330.9, 20.7, 336.6, 337, 326.4, 331.4, 338.6, _, 333.8, 338.7,
        337.3, 333.2, 350.5, 331.2, 327.5, 352.6, 347.5, 323.4, 352, 325.3, 0.1,
        326.5, 328.4, 328.1, 331.9, 328.8, 330.4, 333.4, 331.1, 336.4, 326.3,
        337.1, 335.6, 327.8, 271.5, 331.3 ;

     ff = 14.40063, 12.71024, 0, 7.480422, 10.61489, 9.930736, 7.767642, 12.29,
        14.5523, 14.31887, 15.59, 7.77, 7.253119, 8.39, 12.31, 9.03, 8.82, 7.23,
        _, 12.58, 4.92, 10.97, 6.88, 7.11, 4.99, 6.1, 8.76, 2.68, 4.29, 5.05,
        2.43, 5.38, 3.07, 12.74, 10.74, 20.89, 7.5, 10.56, 6.14, 8.7, 8.39, 6.64,
        7.09, 4.16, 5.21, 3.03, 2.88 ;

     gff = 17.47643, 19.11437, 0, 8.184164, 12.64459, 11.1621, 9.07996, 16.54,
        17.28121, 16.76123, 18.21, 13.3, 8.400682, 12.29, 14.35, 12.1, 11.92,
        9.92, _, 14.85, 8.88, 13.42, 10.37, 9.32, 7.92, 8.99, 10.99, 5.07, 6.86,
        7.26, 3.21, 7.75, 4.97, 19.26, 17.94, 23.88, 13.05, 14.12, 11.69, 11.75,
        12.62, 10.78, 12.21, 7.4, 8.72, 5.03, 5.5 ;

     ta = 15, 15.6, 15.5, 16, 15.9, 16.9, 18.2, 16, 14.9, 15.6, _, 16.7, 17.2,
        16.3, 17.3, _, 16.6, 18.9, 16.2, _, 16.4, 18, 17.5, 20.9, 19.7, 17.2,
        21.3, 20.3, 22.6, 24.4, 19, 26, 20.7, 15.4, 14.9, 15.5, 15.2, _, 15.7,
        16.1, 15.8, 16.1, 16, 16.6, 15.9, 14.7, 17.2 ;

     rh = 98, 87, 95, 97, 98, 96, 95, 95, 94, 95, _, 97, 92, 97, 95, _, 98, 91,
        96, _, 97, 97, 97, 87, 93, 99, 82, 92, 88, 77, 97, 76, 90, 92, 94, 95,
        94, _, 94, 96, 96, 95, 96, 97, 96, 99, 96 ;

     pp = 1011.647, 1010.537, 1010.917, 1011.244, 1010.213, 1007.996, 1006.526,
        1008.164, 1011.488, 0, _, 1007.934, 1009.975, 1007.509, 1007.941, _, _,
        1007.273, _, _, 1007.118, _, 1006.237, 1006.516, _, 1005.847, _, _,
        1005.052, 1005.169, _, _, 1004.474, 1010.052, 1010.173, 1008.988,
        1008.784, _, 1008.559, 1007.503, 1007.409, 1007.006, 1006.774, 1006.152,
        _, 1006.434, _ ;

     zm = 3030, 10600, 7760, 6690, 3860, 5750, 6360, 8980, 7200, 4390, _, 5060,
        11400, 6820, 2800, _, 4980, 6270, _, _, 6410, 4350, 5030, 12200, 6690,
        1740, _, _, 8900, 17500, _, _, 5490, 5870, 6860, _, 7520, _, 6770, 7270,
        9540, _, 9970, 7270, 8940, 3430, _ ;

     iso_dataset = "" ;

     product = "" ;

     projection = "" ;
    }


There is also a simpler table: ftp://ftp.knmi.nl/pub_weerberichten/tabel_10min_data.html but no historical
data can be fetched.

The strategy for ETL could be to:

* use the historical for initial DB fill
* incrementally add, each hour, from the 10-minute data.

ETL Implementation
==================

In this section the ETL is elaborated.


As with AQ the ETL is performed in these steps:

#. Incremental download of source data and preparation
#. Raw data for stations and measurements to Postgres tables, "Core Weather Data"
#. SOS ETL: transform and publish "Core Weather Data" to the 52N SOS DB via SOS-Transactions (SOS-T)

Stations ETL
------------

Needs to be done once. Open source tools like `ncdump <https://www.unidata.ucar.edu/software/netcdf/docs/netcdf/ncdump.html>`_
and GDAL (http://www.gdal.org/frmt_netcdf.html) exist to extract data from the NetCDF file.  We'll use ``ncdump``. Install on Linux via
``apt-get install netcdf-bin``, on Mac OSX via ``brew install netcdf``.

The ETL is done in the following steps (see Git dir ``/data/knmi/stations``):

1. download ``wget http://data.knmi.nl/inspire/download/waarneemstations/1/noversion/0000/00/00/STD___OPER_P___OBS_____L2.nc.zip``

2. unzip to ``STD___OPER_P___OBS_____L2.nc``

3. create a text-readable Net CDF dump. ::

    ncdump STD___OPER_P___OBS_____L2.nc > stations.ncdump.txt

4. create CSV from ``stations.ncdump.txt``  using custom Python program. ::

    ./stations2csv.py > stations.csv

5.  use ``ogr2ogr`` commandline with ``stations.vrt`` for DB mappings to read into PostGIS


ETL Step 1. - Harvester
-----------------------

TO BE SUPPLIED

ETL Step 2 - Raw Measurements
-----------------------------

This step produces raw weather measurements.

Two tables: ``stations`` and ``measurements``. This is a 1:1 transformation from the raw weather data harvested in Step 1.
The ``measurements`` table refers to the ``stations`` by a FK ``station_code`` (WMO in source data). The table ``etl_progress`` is
used to track the last file processed from ``lml_files``.


Measurements
~~~~~~~~~~~~

TO BE SUPPLIED


ETL Step 3 - SOS Publication
----------------------------

In this step the Raw Weather data (see Step 2) is transformed to "SOS Ready Data",
i.e. data that can be handled by the 52North SOS server.  "SOS Transactions" (SOS-T) 
have been proven to work well for the LML AQ data. So from here on publication via 
SOS-T is further expanded.


SOS Publication - Stetl Strategy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Similar to SOS-T for AQ. 

SOS Publication - Sensors
~~~~~~~~~~~~~~~~~~~~~~~~~

This step needs to be performed only once, or when any of the original Station data changes.

The Stetl config https://github.com/Geonovum/sospilot/blob/master/src/knmi/stations2sensors.cfg
uses a Standard Stetl module, ``inputs.dbinput.PostgresDbInput`` for obtaining Record data from a Postgres database. ::

    {{
      "request": "InsertSensor",
      "service": "SOS",
      "version": "2.0.0",
      "procedureDescriptionFormat": "http://www.opengis.net/sensorML/1.0.1",
      "procedureDescription": "{procedure-desc.xml}",
       "observableProperty": [
        (need observable properties: Temperature, Wind direction etc)
      ],
      "observationType": [
        "http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement"
      ],
      "featureOfInterestType": "http://www.opengis.net/def/samplingFeatureType/OGC-OM/2.0/SF_SamplingPoint"
    }}

The SOSTOutput module will expand ``{procedure-desc.xml}`` with the Sensor ML template.

SOS Publication - Observations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Stetl config 

The Observation template looks as follows. ::

   {{
      "request": "InsertObservation",
      "service": "SOS",
      "version": "2.0.0",
      "offering": "http://sensors.geonovum.nl/knmi/offering/{station_code}",
      "observation": {{
        "identifier": {{
          "value": "{unique_id}",
          "codespace": "http://www.opengis.net/def/nil/OGC/0/unknown"
        }},
        "type": "http://www.opengis.net/def/observationType/OGC-OM/2.0/OM_Measurement",
        "procedure": "http://sensors.geonovum.nl/knmi/procedure/{station_code}",
        "observedProperty": "http://sensors.geonovum.nl/knmi/observableProperty/{observation_type}",
        "featureOfInterest": {{
          "identifier": {{
            "value": "http://sensors.geonovum.nl/knmi/featureOfInterest/{station_code}",
            "codespace": "http://www.opengis.net/def/nil/OGC/0/unknown"
          }},
          "name": [
            {{
              "value": "{municipality}",
              "codespace": "http://www.opengis.net/def/nil/OGC/0/unknown"
            }}
          ],
          "geometry": {{
            "type": "Point",
            "coordinates": [
              {station_lat},
              {station_lon}
            ],
            "crs": {{
              "type": "name",
              "properties": {{
                "name": "EPSG:4326"
              }}
            }}
          }}
        }},
        "phenomenonTime": "{sample_time}",
        "resultTime": "{sample_time}",
        "result": {{
          "uom": "deegrees",
          "value": {sample_value}
        }}
      }}
   }}

It is quite trivial in ``sosoutput.py`` to substitute these values from the ``measurements``-table records.

Like in ETL Step 2 the progress is remembered in the table ``rivm_lml.etl_progress`` by updating the ``last_id`` field
after publication, where that value represents the ``gid`` value of ``rivm_lml.measurements``.

SOS Publication - Results
~~~~~~~~~~~~~~~~~~~~~~~~~

TO BE SUPPLIED
Via the standard SOS protocol the results can be tested:

* GetCapabilities: http://sensors.geonovum.nl/sos/service?service=SOS&request=GetCapabilities
* DescribeSensor (station 275, Deelen): to be supplied
* GetObservation: to be supplied

