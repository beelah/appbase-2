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
]

module.exports = routeInfos