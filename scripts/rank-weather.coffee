# Description:
#   A list of locations, sorted by temperature. Eg. hubot rank weather in Zürich, Helsinki, London, Munich.
#
# Configuration:
#   HUBOT_WEATHER_CELSIUS - Display in celsius
#   HUBOT_FORECAST_API_KEY - Forecast.io API Key
#
# Commands:
#   hubot rank weather <cities> - Display a list of locations, sorted by temperature.
#
# Author:
#   lewisnyman
env = process.env

forecastIoUrl = 'https://api.forecast.io/forecast/' + process.env.HUBOT_FORECAST_API_KEY + '/'
googleMapUrl = 'http://maps.googleapis.com/maps/api/geocode/json'

class LocationData
  constructor: (msg, name) ->
    @name = name
    @msg = msg
    @lookupAddress(@lookupWeather)

  # Convert a text address into coordinates using GoogleMapAPI.
  lookupAddress: (callback) =>
    @msg.http(googleMapUrl).query(address: @name, sensor: true)
      .get() (err, res, body) =>
        body = JSON.parse body
        @coords = body.results[0].geometry.location
        callback()

  # Retrive weather data for a set of coordinates using ForecastIoAPI.
  lookupWeather: (callback) =>
    return @msg.send "You need to set env.HUBOT_FORECAST_API_KEY to get weather data" if not env.HUBOT_FORECAST_API_KEY

    url = forecastIoUrl + @coords.lat + ',' + @coords.lng

    @msg.http(url).query(units: 'ca').get() (err, res, body) =>
      return @msg.send 'Could not get weather data for: #{location}' if err
      try
        body = JSON.parse body
        current = body.currently
      catch err
        return @msg.send "Could not parse weather data."
      @info = {
        current : current
        humidity : (current.humidity * 100).toFixed 0
      }
      if env.HUBOT_WEATHER_CELSIUS
        @info.tempSuffix = "ºC"
      else
        @info.tempSuffix = "ºF"
      @info.temperature = @getTemp(current.temperature)
      @info.text = "#{@name}: #{@info.temperature}#{@info.tempSuffix} #{@info.current.summary}, #{@info.humidity}% humidity"
      return @

  getTemp: (c) ->
    if env.HUBOT_WEATHER_CELSIUS
      return c.toFixed(0)
    return ((c * 1.8) + 32).toFixed(0)

class WeatherRank
  constructor: (robot) ->
    @robot = robot
    @locations = []

  # Check that all the location data has been populated.
  checkData: ->
    @complete = true
    for location in @locations
      if (!location.info?)
        @complete = false
    return @complete

  # Sort locations by temperature.
  sortData: ->
    @locations.sort( (location1, location2) ->
      return location2.info.temperature -  location1.info.temperature;
    )
    return @

  # Output the location data.
  outputData: (msg) ->
    for location in @locations
      msg.send location.info.text

module.exports = (robot) ->

  robot.respond /rank weather\s(?:me|for|in)?\s(.*)/i, (msg) ->
    wrank = new WeatherRank robot
    wrank.locations = msg.match[1].split(',');
    for location, i in wrank.locations
      wrank.locations[i] = new LocationData(msg, location)

    timer = setInterval( ->
      complete = wrank.checkData()
      if complete
        clearInterval(timer)
        wrank.sortData().outputData(msg)
    , 1000)


