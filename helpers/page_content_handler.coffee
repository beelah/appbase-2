_ = require 'underscore'
async = require 'async'
config = require '../config'
request = require 'request'

pageContentHandler = 
  index : (req, res, cbf) ->
    viewData = 
      title : '首页测试'
    cbf null, viewData
  mobile : (req, res, cbf) ->
    viewData =
      title : '手机页测试'
    cbf null, viewData
  save : (req, res, cbf) ->
    cbf null, {
      msg : 'success'
    }
  long : (req, res, cbf) ->
    async.parallel [
      (cbf) ->
        getData1 1, cbf
      (cbf) ->
        getData2 2, cbf
    ], (err, data) ->
      viewData =
      title : '手机页测试'
      cbf null, viewData
  improve : (req, res, cbf) ->
    if req.xhr
      getData2 2, cbf
    else
      getData1 1, (err, data) ->
        viewData =
          title : '手机页测试'
        cbf null, viewData
  faster : (req, res, cbf) ->
    if req.xhr
      getData3 3, cbf
    else
      getData3 3, ->
      getData1 1, (err, data) ->
        viewData =
          title : '手机页测试'
        cbf null, viewData
  ajax1 : (req, res, cbf) ->
    console.dir req.url
    cbf null, {
      ajax : 1
    }
  ajax2 : (req, res, cbf) ->
    console.dir req.url
    cbf null, {
      ajax : 2
    }
  mergeajax : (req, res, cbf) ->
    app = config.app
    body = req.body
    funcs = _.map body.data, (option) ->
      (cbf) ->
        url = "http://localhost:10000#{option.url}"
        if option.type == 'post'
          request.post url, {form : option.data}, (err, res, data) ->
            cbf err, data
        else
          request.get url, (err, res, data) ->
            cbf err, data
    async.parallel funcs, (err, result) ->
      cbf err, result

getData1 = (id, cbf) ->
  _.delay ->
    cbf null, {a : 1}
  , 1000

getData2 = (id, cbf) ->
  _.delay ->
    cbf null, {b : 2}
  , 2000

getData3 = async.memoize getData2

module.exports = pageContentHandler