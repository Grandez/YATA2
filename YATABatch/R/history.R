updateHistory = function(logoutput, loglevel) {
    browser()
    process = "history"
    logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/", process, ".log")
    pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/", process, ".pid")

    batch = YATABatch$new("History")
    fact  = batch$fact

    if (file.exists(pidfile) && !unload) return (batch$rc$RUNNING)
    cat(paste0(Sys.getpid(),"\n"), file=pidfile)

    rc    = batch$rc$OK
    count = 0
    begin = as.numeric(Sys.time())

    if (!missing(logoutput)) batch$logger$setLogOutput (logoutput)
    if (!missing(loglevel))  batch$logger$setLogLevel  (loglevel)

    batch$fact$setLogger(batch$logger)

    octc = fact$getObject(fact$CODES$object$currencies)
    hist = fact$getObject(fact$CODES$object$history)
    prov = fact$getObject(fact$CODES$object$providers)
    ctc  = octc$getCurrencies()
    rng  = hist$getRanges()
    df   = dplyr::left_join(ctc, rng, by=c("id", "symbol"))

    df$min = "2019-12-31"
    #JGG OJO AL 2021-01-01 COMO FECHA FIJA
    df[is.na(df$min), "min"] = as.Date.character("2020-01-01")
    df[is.na(df$max), "max"] = as.character(Sys.Date())

    pid  = Sys.getpid() %% 2
    from = ifelse(pid == 0, 1, nrow(ctc))
    to   = ifelse(pid == 0, nrow(ctc), 1)

    for (row in from:to) {
         if (difftime(Sys.time(), df[row,"max"], unit="days") <= 1) next
         rc2 = tryCatch({
         batch$logger$batch("%5d - Retrieving history for %s",row,df[row,"name"])
         data = prov$getHistory(df[row, "id"], df[row,"max"])
           if (!is.null(data)) {
               data$id = df[row, "id"]
               data$symbol = df[row, "symbol"]
               .add2database(data, hist$getTableHistory())
               if ((row %% 2) == 0) Sys.sleep(1) # Para cada 2
           }
           batch$rc$OK
         }, error = function(cond) {
           cat(cond$message, "\n")
           # Nada. Ignoramos errores de conexion, duplicates, etc
           batch$rc$ERRORS
        })
        if (rc2 > rc) rc = rc2
    }
    batch$logger$executed(0, begin, "Retrieving history")

    if (file.exists(pidfile)) file.remove(pidfile)
    invisible(rc)
}
