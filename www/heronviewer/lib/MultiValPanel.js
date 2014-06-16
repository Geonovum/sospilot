/** ************************************************************************ */
/* Create a dimension window based on multiple values given for a dimension */
/** ************************************************************************ */
/* Dimension window handling */
var dimensionWindows = new Array();

MultiValMainWindowTabPanel = new Ext.TabPanel({
    border: false,
    frame: false
});

MultiValMainPanel = new Ext.Panel({
    closeAction: 'hide',
    title: 'Dimensions',
    // width:360,
    margins: '5 0 0 0',
    height: 160,
    layout: 'fit',
    region: 'south',
    items: MultiValMainWindowTabPanel,

    autoScroll: false,
    border: true,
    frame: false,
    split: false
});
/*
 * MultiValMainWindow = new Ext.Window({ closeAction:'hide',
 * title:'Dimensions', x:280, y:90, width:360, height:146, layout:'fit',
 * items:MultiValMainWindowTabPanel, autoScroll:true, border:false,frame:true
 * });
 */

// MultiValMainWindow.show();
MultiValPanel = Ext.extend(Ext.Panel, {
    initComponent: function () {
        var _this = this;
        _this.getCurrentValue = function () {
            return _this.dimension.currentValue;
        }
        _this.panelType = 'MultiVal';
        _this.hasChanged = function () {

            if (getFeatureInfoWindow.isVisible()) {
                if (mainMap.map.isMapPinVisible() == true) {
                    var mapPinXY = mainMap.map.getMapPinXY();
                    mainMap.map.getFeatureInfo(mapPinXY[0], mapPinXY[1]);
                }
            }
        }
        var prev = new Ext.Button({
            region: 'west',
            text: '&lt previous',
            hideLabel: true,
            listeners: {
                'click': function (e) {
                    var value = _this.list.getValue();
                    var store = _this.list.getStore();
                    var index = store.findExact('time', value);
                    // debug(index+" == "+value);
                    var newvalue = store.getAt(index - 1);

                    if (newvalue != undefined) {
                        _this.list.setValue(newvalue.get('time'));
                        _this.list.fireEvent('select', _this.list, newvalue, index);
                    }
                }
            }
        });
        var next = new Ext.Button({
            region: 'east',
            text: 'next &gt;',
            ctCls: 'x-box-layout-ct',
            hideLabel: true,
            listeners: {
                'click': function (e) {
                    var value = _this.list.getValue();
                    var store = _this.list.getStore();
                    var index = store.findExact('time', value);
                    // debug(index+" == "+value);
                    var newvalue = store.getAt(index + 1);
                    if (newvalue != undefined) {
                        _this.list.setValue(newvalue.get('time'));
                        _this.list.fireEvent('select', _this.list, newvalue, index);
                    }
                }
            }
        });

        _this.list = new Ext.form.ComboBox({
            // fieldLabel:'Select a value',
            region: 'center',
            height: 20,
            width: 200,
            hideLabel: true,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            mode: 'local',
            store: new Ext.data.Store({
                id: 0,
                fields: [ 'time' ]
            }),
            valueField: 'time',
            displayField: 'time',
            listeners: {
                select: {
                    fn: function (a, record, nr) {
                        // debug("setting "+panel.dim.name+" to
                        // "+panel.dim.currentValue);
                        mainMap.map.setDimension(_this.dimension.name, record.get('time'));
                        mainMap.map.draw("select");
                        _this.hasChanged();


                    }
                }
            }
        });
        _this.label = new Ext.form.Label({
            text: "Dimension '" + _this.dimension.name + "' with units '" + _this.dimension.units + "':"
        });
        _this.panel = new Ext.Panel({
            // border:false,
            layout: 'fit',
            border: false,
            frame: true,
            items: [ _this.label, _this.list ],

            region: 'center'
        });
        _this.setTitle(_this.dimension.name);
        Ext.apply(this, {
            height: 95,
            // title:"dim",
            closeAction: 'hide',
            layout: 'fit',
            border: false,
            frame: false,
            items: [ _this.panel ],
            bbar: [/*
             * new Ext.Button({ iconCls:'button_refresh', text:'refresh',
             * handler: function(){
             * _this.dimension.parentLayer.jumpToDimEnd=true;
             * doGetCapabilities(mainMap.map.getActiveLayer().service,mainMap.map.getActiveLayer().title,true); }
             * }),
             */prev, next ]
        })
        MultiValPanel.superclass.initComponent.apply(this, arguments);
    }
});

// var t = new TimeRangeWindow ({ });
// t.show();

