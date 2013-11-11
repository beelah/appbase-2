module.exports =
  schema : 
    account : 
      type : String
      require : true
      unique : true
      index : true
    pwd : 
      type : String
      require : true
    nick : 
      type : String
  options :
    strict : false