winston = require 'winston'
_ = require 'underscore'
path = require 'path'
logger =  new winston.Logger {
  transports : [
    new winston.transports.Console
    new winston.transports.File {
      filename: path.join __dirname, '../', 'appbase.log'
    }
  ]
}

# 'log info debug warn error'

appPath = path.join __dirname, '..'
module.exports = (file) ->
  file = file.replace appPath, ''
  log = (type, args) ->
    lastItem = _.last args
    if _.isObject lastItem
      lastItem.file ?= file
    else
      args.push {
        file : file
      }
    logger[type].apply logger, args
  newLogger = {}
  _.each 'info debug error warn'.split(' '), (func) ->
    newLogger[func] = (args...) ->
      log func, args
  newLogger