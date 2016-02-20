/**
 * Options for MapPanel
 * These will be assigned as "hropts" within the global config
 * "scratch" is just for convenience.
 *
 **/
Ext.namespace("Heron.options.map");
Ext.namespace("Heron.PDOK");

/** Use these in  services where the server has less resolutions than the Map, OL will "blowup" lower resolutions */
Heron.options.serverResolutions = {
    zoom_0_12: [3440.640, 1720.320, 860.160, 430.080, 215.040, 107.520, 53.760, 26.880, 13.440, 6.720, 3.360, 1.680, 0.840],
    zoom_0_13: [3440.640, 1720.320, 860.160, 430.080, 215.040, 107.520, 53.760, 26.880, 13.440, 6.720, 3.360, 1.680, 0.840, 0.420],
    zoom_0_14: [3440.640, 1720.320, 860.160, 430.080, 215.040, 107.520, 53.760, 26.880, 13.440, 6.720, 3.360, 1.680, 0.840, 0.420, 0.210],
    zoom_0_15: [3440.640, 1720.320, 860.160, 430.080, 215.040, 107.520, 53.760, 26.880, 13.440, 6.720, 3.360, 1.680, 0.840, 0.420, 0.210, 0.105],
    zoom_0_16: [3440.640, 1720.320, 860.160, 430.080, 215.040, 107.520, 53.760, 26.880, 13.440, 6.720, 3.360, 1.680, 0.840, 0.420, 0.210, 0.105, 0.0525]
};

/**
 * Standard tiling "richtlijn" Netherlands:
 * upperleft: X=-285.401,920 Y=903.401,920;
 * lowerright: X=595.401,920 Y=22.598,080;
 * lowerleft: X=-285.401,920  Y=22.598,080;
 * This results in:
 * maxExtent: '-285401.920,22598.080,595401.920,903401.920'
 * on zoomLevel 2 more common for NL:
 * maxExtent: '-65200.96,242799.04,375200.96,683200.96',
 * but when using TMS all levels needed
 * scales:
 - 750
 - 1500
 - 3000
 - 6000
 - 12000
 - 24000
 - 48000
 - 96000
 - 192000
 - 384000
 - 768000
 - 1536000
 - 3072000
 - 6144000
 - 12288000
 * PDOK (follows tiling standard NL):
 *     baseURL: 'http://geodata.nationaalgeoregister.nl',
 *     TMS: 'http://geodata.nationaalgeoregister.nl/tms/',
 *     WMTS:  'http://geodata.nationaalgeoregister.nl/tiles/service/wmts',
 *     tileOriginLL: new OpenLayers.LonLat(-285401.920, 22598.080),
 *     tileOriginUL: new OpenLayers.LonLat(-285401.920, 903401.920),
 *     tileFullExtent:    new OpenLayers.Bounds(-285401.920, 22598.080, 595401.920, 903401.920),
 *     serverResolutions : [3440.640, 1720.320, 860.160, 430.080, 215.040, 107.520, 53.760, 26.880, 13.440, 6.720, 3.360, 1.680, 0.840, 0.420, 0.210, 0.105, 0.0525],
 */

Heron.options.map.settings = {
    projection: 'EPSG:28992',
    units: 'm',
    /** Using the PDOK/Geonovum NL Tiling rec. */
    resolutions: Heron.options.serverResolutions.zoom_0_16,
    maxExtent: '-285401.920, 22598.080, 595401.920, 903401.920',

//	resolutions: [860.160, 430.080, 215.040, 107.520, 53.760, 26.880, 13.440, 6.720, 3.360, 1.680, 0.840, 0.420, 0.210, 0.105, 0.0525],
//	maxExtent: '-65200.96,242799.04,375200.96,683200.96',
    center: '155000,463000',
    xy_precision: 3,
    zoom: 3,
    allOverlays: false,
    theme: null,
    fractionalZoom: false,

    /**
     * Useful to always have permalinks enabled. default is enabled with these settings.
     * MapPanel.getPermalink() returns current permalink
     *
     **/
    permalinks: {
        /** The prefix to be used for parameters, e.g. map_x, default is 'map' */
        paramPrefix: 'map',
        /** Encodes values of permalink parameters ? default false*/
        encodeType: false,
        /** Use Layer names i.s.o. OpenLayers-generated Layer Id's in Permalinks */
        prettyLayerNames: true
    },

    controls: [
        new OpenLayers.Control.Attribution(),
        new OpenLayers.Control.ZoomBox(),
        new OpenLayers.Control.Navigation({dragPanOptions: {enableKinetic: true}}),
        new OpenLayers.Control.LoadingPanel(),
        new OpenLayers.Control.PanPanel(),
        new OpenLayers.Control.ZoomPanel(),

        /*,				new OpenLayers.Control.OverviewMap() */
//        new OpenLayers.Control.PanZoomBar(),
        new OpenLayers.Control.ScaleLine({bottomOutUnits: '', geodesic: true, maxWidth: 200})
    ]
    /** You can always control which controls are to be added to the map. */
    /* controls : [
     new OpenLayers.Control.Attribution(),
     new OpenLayers.Control.ZoomBox(),
     new OpenLayers.Control.Navigation({dragPanOptions: {enableKinetic: true}}),
     new OpenLayers.Control.LoadingPanel(),
     new OpenLayers.Control.PanPanel(),
     new OpenLayers.Control.ZoomPanel(),
     new OpenLayers.Control.OverviewMap(),
     new OpenLayers.Control.ScaleLine({geodesic: true, maxWidth: 200})
     ] */
};


// Scratch object, just to keep list of URLs for reuse
Ext.namespace("Heron.scratch");
Heron.scratch.urls = {
    SOSPILOT_OWS: 'http://sensors.geonovum.nl/gs/ows?',
    PDOK: 'http://geodata.nationaalgeoregister.nl',
    KADEMO_WFS: 'http://kademo.nl/gs2/wfs?',
    KADEMO_OWS: 'http://kademo.nl/gs2/ows?',
    KADEMO_GWC_TMS: 'http://kademo.nl/gwc/service/tms/',
    MAP5_TMS: 'http://s.map5.nl/map/gast/tms/',
    MAP5_WMS: 'http://s.map5.nl/map/gast/service?',
    OPENBASISKAART_TMS: 'http://openbasiskaart.nl/mapcache/tms/',
    RO_WMS: 'http://afnemers.ruimtelijkeplannen.nl/afnemers/services?',
    KNMI_ACT_10MIN: 'https://data.knmi.nl/wms/cgi-bin/wms.cgi?%26source%3D%2FActuele10mindataKNMIstations%2F1%2Fnoversion%2F2014%2F11%2F04%2FKMDS__OPER_P___10M_OBS_L2%2Enc%26'
};

