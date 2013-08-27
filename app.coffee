program = require 'commander'
jtCluster = require 'jtcluster'

do ->
  program.version('0.0.1')
  .option('-p, --port <n>', 'listen port', parseInt)
  .parse process.argv


options = 
  # 检测的时间间隔
  interval : 60 * 1000
  # worker检测的超时值
  timeout : 5 * 1000
  # 连续失败多少次后重启
  failTimes : 5
  slaveHandler : ->
    jtApp = require 'jtapp'
    path = require 'path'
    setting = 
      launch : [
        __dirname
      ]
      middleware : 
        mount : '/healthchecks'
        handler : ->
          (req, res) ->
            res.end 'success'
      port : program.port || 10000
    jtApp.init setting, (err, app) ->
      console.error err
  error : (err) ->
    console.error err.stack
  beforeRestart : (cbf) ->
    console.warn 'the server will be restart!'
    GLOBAL.setImmediate ->
      cbf null
if process.env.NODE_ENV == 'production'
  jtCluster.start options
else
  options.slaveHandler()
