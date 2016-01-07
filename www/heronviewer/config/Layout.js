/*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
Ext.namespace("Heron");
Ext.namespace("Heron.options");
Ext.namespace("Heron.options.layertree");
Heron.options.urls = Heron.scratch.urls;

// Create end interval date from current date for timeseries slider config.
Heron.date = new Date();
Heron.date.setHours(Heron.date.getHours() - 1);
Heron.date.setMinutes(0);
Heron.date.setSeconds(0);
Heron.date.setMilliseconds(0);

Heron.date = Heron.date.toISOString();

Heron.cdate = new Date();
Heron.cdate.setHours(Heron.cdate.getHours() - 3);
Heron.cdate.setMinutes(0);
Heron.cdate.setSeconds(0);
Heron.cdate.setMilliseconds(0);

Heron.cdate = Heron.cdate.toISOString();

/**
 * Defines the entire layout of a Heron webapp using ExtJS-style.
 *
 * The layout specifies a hierarchy of ExtJS (Panel) components.
 * Each component is either a container of components (xtype: 'panel', i.e. an ExtJS Panel)
 * or a specific leaf component like a map panel (xtype: 'hr_mappanel') or simple HTML
 * panel (xtype: 'hr_htmlpanel'). Each component has a 'xtype' string and component-specific options.
 * The 'xtype' defines the component widget class .
 * For a container-type (xtype: 'panel') the options should include a 'layout' (like 'border' or 'card',
 * and an array of 'items' with each element being a component (another container or a leaf widget component).
 *
 * In order to distinguish ExtJS-specific config options from those that are Heron-specific,
 * the later are prefixed with "hr". These are defined outside this file to allow quick custimization.
 *
 * Specific config options for ExtJS components can be found in the API docs:
 * http://docs.sencha.com/ext-js/3-4/#!/api
 *
 * This is the core config, mainly the layout of a Heron browser application for all examples.
 * Many of the options refer to Javascript variables that are defined within
 * the DefaultOptions*.js. In particular Layers and specific widgets. This has been done
 * to create a reusable config for all examples. Each example may also add a 3rd refinement
 * using a local Config.js file. The names of the config files and variables like Heron.options.bookmarks
 * don't matter. They are just a convenience as to break up a large configuration into
 * the more stable common parts and the more variable parts. As it is all JSON/JavaScript, we
 * can use variables, in our case namespaced, like "Heron.options.bookmarks" as to avoid conflicts in
 * the global JS namespace. (If we would have XML configs we would have to resort to xlinks).
 *
 **/
