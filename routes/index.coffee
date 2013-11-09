config = require '../config'
pageContentHandler = require '../helpers/page_content_handler'


routeInfos = [
  {
    route : '/'
    template : 'index'
    handler : pageContentHandler.index
  }
  {
    route : ['/cat/:cat', '/cat/:cat/page/:page']
    template : 'index'
    handler : pageContentHandler.index
  }
  {
    route : '/mobile'
    template : 'mobile'
    handler : pageContentHandler.mobile
  }
  {
    route : '/save'
    type : 'post'
    handler : pageContentHandler.save
  }
  {
    route : '/long'
    template : 'index'
    handler : pageContentHandler.long
  }
  {
    route : '/long/improve'
    template : 'index'
    handler : pageContentHandler.improve
  }
  {
    route : '/long/faster'
    template : 'index'
    handler : pageContentHandler.faster
  }
  {
    route : '/ajax1'
    handler : pageContentHandler.ajax1
  }
  {
    route : '/ajax2'
    type : 'post'
    handler : pageContentHandler.ajax2
  }
  {
    route : '/mergeajax'
    type : 'post'
    handler : pageContentHandler.mergeajax
  }
]

module.exports = routeInfos