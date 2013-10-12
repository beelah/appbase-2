jtMongoose = require 'jtmongoose'
path = require 'path'
requireTree = require 'require-tree'
async = require 'async'
_ = require 'underscore'
_s = require 'underscore.string'
logger = require './logger'

options =
  db : 
    native_parser : true
  server :
    poolSize : 5

mongodb =
  init : (setting) ->
    dbName = setting.dbName
    jtMongoose.init dbName, setting.uri, options

    jtMongoose.on dbName, 'connected', ->
      logger.info 'connected'
    jtMongoose.on dbName, 'disconnected', ->
      logger.warn 'disconnected'

    models = requireTree path.join __dirname, '../models'

    _.each models, (model, name) ->
      name = _s.capitalize name
      schema = jtMongoose.schema dbName, name, model.schema
      if model.indexes
        _.each model.indexes, (args) ->
          schema.index.apply schema, args

      jtMongoose.model dbName, name, schema
    @dbName = dbName


  model : (modelName) ->
    jtMongoose.model @dbName, modelName

module.exports = mongodb  

