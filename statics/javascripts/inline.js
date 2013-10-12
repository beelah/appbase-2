window.TIME_LINE = {
  logs : {},
  startTimes : {},
  time : function(tag){
    this.startTimes[tag] = new Date().getTime();
    return this;
  },
  timeEnd : function(tag, startTag){
    var startTimes = this.startTimes;
    var start = startTimes[tag] || startTimes[startTag];
    if(start){
      this.logs[tag] = new Date().getTime() - start;
    }
    return this;
  },
  getLogs : function(){
    return this.logs;
  }
};