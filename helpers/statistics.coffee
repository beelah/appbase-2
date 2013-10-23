_ = require 'underscore'
moment = require 'moment'
logger = require('./logger') __filename
statistics =
  dataList : []
  save : ->
    mongodb = require './mongodb'
    dataList = @dataList
    @dataList = []
    Statistics = mongodb.model 'Statistics'
    Statistics.collection.insert dataList, (err) ->
      logger.error err if err

  add : (data) ->
    if @dataList.length >= 10
      @save()
    else
      data.date = new Date if !data.date
      date = moment data.date
      formatDate =
        _year : date.format 'YYYY'
        _month : date.format 'MM'
        _day : date.format 'DD'
        _hour : date.format 'hh'
        _minute : date.format 'mm'
      _.extend data, formatDate
      @dataList.push data

module.exports = statistics