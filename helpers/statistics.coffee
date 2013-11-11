_ = require 'underscore'
moment = require 'moment'
logger = require('./logger') __filename
debug = require('debug') 'statistics'
dataList = []

###*
 * save 保存统计数据（当统计数据达到10条时，才保存一次）
 * @return {[type]} [description]
###
save = ->
  mongodb = require './mongodb'
  tmpDataList = dataList
  dataList = []
  Statistics = mongodb.model 'Statistics'
  Statistics.collection.insert tmpDataList, (err) ->
    logger.error err if err

###*
 * add 添加一条统计记录（只有在统计记录达到10条时，才写到数据库中）
 * @param {[type]} data [description]
###
module.exports.add = (data) ->
  if dataList.length >= 10
    save()
  else
    data.date = new Date if !data.date
    debug 'statistics: %j', data
    dataList.push data

