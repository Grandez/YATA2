get_history = function(.req, .res) {
#      message(paste("best:", Sys.time()))
    browser()
    id   = .getParm(.req, "id")
    from  = .getParm(.req, "from")
    to  = .getParm(.req, "to")

    if (is.null(id) || is.null(from) || is.null(to)) {
        data = json_to(NULL, "data")
        status = list(rc=400, message="missing parameters")
        .setResponse(.res, data, status)
        return()
    }
    tryCatch({
        factory   = YATADBCore::DBFactory$new()
        tbl = factory$getTable("History")
        df = tbl$recordset(id=list(value=id), tms=list(op="between", value=c(from, to)))
        .setResponse(.res, df)
    }, error = function(cond) {
        .setError(.res, cond)
    }, finally = function() {
        factory$destroy()
    })
}
#  jj=paste('{"data":', j1,',"status":', j2,'}')
