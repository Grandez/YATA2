best_handler = function(.req, .res) {
      writeLines(paste("best:", Sys.time()))

    qryTop   = .req$parameters_query[["top"]]
    top      = ifelse(is.null(qryTop),10, as.integer(qryTop))
    qryFrom  = .req$parameters_query[["from"]]
    from     = ifelse(is.null(qryFrom), 1, as.integer(qryFrom))
      message("best - top: ", top, "- from: ", from)
    df = best_body(top, from)
    .df_handler(df, .res)
}
besttop_handler = function(.req, .res) {
    writeLines(paste("besttop:", Sys.time()))

    qryTop   = .req$parameters_query[["top"]]
    top      = ifelse(is.null(qryTop),10, as.integer(qryTop))
    qryFrom  = .req$parameters_query[["from"]]
    from     = ifelse(is.null(qryFrom), 1, as.integer(qryFrom))
      message("besttop - top: ", top, "- from: ", from)
    df = best_body(top, from, TRUE)
    .df_handler(df, .res)
}

hist_handler = function(.req, .res) {
    writeLines(paste("hist:", Sys.time()))
    id   = .req$parameters_query[["id"]]
    from = .req$parameters_query[["from"]]
    to   = .req$parameters_query[["to"]]
    writeLines(paste("hist id: ", id, "from: ", from, "to: ", to))
    df = hist_body(id, from, to)
    .df_handler(df, .res)
}

latest_handler = function(.req, .res) {
    message(Sys.time(), "latest Called")
    df = latest_body()
    .df_handler(df, .res)
}

update_handler = function(.req, .res) {
    message(Sys.time(), "update Called")
    update_body()
}

.df_handler = function(df, .res) {
  .res$set_content_type("application/json")
  .res$set_body(jsonlite::toJSON(df, data.frame = "rows"))
}
