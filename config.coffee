setting = require './setting'
fs = require 'fs'
path = require 'path'
_ = require 'underscore'
statistics = require './helpers/statistics'
logger = require('./helpers/logger') __filename
redis = require './helpers/redis'

getStaticConfig = ->
  if isProductionMode
    if setting.staticHosts
      if _.isArray setting.staticHosts
        staticHosts = setting.staticHosts
      else
        staticHosts = [setting.staticHosts]
    # 单位 秒
    staticMaxAge = 48 * 3600 
    staticVersion = fs.readFileSync path.join __dirname, '/version'
    convertExts = 
      src : ['.coffee', '.styl']
      dst : ['.js', '.css']
  config =
    path : "#{__dirname}/statics"
    urlPrefix : '/static'
    mergePath : "#{__dirname}/statics/temp"
    mergeUrlPrefix : 'temp'
    maxAge : staticMaxAge
    version : staticVersion
    hosts : staticHosts
    convertExts : convertExts
    headers : 
      'v-ttl' : '1800s'
    mergeList : [
      ['/javascripts/utils/underscore.js', '/javascripts/utils/async.js']
    ]

getHost = ->
  host = '*'
  if isProductionMode
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
  host

httpResponseTimeLogger = ->
  (req, res, next) ->
    return next() if res.jt_responseTime
    start = new Date
    res.jt_responseTime = true

    res.on 'header', ->
      duration = new Date - start
      result = 
        type : 'http'
        method : req.method
        params : req.url
        statusCode : res.statusCode || 200
        date : new Date
        length : res._headers['content-length']
        elapsedTime : duration
      statistics.add result
    next()


# 初始化redis
if setting.redis
  redis.init setting.redis

# 初始化mongodb
if setting.mongodb
  require('./helpers/mongodb').init setting.mongodb


isProductionMode = process.env.NODE_ENV == 'production'


config = 
  init : (app) ->
    app.locals.title = '大树工作室'
    if isProductionMode
      app.locals.LOCAL =
        staticHost : 's.jennyou.com'
    else
      app.locals.LOCAL = {}
    logger.info "server is running..."
  firstMiddleware : httpResponseTimeLogger
  host : getHost()
  express : 
    set : 
      'view engine' : 'jade'
      'trust proxy' : true
      views : "#{__dirname}/views"
  static : getStaticConfig()
  firstMiddleware : httpResponseTimeLogger
  route : ->
    require './routes'
  session : ->
    key : 'vicanso'
    secret : 'jenny&tree'
    ttl : 30 * 60
    client : redis.getClient 'vicanso'
    complete : (parser) ->
      config.sessionParser = ->
        parser


module.exports = config

