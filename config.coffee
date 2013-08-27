setting = require './setting'
fs = require 'fs'
path = require 'path'
_ = require 'underscore'
jtRedis = require 'jtredis'


program = require 'commander'

# 初始化redis
if setting.redis
  require('./helpers/redis') setting.redis

# 初始化mongodb
if setting.mongodb
  require('./helpers/mongodb') setting.mongodb

sessionParser = null

isProductionMode = process.env.NODE_ENV == 'production'
host = '*'
staticMaxAge = 1
if isProductionMode
  staticMaxAge = 48 * 3600 * 1000
  staticVersion = fs.readFileSync path.join __dirname, '/version'
  if _.isArray setting.host
    host = setting.host
  else
    host = [setting.host]
  if setting.staticHosts
    if _.isArray setting.staticHosts
      staticHosts = setting.staticHosts
    else
      staticHosts = [setting.staticHosts]
    host = host.concat staticHosts
  convertExts = 
    src : ['.coffee', '.styl']
    dst : ['.js', '.css']

config = 
  getAppPath : ->
    __dirname
  sessionParser : ->
    sessionParser
  getStaticsHost : ->
    if @isProductionMode
      null
    else
      null
  isProductionMode : isProductionMode

  host : host
  express : 
    set : 
      'view engine' : 'jade'
      views : "#{__dirname}/views"
  static : 
    path : "#{__dirname}/statics"
    urlPrefix : '/static'
    mergePath : "#{__dirname}/statics/temp"
    mergeUrlPrefix : 'temp'
    maxAge : staticMaxAge
    version : staticVersion
    hosts : staticHosts
    convertExts : convertExts
    mergeList : [
      ['/javascripts/utils/underscore.js', '/javascripts/utils/async.js']
    ]
  route : ->
    require './routes'
  session : ->
    key : 'vicanso'
    secret : 'jenny&tree'
    ttl : 30 * 60
    client : jtRedis.getClient 'vicanso'
    complete : (parser) ->
      sessionParser = parser

module.exports = config

