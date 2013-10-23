JTMongoose = require 'jtmongoose'
client = null
path = require 'path'
logger = require('./logger') __filename
statistics = require './statistics'


mongodb =
  init : (setting) ->
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
    client.enableProfiling 'distinct count findAndModify findAndRemove find findOne mapReduce group geoNear geoHaystackSearch'.split ' '


  model : (modelName) ->
    if !client
      throw new Error 'must be call init function before use model'
      return 
    client.model modelName
    # jtMongoose.model @dbName, modelName

module.exports = mongodb  

