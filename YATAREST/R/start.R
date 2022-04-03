start = function(port) {
    rc = tryCatch({
    fout = paste0(Sys.getenv("YATA_SITE"),"/data/log/rest.log")
    fpid = paste0(Sys.getenv("YATA_SITE"),"/data/wrk/rest.pid")
    if(!file.exists(fout)) file.create(fout, showWarnings = FALSE)
    cat(Sys.getpid(), "\n", file=fpid)
    sink(fout)
    fact = YATACore::YATAFactory$new()

    YATARest = YATAREST$new()
    if (missing(port)) port = YATARest$getPort()
    backend = BackendRserve$new()
    backend$start(YATARest, http_port = port, background = FALSE)
0
    }, error = function(cond){
        cat("ERROR GORDO\n")
        cat(cond$message)
        cat("\n")
        16
    })
    cat("Acaba REST")
    if (file.exists(fpid)) file.remove(fpid)
    sink()
    if (rc > 0) stop("HA ACABADO CON ERROR")
    rc
}
