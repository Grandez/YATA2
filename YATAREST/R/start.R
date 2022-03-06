start = function(port) {
    if (.Platform$OS.type != "windows") {
        sink("tmp/yata_rest.log", append=TRUE)
    }

    YATARest = YATAREST$new()
    if (missing(port)) {
        port = YATARest$getPort()
    }
    backend = BackendRserve$new()
    backend$start(YATARest, http_port = port)
}
