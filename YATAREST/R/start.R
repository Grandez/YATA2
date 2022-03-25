start = function(port) {
    browser()
    if (.Platform$OS.type != "windows") {
        #sink("/tmp/yata_rest.log", append=TRUE)
        sink("/srv/yata/YATAExternal/log/yata_rst.log")
    } else {
        sink("P:/R/YATA2/REST.log", append=TRUE)
    }
       fact = YATACore::YATAFactory$new()
       assign("Factory",   fact,       envir=.GlobalEnv)
       assign("YATACodes",   fact$CODES,       envir=.GlobalEnv)

    YATARest = YATAREST$new()
    if (missing(port)) {
        port = YATARest$getPort()
    }
    backend = BackendRserve$new()
    backend$start(YATARest, http_port = port, background = FALSE)
}
