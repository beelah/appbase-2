jtRedis = require 'jtredis'
module.exports = (setting) ->
  jtRedis.configure
    redis : setting