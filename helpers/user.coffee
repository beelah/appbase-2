mongodb = require './mongodb'
async = require 'async'
_ = require 'underscore'
crypto = require 'crypto'
try
  Canvas = require 'canvas'
  Image = Canvas.Image
catch e
  console.error e
uuid = require 'node-uuid'


###*
 * getVerificationCode 获取验证码（验证码图片以base64的数据返回）
 * @return {[type]} [description]
###
getVerificationCode = ->
  getCode = ->
    charList = 'ABCDEFGHJKLMNPQRSTUVWXYZ123456789'.split ''
    _.sample charList, 4

  getFont = ->
    fontSize = _.random 16, 20
    "bold #{fontSize}px Georgia"

  getColor = ->
    _.sample ['rgb(8, 33, 225)', 'rgb(225, 146, 8)', 'rgb(225, 33, 8)', 'rgb(237, 38, 126)', 'rgb(5, 49, 16)']

  getRandomTransform = ->
    value = _.random -15, 15
    value / 100
  if !Canvas
    {
      code : '1234'
      data : ''
    }
  else
    code = getCode()
    imageWidth = 50
    imageHeight = 20
    canvas = new Canvas imageWidth, imageHeight
    ctx = canvas.getContext '2d'
    start = 0
    _.each code, (ch) ->
      ctx.font = getFont()
      ctx.fillStyle = getColor()
      ctx.fillText ch, start, 15, imageWidth
      # ctx.transform 1, getRandomTransform(), getRandomTransform(), 1, 0, 0
      start += 10
    {
      code : code.join ''
      data : canvas.toDataURL()
    }

###*
 * get 获取用户数据（参数等同于mongoose model的find）
 * @param  {[type]} args... [description]
 * @return {[type]}         [description]
###
module.exports.get = (args...) ->
  User = mongodb.model 'User'
  User.find.apply User, args
###*
 * getOne 获取一条符合条件的用户数据（参数等同于mongoose model的findOne）
 * @param  {[type]} args... [description]
 * @return {[type]}         [description]
###
module.exports.getOne = (args...) ->
  User = mongodb.model 'User'
  User.findOne.apply User, args
###*
 * add 添加一个用户
 * @param {[type]} data 用户信息
 * @param {[type]} cbf  [description]
###
module.exports.add = (data, cbf) ->
  User = mongodb.model 'User'
  async.waterfall [
    (cbf) =>
      @exists data.account, cbf
    (exists, cbf) ->
      if exists
        err = new Error 'the account has been registered'
        err.msg = '该用户名已被注册'
        cbf err
      else
        new User(data).save cbf
  ], cbf
###*
 * exists 判断该账号是否已存在
 * @param  {[type]} account 账号
 * @param  {[type]} cbf     [description]
 * @return {[type]}         [description]
###
module.exports.exists = (account, cbf) ->
  User = mongodb.model 'User'
  User.findOne {account : account}, (err, doc) ->
    if err || !doc
      cbf err, false
    else
      cbf null, true
###*
 * login 用户登录（验证用户密码是否正确）
 * @param  {[type]} data     [description]
 * @param  {[type]} userInfo [description]
 * @param  {[type]} cbf      [description]
 * @return {[type]}          [description]
###
module.exports.login = (data, userInfo, cbf) ->
  @getOne {account : data.account}, (err, doc) ->
    if err
      cbf err
    else if !doc
      err = new Error 'the account is not exists'
      err.msg = '用户不存在！'
      cbf err
    else
      shasum = crypto.createHash 'sha1'
      if data.pwd == shasum.update(doc.pwd + userInfo.uuid).digest 'hex'
        cbf null, doc
      else
        err = new Error 'the password is wrong'
        err.msg = '用户名或密码错误'
        cbf err

###*
 * getInfoForFrontend 从当前用户信息中获取部分信息给前端用（一些可公开的信息）
 * @param  {[type]} userInfo 用户信息
 * @return {[type]}          [description]
###
module.exports.getInfoForFrontend = (userInfo) ->
  if userInfo.account
    data = 
      account : userInfo.account
      nick : userInfo.nick
  else
    userInfo.verificationCode = getVerificationCode() if !userInfo.verificationCode
    # userInfo.verificationCode = {} if !userInfo.verificationCode
    userInfo.uuid = uuid.v4() if !userInfo.uuid
    data = 
      uuid : userInfo.uuid
      imgData : userInfo.verificationCode.data
