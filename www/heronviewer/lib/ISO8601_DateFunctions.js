//============================================================================
// Name        : ISO8601_datefunctions.js
// Author      : MaartenPlieger (plieger at knmi.nl)
// Version     : 0.4 (September 2010)
// Description : Functions to calculate with ISO8601 dates in javascript
//============================================================================

/*
 Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php

 Copyright (C) 2011 by Royal Netherlands Meteorological Institute (KNMI)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */


/***************************************************/
/* Object to store a time duration / time interval */
/***************************************************/
function DateInterval(year, month, day, hour, minute, second) {
    this.year = parseInt(year);
    this.month = parseInt(month);
    this.day = parseInt(day);
    this.hour = parseInt(hour);
    this.minute = parseInt(minute);
    this.second = parseInt(second);
    this.isRegularInterval = false;
    if (this.month == 0 && this.year == 0)this.isRegularInterval = true;
    this.getTime = function () {
        var timeres = 0;
        // Months and years are unequally distributed in time
        // So get time is not possible
        if (this.month != 0)throw "month != 0";
        if (this.year != 0)throw "year != 0";
        timeres += this.day * 60 * 60 * 24;
        timeres += this.hour * 60 * 60;
        timeres += this.minute * 60;
        timeres += this.second;
        timeres *= 1000;
        return timeres;
    }
    this.toISO8601 = function () {
        var isoTime = 'P';
        if (this.year != 0)isoTime += this.year + 'Y';
        if (this.month != 0)isoTime += this.month + 'M';
        if (this.day != 0)isoTime += this.day + 'D';
        if (this.hour != 0 && this.minute != 0 && this.second != 0)
            isoTime += 'T';
        if (this.hour != 0)isoTime += this.hour + 'H';
        if (this.minute != 0)isoTime += this.minute + 'M';
        if (this.second != 0)isoTime += this.second + 'S';
        return isoTime;
    }
};

/****************************************************/
/* Parses ISO8601 times to a Javascript Date Object */
/****************************************************/
function parseISO8601DateToDate(isotime) {
    /*
     The following functions are added to the standard Date object:
     - add(dateInterval) adds a DateInterval time to this time
     - substract(dateInterval) substracts a DateInterval time to this time
     - toISO8601() returns the date object as iso8601 string
     - clone() creates a copy of this object
     */
    try {
        var splittedOnT = isotime.split('T');
        var left = splittedOnT[0].split('-');
        var right = splittedOnT[1].split(':');
        var date = new Date(Date.UTC(left[0], left[1] - 1, left[2], right[0], right[1], right[2].split('Z')[0]));
        date.add = function (dateInterval) {
            if (dateInterval.isRegularInterval == false) {
                if (dateInterval.year != 0)  this.setUTCFullYear(this.getUTCFullYear() + dateInterval.year);
                if (dateInterval.month != 0) this.setUTCMonth(this.getUTCMonth() + dateInterval.month);
                if (dateInterval.day != 0)   this.setUTCDate(this.getUTCDate() + dateInterval.day);
                if (dateInterval.hour != 0)  this.setUTCHours(this.getUTCHours() + dateInterval.hour);
                if (dateInterval.minute != 0)this.setUTCMinutes(this.getUTCMinutes() + dateInterval.minute);
                if (dateInterval.second != 0)this.setUTCSeconds(this.getUTCSeconds() + dateInterval.second);
            } else {
                this.setTime(this.getTime() + dateInterval.getTime());
            }
        };
        date.substract = function (dateInterval) {
            if (dateInterval.isRegularInterval == false) {
                if (dateInterval.year != 0)  this.setUTCFullYear(this.getUTCFullYear() - dateInterval.year);
                if (dateInterval.month != 0) this.setUTCMonth(this.getUTCMonth() - dateInterval.month);
                if (dateInterval.day != 0)   this.setUTCDate(this.getUTCDate() - dateInterval.day);
                if (dateInterval.hour != 0)  this.setUTCHours(this.getUTCHours() - dateInterval.hour);
                if (dateInterval.minute != 0)this.setUTCMinutes(this.getUTCMinutes() - dateInterval.minute);
                if (dateInterval.second != 0)this.setUTCSeconds(this.getUTCSeconds() - dateInterval.second);
            } else {
                this.setTime(this.getTime() - dateInterval.getTime());
            }
        };
        date.addMultipleTimes = function (dateInterval, numberOfSteps) {
            if (dateInterval.isRegularInterval == false) {
                if (dateInterval.year != 0)  this.setUTCFullYear(this.getUTCFullYear() + dateInterval.year * numberOfSteps);
                if (dateInterval.month != 0) this.setUTCMonth(this.getUTCMonth() + dateInterval.month * numberOfSteps);
                if (dateInterval.day != 0)   this.setUTCDate(this.getUTCDate() + dateInterval.day * numberOfSteps);
                if (dateInterval.hour != 0)  this.setUTCHours(this.getUTCHours() + dateInterval.hour * numberOfSteps);
                if (dateInterval.minute != 0)this.setUTCMinutes(this.getUTCMinutes() + dateInterval.minute * numberOfSteps);
                if (dateInterval.second != 0)this.setUTCSeconds(this.getUTCSeconds() + dateInterval.second * numberOfSteps);
            } else {
                this.setTime(this.getTime() + dateInterval.getTime() * numberOfSteps);
            }
        };
        date.substractMultipleTimes = function (dateInterval, numberOfSteps) {
            if (dateInterval.isRegularInterval == false) {
                if (dateInterval.year != 0)  this.setUTCFullYear(this.getUTCFullYear() - dateInterval.year * numberOfSteps);
                if (dateInterval.month != 0) this.setUTCMonth(this.getUTCMonth() - dateInterval.month * numberOfSteps);
                if (dateInterval.day != 0)   this.setUTCDate(this.getUTCDate() - dateInterval.day * numberOfSteps);
                if (dateInterval.hour != 0)  this.setUTCHours(this.getUTCHours() - dateInterval.hour * numberOfSteps);
                if (dateInterval.minute != 0)this.setUTCMinutes(this.getUTCMinutes() - dateInterval.minute * numberOfSteps);
                if (dateInterval.second != 0)this.setUTCSeconds(this.getUTCSeconds() - dateInterval.second * numberOfSteps);
            } else {
                this.setTime(this.getTime() - dateInterval.getTime() * numberOfSteps);
            }
        };


        date.toISO8601 = function () {
            function prf(input, width) {
                //print decimal with fixed length (preceding zero's)
                var string = input + '';
                var len = width - string.length;
                var j, zeros = '';
                for (j = 0; j < len; j++)zeros += "0" + zeros;
                string = zeros + string;
                return string;
            }

            var iso = prf(this.getUTCFullYear(), 4) +
                "-" + prf(this.getUTCMonth() + 1, 2) +
                "-" + prf(this.getUTCDate(), 2) +
                "T" + prf(this.getUTCHours(), 2) +
                ":" + prf(this.getUTCMinutes(), 2) +
                ":" + prf(this.getUTCSeconds(), 2) + 'Z';
            return iso;
        }
        date.clone = function () {
            return parseISO8601DateToDate(date.toISO8601());
        }
        return date;
    }
    catch (e) {
        throw("In parseISO8601DateToDate:" + e);
    }
}