Heron.PDOK.urls = {
    ADRESSEN: Heron.scratch.urls.PDOK + '/inspireadressen/ows?',
    BAGVIEWER: Heron.scratch.urls.PDOK + '/bagviewer/ows?',
    BESCHERMDENATUURMONUMENTEN: Heron.scratch.urls.PDOK + '/beschermdenatuurmonumenten/wms?',
    BESTUURLIJKEGRENZEN: Heron.scratch.urls.PDOK + '/bestuurlijkegrenzen/ows?',
    PDOKTMS: Heron.scratch.urls.PDOK + '/tms/',
    NATURA2000: Heron.scratch.urls.PDOK + '/natura2000/wms?',
    NATURA2000WMTS: Heron.scratch.urls.PDOK + '/tiles/service/wmts/natura2000?',
    NWBWEGEN: Heron.scratch.urls.PDOK + '/nwbwegen/wms?',
    NWBVAARWEGEN: Heron.scratch.urls.PDOK + '/nwbvaarwegen/wms?',
    NWBSPOORWEGEN: Heron.scratch.urls.PDOK + '/nwbspoorwegen/wms?',
    NWBSPOORWEGENWFS: Heron.scratch.urls.PDOK + '/nwbspoorwegen/wfs?',
    DTB: Heron.scratch.urls.PDOK + '/digitaaltopografischbestand/wms?',
    NATIONALEPARKEN: Heron.scratch.urls.PDOK + '/nationaleparken/wms?',
    WETLANDS: Heron.scratch.urls.PDOK + '/wetlands/wms?',
    NHI: Heron.scratch.urls.PDOK + '/nhi/wms?',
    AHN1: Heron.scratch.urls.PDOK + '/ahn25m/wms?',
    AHN2: Heron.scratch.urls.PDOK + '/ahn2/wms?',
    NOK: Heron.scratch.urls.PDOK + '/nok2010/wms?',
    VIN: Heron.scratch.urls.PDOK + '/vin/wms?',
    WEGGEG: Heron.scratch.urls.PDOK + '/weggeg/wms?',
    TOP10NL: Heron.scratch.urls.PDOK + '/top10nl/wms?',
    TOP10NLWMTS: Heron.scratch.urls.PDOK + '/tiles/service/wmts/top10nl?',
    TOP250RASTER: Heron.scratch.urls.PDOK + '/top250raster/wms?',
    TOP50RASTER: Heron.scratch.urls.PDOK + '/top50raster/wms?',
    TOP50VECTOR: Heron.scratch.urls.PDOK + '/top50vector/wms?',
    CULTGIS: Heron.scratch.urls.PDOK + '/cultgis/wms?',
    NOK2011: Heron.scratch.urls.PDOK + '/nok2011/wms?',
    BESTANDBODEMGEBRUIK2008: Heron.scratch.urls.PDOK + '/bestandbodemgebruik2008/wms?',
    BEVOLKINGSKERNEN2008: Heron.scratch.urls.PDOK + '/bevolkingskernen2008/wms?',
    AAN: Heron.scratch.urls.PDOK + '/aan/wms?',
    WIJKENBUURTEN2011: Heron.scratch.urls.PDOK + '/wijkenbuurten2011/wms?',
    WIJKENBUURTEN2010: Heron.scratch.urls.PDOK + '/wijkenbuurten2010/wms?',
    WIJKENBUURTEN2009: Heron.scratch.urls.PDOK + '/wijkenbuurten2009/wms?',
    CBSVIERKANTEN100m2010: Heron.scratch.urls.PDOK + '/cbsvierkanten100m2010/wms?',
    NOK2007: Heron.scratch.urls.PDOK + '/nok2007/wms?',
    LAWROUTES: Heron.scratch.urls.PDOK + '/lawroutes/wms?',
    LFROUTES: Heron.scratch.urls.PDOK + '/lfroutes/wms?',
    RDINFO: Heron.scratch.urls.PDOK + '/rdinfo/wms?',
    STREEKPADEN: Heron.scratch.urls.PDOK + '/streekpaden/wms?'
};

Ext.namespace("Heron.options.wfs");
Heron.options.wfs.downloadFormats = [
    {
        name: 'CSV',
        outputFormat: 'csv',
        fileExt: '.csv'
    },
    {
        name: 'GML (version 2.1.2)',
        outputFormat: 'text/xml; subtype=gml/2.1.2',
        fileExt: '.gml'
    },
    {
        name: 'ESRI Shapefile (zipped)',
        outputFormat: 'SHAPE-ZIP',
        fileExt: '.zip'
    },
    {
        name: 'GeoJSON',
        outputFormat: 'json',
        fileExt: '.json'
    }
];

/* Vector layers voor interactiviteit */
Ext.namespace("Heron.options.worklayers");
Heron.options.worklayers = {
    editor: new OpenLayers.Layer.Vector('Tekenlaag', {
        displayInLayerSwitcher: true, visibility: false, customStyling: true
    }),


    scratch: new OpenLayers.Layer.Vector('Kladlaag', {
        displayInLayerSwitcher: true, visibility: false
    })
};


/** Collect layers from above, these are actually added to the map.
 * One could also define the layer objects here immediately.
 * */
