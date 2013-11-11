program = require 'commander'
do ->
  program.version('0.0.1')
  .option('-p, --port <n>', 'listen port', parseInt)
  .option('--log <n>', 'the log file')
  .parse process.argv

JTCluster = require 'jtcluster'
JTMonitor = require 'jtmonitor'
statistics = require './helpers/statistics'
logger = require('./helpers/logger') __filename
slaveTotal = require('os').cpus().length - 1
mailer = require './helpers/mailer'

options = 
  # 检测的时间间隔
  interval : 60 * 1000
  # worker检测的超时值
  timeout : 5 * 1000
  # 连续失败多少次后重启
  failTimes : 5
  slaveTotal : require('os').cpus().length - 1
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
      logger.error if err

    jtMonitor = new JTMonitor
    jtMonitor.on 'log', (data) ->
      data.type = 'monitor'
      data._jtPid = process._jtPid if process._jtPid
      data.pid = process.pid
      statistics.add data
    jtMonitor.start {
      checkInterval : 30 * 1000
      # node使用内存的预警线，单位MB
      memoryLimits : [80, 150, 300]
      # os load平均值（使用每5分钟的平均值，以单核为准，若多核会根据CPU核数自动调整数值）
      loadavgLimits : [0.6, 0.65, 1]
      # 空闲内存，单位MB,若为小数则表示系统总内存*该值
      freeMemoryLimits : [0.9, 512, 256]
      # 这里的实现方法在windows下面检测不了
      cpuUsageLimits : [30, 50, 80]
    }
  beforeRestart : (cbf) ->
    logger.info 'the server will be restart!'
    GLOBAL.setImmediate ->
      cbf null
if process.env.NODE_ENV == 'production'
  jtCluster = new JTCluster
  jtCluster.start options
  jtCluster.on 'error', (err) ->
    logger.error err if err
  jtCluster.on 'log', (log) ->
    if log
      logger.info log
      # if log.category == 'uncaughtException'
      #   发送email
else
  options.slaveHandler()