/*********************************************************/
/* Parses ISO8601 time duration to a DateInterval Object */
/*********************************************************/
function parseISO8601IntervalToDateInterval(isotime) {
    if (isotime.charAt(0) == 'P') {
        var splittedOnT = isotime.split('T');
        var years = 0, months = 0, days = 0, hours = 0;
        minutes = 0;
        seconds = 0;
        var YYYYMMDDPart = splittedOnT[0].split('P')[1];
        var HHMMSSPart = splittedOnT[1];
        //Parse the left part
        if (YYYYMMDDPart) {
            var yearIndex = YYYYMMDDPart.indexOf("Y");
            var monthIndex = YYYYMMDDPart.indexOf("M");
            var dayIndex = YYYYMMDDPart.indexOf("D");
            if (yearIndex != -1) {
                years = (YYYYMMDDPart.substring(0, yearIndex));
            }
            if (monthIndex != -1) {
                months = (YYYYMMDDPart.substring(yearIndex + 1, monthIndex));
            }
            if (dayIndex != -1) {
                var start = yearIndex;
                if (monthIndex != -1)start = monthIndex;
                days = (YYYYMMDDPart.substring(start + 1, dayIndex));
            }
        }
        //parse the right part
        if (HHMMSSPart) {
            var hourIndex = HHMMSSPart.indexOf("H");
            var minuteIndex = HHMMSSPart.indexOf("M");
            var secondIndex = HHMMSSPart.indexOf("S");
            if (hourIndex != -1) {
                hours = (HHMMSSPart.substring(0, hourIndex));
            }
            if (minuteIndex != -1) {
                minutes = (HHMMSSPart.substring(hourIndex + 1, minuteIndex));
            }
            if (secondIndex != -1) {
                var start = hourIndex;
                if (minuteIndex != -1)start = minuteIndex;
                seconds = (HHMMSSPart.substring(start + 1, secondIndex));
            }
        }
        // Assemble the dateInterval object
        var dateInterval = new DateInterval(years, months, days, hours, minutes, seconds);
        return dateInterval;
    }
}

/**********************************************************/
/* Calculates the number of time steps with this interval */
/**********************************************************/
function getNumberOfTimeSteps(starttime /*Date*/, stoptime /*Date*/, interval /*DateInterval*/) {
    var steps = 0;
    if (interval.month != 0 || interval.year != 0) {
        //In case of unequally distributed time steps...
        var testtime = starttime.clone();
        var timestopms = stoptime.getTime();
        while (testtime.getTime() < timestopms) {
            testtime.add(interval);
            steps++;
        }

        //steps++;
        return steps;
    } else {
        //In case of equally distributed time steps
        steps = parseInt(((stoptime.getTime() - starttime.getTime()) / interval.getTime()) + 0.5);

        return steps;
    }
}

