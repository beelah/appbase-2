JTMongoose = require 'jtmongoose'
client = null
path = require 'path'
logger = require('./logger') __filename
statistics = require './statistics'

###*
 * init 初始化数据库，自动初始化models下面的schema
 * @param  {[type]} setting [description]
 * @return {[type]}         [description]
###
module.exports.init = (setting) ->
  options =
    db : 
      native_parser : true
    server :
      poolSize : 5
  client = new JTMongoose setting.uri, options
  client.on 'log', (data) ->
    logger.info data.method
  client.on 'profiling', (data) ->
    data.type = 'mongodb'
    statistics.add data
  client.initModels path.join __dirname, '../models'
  # 对这些函数启用性能记录
  client.enableProfiling 'distinct count findAndModify findAndRemove find findOne mapReduce group geoNear geoHaystackSearch'.split ' '

###*
 * model 获取mongoose的model
 * @param  {[type]} modelName model的名字（根据models中的文件名生成，首字母大写）
 * @return {[type]}           [description]
###
module.exports.model = (modelName) ->
  if !client
    throw new Error 'must be call init function before use model'
    return 
  client.model modelName

