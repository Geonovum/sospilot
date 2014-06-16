Ext.namespace("Heron.widgets");

/** api: (define)
 *  module = Heron.widgets
 *  class = TimeRangePanel
 *  base_link = `Heron.widgets.TimeRangePanel <TimeRangePanel.html>`_
 */

/**
 * Creates a dimension window for Time based on OGC's timeperiod:
 * starttime/stoptime/resolution.
 *
 * Original from: http://geoservices.knmi.nl/adaguc_portal/extgui.js
 * @constructor
 * @extends Ext.Panel
 *
 */
Heron.widgets.TimeRangePanel = Ext.extend(Ext.Panel, {
    title: __('Time Series Slider'),
    timeLayers: [],

    initComponent: function () {
        var _this = this;
        _this.isDateRefreshing = false;

        // _this.isAnimating=false;
        _this.getCurrentValue = function () {
            return _this.getDateString();
        };

        _this.panelType = 'Range';
        _this.prevPanel = new Ext.Panel({
            region: 'west',
            width: 30,
            layout: 'form',
            border: false,
            items: [ new Ext.Button({
                width: 30,
                text: '&lt;',
                hideLabel: true,
                listeners: {
                    'click': function (e) {
                        _this.slider.setValue(_this.slider.getValue() - 1);
                    }
                }
            }) ]
        });
        _this.nextPanel = new Ext.Panel({
            region: 'east',
            width: 30,
            layout: 'form',
            border: false,
            items: [ new Ext.Button({
                width: 30,
                text: '&gt;',
                hideLabel: true,
                listeners: {
                    'click': function (e) {
                        _this.slider.setValue(_this.slider.getValue() + 1);
                    }
                }
            }) ]
        });
        _this.slider = new Ext.Slider({
            value: 50,
            increment: 1,
            minValue: 0,
            maxValue: 100,
            listeners: {
                change: {
                    fn: function (a) {
                        _this.animateCheckBox.setValue(false);
                        _this.refreshCheckBox.setValue(false);
                        _this.sliderChanged();
                    }
                }
            }
        });


        _this.slider.mySetValue = function (v) {
            //error("mySetValue = "+v);
            _this.slider.suspendEvents();
            // _this.slider.setMaxValue(_this.slider.maxValue);
            _this.slider.setValue(v);
            _this.sliderChanged();
            _this.slider.resumeEvents();
        };

        _this.sliderPanel = new Ext.Panel({
            layout: 'form',
            region: 'center',
            items: [ _this.slider ],
            border: false

        });

        _this.sliderPNPanel = new Ext.Panel({
            layout: 'border',
            region: 'center',
            items: [ _this.prevPanel, _this.sliderPanel, _this.nextPanel ],
            border: false,
            frame: true

        });

        // This is the date selector
        _this.dateSetMinMaxWindow = new Ext.Window({
            modal: true,
            labelWidth: 125,
            frame: true,
            layout: 'form',
            title: 'Date Range',
            closeAction: 'hide',
            bodyStyle: 'padding:5px 5px 0',
            width: 350,
            defaults: {
                width: 175
            },
            defaultType: 'datefield',
            bbar: [
                {
                    xtype: 'button',
                    text: 'Reset start and end dates',
                    handler: function () {
                        var minValue = _this.timeRange.getDateAtTimeStep(0);
                        var maxValue = _this.timeRange.getDateAtTimeStep(_this.timeRange.timeSteps);
                        _this.slider.setMinValue(0);
                        _this.slider.setMaxValue(_this.timeRange.timeSteps);
                        _this.sliderChanged();
                        var startdt = _this.dateSetMinMaxWindow.getComponent('startdt');
                        var enddt = _this.dateSetMinMaxWindow.getComponent('enddt');
                        startdt.setMinValue(minValue);
                        enddt.setMaxValue(maxValue);
                    }
                }
            ],
            items: [
                {
                    fieldLabel: 'Start Date',
                    name: 'startdt',
                    itemId: 'startdt',
                    vtype: 'daterange',
                    format: 'Y-m-d\\TH:i:s\\Z',
                    listeners: {
                        valid: {
                            fn: function (a) {
                                if (a.getValue()) {
                                    try {
                                        _this.slider.setMinValue(_this.timeRange.getTimeStepFromDate(a.getValue()));
                                        _this.sliderChanged();
                                    } catch (e) {
                                        error(e);
                                    }
                                }
                            }
                        }
                    }
                },
                {
                    fieldLabel: 'End Date',
                    name: 'enddt',
                    itemId: 'enddt',
                    vtype: 'daterange',
                    format: 'Y-m-d\\TH:i:s\\Z',
                    listeners: {
                        valid: {
                            fn: function (a) {
                                if (a.getValue()) {
                                    try {
                                        _this.slider.setMaxValue(_this.timeRange.getTimeStepFromDate(a.getValue()));
                                        _this.sliderChanged();
                                    } catch (e) {
                                        error(e);
                                    }
                                }
                            }
                        }
                    }
                }
            ]
        });
        // This is the date selector
        _this.dateMinMaxSelector = new Ext.Button({
            iconCls: 'date-trigger',
            width: '24',
            region: 'east',
            handler: function (b) {
                var startdt = _this.dateSetMinMaxWindow.getComponent('startdt');
                var enddt = _this.dateSetMinMaxWindow.getComponent('enddt');
                startdt.endDateField = enddt;
                enddt.startDateField = startdt;
                var minValue = _this.timeRange.getDateAtTimeStep(0);
                var maxValue = _this.timeRange.getDateAtTimeStep(_this.timeRange.timeSteps);

                startdt.myMin = minValue;
                startdt.myMax = maxValue;
                enddt.myMin = minValue;
                enddt.myMax = maxValue;
                var pos = b.getPosition();
                _this.dateSetMinMaxWindow.setPosition(pos[0], pos[1]);
                _this.dateSetMinMaxWindow.show(b);
                if (!startdt.getValue() || !enddt.getValue()) {
                    startdt.setValue(minValue);
                    enddt.setValue(maxValue);
                } else {
                    var date = _this.timeRange.getDateAtTimeStep(_this.slider.getPosition());
                    if (date > minValue)
                        startdt.setMinValue(date);
                    else
                        startdt.setMinValue(minValue);
                    if (date < maxValue)
                        enddt.setMinValue(date);
                    else
                        enddt.setMaxValue(maxValue);
                }
            }
        });

        // Date field
        _this.getDateString = function () {
            return _this.dateFieldYear.getValue() + "-" +
                _this.dateFieldMonth.getValue() + "-" +
                _this.dateFieldDay.getValue() + "T" +
                _this.dateFieldHour.getValue() + ":" +
                _this.dateFieldMinute.getValue() + ":" +
                _this.dateFieldSecond.getValue() + "Z";
        };

        _this.setDateString = function (dateString) {

            _this.skipEvents = true;
            _this.dateFieldYear.setValue(dateString.substring(0, 4));
            _this.dateFieldMonth.setValue(dateString.substring(5, 7));
            _this.dateFieldDay.setValue(dateString.substring(8, 10));
            _this.dateFieldHour.setValue(dateString.substring(11, 13));
            _this.dateFieldMinute.setValue(dateString.substring(14, 16));
            _this.dateFieldSecond.setValue(dateString.substring(17, 19));
            // JvdB mainMap.map.setDimension(_this.dim.name, dateString);
            _this.skipEvents = false;
        }

        /*  var YYYYMMDDExpr = /[\d]{4}-?[\d]{2}-?[\d]{2}T-?[\d]{2}:?[\d]{2}:?[\d]{2}Z/;
         _this.dateField = new Ext.form.TextField({
         hideLabel : true,

         region : 'center',
         disabled : false,
         emptyText : 'YYYY-MM-DDThh:mm:ssZ',
         allowBlank : false,
         invalidText : 'The format is wrong, it should be like : \'2009-03-23T16:05:00Z\'',
         validator : function(value){
         return YYYYMMDDExpr.test(value);
         },
         listeners : {
         valid : {
         fn : function(a){

         var timeStep = 0;
         try {
         timeStep = _this.timeRange.getTimeStepFromISODate(_this.getDateString());
         } catch (e) {
         error("Invalid date entered!");
         return;
         }
         // debug("valid"+timeStep);

         _this.slider.setValue(timeStep);// TODO CHECK this!

         }
         }
         }
         });*/
        var NumberExpr2digits = /[\d]{2}/;
        var NumberExpr4digits = /[\d]{4}/;
        var DateFieldDialog = Ext.extend(Ext.form.TextField, {
            initComponent: function () {
                var d = this;
                Ext.apply(this, {

                    height: 12, listeners: {
                        valid: {
                            fn: function (a) {
                                if (_this.skipEvents)return;
                                var timeStep = 0;
                                try {
                                    timeStep = _this.timeRange.getTimeStepFromISODate(_this.getDateString());
                                } catch (e) {
                                    error("Invalid date entered!");
                                    return;
                                }
                                // debug("valid"+timeStep);

                                _this.slider.setValue(timeStep);// TODO CHECK this!

                            }
                        },
                        //Try to make a valid text, by adding a "0" in front of the value.
                        specialkey: {fn: function (t, e) {
                            if (e.getKey() == e.ENTER) {
                                var v = t.getValue();
                                if (isNumber(v)) {
                                    if (v < 10) {
                                        v = "0" + v;
                                        if (t.validator(v)) {
                                            t.setValue(v);
                                        }
                                    }
                                }
                            }
                        }}
                    }
                });
                DateFieldDialog.superclass.initComponent.apply(this, arguments);
            }
        });

        function isNumber(o) {
            return !isNaN(o - 0);
        }

        var DateFieldSpinnerDialog = Ext.extend(Ext.ux.form.SmallSpinnerField, {
            initComponent: function () {
                //var d = this;
                this._width = this.width;

                this.doLayout = function () {
                    this.spinner.doResize(this._width, 0);
                }
                Ext.apply(this, {
                    height: 22, margins: '0 0 0 0', listeners: {
                        valid: {
                            fn: function (a) {
                                if (_this.skipEvents)return;
                                var timeStep = 0;
                                try {
                                    timeStep = _this.timeRange.getTimeStepFromISODate(_this.getDateString());
                                } catch (e) {
                                    error("Invalid date entered!");
                                    return;
                                }
                                // debug("valid"+timeStep);

                                _this.slider.setValue(timeStep);// TODO CHECK this!

                            }
                        },
                        //Try to make a valid text, by adding a "0" in front of the value.
                        specialkey: {fn: function (t, e) {
                            if (e.getKey() == e.ENTER) {
                                var v = t.getValue();
                                if (isNumber(v)) {
                                    if (v < 10) {
                                        v = "0" + v;
                                        if (t.validator(v)) {
                                            t.setValue(v);
                                        }
                                    }
                                }
                            }
                        }}


                    }
                });
                DateFieldSpinnerDialog.superclass.initComponent.apply(this, arguments);
            }
        });

        _this.dateChooser = new Ext.Button({
            iconCls: 'date-trigger',
            width: '24',
            region: 'east', frame: false, border: false,
            handler: function (b) {
                var d = new Ext.Window({
                    items: [new Ext.DatePicker({
                        listeners: {
                            'select': function (m, date) {
                                d.hide();
                                _this.skipEvents = true;
                                _this.dateFieldYear.setValue(date.getUTCFullYear());
                                _this.dateFieldMonth.setValue(date.getUTCMonth() + 1);
                                _this.skipEvents = false;
                                _this.dateFieldDay.setValue(date.getUTCDate() + 1);
                            }
                        }
                    })
                    ]
                });
                d.show();
            }
        });


        _this.dateFieldYear = new DateFieldSpinnerDialog({fieldLabel: 'Year', width: 45, validator: function (value) {
            return  NumberExpr4digits.test(value);
        }});
        _this.dateFieldMonth = new DateFieldSpinnerDialog({fieldLabel: 'Month', width: 34, validator: function (value) {
            return  NumberExpr2digits.test(value);
        }});
        _this.dateFieldDay = new DateFieldSpinnerDialog({fieldLabel: 'Day', width: 34, validator: function (value) {
            return  NumberExpr2digits.test(value);
        }});
        _this.dateFieldHour = new DateFieldSpinnerDialog({fieldLabel: 'Hour', width: 34, validator: function (value) {
            return  NumberExpr2digits.test(value);
        }});
        _this.dateFieldMinute = new DateFieldSpinnerDialog({fieldLabel: 'Minute', width: 34, validator: function (value) {
            return  NumberExpr2digits.test(value);
        }});
        _this.dateFieldSecond = new DateFieldSpinnerDialog({fieldLabel: 'Second', width: 34, validator: function (value) {
            return  NumberExpr2digits.test(value);
        }});

        /*
         * _this.dateField = new Ext.form.TextField({ hideLabel:true,
         *
         * region:'center',
         * disabled:false,emptyText:'YYYY-MM-DDThh:mm:ssZ',allowBlank:false,
         * invalidText: 'The format is wrong, it should be like :
         * \'2009-03-23T16:05:00Z\'', validator: function(value){ return
         * YYYYMMDDExpr.test(value); }, listeners:{valid:{fn:function(a) { var
         * timeStep=0; try{
         * timeStep=_this.timeRange.getTimeStepFromISODate(_this.getDateString()); }
         * catch(e){ error("Invalid date entered!"); return; }

         * _this.slider.setValue(timeStep);//TODO CHECK this!
         *
         * }}} });
         *
         * , _this.dateMinMaxSelector
         */

        _this.leftDatePanel = new Ext.Panel({
            layout: 'hbox',
            width: 400,
            layoutConfig: {
                pack: 'start'

            },

            ctCls: 'x-toolbar',
            items: [
                {xtype: 'label', text: 'Date: ', margins: '5px 0px 5px 0px'},
                _this.dateFieldYear,
                {xtype: 'label', text: ' - ', margins: '5px 0px 5px 0px'},
                _this.dateFieldMonth,
                {xtype: 'label', text: ' - ', margins: '5px 0px 5px 0px'},
                _this.dateFieldDay,
                {xtype: 'label', text: '  Time: ', margins: '5px 0px 5px 5px'},
                _this.dateFieldHour,
                {xtype: 'label', text: ' : ', margins: '5px 0px 5px 0px'},
                _this.dateFieldMinute,
                {xtype: 'label', text: ' : ', margins: '5px 0px 5px 0px'},
                _this.dateFieldSecond
            ],
            border: false, frame: true

        });
        _this.isDateRefreshRunning = false;
        _this.refreshCheckBox = new Ext.form.Checkbox({
            checked: false,
            boxLabel: 'auto update',
            tooltip: '',
            listeners: {
                check: {
                    fn: function (a, checked) {
                        if (checked) {
                            _this.isDateRefreshing = true;
                            if (!_this.refreshTimer) {
                                _this.refreshTimer = new Timer();
                            }
                            _this.refreshTFunc = function () {
                                if (_this.refreshCheckBox.getValue() == false) {
                                    _this.isDateRefreshRunning = false;
                                    return;
                                }
                                _this.refresh();
                                _this.isDateRefreshRunning = true;
                                _this.refreshTimer.InitializeTimer(60 * 60, _this.refreshTFunc);
                            }
                            if (_this.isDateRefreshRunning == false)
                                _this.refreshTFunc();
                        } else
                            _this.isDateRefreshing = false;
                    }
                }
            }
        });
        var numberOfAnimationFrames = 12;
        _this.startAnimation = function () {

            /*
             * var endDate = _this.getDateString(); var startStep =
             * _this.timeRange.getTimeStepFromISODate(endDate)-12;
             * if(startStep<0)startStep=0; var startDate =
             * _this.timeRange.getDateAtTimeStep(startStep).toISO8601();
             * var newTime = startDate+"/"+endDate;
             * mainMap.map.setDimension('time',newTime);
             * mainMap.map.draw();
             */
            // return;
            if (!_this.animationTimer) {
                _this.animationTimer = new Timer();
            }
            _this.loopDates = new Array();
            //var endDate = _this.getDateString();

            // JvdB var endDate = mainMap.map.getDimension(_this.dim.name).currentValue;
            var endDate = _this.dimension.currentValue;
            var endStep;
            if (endDate == 'current') {
                endStep = _this.timeRange.timeSteps;
            } else {
                endStep = _this.timeRange.getTimeStepFromISODate(endDate);
            }
            _this.animateCheckBox.origStepBeforeAnimation = endStep;
            var numSteps = numberOfAnimationFrames;
            if (numSteps > endStep)
                numSteps = endStep;
            if (numSteps <= 1) {
                alert("Cannot animate: there is only one timestep available.");
                _this.animateCheckBox.setValue(false);
                _this.refreshCheckBox.setValue(false);
                return;
            }
            var startStep = endStep - (numSteps - 1);
            if (startStep < 0)startStep = 0;
            // Make a list of dates we would like to loop.
            for (var j = 0; j < numSteps; j++) {
                _this.loopDates[j] = _this.timeRange.getDateAtTimeStep(startStep + j).toISO8601();
            }

            _this.currentAnimationStep = 0;
            // mainMap.map.setSwapBufferCount(numSteps);

            _this.busy = 0;

            _this.drawNext = function () {
                var curStep = _this.currentAnimationStep;
                var curDate = _this.loopDates[curStep];
                _this.loop();
                // mainMap.map.setDimension(_this.dim.name, _this.loopDates[_this.currentAnimationStep]);
                // error(_this.currentAnimationStep);
                // mainMap.map.addListener('onmapready', _this.loop, false);
                // mainMap.map.draw("startAnimation", _this.currentAnimationStep);
                // if(_this.loopDates[_this.currentAnimationStep]!=_this.getDateString()){_this.setDateString(_this.loopDates[_this.currentAnimationStep]);}
            }

            _this.loop = function () {
                if (_this.animateCheckBox.getValue() == false) {
                    return;
                }
                _this.isAnimating = true;
                var timeStep;
                try {
                    timeStep = _this.timeRange.getTimeStepFromISODate(_this.loopDates[_this.currentAnimationStep]);
                } catch (e) {
                    error(e);
                    error('_this.currentAnimationStep=' + _this.currentAnimationStep + ' numSteps=' + numSteps);
                }

                if (_this.currentAnimationStep == 0) {
                    // mainMap.map.resetSwapBuffers();
                    _this.animationTimer.InitializeTimer(50, _this.drawNext);
                } else {
                    if (_this.currentAnimationStep + 1 >= numberOfAnimationFrames || _this.currentAnimationStep + 1 >= numSteps) {
                        _this.currentAnimationStep = 0;
                        _this.animationTimer.InitializeTimer(200, _this.drawNext);
                    } else
                        _this.animationTimer.InitializeTimer(50, _this.drawNext);
                }
                _this.currentAnimationStep++;
            }
            _this.loop();
            // mainMap.map.draw();
        }
        _this.animateCheckBox = new Ext.form.Checkbox({
            // region:'east',
            checked: false,
            boxLabel: 'animate',
            tooltip: 'Loops 12 steps: From ' + numberOfAnimationFrames + ' steps back in time until provided time',
            listeners: {

                check: {
                    fn: function (a, checked) {
                        if (checked) {
                            _this.startAnimation();
                        } else {
                            _this.isAnimating = false;
                            if (_this.animateCheckBox.origStepBeforeAnimation) {
                                _this.slider.setValue(_this.animateCheckBox.origStepBeforeAnimation);
                            }
                            _this.sliderChanged();
                        }
                    }
                }
            }
        });
        _this.datePanel = new Ext.Panel({
            height: 36,

            layout: 'fit',
            region: 'north',
            items: [ _this.leftDatePanel ],
            border: false, frame: false

        });
        _this.sliderChanged = function () {

            if (_this.animateCheckBox.getValue() == false) {
                // JvdB mainMap.map.setSwapBufferCount(2);
                _this.setNewStep(_this.slider.getValue());
                // alert('changed');
            } else {
                _this.setNewStep(_this.slider.getValue());

                _this.startAnimation();
            }

            try {
                // filterTitle is out of scope, get it from the component
                var dateString = _this.timeRange.getDateAtTimeStep(_this.slider.getValue()).toISO8601();
                for (var i = 0; i < this.timeLayers.length; i++) {
                    this.timeLayers[i].mergeNewParams({'time': dateString});
                    this.timeLayers[i].redraw();
                }
            }
            catch (err) {
                alert('Error: ' + err.message);
            }
        }
        _this.setNewStep = function (step) {
            //error("setNewStep = '"+step+"' isNaN(step): "+isNaN(step));
            if (isNaN(step))return;
            function setNewDimValue() {

                var dateToSet = _this.timeRange.getDateAtTimeStep(step).toISO8601();
                _this.setDateString(dateToSet);

                /*_this.slider.suspendEvents();
                 _this.slider.setValue(step);
                 _this.slider.resumeEvents();*/


                //if( mainMap.map.getDimension(_this.dim.name).currentValue==dateToSet)return;//Already up to date.

                // mainMap.map.setDimension(_this.dim.name, _this.getDateString());

                // mainMap.map.draw("setNewStep " + step);
                // _this.isUptoDate=true;
                // legendWindow.loadLegendGraphic();

                //if (getFeatureInfoWindow.isVisible()) {
                //    if (mainMap.map.isMapPinVisible() == true) {
                //        var mapPinXY = mainMap.map.getMapPinXY();
                //        mainMap.map.getFeatureInfo(mapPinXY[0], mapPinXY[1]);
                //    }
                // }
            }

            setNewDimValue();
            /*if (!_this.timer) {
             setNewDimValue();
             _this.timer = new Timer();
             }
             _this.timer.InitializeTimer(2, function(){
             _this.timer = undefined;
             setNewDimValue();
             });*/

        }

        _this.setDimension = function (dim) {
            _this.dimension = dim;

            // Create a slider on basis of time
            function setSlider(isodate) {

                _this.timeRange = new parseISOTimeRangeDuration(isodate);
                _this.slider.maxValue = _this.timeRange.timeSteps;

                // if(_this.slider.maxValue==0)_this.slider.maxValue=1;
            }

            setSlider(_this.dimension.values);

//            if (!_this.dim) {
//                _this.dim = dim;
//                setSlider(_this.dim.values);
//            } else {
//                if (_this.dim.values != dim.values) {
//                    _this.dim = dim;
//
//                    setSlider(_this.dim.values);
//                    // _this.animateCheckBox.setValue(false);
//                    // _this.refreshCheckBox.setValue(false);
//                }
//            }

            var timeStep = 0;
            _this.isAnimating = _this.animateCheckBox.getValue();
            var isRefreshing = _this.refreshCheckBox.getValue();
//  JvdB          if (_this.dim.parentLayer.jumpToDimEnd == true) {
//
//                // Set latest value
//                _this.slider.mySetValue(_this.slider.maxValue);// TODO
//                _this.dim.parentLayer.jumpToDimEnd = false;
//
//            } else {
            // Set closest value
            if (_this.isAnimating == false) {
                // var currentValue = _this.getDateString();
                // JvdB currentValue = mainMap.map.getDimension(dim.name).currentValue;
                var currentValue = _this.getDateString();
                _this.setDateString(currentValue);

                timeStep = 0;
                try {
                    timeStep = _this.timeRange.getTimeStepFromISODate(currentValue);
                } catch (e) {
                    error("Unable to find closest timestep, trying to set default value " + dim.defaultValue);
                    try {
                        timeStep = _this.timeRange.getTimeStepFromISODate(dim.defaultValue);
                    } catch (e) {
                        error("Unable to set default value");
                    }
                }
                // if(timeStep==_this.slider.getValue())_this.setNewStep(timeStep);

                _this.slider.mySetValue(timeStep);

            }

            if (isRefreshing) {
                _this.refreshCheckBox.setValue(true);
            }
            if (_this.isAnimating) {
                _this.animateCheckBox.setValue(true);
            }

            // _this.slider.render();
        }

        _this.refresh = function () {

            //We need to refresh all layers.
            _this.dim.parentLayer.jumpToDimEnd = true;
            //doGetCapabilities(mainMap.map.getActiveLayer().service, mainMap.map.getActiveLayer().title, true);

            var layers = mainMap.map.getLayers();
            for (var l = 0; l < layers.length; l++) {
                doGetCapabilities(layers[l].service, layers[l].title, true, layers[l]);
            }
        }
        // JvdB _this.datePanel.setTitle("Dimension '" + _this.dimension.name + "' with units '" + _this.dimension.units + "'");
        _this.datePanel.setTitle("Dimension '" + _this.dimension.name + "' with units '" + _this.dimension.units + "'");

        Ext.apply(this, {
            height: 95,
            // title: _this.dimension.name,
            layout: 'border',
            items: [ _this.datePanel, _this.sliderPNPanel ],
//            bbar:
//                [
//                    new Ext.Button({
//                iconCls: 'button_refresh',
//                //text : 'refresh',
//                tooltip: 'Reloads the getcapabilities file, the slider will be updated with the new latest time available. ',
//                handler: _this.refresh
//            }),
//            {
//                xtype: 'tbseparator'
//            },
//            _this.refreshCheckBox,
//            {
//                xtype: 'tbseparator'
//            },
//            _this.animateCheckBox ],
            listeners: {
                activate: {
                    fn: function () {
                        // There us a bug in ext, when the tabpanel is invisible, the slider position is not updated.
                        // Here we reset it by setting it to zero and reassigning its original value on tabpanel activation.
                        var a = _this.slider.getValue();
                        _this.slider.suspendEvents();
                        _this.slider.setValue(0, false);
                        _this.slider.setValue(a, false);
                        _this.slider.resumeEvents();
                    }
                },
                collapse: {
                    fn: function () {
                        // alert('fireEvent');
                    }
                }
            }
        });

        this.setDimension(this.dimension);
        Heron.widgets.TimeRangePanel.superclass.initComponent.apply(this, arguments);
        this.slider.setValue(0, false);
        var dateToSet = this.timeRange.getDateAtTimeStep(this.slider.getValue()).toISO8601();
        this.setDateString(dateToSet);
    },
    /** method[listeners]
     *  Show qtip
     */
    listeners: {
        afterrender: function (c) {
            var map = Heron.App.getMap();
            for (var i = 0; i < this.layerNames.length; i++) {
                this.timeLayers[i] = map.getLayersByName(this.layerNames[i])[0];
            }
        }
    }
});

function Timer() {
    var timerID = null;
    var timerRunning = false;
    var delay = 10;
    var secs;
    var initsecs;
    var timehandler = '';
    var self = this;
    this.InitializeTimer = function (secstime, functionhandler) {
        // Set the length of the timer, in seconds
        secs = secstime;
        initsecs = secs;
        timehandler = functionhandler;
        StopTheClock();
        if (secs > 0)StartTheTimer();
    }
    this.ResetTimer = function () {
        secs = initsecs;
    }
    this.StopTimer = function () {
        StopTheClock();
    }
    function StopTheClock() {
        if (timerRunning)clearTimeout(timerID);
        timerRunning = false;
    }

    function TimeEvent() {
        if (timehandler != '')timehandler();
    }

    function StartTheTimer() {
        if (secs == 0) {
            StopTheClock();
            TimeEvent();
        }
        else {
            secs = secs - 1;
            timerRunning = true;
            timerID = setTimeout(function () {
                StartTheTimer();
            }, delay);
        }
    }
}

/** api: xtype = hr_timerangepanel */
Ext.reg('hr_timerangepanel', Heron.widgets.TimeRangePanel);

