start = function(port) {
    if (.Platform$OS.type != "windows") {
        sink("/tmp/yata_rest.log", append=TRUE)
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
    backend$start(YATARest, http_port = port)
}
