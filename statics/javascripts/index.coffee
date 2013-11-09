$ ->
  if window.location.pathname == '/long/improve'
    $.get('/long/improve').success (res) ->

  if window.location.pathname == '/long/faster'
    $.get('/long/faster').success (res) ->
      

  option1 =
    url : '/ajax1'
  option2 = 
    url : '/ajax2'
    type : 'post'
    data : 
      pwd : '12345'
  MergeAjax.handler option1, (data) ->
    console.dir data
  MergeAjax.handler option2, (data) ->
    console.dir data


window.MergeAjax =
  interval : 10
  options : []
  cbfs : []
  handler : (option, cbf) ->
    @options.push option
    @cbfs.push cbf
    _.delay =>
      if @options.length
        resultCbfs = @cbfs
        opts = 
          data : @options
        $.ajax {
          type : 'post'
          url : '/mergeajax'
          data : opts
          success : (data) ->
            _.each resultCbfs, (cbf, i) ->
              cbf data[i]
        }
        @options = []
        @cbfs = []
    , @interval
