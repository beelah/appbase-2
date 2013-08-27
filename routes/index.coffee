config = require '../config'
appPath = config.getAppPath()
pageContentHandler = require "#{appPath}/helpers/page_content_handler"


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