_ = require 'underscore'
async = require 'async'

pageContentHandler = 
  index : (req, res, cbf) ->
    viewData = 
      title : '首页测试'
    cbf null, viewData
  mobile : (req, res, cbf) ->
    viewData =
      title : '手机页测试'
    cbf null, viewData

module.exports = pageContentHandler