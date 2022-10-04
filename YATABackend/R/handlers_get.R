.getParm = function(req, parm, default) {
    p  = req$parameters_query[[parm]]
    ifelse(is.null(p), dafult, p)
}
handler_alive = function(.req, .res) {
    cat(paste(Sys.time(),"Recibe Alive\n"))
   .res$set_status_code(200)
   .res$set_body(jsonlite::toJSON("OK"))
}
FUN = function(.req, .res) {
             .res$set_status_code(200)
             .res$set_body("OK") }
best_handler = function(req, .res) {
#      message(paste("best:", Sys.time()))
    top   = .getParm(req, "top",  10)
    from  = .getParm(req, "from",  7)
    group = .getParm(req, "group", 0)
    tryCatch({
        df = best_body(top, from, group)
       .handler_ok(df, .res)
    }, error = function(e) {
      .res$set_status_code(500)
      .res$set_content_type("application/json")
      .res$set_body(jsonlite::toJSON(e))
    })
}
hist_handler = function(.req, .res) {
    #JGG Ahi que ir a History
    id   = .req$parameters_query[["id"]]
    from = .req$parameters_query[["from"]]
    to   = .req$parameters_query[["to"]]
    cat(paste(Sys.time(), " - HIST: ", id, "from: ", from, "to: ", to, "\n"))
    tryCatch({
       fact = YATACore::YATAFactory$new()
       hist = fact$getObject(fact$codes$object$history)
       df   = hist$getHistory(id, from, to)
       message("HIST OK")
       message(df)
      .handler_ok(df, .res)
    }, error = function(e) {
        message("HIST ERROR")
        print(e)
      .res$set_status_code(500)
      .res$set_content_type("text/html")
      .res$set_body("KO")
    }, finally =  {
        fact$clear()
        .res
    })
}
latest_handler = function(.req, .res) {
   from  = .req$parameters_query[["from"]]
   limit = .req$parameters_query[["limit"]]

   message(Sys.time(), " latest Called")
   df = tryCatch({
       browser()
      message(Sys.time(), " Antes de FACTORY")
      fact = YATACore::YATAFactory$new(level=2) # Providers
      message(Sys.time(), " Antes de Provider")
      prov = fact$getDefaultProvider()
      message(Sys.time(), " Antes de getTickers")
      df = prov$getTickers(max=limit,from = from)

      message(Sys.time(), paste(" Despues de getTickers ", nrow(df)))
      .handler_ok(df$df, .res)
   }, error = function(cond) {
       message(Sys.time(), cond$message)
      .handler_ko(cond, .res)
   })
}
trending_handler = function(.req, .res) {
    browser()
   logger("trending")
   tryCatch({
     fact = YATACore::YATAFACTORY$new(level=2)
     prov = fact$getDefaultProvider()

     df   = prov$getTrend()
     .handler_ok(df, .res)
   }, error = function(cond) {
      .res$set_status_code(500)
      .res$set_content_type("text/html")
      .res$set_body("KO")
   })
}
.handler_ok = function(df, .res) {
    message("entra en el OK")
  .res$set_status_code(200)
  .res$set_content_type("application/json")
    message("entra en el set_body")
  .res$set_body(jsonlite::toJSON(df, data.frame = "rows"))
    message("sale set body")
    .res
}
.handler_ko = function(cond, .res) {
    browser()
    data = list(
        status = 500
        ,message = cond$message
    )
    .res$set_status_code(500)
    .res$set_content_type("application/json")
    .res$set_body(jsonlite::toJSON(data, pretty=TRUE))
}