// var t2 = new MultiValPanel ({ });
// t2.show();
var getDimWindowPanelTypeForDim = function (dim) {
    var panelType = 'MultiVal';
    if (dim.values.split("/").length > 1 && dim.values.split(",").length < 2)
        panelType = 'Range';
    if (dim.units != "ISO8601")
        panelType = 'MultiVal';
    return panelType;
}
var makeDimensionWindows = function (dims, removeUnusedTabs) {
    // error("makeDimensionWindows");
    // Disable windows that are not used anymore
    for (var i = 0; i < dimensionWindows.length; i++) {
        dimensionWindows[i].keep = false;
    }

    for (var i = 0; i < dimensionWindows.length; i++) {
        if (dimensionWindows[i].keep == false) {
            for (var j = 0; j < dims.length; j++) {
                if (dimensionWindows[i].dimension.name == dims[j].name) {
                    var panelType = getDimWindowPanelTypeForDim(dims[j]);
                    if (dimensionWindows[i].panelType == panelType) {
                        dimensionWindows[i].keep = true;
                        break;
                    }
                }
            }
        }
    }

    if (removeUnusedTabs) {
        // Remove tabs
        for (var i = 0; i < dimensionWindows.length; i++) {
            if (dimensionWindows[i].keep == false) {
                MultiValMainWindowTabPanel.remove(dimensionWindows[i]);
            }
        }

        // Rebuild array;
        var oldDimWin = dimensionWindows;
        dimensionWindows = Array();
        for (var i = 0; i < oldDimWin.length; i++) {
            if (oldDimWin[i].keep == true) {
                dimensionWindows.push(oldDimWin[i]);
            }
        }
    }

    // else dimensionWindows[i].panelEnable();
    // }

    // Create or re-use for each dimension a new window
    // debug("makeDimensionWindows");
    for (var j = 0; j < dims.length; j++) {

        var dim = dims[j];

        var dimAv = -1;
        /*
         * var panelType='MultiVal'; if(dims[j].values.split("/").length>1&&
         * dims[j].values.split(",").length<2)panelType='Range';
         */

        var panelType = getDimWindowPanelTypeForDim(dim);

        // Check if there is already a window for this dimension
        for (var i = 0; i < dimensionWindows.length; i++) {

            if (dimensionWindows[i].dimension.name == dim.name) {
                if (dimensionWindows[i].panelType == panelType) {
                    dimAv = i;
                    break;
                }
            }
        }
        // If this dimension does not have yet a window, create a new window
        if (dimAv == -1) {
            var newDimWin;
            if (panelType == 'Range') {
                newDimWin = new TimeRangeWindow({
                    dimension: dim
                });
            }
            if (panelType == 'MultiVal') {

                newDimWin = new MultiValPanel({
                    dimension: dim
                });

            }
            dimensionWindows.push(newDimWin);

            MultiValMainWindowTabPanel.add(newDimWin);
            newDimWin.show();
            MultiValMainWindowTabPanel.doLayout();

            // MultiValMainWindow.show();
            // MultiValMainWindow.doLayout();

            dimAv = dimensionWindows.length - 1;
        }

        var dimWin = dimensionWindows[dimAv];
        /*
         * if(dimWin.panelType=='Range'){ dimWin.setTitle("Dimension
         * '"+dim.name+"' with units '"+dim.units+"'");// and type
         * '"+panelType+"'"); }else{ dimWin.setTitle(dim.name);// and type }
         */

        // Do we have a dimension with a range or with multiple values?
        if (panelType == 'Range') {
            dimWin.setDimension(dim);
        } else {

            //Multiple values dim
            var dimPanel = dimWin;
            if (dimPanel.list.values != dim.values) {
                dimPanel.list.values = dim.values;
                // error("Setting");
                // Create a dimension panel based on multiple values
                var currentValue = mainMap.map.getDimension(dim.name).currentValue;


                var cvf = false;// currentValueFound
                // var dimPanel=dimWin;//createDimPanelMultiVal(dimWin);

                var store = dimPanel.list.getStore();
                store.removeAll();

                var valuesc = dim.values.split(",");
                var firstValue = undefined;
                // dim.values can be in the form of:
                // 2010-11-11T18:00:00Z,2010-11-11T21:00:00Z/2010-11-22T00:00:00Z/PT3H,2010-11-22T06:00:00Z/2010-11-26T00:00:00Z/PT6H

                for (var k = 0; k < valuesc.length; k++) {
                    var valuesd = Array();
                    // Maybe a time range is given, check it with start/stop/res

                    if (valuesc[k].split("/").length > 1 && valuesc[k].split(",").length < 2) {

                        if (dim.units == "ISO8601") {
                            // Yes, a time range is given, expand valuesd according to this.
                            try {
                                var timeRange = new parseISOTimeRangeDuration(valuesc[k]);
                                if (timeRange) {
                                    for (var j = 0; j < timeRange.timeSteps; j++)
                                        valuesd.push(timeRange.getDateAtTimeStep(j).toISO8601());
                                } else
                                    valuesd.push(valuesc[k]);
                            } catch (e) {
                                error(e);
                                valuesd.push(valuesc[k]);
                            }
                        } else {
                            // Other type of range is given: expand it
                            var sp = valuesc[0].split("/");
                            res = 1;
                            if (sp.length == 3)
                                res = sp[2];
                            for (var j = sp[0]; j < sp[1]; j = j + res) {
                                valuesd.push(sp[0] + res);
                            }
                            if (sp[0] == sp[1])
                                valuesd.push(sp[0]);
                        }
                    } else {
                        valuesd.push(valuesc[k]);
                    }

                    for (var l = 0; l < valuesd.length; l++) {
                        var value = {};
                        value['time'] = valuesd[l];
                        // Check if the current map dimension value is in this list
                        if (cvf == false && value['time'] == currentValue) {
                            cvf = true;
                        }
                        if (firstValue == undefined)
                            firstValue = value['time'];
                        store.add(new Ext.data.Record(value));
                    }
                }
                dimPanel.list.enable();
                dimPanel.list.reset();
                dimPanel.dimension = dim;

                if (cvf == true) {

                    dimPanel.list.setValue(mainMap.map.getDimension(dim.name).currentValue);
                } else {
                    dimPanel.list.setValue(firstValue);
                    mainMap.map.setDimension(dim.name, firstValue);
                }
            } else {
                //error("Already set, skipping...");

                //dimPanel.list.setValue(mainMap.map.getDimension(dim.name).currentValue);
                dimPanel.list.setValue(dim.currentValue);
            }

        }
        // dimWin.dimPanel=dimPanel;
        // dimPanel.type.setValue(dim.defaultValue);
        // debug("Dimension '"+dim.name+"' with units '"+dim.units+"'");
        // w.show();!p
    }
};

