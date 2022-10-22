get_latest = function(.req, .res) {
    id   = .getParm(.req, "id")

   if (is.null(id)) return (.missingParms(.res))

    tryCatch({
        factory   = YATADBCore::DBFactory$new()
        tbl = factory$getTable("Session")
        .setResponse(.res, tbl$current)
    }, error = function(cond) {
        browser()
        .setError(.res, cond)
    }, finally = function() {
        factory$destroy()
    })
}