Heron.options.map.layers = [
    /*
     * ==================================
     *            BaseLayers
     * ==================================
     */

    /*
     * Areal images PDOK.
     */
    new OpenLayers.Layer.TMS(
        "Luchtfoto (PDOK)",
        'http://geodata1.nationaalgeoregister.nl/luchtfoto/tms/',
        {
            layername: 'luchtfoto_EPSG28992',
            type: 'jpeg',
            serverResolutions: Heron.options.serverResolutions.zoom_0_13,
            isBaseLayer: true,
            visibility: true
        }
    ),

    new OpenLayers.Layer.TMS("Map5 Relief Struct TMS",
        Heron.scratch.urls.MAP5_TMS,
        {
            layername: 'relief_struct/EPSG28992',
            type: "jpeg",
            isBaseLayer: true,
            transparent: false,
            bgcolor: "0xffffff",
            visibility: false,
            singleTile: false,
            serverResolutions: Heron.options.serverResolutions.zoom_0_16,
            alpha: true,
            opacity: 1.0,
            attribution: "CC by CA <a href='http://opentopo.nl'>OpenTopo</a> <br/>Data <a href='http://www.openstreetmap.org/copyright'>ODbL</a> <a href='http://openstreetmap.org/'>OpenStreetMap</a> ",
            transitionEffect: 'resize'
        }),

    new OpenLayers.Layer.TMS("OpenBasisKaart OSM",
        Heron.scratch.urls.OPENBASISKAART_TMS,
        {
            layername: 'osm@rd',
            type: "png",
            isBaseLayer: true,
            transparent: true,
            bgcolor: "0xffffff",
            visibility: false,
            singleTile: false,
            serverResolutions: Heron.options.serverResolutions.zoom_0_13,
            alpha: true,
            opacity: 1.0,
            attribution: "(C) <a href='http://openbasiskaart.nl'>OpenBasisKaart</a><br/>Data <a href='http://www.openstreetmap.org/copyright'>ODbL</a> <a href='http://openstreetmap.org/'>OpenStreetMap</a> ",
            transitionEffect: 'resize'
        }),

    new OpenLayers.Layer.TMS("BRT Achtergrondkaart",
        Heron.PDOK.urls.PDOKTMS,
        {
            layername: 'brtachtergrondkaart',
            type: "png",
            isBaseLayer: true,
            transparent: true,
            bgcolor: "0xffffff",
            visibility: false,
            singleTile: false,
            serverResolutions: Heron.options.serverResolutions.zoom_0_13,
            alpha: true,
            opacity: 1.0,
            attribution: "Bron: <a href='https://www.pdok.nl/nl/service/wmts-brt-achtergrondkaart'>BRT Achtergrondkaart</a> en <a href='http://openstreetmap.org/'>OpenStreetMap</a> <a href='http://www.openstreetmap.org/copyright'>ODbL</a>",
            transitionEffect: 'resize'
        }),

    new OpenLayers.Layer.TMS("OpenTopo TMS",
        Heron.scratch.urls.MAP5_TMS,
        {
            layername: 'opentopo/EPSG28992',
            type: "jpeg",
            isBaseLayer: true,
            transparent: false,
            bgcolor: "0xffffff",
            visibility: false,
            singleTile: false,
            serverResolutions: Heron.options.serverResolutions.zoom_0_16,
            alpha: true,
            opacity: 1.0,
            attribution: "CC by CA <a href='http://opentopo.nl'>OpenTopo</a> <br/>Data <a href='http://www.openstreetmap.org/copyright'>ODbL</a> <a href='http://openstreetmap.org/'>OpenStreetMap</a> ",
            transitionEffect: 'resize',
            metadata: {
                legend: {
                    // Use a fixed URL as legend
                    legendURL: 'images/legend/legenda-opentopo-1012.png',
                    hideInLegend: false
                }
            }
        }),

    new OpenLayers.Layer.TMS("OpenSimpleTopo TMS",
        Heron.scratch.urls.MAP5_TMS,
        {
            layername: 'opensimpletopo/EPSG28992',
            type: "jpeg",
            isBaseLayer: true,
            transparent: false,
            bgcolor: "0xffffff",
            visibility: false,
            singleTile: false,
            serverResolutions: Heron.options.serverResolutions.zoom_0_16,
            alpha: true,
            opacity: 1.0,
            attribution: "CC by CA <a href='http://opentopo.nl'>OpenTopo</a> <br/>Data <a href='http://www.openstreetmap.org/copyright'>ODbL</a> <a href='http://openstreetmap.org/'>OpenStreetMap</a> ",
            transitionEffect: 'resize',
            metadata: {
                legend: {
                    // Use a fixed URL as legend
                    legendURL: 'images/legend/legenda-opensimpletopo-760.png',
                    hideInLegend: false
                }
            }
        }),


    new OpenLayers.Layer.TMS("Map5 OpenLufo TMS",
        Heron.scratch.urls.MAP5_TMS,
        {
            layername: 'openlufo/EPSG28992',
            type: "jpeg",
            isBaseLayer: true,
            transparent: false,
            bgcolor: "0xffffff",
            visibility: false,
            singleTile: false,
            serverResolutions: Heron.options.serverResolutions.zoom_0_16,
            alpha: true,
            opacity: 1.0,
            attribution: "CC by CA <a href='http://opentopo.nl'>OpenTopo</a> <br/>Data <a href='http://www.openstreetmap.org/copyright'>ODbL</a> <a href='http://openstreetmap.org/'>OpenStreetMap</a> ",
            transitionEffect: 'resize'
        }),

    new OpenLayers.Layer.TMS("Map5 TopRaster TMS",
        Heron.scratch.urls.MAP5_TMS,
        {
            layername: 'topraster/EPSG28992',
            type: "jpeg",
            isBaseLayer: true,
            transparent: false,
            bgcolor: "0xffffff",
            visibility: false,
            singleTile: false,
            serverResolutions: Heron.options.serverResolutions.zoom_0_16,
            alpha: true,
            opacity: 1.0,
            attribution: "<a href='http://kadaster.nl'>Kadaster</a>, rendered by <a href='http://map5.nl'>Map5.nl</a> ",
            transitionEffect: 'resize',
            metadata: {
                legend: {
                    // Use a fixed URL as legend
                    legendURL: 'images/legend/legenda-t25raster.png',
                    hideInLegend: false
                }
            }
        }),

    /*
     * Combinatie top250/50/25
     * http://kademo.nl/gwc/service/tms/1.0.0/top_raster@nlGridSetPDOK@png
     */
    //new OpenLayers.Layer.TMS(
    //    "TopRaster",
    //    Heron.scratch.urls.KADEMO_GWC_TMS,
    //    {
    //        layername: 'top_raster@nlGridSetPDOK@png',
    //        type: "png",
    //        isBaseLayer: true,
    //        transparent: true,
    //        bgcolor: "0xffffff",
    //        visibility: false,
    //        singleTile: false,
    //        alpha: true, opacity: 1.0,
    //        transitionEffect: 'resize',
    //        metadata: {
    //            legend: {
    //                // Use a fixed URL as legend
    //                legendURL: 'images/legend/legenda-t25raster.png',
    //                hideInLegend: false
    //            }
    //        }
    //    }),


    new OpenLayers.Layer.Image(
        "Blanco",
        Ext.BLANK_IMAGE_URL,
        OpenLayers.Bounds.fromString(Heron.options.map.settings.maxExtent),
        new OpenLayers.Size(10, 10),
        {
            resolutions: Heron.options.map.settings.resolutions,
            isBaseLayer: true,
            visibility: false,
            displayInLayerSwitcher: true,
            transitionEffect: 'resize'
        }
    ),

/** OVERLAYS **/

    /* START KNMI */
    // http://geoservices.knmi.nl/cgi-bin/RADNL_OPER_R___25PCPRR_L3.cgi?SERVICE=WMS&&SERVICE=WMS&VERSION=1.3.0&REQUEST=GetMap
    // &LAYERS=RADNL_OPER_R___25PCPRR_L3_COLOR&WIDTH=550&HEIGHT=512&CRS=EPSG%3A3857&
    // BBOX=-10713.691389678395,6332649.790725125,1219245.7073756782,7477630.176484875&STYLES=default&
    // FORMAT=image/png&TRANSPARENT=TRUE&&time=2014-05-15T11%3A30%3A00Z
    //https://data.knmi.nl/wms-preview/viewer/?service=https%3A%2F%2Fdata.knmi.nl%2Fwms%2Fcgi-bin%2Fwms.cgi%3Fsource%3D%2FActuele10mindataKNMIstations%252F1%252Fnoversion%252F2014%252F11%252F04%252FKMDS__OPER_P___10M_OBS_L2.nc&zoomtolayer=1&layer=ta
    // WMS: https://data.knmi.nl/wms/cgi-bin/wms.cgi?%26source%3D%2FActuele10mindataKNMIstations%2F1%2Fnoversion%2F2014%2F11%2F04%2FKMDS__OPER_P___10M_OBS_L2%2Enc%26&service=WMS&request=GetCapabilities

    /*
     * KNMI: Actual Temperatures
     */
    new OpenLayers.Layer.WMS(
        "KNMI - Current Temperatures",
        Heron.scratch.urls.KNMI_ACT_10MIN,
        {layers: "ta", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize'
        }
    ),

    /*
     * KNMI: Actual Wind forces
     */
    new OpenLayers.Layer.WMS(
        "KNMI - Current Wind Forces",
        Heron.scratch.urls.KNMI_ACT_10MIN,
        {layers: "ff", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize'
        }
    ),

    /*
     * KNMI: Actual Wind Directions
     */
    new OpenLayers.Layer.WMS(
        "KNMI - Current Wind Directions",
        Heron.scratch.urls.KNMI_ACT_10MIN,
        {layers: "dd", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize'
        }
    ),

    /*
     * KNMI: Actual Air Pressures
     */
    new OpenLayers.Layer.WMS(
        "KNMI - Current Air Pressures",
        Heron.scratch.urls.KNMI_ACT_10MIN,
        {layers: "pp", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize'
        }
    ),

    /*
     * KNMI: Rain Radar
     */
    new OpenLayers.Layer.WMS(
        "KNMI - Rain Radar (Color)",
        "http://geoservices.knmi.nl/cgi-bin/RADNL_OPER_R___25PCPRR_L3.cgi?",
        {layers: "RADNL_OPER_R___25PCPRR_L3_COLOR", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize'
        }
    ),

    // More KNMI at: http://geoservices.knmi.nl/WMSexamplesinADAGUC.html
    // http://geoservices.knmi.nl/cgi-bin/INTER_OPER_R___OBSERV__L3.cgi?

    /*
     * RIVM: All Stations
     */
    new OpenLayers.Layer.WMS(
        "RIVM - All Stations",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "all_stations", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Stations
     */
    new OpenLayers.Layer.WMS(
        "RIVM - Active Stations",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "active_stations", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Active Stations WFS
     */
    new OpenLayers.Layer.Vector("RIVM - Active Stations (WFS)", {
        strategies: [new OpenLayers.Strategy.BBOX()],
        visibility: false,
        style: {
            fillColor: '#37f',
            fillOpacity: 0.8,
            graphicName: "triangle",
            strokeColor: '#03c',
            strokeWidth: 2,
            graphicZIndex: 1,
            pointRadius: 4
        },
        protocol: new OpenLayers.Protocol.WFS({
            version: '1.1.0',
            outputFormat: 'GML2',
            srsName: 'EPSG:28992',
            url: Heron.scratch.urls.SOSPILOT_OWS,
            featureType: "active_stations",
            featureNS: "http://sensors.geonovum.nl",
            geometryName: 'point'
        })
    }),

    /*
     * RIVM: Zones en Agglomeraties
     */
    new OpenLayers.Layer.WMS(
        "Zones and Agglomerations",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "zones", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true, opacity: 0.35,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Measurements CO
     */
    new OpenLayers.Layer.WMS(
        "RIVM - History CO",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "measurements_co", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Current CO
     */
    new OpenLayers.Layer.WMS(
        "RIVM - Current CO",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_co", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Measurements NH3
     */
    new OpenLayers.Layer.WMS(
        "RIVM - History NH3",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "measurements_nh3", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Current NH3
     */
    new OpenLayers.Layer.WMS(
        "RIVM - Current NH3",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_nh3", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Measurements NO
     */
    new OpenLayers.Layer.WMS(
        "RIVM - History NO",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "measurements_no", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Measurements NO
     */
    new OpenLayers.Layer.WMS(
        "RIVM - Current NO",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_no", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Measurements NO2
     */
    new OpenLayers.Layer.WMS(
        "RIVM - History NO2",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "measurements_no2", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Current NO2
     */
    new OpenLayers.Layer.WMS(
        "RIVM - Current NO2",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_no2", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Measurements O3
     */
    new OpenLayers.Layer.WMS(
        "RIVM - Current O3",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_o3", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Measurements O3
     */
    new OpenLayers.Layer.WMS(
        "RIVM - History O3",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "measurements_o3", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Measurements PM10
     */
    new OpenLayers.Layer.WMS(
        "RIVM - History PM10",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "measurements_pm10", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Measurements PM10
     */
    new OpenLayers.Layer.WMS(
        "RIVM - Current PM10",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_pm10", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Measurements SO2
     */
    new OpenLayers.Layer.WMS(
        "RIVM - History SO2",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "measurements_so2", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: Current SO2
     */
    new OpenLayers.Layer.WMS(
        "RIVM - Current SO2",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_so2", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /* END RIVM */

    /* START SMARTEM  */

    /*
     * SMARTEM: All Stations
     */
    new OpenLayers.Layer.WMS(
        "Smart Emission - Stations",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "stations_smartem", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: true, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * Smart Emission: Measurements CO
     */
    new OpenLayers.Layer.WMS(
        "Smart Emission - History CO",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "measurements_co_smartem", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * Smart Emission: Current CO
     */
    new OpenLayers.Layer.WMS(
        "Smart Emission - Current CO",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_co_smartem", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * Smart Emission: Current CO2
     */
    new OpenLayers.Layer.WMS(
        "Smart Emission - Current CO2",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_co2_smartem", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * Smart Emission: Measurements NO2
     */
    new OpenLayers.Layer.WMS(
        "Smart Emission - History NO2",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "measurements_no2_smartem", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * Smart Emission: Current NO2
     */
    new OpenLayers.Layer.WMS(
        "Smart Emission - Current NO2",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_no2_smartem", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * Smart Emission: Measurements O3
     */
    new OpenLayers.Layer.WMS(
        "Smart Emission - History O3",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "measurements_o3_smartem", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * Smart Emission: Current O3
     */
    new OpenLayers.Layer.WMS(
        "Smart Emission - Current O3",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_o3_smartem", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * Smart Emission: Meteo: Current Temperature
     */
    new OpenLayers.Layer.WMS(
        "Smart Emission - Current Temperature",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_temperature_smartem", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * Smart Emission: Meteo: Current Barometer
     */
    new OpenLayers.Layer.WMS(
        "Smart Emission - Current Barometer",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_barometer_smartem", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * Smart Emission: Meteo: Current Humidity
     */
    new OpenLayers.Layer.WMS(
        "Smart Emission - Current Humidity",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_humidity_smartem", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * Smart Emission: Meteo: Current Audio/Noise Level
     */
    new OpenLayers.Layer.WMS(
        "Smart Emission - Current Audio Level",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "last_measurements_au_level_smartem", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: true, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /* END SMARTEM  */
    /* START APS2RASTER */


    /*
     * RIVM: APS2RASTER TEST NO2
     */
    new OpenLayers.Layer.WMS(
        "TEST - RIO APS NO2",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "rio_no2_2015091611", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * RIVM: APS2RASTER TEST O3
     */
    new OpenLayers.Layer.WMS(
        "TEST - RIO APS O3",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "rio_o3_2015091611", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

        /*
     * RIVM: APS2RASTER TEST PM10
     */
    new OpenLayers.Layer.WMS(
        "TEST - RIO APS PM10",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "rio_pm10_2015091611", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

      /* END APS2RASTER */


    /* START GEONOVUM WEATHER */

    /*
     * GEONOVUM: Weather Stations
     */
    new OpenLayers.Layer.WMS(
        "Weather Stations",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "weather_stations", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * GEONOVUM: Observations Weather
     */
    new OpenLayers.Layer.WMS(
        "Weather Observations",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "weather_observations", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /*
     * GEONOVUM: Last Observations Weather
     */
    new OpenLayers.Layer.WMS(
        "Last Weather Observations",
        Heron.scratch.urls.SOSPILOT_OWS,
        {layers: "weather_last_observations", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    outputFormat: 'GML2',
                    featurePrefix: 'sensors',
                    featureNS: 'http://sensors.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),

    /* END GEONOVUM WEATHER */

    /*
     * PDOK: BAG Adressen
     */
    new OpenLayers.Layer.WMS(
        "BAG - Adressen",
        Heron.PDOK.urls.ADRESSEN,
        {layers: "inspireadressen", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    featurePrefix: 'inspireadressen',
                    featureNS: 'http://inspireadressen.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats,
                    maxQueryArea: 1000000,
                    maxQueryLength: 10000
                }
            }
        }
    ),

    /*
     * PDOK: BagViewer Lagen
     */
    new OpenLayers.Layer.WMS(
        "BAG - Panden",
        Heron.PDOK.urls.BAGVIEWER,
        {layers: "pand", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    featurePrefix: 'pand',
                    featureNS: 'http://bagviewer.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats,
                    maxQueryArea: 1000000,
                    maxQueryLength: 10000
                }
            }
        }
    ),
    new OpenLayers.Layer.Vector("BAG - Panden (WFS)", {
        maxResolution: 0.84,
        strategies: [new OpenLayers.Strategy.BBOX()],
        visibility: false,
        styleMap: new OpenLayers.StyleMap(
            {'strokeColor': '#222222', 'fillColor': '#eeeeee', graphicZIndex: 1, fillOpacity: 0.8}),
        protocol: new OpenLayers.Protocol.WFS({
            url: Heron.PDOK.urls.BAGVIEWER,
            featureType: "pand",
            featureNS: "http://bagviewer.geonovum.nl",
            geometryName: 'geometrie'
        })
    }),

    /*
     * PDOK: BagViewer Lagen
     */
    new OpenLayers.Layer.WMS(
        "BAG - Verblijfsobjecten",
        Heron.PDOK.urls.BAGVIEWER,
        {layers: "verblijfsobject", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    featurePrefix: 'verblijfsobject',
                    featureNS: 'http://bagviewer.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats,
                    maxQueryArea: 1000000,
                    maxQueryLength: 10000
                }
            }
        }
    ),

    /*
     * PDOK: BagViewer Lagen
     */
    new OpenLayers.Layer.WMS(
        "BAG - Ligplaatsen",
        Heron.PDOK.urls.BAGVIEWER,
        {layers: "ligplaats", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    featurePrefix: 'ligplaats',
                    featureNS: 'http://bagviewer.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats,
                    maxQueryArea: 1000000000,
                    maxQueryLength: 10000
                }
            }
        }
    ),

    /*
     * PDOK: BagViewer Lagen
     */
    new OpenLayers.Layer.WMS(
        "BAG - Standplaatsen",
        Heron.PDOK.urls.BAGVIEWER,
        {layers: "standplaats", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    featurePrefix: 'standplaats',
                    featureNS: 'http://bagviewer.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats,
                    maxQueryArea: 1000000000,
                    maxQueryLength: 10000
                }
            }
        }
    ),

    /*
     * PDOK: BagViewer Lagen
     */
    new OpenLayers.Layer.WMS(
        "BAG - Woonplaatsen",
        Heron.PDOK.urls.BAGVIEWER,
        {layers: "woonplaats", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    featurePrefix: 'woonplaats',
                    featureNS: 'http://bagviewer.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats,
                    maxQueryArea: 1000000000,
                    maxQueryLength: 10000
                }
            }
        }
    ),

    /*
     * PDOK: Bestuurlijke Grenzen  WMS
     */
    new OpenLayers.Layer.WMS(
        "Bestuurlijke Grenzen - Gemeenten",
        Heron.PDOK.urls.BESTUURLIJKEGRENZEN,
        {layers: "gemeenten", format: "image/png8", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),
    new OpenLayers.Layer.WMS(
        "Bestuurlijke Grenzen - Provincies",
        Heron.PDOK.urls.BESTUURLIJKEGRENZEN,
        {layers: "provincies", format: "image/png8", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),
    new OpenLayers.Layer.WMS(
        "Bestuurlijke Grenzen - Land",
        Heron.PDOK.urls.BESTUURLIJKEGRENZEN,
        {layers: "landsgrens", format: "image/png8", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),

    /*
     * PDOK: Bestuurlijke Grenzen  WFS
     */
    new OpenLayers.Layer.Vector("Bestuurlijke Grenzen - Gemeenten (WFS)", {
        strategies: [new OpenLayers.Strategy.BBOX()],
        visibility: false,
        styleMap: new OpenLayers.StyleMap(
            {'strokeColor': '#222222', 'fillColor': '#eeeeee', graphicZIndex: 1, fillOpacity: 0.6}),
        protocol: new OpenLayers.Protocol.WFS({
            version: '1.1.0',
            outputFormat: 'GML2',
            srsName: 'EPSG:28992',
            url: Heron.PDOK.urls.BESTUURLIJKEGRENZEN,
            featureType: "gemeenten",
            featureNS: "http://bestuurlijkegrenzen.geonovum.nl",
            geometryName: 'geom'
        })
    }),

    new OpenLayers.Layer.Vector("Bestuurlijke Grenzen - Provincies (WFS)", {
        strategies: [new OpenLayers.Strategy.BBOX()],
        visibility: false,
        styleMap: new OpenLayers.StyleMap(
            {'strokeColor': '#CC66FF', 'fillColor': '#CC66FF', graphicZIndex: 1, fillOpacity: 0.6}),
        protocol: new OpenLayers.Protocol.WFS({
            version: '1.1.0',
            outputFormat: 'GML2',
            srsName: 'EPSG:28992',
            url: Heron.PDOK.urls.BESTUURLIJKEGRENZEN,
            featureType: "provincies",
            featureNS: "http://bestuurlijkegrenzen.geonovum.nl",
            geometryName: 'geom'
        })
    }),

    new OpenLayers.Layer.Vector("Bestuurlijke Grenzen - Land (WFS)", {
        strategies: [new OpenLayers.Strategy.BBOX()],
        visibility: false,
        styleMap: new OpenLayers.StyleMap(
            {'strokeColor': '#FF9900', 'fillColor': '#FF9900', graphicZIndex: 1, fillOpacity: 0.6}),
        protocol: new OpenLayers.Protocol.WFS({
            version: '1.1.0',
            outputFormat: 'GML2',
            srsName: 'EPSG:28992',
            url: Heron.PDOK.urls.BESTUURLIJKEGRENZEN,
            featureType: "landsgrens",
            featureNS: "http://bestuurlijkegrenzen.geonovum.nl",
            geometryName: 'geom'
        })
    }),


    /*
     * PDOK: NWB Wegen
     */
    new OpenLayers.Layer.WMS(
        "NWB - Wegen",
        Heron.PDOK.urls.NWBWEGEN,
        {layers: "wegvakken", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    featurePrefix: 'nwbwegen',
                    featureNS: 'http://nwbwegen.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats,
                    maxQueryArea: 10000000,
                    maxQueryLength: 10000
                }
            }
        }
    ),
/**
 * PDOK: Digitaal Topografisch Bestand
 */
    new OpenLayers.Layer.WMS(
        "DTB Vlakken",
        Heron.PDOK.urls.DTB,
        {layers: 'vlakken', format: "image/png", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),

    new OpenLayers.Layer.WMS(
        "DTB Lijnen",
        Heron.PDOK.urls.DTB,
        {layers: 'lijnen', format: "image/png", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),

    new OpenLayers.Layer.WMS(
        "DTB Punten",
        Heron.PDOK.urls.DTB,
        {layers: 'punten', format: "image/png", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),

    new OpenLayers.Layer.WMS(
        "AHN 25m",
        Heron.PDOK.urls.AHN1,
        {layers: 'ahn25m', format: "image/png", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),

/** AHN2 - 5 lagen  - sinds 5 maart 2014 */
    new OpenLayers.Layer.WMS(
        "AHN2 0.5m Ruw",
        Heron.PDOK.urls.AHN2,
        {layers: 'ahn2_05m_ruw', format: "image/png", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true, maxResolution: 108}
    ),

    new OpenLayers.Layer.WMS(
        "AHN2 0.5m Geinterpoleerd",
        Heron.PDOK.urls.AHN2,
        {layers: 'ahn2_05m_int', format: "image/png", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true, maxResolution: 108}
    ),

    new OpenLayers.Layer.WMS(
        "AHN2 0.5m Niet Geinterpoleerd",
        Heron.PDOK.urls.AHN2,
        {layers: 'ahn2_05m_non', format: "image/png", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true, maxResolution: 108}
    ),

    new OpenLayers.Layer.WMS(
        "AHN2 5m",
        Heron.PDOK.urls.AHN2,
        {layers: 'ahn2_5m', format: "image/png", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),

    new OpenLayers.Layer.WMS(
        "AHN2 Bladindex",
        Heron.PDOK.urls.AHN2,
        {layers: 'ahn2_bladindex', format: "image/png", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),


    /*
     * PDOK: Lange Afstands Wandelpaden
     */
    new OpenLayers.Layer.WMS(
        "Lange Afstands Wandelroutes",
        Heron.PDOK.urls.LAWROUTES,
        {layers: "lawroutes", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize'
        }
    ),

    /*
     * PDOK: Streekpaden
     */
    new OpenLayers.Layer.WMS(
        "Streekpaden",
        Heron.PDOK.urls.STREEKPADEN,
        {layers: "streekpaden", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize'
        }
    ),

    /*
     * PDOK: Landelijke Fietsroutes
     */
    new OpenLayers.Layer.WMS(
        "Landelijke Fietsroutes",
        Heron.PDOK.urls.LFROUTES,
        {layers: "lfroutes", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize'
        }
    ),

    /*
     * PDOK: RD Info Punten
     */
    new OpenLayers.Layer.WMS(
        "RD Info - Punten",
        Heron.PDOK.urls.RDINFO,
        {layers: "punten", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    featurePrefix: 'punten',
                    featureNS: 'http://rdinfo.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats,
                    maxQueryArea: 750000000,
                    maxQueryLength: 500000
                }
            }
        }
    ),

    /*
     * PDOK: RD Info Stations
     */
    new OpenLayers.Layer.WMS(
        "RD Info - Stations",
        Heron.PDOK.urls.RDINFO,
        {layers: "stations", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    featurePrefix: 'stations',
                    featureNS: 'http://rdinfo.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats,
                    maxQueryArea: 750000000,
                    maxQueryLength: 500000
                }
            }
        }
    ),

    /*
     * PDOK: RD Info Stations
     */
    new OpenLayers.Layer.WMS(
        "Natura 2000",
        Heron.PDOK.urls.NATURA2000,
        {layers: "natura2000", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    featurePrefix: 'natura2000',
                    featureNS: 'http://natura2000.geonovum.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats
                }
            }
        }
    ),


/** Natura 2000 (PDOK) */
    new OpenLayers.Layer.TMS("Natura 2000 (TMS)",
        Heron.PDOK.urls.PDOKTMS,
        {
            layername: 'natura2000',
            type: 'png',
            isBaseLayer: false,
            transparent: true,
            bgcolor: "0xffffff",
            visibility: false,
            singleTile: false,
            transitionEffect: 'resize'
        }),


    new OpenLayers.Layer.WMS(
        "Nationale Parken",
        Heron.PDOK.urls.NATIONALEPARKEN,
        {layers: 'nationaleparken', format: "image/png8", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),

    new OpenLayers.Layer.WMS(
        "NOK 2010 - EHS",
        Heron.PDOK.urls.NOK,
        {layers: 'ehs', format: "image/png8", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),

    new OpenLayers.Layer.WMS(
        "NOK 2010 - RODS",
        Heron.PDOK.urls.NOK,
        {layers: 'rods', format: "image/png8", transparent: true, info_format: 'application/vnd.ogc.gml'},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),
    new OpenLayers.Layer.WMS(
        "NOK 2010 - BBLBuitenbegrenzing",
        Heron.PDOK.urls.NOK,
        {
            layers: 'bblbuitenbegrenzing',
            format: "image/png8",
            transparent: true,
            info_format: 'application/vnd.ogc.gml'
        },
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true}
    ),
    /*
     * EINDE PDOK
     */
    /* ------------------------------
     * LKI Kadastrale Vlakken
     * ------------------------------ */
    new OpenLayers.Layer.WMS("Kadastrale Vlakken",
        Heron.scratch.urls.KADEMO_OWS,
        {layers: "lki_vlakken", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize', maxResolution: 6.72,
            metadata: {
                wfs: {
                    protocol: 'fromWMSLayer',
                    featurePrefix: 'kad',
                    featureNS: 'http://innovatie.kadaster.nl',
                    downloadFormats: Heron.options.wfs.downloadFormats,
                    maxQueryArea: 1000000,
                    maxQueryLength: 10000
                }
            }
        }
    ),

    /* ------------------------------
     * LKI Kadastrale Vlakken
     * ------------------------------ */
//    new OpenLayers.Layer.WMS("Kadastrale Vlakken (Subset)",
//            Heron.scratch.urls.KADEMO_OWS,
//            {layers: "lki_vlakken_small", format: "image/png", transparent: true},
//            {isBaseLayer: false, singleTile: true, visibility: false, alpha: true, featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize',
//                metadata: {
//                    wfs: {
//                        protocol: 'fromWMSLayer',
//                        featurePrefix: 'kad',
//                        featureNS: 'http://innovatie.kadaster.nl',
//                        downloadFormats: Heron.options.wfs.downloadFormats,
//                        maxQueryArea: 1000000,
//                        maxQueryLength: 5000
//                    }
//                }
//            }
//    ),

    /*
     * Cadastral Parcels The Netherlands - 2009.
     */
    new OpenLayers.Layer.TMS(
        "Kadastrale Vlakken (tiled)",
        Heron.scratch.urls.KADEMO_GWC_TMS,
        {
            layername: 'kadkaart_vlakken@nlGridSetPDOK@png',
            type: "png",
            isBaseLayer: false,
            transparent: true,
            visibility: false,
            maxResolution: 6.72,
            metadata: {
                legend: {
                    // Use a fixed URL as legend
                    legendURL: 'images/legend/lki_vlakken.png',
                    hideInLegend: false
                }
            }
        }
    ),

    new OpenLayers.Layer.WMS("Kadastrale Bebouwingen",
        Heron.scratch.urls.KADEMO_OWS,
        {layers: "lki_gebouwen", format: "image/png", transparent: true},
        {
            isBaseLayer: false, singleTile: true, visibility: false, alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml", transitionEffect: 'resize'
        }
    ),


    /*
     * Buildings - The Netherlands - 2009.
     */
    new OpenLayers.Layer.TMS(
        "Kadastrale Gebouwen (tiled)",
        Heron.scratch.urls.KADEMO_GWC_TMS,
        {
            layername: 'kadkaart_gebouwen@nlGridSetPDOK@png',
            type: "png",
            isBaseLayer: false,
            transparent: true,
            visibility: false,
            maxResolution: 6.72,
            metadata: {
                legend: {
                    // Use a fixed URL as legend
                    legendURL: 'images/legend/lki_gebouwen.png',
                    hideInLegend: false
                }
            }
        }
    ),

    new OpenLayers.Layer.WMS("Kadastrale Teksten",
        Heron.scratch.urls.KADEMO_OWS,
        {layers: "lki_teksten", format: "image/png", transparent: true},
        {
            isBaseLayer: false,
            singleTile: true,
            visibility: false,
            alpha: true,
            featureInfoFormat: "application/vnd.ogc.gml",
            hideInLegend: true,
            transitionEffect: 'resize'
        }
    ),

    new OpenLayers.Layer.WMS("Kadastrale Perceelnummers",
        Heron.scratch.urls.KADEMO_OWS,
        {layers: "lki_vlakken", format: "image/png", styles: "lki_perceelnrs", transparent: true},
        {
            isBaseLayer: false,
            singleTile: true,
            visibility: false,
            featureInfoFormat: "application/vnd.ogc.gml",
            transitionEffect: 'resize'
        }
    ),

    /*
     * Cadastral Parcel numbers - The Netherlands - 2009.
     */
    new OpenLayers.Layer.TMS(
        "Perceel Nummers (tiled)",
        Heron.scratch.urls.KADEMO_GWC_TMS,
        {
            layername: 'kadkaart_perceelnrs@nlGridSetPDOK@png',
            type: "png",
            isBaseLayer: false,
            transparent: true,
            visibility: false
        }
    ),

    new OpenLayers.Layer.WMS("Kadastrale Kaart Alles",
        Heron.scratch.urls.KADEMO_OWS,
        {layers: "kadkaart", format: "image/png", transparent: true},
        {isBaseLayer: false, singleTile: true, visibility: false, alpha: true, opacity: 0.7, transitionEffect: 'resize'}
    ),

    new OpenLayers.Layer.TMS(
        "Kadastrale Kaart Alles (tiled)",
        Heron.scratch.urls.KADEMO_GWC_TMS,
        {
            layername: 'kadkaart_alles@nlGridSetPDOK@png',
            type: "png",
            isBaseLayer: false,
            transparent: true,
            bgcolor: "0xffffff",
            visibility: false,
            singleTile: false,
            alpha: true, opacity: 0.7,
            maxResolution: 6.72,
            transitionEffect: 'resize',
            metadata: {
                legend: {
                    // Use a fixed URL as legend
                    legendURL: 'images/legend/lki_vlakken_gebouwen.png',
                    hideInLegend: false
                }
            }
        }
    ),

/** RO-Online
 *
 */

    /* ------------------------------
     * RO Online info
     * zie ook http://afnemers.ruimtelijkeplannen.nl/afnemers/wms.jsp
     * ------------------------------ */
    new OpenLayers.Layer.WMS(
        "RO Online Bestemmingsplannen",
        Heron.scratch.urls.RO_WMS,
        {
            layers: "BP:Bestemmingsplangebied,BP:Rijksbestemmingsplangebied,BP:Uitwerkingsplangebied,BP:Wijzigingsplangebied,BP:Inpassingsplangebied,BP:Gebiedsaanduiding,BP:Figuur,BP:Dubbelbestemming,BP:Functieaanduiding,BP:Bouwaanduiding,BP:Lettertekenaanduiding,BP:Maatvoering,BP:Bouwvlak,BP:Enkelbestemming",
            format: "image/png",
            transparent: true
        },
        {
            isBaseLayer: false,
            singleTile: true,
            visibility: false,
            featureInfoFormat: "application/vnd.ogc.gml",
            alpha: true,
            opacity: 0.7
        }
    ),
// BP:Bestemmingsplangebied,BP:Rijksbestemmingsplangebied,BP:Uitwerkingsplangebied,BP:Wijzigingsplangebied,BP:Inpassingsplangebied,BP:Gebiedsaanduiding,BP:Figuur,BP:Dubbelbestemming,BP:Functieaanduiding,BP:Bouwaanduiding,BP:Lettertekenaanduiding,BP:Maatvoering,BP:Bouwvlak,BP:Enkelbestemming

    new OpenLayers.Layer.WMS(
        "RO Online Gem. Structuurvisie",
        Heron.scratch.urls.RO_WMS,
        {
            layers: "GSV:Structuurvisieplangebied,GSV:Structuurvisiecomplex,GSV:Structuurvisiegebied",
            format: "image/png",
            transparent: true
        },
        {
            isBaseLayer: false,
            singleTile: true,
            visibility: false,
            featureInfoFormat: "application/vnd.ogc.gml",
            alpha: true,
            opacity: 0.7
        }
    ),

    new OpenLayers.Layer.WMS(
        "RO Online Prov. Structuurvisie",
        Heron.scratch.urls.RO_WMS,
        {
            layers: "PSV:Structuurvisieplangebied,PSV:Structuurvisiecomplex,PSV:Structuurvisieverklaring,PSV:Structuurvisiegebied",
            format: "image/png",
            transparent: true
        },
        {
            isBaseLayer: false,
            singleTile: true,
            visibility: false,
            featureInfoFormat: "application/vnd.ogc.gml",
            alpha: true,
            opacity: 0.7
        }
    ),
    /** NGSI10 Entity Layer from Fiware Orion Context Broker. */
    new OpenLayers.Layer.Vector('Fiware Entities', {
        strategies: [new OpenLayers.Strategy.Fixed()],
        visibility: false,
        protocol: new OpenLayers.Protocol.NGSI10({
            url: 'http://sensors.geonovum.nl:1026/v1/queryContext',
            // url: 'http://orion.lab.fi-ware.org:1026/ngsi10/queryContext',
            // data: {"entities": [{"isPattern": "true", "id": "b"}]},
            // authToken: '<personal fiware auth token string>',
            refreshMillis: 4000,
            fiwareService: 'fiwareiot'
        }),
        styleMap: new OpenLayers.StyleMap({
            "default": new OpenLayers.Style(null, {

                rules: [new OpenLayers.Rule({
                    title: 'Entity',
                    symbolizer: {
                        "Point": {
                            fillColor: '#37f',
                            fillOpacity: 0.8,
                            graphicName: "circle",
                            strokeColor: '#03c',
                            strokeWidth: 2,
                            graphicZIndex: 1,
                            pointRadius: 5,
                            label: "${label} ${temperature}C",
                            fontColor: "#cc0000",
                            fontSize: "12px",
                            fontFamily: "Courier New, monospace",
                            fontWeight: "bold",
                            //labelAlign: "cm",
                            labelXOffset: "12",
                            labelYOffset: "12",
                            // labelOutlineColor: "white",
                            labelOutlineWidth: 2

                        }
                    }
                })]
            })
        }),

        projection: new OpenLayers.Projection("EPSG:4326")
    }),

    Heron.options.worklayers.editor,
    Heron.options.worklayers.scratch
];

/*
 * Define the Layer tree (shown in left menu)
 * Use the exact Open Layers Layer names to identify layers ("layer" attrs) from Heron.options.map.settings.layers above.
 * The text with each node is determined by the WMS Layer name, but may be overruled with a "text" attribute.
 *
 **/
Ext.namespace("Heron.options.layertree");
Heron.options.layertree.tree = [
    {
        // JvdB: Container for layers added via "Add layers", initially hidden until Layers added
        text: 'Toegevoegde Lagen', nodeType: 'hr_userlayercontainer', expanded: true, children: []
    },
    {
        text: 'Basis Kaarten', expanded: false, children: [
        {nodeType: "gx_layer", layer: "BRT Achtergrondkaart", text: "BRT (PDOK)"},
        {nodeType: "gx_layer", layer: "OpenBasisKaart OSM"},
        {nodeType: "gx_layer", layer: "OpenTopo TMS", text: "OpenTopo (Map5.nl)"},
        {nodeType: "gx_layer", layer: "OpenSimpleTopo TMS", text: "OpenSimpleTopo (Map5.nl)"},
        {nodeType: "gx_layer", layer: "Map5 OpenLufo TMS", text: "OpenLufo (Map5.nl)"},
        {nodeType: "gx_layer", layer: "Map5 Relief Struct TMS", text: "AHN2 Reliëf (Map5.nl)"},
        {nodeType: "gx_layer", layer: "Map5 TopRaster TMS", text: "TopRaster (Map5.nl)"},
        {nodeType: "gx_layer", layer: "Luchtfoto (PDOK)"},
        {nodeType: "gx_layer", layer: "Blanco"}
    ]
    },

    {
        text: 'Sensoren', expanded: true, children: [
        {nodeType: "gx_layer", layer: "RIVM - All Stations", text: "RIVM AQ Stations (WMS)"},
        {nodeType: "gx_layer", layer: "RIVM - Active Stations", text: "RIVM AQ LML Stations"},
        {nodeType: "gx_layer", layer: "RIVM - Active Stations (WFS)", text: "RIVM AQ Stations (WFS)"},
        {nodeType: "gx_layer", layer: "Zones and Agglomerations", text: "RIVM Zones and Agglomerations (WMS)"},
        {nodeType: "gx_layer", layer: "Smart Emission - Stations", text: "Smart Emission - Stations (WMS)"}
    ]
    },
    {
        text: 'Chemische Componenten (Current)', expanded: true, children: [
        {
            text: 'Carbon monoxide (CO, ug/m3)', expanded: true, children: [
            {nodeType: "gx_layer", layer: "RIVM - Current CO"},
            {nodeType: "gx_layer", layer: "Smart Emission - Current CO"}

        ]
        },
        {
            text: 'Carbon dioxide (CO2, ppm)', expanded: true, children: [
            {nodeType: "gx_layer", layer: "Smart Emission - Current CO2"}
        ]
        },
        {
            text: 'Ammonia (NH3, ug/m3) - WMS', expanded: false, children: [
            {nodeType: "gx_layer", layer: "RIVM - Current NH3"}
        ]
        },
        {
            text: 'Nitrogen Oxide (NO, ug/m3) - WMS', expanded: false, children: [
            {nodeType: "gx_layer", layer: "RIVM - Current NO"}
        ]
        },
        {
            text: 'Nitrogen Dioxide (NO2, ug/m3) - WMS', expanded: true, children: [
            {nodeType: "gx_layer", layer: "RIVM - Current NO2"},
            {nodeType: "gx_layer", layer: "Smart Emission - Current NO2"}
        ]
        },
        {
            text: 'Ozone (O3, ug/m3) - WMS', expanded: true, children: [
            {nodeType: "gx_layer", layer: "RIVM - Current O3"},
            {nodeType: "gx_layer", layer: "Smart Emission - Current O3"}
        ]
        },
        {
            text: 'Particulate Matter (PM10, ug/m3) - WMS', expanded: false, children: [
            {nodeType: "gx_layer", layer: "RIVM - Current PM10"}

        ]
        },
        {
            text: 'Sulfur Dioxide (SO2, ug/m3) - WMS', expanded: false, children: [
            {nodeType: "gx_layer", layer: "RIVM - Current SO2"}

        ]
        }
    ]
    },
    {
        text: 'Chemische Componenten (Historie)', expanded: false, children: [
        {
            text: 'Carbon monoxide (CO)', expanded: false, children: [
            {nodeType: "gx_layer", layer: "RIVM - History CO"}
            //,
            //{nodeType: "gx_layer", layer: "Smart Emission - History CO"}
        ]
        },
        {
            text: 'Ammonia (NH3) - WMS', expanded: false, children: [
            {nodeType: "gx_layer", layer: "RIVM - History NH3"}
        ]
        },
        {
            text: 'Nitrogen Oxide (NO) - WMS', expanded: false, children: [
            {nodeType: "gx_layer", layer: "RIVM - History NO"}
        ]
        },
        {
            text: 'Nitrogen Dioxide (NO2) - WMS', expanded: true, children: [
            {nodeType: "gx_layer", layer: "RIVM - History NO2"},
            //{nodeType: "gx_layer", layer: "Smart Emission - History NO2"},
            {nodeType: "gx_layer", layer: "TEST - RIO APS NO2"}
        ]
        },
        {
            text: 'Ozone (O3) - WMS', expanded: true, children: [
            {nodeType: "gx_layer", layer: "RIVM - History O3"},
            //{nodeType: "gx_layer", layer: "Smart Emission - History O3"},
            {nodeType: "gx_layer", layer: "TEST - RIO APS O3"}
        ]
        },
        {
            text: 'Particulate Matter (PM10) - WMS', expanded: true, children: [
            {nodeType: "gx_layer", layer: "RIVM - History PM10"},
            {nodeType: "gx_layer", layer: "TEST - RIO APS PM10"}

        ]
        },
        {
            text: 'Sulfur Dioxide (SO2) - WMS', expanded: false, children: [
            {nodeType: "gx_layer", layer: "RIVM - History SO2"}

        ]
        }
    ]
    },

    //{
    //    text: 'RIVM LML', expanded: false, children: [
    //    {
    //        text: 'Carbon monoxide (CO) - WMS', expanded: false, children: [
    //        {nodeType: "gx_layer", layer: "RIVM - Current CO", text: "Current CO"},
    //        {nodeType: "gx_layer", layer: "RIVM - History CO", text: "Time Series Measurements CO"}
    //    ]
    //    },
    //    {
    //        text: 'Ammonia (NH3) - WMS', expanded: false, children: [
    //        {nodeType: "gx_layer", layer: "RIVM - Current NH3", text: "Current NH3"},
    //        {nodeType: "gx_layer", layer: "RIVM - History NH3", text: "Time Series Measurements NH3"}
    //    ]
    //    },
    //    {
    //        text: 'Nitrogen Oxide (NO) - WMS', expanded: false, children: [
    //        {nodeType: "gx_layer", layer: "RIVM - Current NO", text: "Current NO"},
    //        {nodeType: "gx_layer", layer: "RIVM - History NO", text: "Time Series Measurements NO"}
    //    ]
    //    },
    //    {
    //        text: 'Nitrogen Dioxide (NO2) - WMS', expanded: true, children: [
    //        {nodeType: "gx_layer", layer: "RIVM - Current NO2", text: "Current NO2"},
    //        {nodeType: "gx_layer", layer: "RIVM - History NO2", text: "Time Series Measurements NO2"}
    //    ]
    //    },
    //    {
    //        text: 'Ozone (O3) - WMS', expanded: true, children: [
    //        {nodeType: "gx_layer", layer: "RIVM - Current O3", text: "Current O3"},
    //        {nodeType: "gx_layer", layer: "RIVM - History O3", text: "Time Series Measurements O3"}
    //    ]
    //    },
    //    {
    //        text: 'Particulate Matter (PM10) - WMS', expanded: true, children: [
    //        {nodeType: "gx_layer", layer: "RIVM - Current PM10", text: "Current PM10"},
    //        {nodeType: "gx_layer", layer: "RIVM - History PM10", text: "Time Series Measurements PM10"}
    //
    //    ]
    //    },
    //    {
    //        text: 'Sulfur Dioxide (SO2) - WMS', expanded: false, children: [
    //        {nodeType: "gx_layer", layer: "RIVM - Current SO2", text: "Current SO2"},
    //        {nodeType: "gx_layer", layer: "RIVM - History SO2", text: "Time Series Measurements SO2"}
    //
    //    ]
    //    }
    //]
    //},
    //{
    //    text: 'Smart Emission (Citygis.nl)', expanded: false, children: [
    //    {nodeType: "gx_layer", layer: "Smart Emission - Sensors", text: "Smart Emission - Sensors (WMS)"},
    //    //{nodeType: "gx_layer", layer: "SmartEm - Active Stations (WFS)", text: "AQ Stations (Active WFS)" },
    //    {
    //        text: 'Carbon monoxide (CO) - WMS', expanded: false, children: [
    //        {nodeType: "gx_layer", layer: "Smart Emission - Current CO", text: "Current CO"},
    //        {nodeType: "gx_layer", layer: "Smart Emission - History CO", text: "Time Series Measurements CO"}
    //    ]
    //    },
    //    {
    //        text: 'Nitrogen Dioxide (NO2) - WMS', expanded: true, children: [
    //        {nodeType: "gx_layer", layer: "Smart Emission - Current NO2", text: "Current NO2"},
    //        {nodeType: "gx_layer", layer: "Smart Emission - History NO2", text: "Time Series Measurements NO2"}
    //    ]
    //    },
    //    {
    //        text: 'Ozone (O3) - WMS', expanded: true, children: [
    //        {nodeType: "gx_layer", layer: "Smart Emission - Current O3", text: "Current O3"},
    //        {nodeType: "gx_layer", layer: "Smart Emission - History O3", text: "Time Series Measurements O3"}
    //    ]
    //    }
    //]
    //},

    {
        text: 'Smart Emission - Meteo', expanded: true, children: [
        {nodeType: "gx_layer", layer: "Smart Emission - Current Temperature"},
        {nodeType: "gx_layer", layer: "Smart Emission - Current Barometer"},
        {nodeType: "gx_layer", layer: "Smart Emission - Current Humidity"}
    ]
    },
    {
        text: 'Smart Emission - Audio', expanded: true, children: [
        {nodeType: "gx_layer", layer: "Smart Emission - Current Audio Level"}
    ]
    },
    {
        text: 'Geonovum Weather', expanded: false, children: [
        {nodeType: "gx_layer", layer: "Weather Stations", text: "Weather Stations (WMS)"},
        {nodeType: "gx_layer", layer: "Weather Observations", text: "Weather Observations (WMS Time)"},
        {nodeType: "gx_layer", layer: "Last Weather Observations", text: "Last Weather Observations (WMS)"}
    ]
    },
    {
        text: 'Fiware', expanded: false, children: [
        {nodeType: "gx_layer", layer: "Fiware Entities", text: "Fiware Entities (Geonovum)"}
    ]
    },
    {
        text: 'KNMI - Meteorology', expanded: false, children: [
        {nodeType: "gx_layer", layer: "KNMI - Current Temperatures"},
        {nodeType: "gx_layer", layer: "KNMI - Current Wind Forces"},
        {nodeType: "gx_layer", layer: "KNMI - Current Wind Directions"},
        {nodeType: "gx_layer", layer: "KNMI - Current Air Pressures"},
        {nodeType: "gx_layer", layer: "KNMI - Rain Radar (Color)"}
    ]
    },
    //{
    //    text: 'Kadaster', expanded: false, children: [
    //
    //    {
    //        text: 'Kadastrale Kaart (zoom >8)', expanded: false, children: [
    //        {nodeType: "gx_layer", layer: "Kadastrale Vlakken", text: "Percelen (WMS)"},
    //        {nodeType: "gx_layer", layer: "Kadastrale Vlakken (tiled)", text: "Percelen (tiled)"},
    //        {nodeType: "gx_layer", layer: "Kadastrale Gebouwen (tiled)", text: "Gebouwen (tiled)"},
    //        {nodeType: "gx_layer", layer: "Kadastrale Kaart Alles (tiled)", text: "Percelen en Gebouwen (tiled)"}
    //    ]
    //    }
    //]
    //},
    {
        text: 'PDOK', expanded: false, children: [
        {
            text: 'BAG', expanded: false, children: [
            {nodeType: "gx_layer", layer: "BAG - Adressen", text: "BAG Adressen"},
            {nodeType: "gx_layer", layer: "BAG - Woonplaatsen", text: "BAG Woonplaatsen"},
            {nodeType: "gx_layer", layer: "BAG - Ligplaatsen", text: "BAG Ligplaatsen"},
            {nodeType: "gx_layer", layer: "BAG - Standplaatsen", text: "BAG Standplaatsen"},
            {nodeType: "gx_layer", layer: "BAG - Verblijfsobjecten", text: "BAG Verblijfsobjecten"},
            {nodeType: "gx_layer", layer: "BAG - Panden", text: "BAG Panden"},
            {nodeType: "gx_layer", layer: "BAG - Panden (WFS)", text: "BAG Panden (WFS)"}
        ]
        },
        {
            text: 'Bestuurlijke Grenzen', expanded: false, children: [
            /*							{nodeType: "gx_layer", layer: "Bestuurlijke Grenzen - Buurten", text: "Buurten" },
             {nodeType: "gx_layer", layer: "Bestuurlijke Grenzen - Wijken", text: "Wijken" },  */
            {nodeType: "gx_layer", layer: "Bestuurlijke Grenzen - Gemeenten", text: "Gemeenten (WMS)"},
            {nodeType: "gx_layer", layer: "Bestuurlijke Grenzen - Gemeenten (WFS)", text: "Gemeenten (WFS)"},
            {nodeType: "gx_layer", layer: "Bestuurlijke Grenzen - Provincies", text: "Provincies"},
            {nodeType: "gx_layer", layer: "Bestuurlijke Grenzen - Provincies (WFS)", text: "Provincies (WFS)"},
            {nodeType: "gx_layer", layer: "Bestuurlijke Grenzen - Land", text: "Land"},
            {nodeType: "gx_layer", layer: "Bestuurlijke Grenzen - Land (WFS)", text: "Land (WFS)"}
        ]
        },
        {
            text: 'Digitaal Topografisch Bestand (DTB)', expanded: false, children: [
            {nodeType: "gx_layer", layer: "DTB Vlakken"},
            {nodeType: "gx_layer", layer: "DTB Lijnen"},
            {nodeType: "gx_layer", layer: "DTB Punten"}
        ]
        },
        {
            text: 'Actueel Hoogtebestand (AHN)', expanded: false, children: [
            {nodeType: "gx_layer", layer: "AHN2 0.5m Ruw"},
            {nodeType: "gx_layer", layer: "AHN2 0.5m Geinterpoleerd"},
            {nodeType: "gx_layer", layer: "AHN2 0.5m Niet Geinterpoleerd"},
            {nodeType: "gx_layer", layer: "AHN2 5m"},
            {nodeType: "gx_layer", layer: "AHN2 Bladindex"},
            {nodeType: "gx_layer", layer: "AHN 25m", text: 'AHN1 25m (Oud)'}
        ]
        },
        {
            text: 'Rijksdriehoeksmeting (RDInfo)', expanded: false, children: [
            {nodeType: "gx_layer", layer: "RD Info - Punten"},
            {nodeType: "gx_layer", layer: "RD Info - Stations"}
        ]

        },
        {
            text: 'Natuur & Mileu', expanded: false, children: [
            {nodeType: "gx_layer", layer: "Natura 2000"},
            {nodeType: "gx_layer", layer: "Nationale Parken"},
            {nodeType: "gx_layer", layer: "NOK 2010 - EHS"},
            {nodeType: "gx_layer", layer: "NOK 2010 - RODS"},
            {nodeType: "gx_layer", layer: "NOK 2010 - BBLBuitenbegrenzing", text: "NOK 2010 - BBLBuitenbegr."}
        ]
        }
    ]
    },
    {
        text: 'RO Online', expanded: false, children: [
        {nodeType: "gx_layer", layer: "RO Online Bestemmingsplannen", text: "Bestemmingsplannen (BP)"},
        {nodeType: "gx_layer", layer: "RO Online Gem. Structuurvisie", text: "Gem. Structuurvisie (GSV),"},
        {nodeType: "gx_layer", layer: "RO Online Prov. Structuurvisie", text: "Prov. Structuurvisie (PSV)"}
    ]
    },
    {
        text: 'Scratch folder', expanded: false, children: [
        {nodeType: "gx_layer", layer: "Tekenlaag", text: "Drawing Layer"},
        {nodeType: "gx_layer", layer: "Kladlaag", text: "Upload Loayer"}
    ]
    }

];
