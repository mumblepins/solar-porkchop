class EarthTime
  # Default to Earth time
  @hoursPerDay: 24
  @daysPerYear: 365
  
  @setDateFormat: (newHoursPerDay, newDaysPerYear) ->
    oldHoursPerDay = @hoursPerDay
    oldDaysPerYear = @daysPerYear
    @hoursPerDay = newHoursPerDay
    @daysPerYear = newDaysPerYear
    $(@).trigger('dateFormatChanged', [oldHoursPerDay, oldDaysPerYear])
  
  @secondsPerDay: -> @hoursPerDay * 3600
  
  @hmsString: (hour, min, sec) ->
    min = "0#{min}" if min < 10
    sec = "0#{sec}" if sec < 10
    "#{hour}:#{min}:#{sec}"
  
  @fromDuration: (years = 0, days = 0, hours = 0, mins = 0, secs = 0) ->
    new EarthTime(((((+years * @daysPerYear) + +days + (+years // 4)) * @hoursPerDay + +hours) * 60 + +mins) * 60 + +secs)
  
  @fromDate: (year = 0, day = 0, hour = 0, min = 0, sec = 0) ->
    @fromDuration(+year - 1999, +day - 1, +hour, +min, +sec)
  
  @parse: (dateString) ->
    components = dateString.match(/(\d+)\/(\d+)\s+(\d+):(\d+):(\d+)/)
    components.shift()
    @fromDate(components...)

  constructor: (t) ->
    @t = if t.constructor == EarthTime then t.t else t
  
  hms: ->
    hours = (@t / 3600) | 0
    t = @t % 3600
    mins = (t / 60) | 0
    secs = t % 60
    [hours, mins, secs]
  
  ydhms: ->
    [hours, mins, secs] = @hms()
    days = (hours / EarthTime.hoursPerDay) | 0
    hours = hours % EarthTime.hoursPerDay
    years = (days / EarthTime.daysPerYear) | 0
    days = days % EarthTime.daysPerYear
    [years, days, hours, mins, secs]
  
  toDays: ->
    @t / EarthTime.secondsPerDay()
    
  toDate: ->
    [years, days, hours, mins, secs] = @ydhms()
    [years + 1999, days + 1, hours, mins, secs]
  
  toDateString: ->
    [year, day, hour, min, sec] = @toDate()
    if year >= 1
      "#{year} CE, Day #{day} at #{EarthTime.hmsString(hour, min, Math.round(sec))}"
    else
      year = 1 - year
      "#{year} BCE, Day #{day} at #{EarthTime.hmsString(hour, min, Math.round(sec))}"

  toShortDateString: (t) ->
    [year, day, hour, min, sec] = @toDate()
    "#{year}/#{day} #{EarthTime.hmsString(hour, min, Math.round(sec))}"

  toDurationString: (t) ->
    [years, days, hours, mins, secs] = @ydhms()
    result = ""
    result += years + " years " if years > 0
    result += days + " days " if years > 0 or days > 0
    result + EarthTime.hmsString(hours, mins, Math.round(secs))

(exports ? this).EarthTime = EarthTime
