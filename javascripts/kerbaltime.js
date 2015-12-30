// Generated by CoffeeScript 1.10.0
(function() {
  var EarthTime;

  EarthTime = (function() {
    EarthTime.hoursPerDay = 24;

    EarthTime.daysPerYear = 365;

    EarthTime.setDateFormat = function(newHoursPerDay, newDaysPerYear) {
      var oldDaysPerYear, oldHoursPerDay;
      oldHoursPerDay = this.hoursPerDay;
      oldDaysPerYear = this.daysPerYear;
      this.hoursPerDay = newHoursPerDay;
      this.daysPerYear = newDaysPerYear;
      return $(this).trigger('dateFormatChanged', [oldHoursPerDay, oldDaysPerYear]);
    };

    EarthTime.secondsPerDay = function() {
      return this.hoursPerDay * 3600;
    };

    EarthTime.hmsString = function(hour, min, sec) {
      if (min < 10) {
        min = "0" + min;
      }
      if (sec < 10) {
        sec = "0" + sec;
      }
      return hour + ":" + min + ":" + sec;
    };

    EarthTime.fromDuration = function(years, days, hours, mins, secs) {
      if (years == null) {
        years = 0;
      }
      if (days == null) {
        days = 0;
      }
      if (hours == null) {
        hours = 0;
      }
      if (mins == null) {
        mins = 0;
      }
      if (secs == null) {
        secs = 0;
      }
      return new EarthTime(((((+years * this.daysPerYear) + +days + (Math.floor(+years / 4))) * this.hoursPerDay + +hours) * 60 + +mins) * 60 + +secs);
    };

    EarthTime.fromDate = function(year, day, hour, min, sec) {
      if (year == null) {
        year = 0;
      }
      if (day == null) {
        day = 0;
      }
      if (hour == null) {
        hour = 0;
      }
      if (min == null) {
        min = 0;
      }
      if (sec == null) {
        sec = 0;
      }
      return this.fromDuration(+year - 1999, +day - 1, +hour, +min, +sec);
    };

    EarthTime.parse = function(dateString) {
      var components;
      components = dateString.match(/(\d+)\/(\d+)\s+(\d+):(\d+):(\d+)/);
      components.shift();
      return this.fromDate.apply(this, components);
    };

    function EarthTime(t) {
      this.t = t.constructor === EarthTime ? t.t : t;
    }

    EarthTime.prototype.hms = function() {
      var hours, mins, secs, t;
      hours = (this.t / 3600) | 0;
      t = this.t % 3600;
      mins = (t / 60) | 0;
      secs = t % 60;
      return [hours, mins, secs];
    };

    EarthTime.prototype.ydhms = function() {
      var days, hours, mins, ref, secs, years;
      ref = this.hms(), hours = ref[0], mins = ref[1], secs = ref[2];
      days = (hours / EarthTime.hoursPerDay) | 0;
      hours = hours % EarthTime.hoursPerDay;
      years = (days / EarthTime.daysPerYear) | 0;
      days = days % EarthTime.daysPerYear;
      return [years, days, hours, mins, secs];
    };

    EarthTime.prototype.toDays = function() {
      return this.t / EarthTime.secondsPerDay();
    };

    EarthTime.prototype.toDate = function() {
      var days, hours, mins, ref, secs, years;
      ref = this.ydhms(), years = ref[0], days = ref[1], hours = ref[2], mins = ref[3], secs = ref[4];
      return [years + 1, days + 1, hours, mins, secs];
    };

    EarthTime.prototype.toDateString = function() {
      var day, hour, min, ref, sec, year;
      ref = this.toDate(), year = ref[0], day = ref[1], hour = ref[2], min = ref[3], sec = ref[4];
      return "Year " + year + ", day " + day + " at " + (EarthTime.hmsString(hour, min, Math.round(sec)));
    };

    EarthTime.prototype.toShortDateString = function(t) {
      var day, hour, min, ref, sec, year;
      ref = this.toDate(), year = ref[0], day = ref[1], hour = ref[2], min = ref[3], sec = ref[4];
      return year + "/" + day + " " + (EarthTime.hmsString(hour, min, Math.round(sec)));
    };

    EarthTime.prototype.toDurationString = function(t) {
      var days, hours, mins, ref, result, secs, years;
      ref = this.ydhms(), years = ref[0], days = ref[1], hours = ref[2], mins = ref[3], secs = ref[4];
      result = "";
      if (years > 0) {
        result += years + " years ";
      }
      if (years > 0 || days > 0) {
        result += days + " days ";
      }
      return result + EarthTime.hmsString(hours, mins, Math.round(secs));
    };

    return EarthTime;

  })();

  (typeof exports !== "undefined" && exports !== null ? exports : this).EarthTime = EarthTime;

}).call(this);
