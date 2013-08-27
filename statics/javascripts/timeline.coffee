window.TIME_LINE = 
  logs : {}
  startTimes : {}
  time : (tag) ->
    @startTimes[tag] = new Date().getTime();
    @
  timeEnd : (tag, startTag) ->
    startTimes = @startTimes
    start = startTimes[tag] || startTimes[startTag]
    if start
      @logs[tag] = new Date().getTime() - start
    @
  getLogs : () ->
    @logs