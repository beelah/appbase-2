config = require '../config'
pageContentHandler = require '../helpers/page_content_handler'


routeInfos = [
  {
    route : '/'
    template : 'index'
    handler : pageContentHandler.index
  }
  {
    route : '/mobile'
    template : 'mobile'
    handler : pageContentHandler.mobile
  }
]

module.exports = routeInfos