//Takes "1999-01-01T00:00:00Z/2009-12-01T00:00:00Z/PT60S" as input
function parseISOTimeRangeDuration(isoTimeRangeDuration) {
    var times = isoTimeRangeDuration.split('/');
    var timeStepDateArray = new Array();
    //Some safety checks
    if (times[2] == undefined){
        times[2] = 'PT1M';
    }
    if (times[1] == undefined) {
        times[1] = times[0];
        times[2] = 'PT1M';
    }
    //Convert the dates
    this.startTime = parseISO8601DateToDate(times[0]);
    this.stopTime = parseISO8601DateToDate(times[1]);
    this.timeInterval = parseISO8601IntervalToDateInterval(times[2]);
    //Calculate the number if steps
    this.timeSteps = getNumberOfTimeSteps(this.startTime, this.stopTime, this.timeInterval);
    //
    this.getTimeSteps = function () {
        return this.timeSteps;
    };

    this.getDateAtTimeStep = function (currentStep) {
        if (this.timeInterval.isRegularInterval == false) {
            var temptime = this.startTime.clone();
            temptime.addMultipleTimes(this.timeInterval, currentStep);
            return temptime;
        } else {
            var temptime = this.startTime.clone();
            var dateIntervalTime = this.timeInterval.getTime();
            dateIntervalTime *= currentStep;
            temptime.setTime(temptime.getTime() + dateIntervalTime);
            return temptime;
        }
    }
    this.getTimeStepFromISODate = function (currentISODate) {
        try {
            currentDate = parseISO8601DateToDate(currentISODate);
        } catch (e) {
            throw("The date '" + currentISODate + "' is not a valid date");
        }
        return this.getTimeStepFromDate(currentDate);
    }

    /*Calculates the time step at the given date  */
    this.getTimeStepFromDate = function (currentDate, throwIfOutsideRange) {
        if (!throwIfOutsideRange)throwIfOutsideRange = false;

        var currentDateTime = currentDate.getTime();
        if (currentDateTime < this.startTime.getTime()) {
            if (throwIfOutsideRange == true) {
                throw "getTimeStepFromDate: requested date is earlier than this time range ";
            }
            return 0;
        }
        if (currentDateTime > this.stopTime.getTime()) {
            if (throwIfOutsideRange == true) {
                throw "getTimeStepFromDate: requested date is later than this time range ";
            }
            return this.timeSteps;
        }
        if (currentDateTime >= this.stopTime.getTime())return this.timeSteps;
        //alert(this.startTime.getTime()+"\n"+currentDateTime +"\n"+this.stopTime.getTime());
        var timeStep = 0;
        if (this.timeInterval.isRegularInterval == false) {
            var temptime = this.startTime.clone();
            for (j = 0; j <= this.timeSteps; j++) {
                var temptimeTime = temptime.getTime();
                temptime.add(this.timeInterval);
                var temptimeTime_1stepfurther = temptime.getTime();
                if (currentDateTime >= temptimeTime && currentDateTime < temptimeTime_1stepfurther)return j;
            }
            throw "Date " + currentDate.toISO8601() + " not found!";
        } else {
            timeStep = (currentDate.getTime() - this.startTime.getTime()) / this.timeInterval.getTime();
            timeStep = parseInt(timeStep + 0.5);
            return timeStep;
        }
        throw "Date " + currentDate.toISO8601() + " not found";
        return -1;
    }
    /*Returns the timestep at the currentDate, if currentdate is outside the range,
     a exception is thrown.  */
    this.getTimeStepFromDate_WithinRange = function (currentDate) {
        return this.getTimeStepFromDate(currentDate, true);
    }
    /*Returns the timestep at the currentDate, if currentdate is outside the range,
     a minimum or maximum step which lies within the time range is returned.  */
    this.getTimeStepFromDate_Clipped = function (currentDate) {
        return this.getTimeStepFromDate(currentDate, false);
    }
}

/*Example:
 function init(){
 var isodate="1999-01-01T00:00:00Z/2009-12-01T00:00:00Z/PT60S";
 //Split on '/'
 var times=isodate.split('/');
 //Some safety checks
 if(times[1]==undefined){times[1]=times[0];times[2]='PT1M';}
 //Convert the dates
 starttime=parseISO8601DateToDate(times[0]);
 stoptime=parseISO8601DateToDate(times[1]);
 interval=parseISO8601IntervalToDateInterval(times[2]);
 //Calculate the number if steps
 steps=getNumberOfTimeSteps(starttime,stoptime,interval);
 }
 */