best_handler = function(.req, .res) {
    message(Sys.time(), "best Called")
    qryTop   = .req$parameters_query[["top"]]
    top      = ifelse(is.null(qryTop),10, as.integer(qryTop))
    qryFrom  = .req$parameters_query[["from"]]
    from     = ifelse(is.null(qryFrom), 1, as.integer(qryFrom))
    df = best_body(top, from)
    .res$set_content_type("application/json")
    .res$set_body(jsonlite::toJSON(df, data.frame = "rows"))
}

latest_handler = function(.req, .res) {
    message(Sys.time(), "latest Called")
    browser()
    df = latest_body()
    browser()
    # execLatest()
}

