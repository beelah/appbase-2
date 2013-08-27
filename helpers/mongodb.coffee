jtMongoose = require 'jtmongoose'

options =
  db : 
    native_parser : true
  server :
    poolSize : 5


module.exports = (setting) ->
  jtMongoose.init setting.dbName, setting.uri, options