Heron.layout = {
    xtype: 'panel',

    /* Optional ExtJS Panel properties here, like "border", see ExtJS API docs. */
    id: 'hr-container-main',
    layout: 'border',
    border: true,

    /** Any classes in "items" and nested items are automatically instantiated (via "xtype") and added by ExtJS. */
    items: [
        {
            xtype: 'panel',
            id: 'hr-menu-left-container',
            layout: 'accordion',
            region: "west",
            width: 268,
            collapsible: true,
            border: false,
            items: [
                {
                    xtype: 'hr_gxplayerpanel',
                    id: 'gxplayerpanel',
                    border: true,
                    autoScroll: false,
                    collapsed: false,
                    title: 'Layer Management',
//                    header: false,
//                    width: 240,
                    tbar: [], // we will add buttons to "gxplayerpanel.bbar" later
                    // configuration of all tool plugins for this application, see GXP docs
                    tools: [
//  NOT REQUIRED
//                      {
//                            // ptype: "gxp_layertree",
//                            ptype: "gxp_layermanager",
//
//                            outputConfig: {
//                                id: "layertree",
//                                title: __('Layers'),
//                                header: false,
//                                border: false,
//                                tbar: [] // we will add buttons to "tree.bbar" later
//                            },
//                            outputTarget: "gxplayerpanel"
//                        },
                        {
                            ptype: "gxp_addlayers",
                            actionTarget: "gxplayerpanel.tbar",
                            // addActionText: __('Add layers'),
                            templatedLayerGrid: true,
                            layerGridWidth: 440,
                            layerGridHeight: 600,
                            layerPreviewWidth: 40,
                            layerPreviewHeight: 40,
                            owsPreviewStrategies: ['attributionlogo', 'getlegendgraphic', 'randomcolor'],

                            // Catalog panel settings
                            searchText: "Find in Dutch National Georegister (via CSW)",
                            catalogPanelWidth: 440,

                            defaultSrs: 'EPSG:28992',
                            search: {selectedSource: "nationaalgeoregister"}
                        },
                        {
                            ptype: "gxp_removelayer",
                            actionTarget: "gxplayerpanel.tbar"
//                            removeActionText: __('Remove layer')
                        },
//                        {
//                            ptype: "gxp_removelayer",
//                            actionTarget: "layertree.contextMenu"
//                        },
//                        {
//                            ptype: "gxp_layerproperties",
//                            outputConfig: {defaults: {autoScroll: true}, width: 400, autoHeight: true},
//                            actionTarget: ["gxplayerpanel.tbar"]
//                            //                    actionTarget: ["layertree.contextMenu"]
//                            //                    outputTarget: "layertree"
//                        },
                        {
                            ptype: "gxp_styler",
                            outputConfig: {autoScroll: true, width: 320},
                            actionTarget: ["gxplayerpanel.tbar"]
                            //                    actionTarget: ["layertree.contextMenu"],
                            //                    outputTarget: "layertree"
                        },
//                        {
//                            ptype: "gxp_zoomtolayerextent",
//                            actionTarget: {target: "layertree.contextMenu", index: 0}
//                        },
                        {
                            ptype: "gxp_opacityslider",
                            actionTarget: ["gxplayerpanel.tbar"]
                        }
                    ],

                    // layer sources
                    defaultSourceType: "gxp_wmssource",
                    sources: {
                        rivm_wms: {
                            ptype: "gxp_wmssource",
                            url: 'http://geodata.rivm.nl/geoserver/ows?',
                            version: "1.1.1",
                            title: 'RIVM WMS',
                            owsPreviewStrategies: ['getlegendgraphic']  // or 'no preview available' if empty array
                        },
                        rivm_inspire_wms: {
                            ptype: "gxp_wmssource",
                            url: 'http://inspire.rivm.nl/geoserver/wms?',
                            version: "1.1.1",
                            title: 'RIVM INSPIRE WMS',
                            owsPreviewStrategies: ['getlegendgraphic']  // or 'no preview available' if empty array
                        },

                        //geonovum_sospilot_wms: {
                        //    ptype: "gxp_wmssource",
                        //    url: 'http://sensors.geonovum.nl/gs/sensors/wms?',
                        //    version: "1.1.1",
                        //    title: 'Geonovum SOSPilot WMS',
                        //    owsPreviewStrategies: ['getlegendgraphic']  // or 'no preview available' if empty array
                        //},
                        pdok_bagviewer_wms: {
                            ptype: "gxp_wmssource",
                            url: Heron.options.urls.PDOK + '/bagviewer/wms',
                            version: "1.1.0",
                            title: 'PDOK BAG WMS',
                            owsPreviewStrategies: ['getlegendgraphic']  // or 'no preview available' if empty array
                        },
                        pdok_bestuurlijkegrenzen_wms: {
                            ptype: "gxp_wmssource",
                            url: Heron.options.urls.PDOK + '/bestuurlijkegrenzen/wms',
                            version: "1.1.0",
                            title: 'PDOK Bestuurlijke Grenzen WMS',
                            owsPreviewStrategies: ['getlegendgraphic']  // or 'no preview available' if empty array
                        },
                        pdok_bagviewer_wfs: {
                            ptype: "gxp_wfssource",
                            url: Heron.options.urls.PDOK + '/bagviewer/wfs',
                            version: "1.1.0",
                            title: 'PDOK BAG WFS',
                            owsPreviewStrategies: ['randomcolor']  // or 'no preview available' if empty array
                        },
                        map5_tms: {
                            ptype: "gxp_tmssource",
                            url: 'http://s.map5.nl/map/gast/tms/1.0.0/',
                            isBaseLayer: true,  // default is true
                            group: 'background' // 'background' or 'default', default value is 'background'
                        },
                        pdok_tms: {
                            ptype: "gxp_tmssource",
                            url: Heron.options.urls.PDOK + '/tms/',
                            isBaseLayer: true,  // default is true
                            group: 'background' // 'background' or 'default', default value is 'background'
                        }
                        //                osm: {
                        //                    ptype: "gxp_osmsource"
                        //                }
                        //                dutchheights: {
                        //                    url: "http://geodata.nationaalgeoregister.nl/ahn2/wcs?",
                        //                    version: "1.1.1",
                        //                    title: 'PDOK AHN2'
                        //                },
                        //                google: {
                        //                    ptype: "gxp_googlesource"
                        //                }
                        ,
                        nationaalgeoregister: {
                            ptype: "gxp_cataloguesource",
                            url: "http://www.nationaalgeoregister.nl/geonetwork/srv/dut/csw",
                            fullMetadataUrlTpl: 'http://www.nationaalgeoregister.nl/geonetwork/srv/dut/search?uuid={id}',
                            title: "Nationaal Georegister"
                        }
                    },
                    items: [
                        {
                            xtype: 'hr_layertreepanel',
                            // Optional, use internal default if not set
                            title: null,
                            border: false,
                            autoScroll: true,
                            contextMenu: 'defaults',
                            hropts: Heron.options.layertree,
                            collapsed: false
                        }
                    ]
                },
                {
                    xtype: 'hr_activethemespanel',
                    title: 'Active Layers',
                    contextMenu: 'defaults',
                    collapsed: true,

                    hropts: {
                        // Defines the custom components added with the standard layer node.
                        showOpacity: true, // true - layer opacity icon / function
                        showTools: false, // true - layer tools icon / function (not jet completed)
                        showRemove: false        // true - layer remove icon / function
                    }
                },
                {
                    xtype: 'hr_bookmarkspanel',
                    id: 'hr-bookmarks',
                    collapsed: true,
                    /** The map contexts to show links for in the BookmarksPanel. */
                    hropts: Heron.options.bookmarks
                }
            ]
        },
        {
            xtype: 'panel',
            id: 'hr-map-and-info-container',
            layout: 'border',
            region: 'center',
            width: '100%',
            collapsible: false,
            split: false,
            border: false,
            items: [
                {
                    xtype: 'hr_mappanel',
                    id: 'hr-map',
                    title: 'SOSPilot HeronViewer - Version 1.0 - Made with <a href="http://heron-mc.org">Heron</a>',
                    region: 'center',
                    collapsible: false,
                    border: false,
                    hropts: Heron.options.map
                }
            ]
        },
        {
            xtype: 'panel',

            id: 'hr-right-main',
            layout: 'border', //vertical box for left column
            collapsible: true,
            region: 'east',
            width: 320,
            border: false,
            items: [
                {
                    xtype: 'panel',
                    flex: 1, //gives precedence, and "flexes" to fill space
                    height: 140,
                    region: 'north',
                    layout: 'fit',
                    items: [
                        {
                            xtype: 'hr_simpletimesliderpanel',
                            title: 'Slider for Time Series Layers',
                            border: false,
                            startDateTime: '2014-06-09T17:00:00Z',
                            endDateTime: Heron.date,  // default is current time
                            stepTime: 'PT1H',
                            dateTime: Heron.cdate,
                            layerNames: [
                                "KNMI - Rain Radar (Color)",
                                "RIVM - History CO",
                                "RIVM - History NH3",
                                "RIVM - History NO2",
                                "RIVM - History NO",
                                "RIVM - History PM10",
                                "RIVM - History O3",
                                "RIVM - History SO2",
                                "Smart Emission - History CO",
                                "Smart Emission - History NO2",
                                "Smart Emission - History O3",
                                "Weather Observations"
                            ]
                        }
                    ]
                },
                {
                    xtype: 'hr_layerlegendpanel',
                    id: 'hr-layerlegend-panel',
                    region: 'center',
                    border: false,
                    defaults: {
                        useScaleParameter: true,
                        baseParams: {
                            FORMAT: 'image/png'
                        }
                    },
                    hropts: {
                        // Preload Legends on initial startup
                        // Will fire WMS GetLegendGraphic's for WMS Legends
                        // Otherwise Legends will be loaded only when Layer
                        // becomes visible. Default: false
                        prefetchLegends: false
                    }
                }
            ]
        }
    ]
};
