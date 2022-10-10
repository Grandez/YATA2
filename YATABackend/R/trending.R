trending = function(req, .res) {
#      message(paste("best:", Sys.time()))
    period   = .getParm(req, "period",  1)
    top  = .getParm(req, "top",  30)
    group = .getParm(req, "group", 0)
    tryCatch({
        factory   = YATADBCore::DBFactory$new()
        tbl = factory$getTable("Trending")
        df = tbl$table(period = period)
        df = df[1:top,]
        status = list(
            status = 0
            ,count = nrow(df)
        )
        df = best_body(top, from, group)
       .handler_ok(df, .res)
    }, error = function(e) {
      .res$set_status_code(500)
      .res$set_content_type("application/json")
      .res$set_body(jsonlite::toJSON(e))
    })
}
#  jj=paste('{"data":', j1,',"status":', j2,'}')
