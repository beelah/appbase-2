jtRedis = require 'jtredis'

redis = 
  init : (setting) ->
    jtRedis.configure 'redis', setting
  getClient : (name) ->
    jtRedis.getClient name
module.exports = redis