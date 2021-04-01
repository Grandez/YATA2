.getParm = function(req, parm, default) {
    p  = req$parameters_query[[parm]]
    ifelse(is.null(p), dafult, p)
}
best_handler = function(req, .res) {
      writeLines(paste("best:", Sys.time()))
    top   = .getParm(req, "top",  10)
    from  = .getParm(req, "from",  7)
    group = .getParm(req, "group", 0)
    tryCatch({
        df = best_body(top, from, group)
       .df_handler(df, .res)
    }, error = function(e) {
      .res$set_status_code(500)
      .res$set_content_type("application/json")
      .res$set_body(jsonlite::toJSON(e))
    })
}
hist_handler = function(.req, .res) {
    writeLines(paste("hist:", Sys.time()))
    id   = .req$parameters_query[["id"]]
    from = .req$parameters_query[["from"]]
    to   = .req$parameters_query[["to"]]
    writeLines(paste("hist id: ", id, "from: ", from, "to: ", to))
    tryCatch({
        browser()
       fact = YATACore::YATAFACTORY$new()
       sess = fact$getObject(fact$codes$object$session)
       df   = sess$getHistorical("EUR", id,from,to)
      .df_handler(df, .res)
    }, error = function(e) {
      .res$set_status_code(500)
      .res$set_content_type("application/json")
      .res$set_body(jsonlite::toJSON(e))
    }, finally =  {
        fact$clear()
    })
}

latest_handler = function(.req, .res) {
    message(Sys.time(), "latest Called")
    df = latest_body()
    .df_handler(df, .res)
}

update_handler = function(.req, .res) {
    message(Sys.time(), "update Called")
    tryCatch({
       fact = YATACore::YATAFACTORY$new()
       sess = fact$getObject(fact$codes$object$session)
       sess$updateLatest()
      .res$set_status_code(200)
      .res$set_content_type("text/plain")
      .res$set_body("OK")
    }, error = function(e) {
      .res$set_status_code(500)
      .res$set_content_type("text/plain")
      .res$set_body(e)
    }, finally =  {
        fact$clear()
    })
    .res
}

.df_handler = function(df, .res) {
  .res$set_status_code(200)
  .res$set_content_type("application/json")
  .res$set_body(jsonlite::toJSON(df, data.frame = "rows"))
}
