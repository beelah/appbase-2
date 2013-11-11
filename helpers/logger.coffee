winston = require 'winston'
_ = require 'underscore'
path = require 'path'
program = require 'commander'
transports = []
if process.env.NODE_ENV != 'production'
  transports.push new winston.transports.Console
if program.log
  transports.push new winston.transports.File {
    filename : program.log
  }
logger =  new winston.Logger {
  transports : transports
}

appPath = path.join __dirname, '..'

###*
 * exports 用于返回一个looger对象，有info debug error warn方法，主要用于方便输出log时带上文件名
 * @param  {[type]} file [description]
 * @return {[type]}      [description]
###
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