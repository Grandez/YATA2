start = function(port) {
    YATARest = YATAREST$new()
    if (missing(port)) {
        port = YATARest$getPort()
    }
    backend = BackendRserve$new()
    backend$start(YATARest, http_port = port)
}
