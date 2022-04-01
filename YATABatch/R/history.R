updateHistory = function(output=1, log=1) {
    logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/history.log")
    pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/history.pid")

    batch   = YATABatch$new("History")
    if (file.exists(pidfile)) return (batch$rc$RUNNING)

    count = 0
    begin = as.numeric(Sys.time())

    batch$fact$setLogger(batch$logger)

    fact = YATACore::YATAFactory$new()
    octc = fact$getObject(fact$CODES$object$currencies)
    hist = fact$getObject(fact$CODES$object$history)
    prov = fact$getObject(fact$CODES$object$providers)
    ctc  = octc$getCurrencies()
    rng  = hist$getRanges()
    df   = dplyr::left_join(ctc, rng, by=c("id", "symbol"))

    #JGG OJO AL 2021-01-01 COMO FECHA FIJA
    df[is.na(df$min), "min"] = as.Date.character("2021-01-01")
    df[is.na(df$max), "max"] = as.Date.character("2021-01-01")
    pid = Sys.getpid() %% 2
    from = ifelse(pid == 0, 1,         nrow(ctc))
    to   = ifelse(pid == 0, nrow(ctc), 1)

    for (row in from:to) {
         tryCatch({
           batch$logger$batch("%5d - Retrieving history for %s", row, df[row,"name"])
           if (difftime(Sys.time(), df[row,"max"], unit="days") <= 1) next
           data = prov$getHistory(df[row, "id"], df[row,"max"])
           if (!is.null(data)) {
               data$id = df[row, "id"]
               data$symbol = df[row, "symbol"]
               .add2database(data, hist)
               if ((row %% 2) == 0) Sys.sleep(1) # Para cada 2
           }
        }, error = function(cond) {
            # Nada. Ignoramos errores de conexion, duplicates, etc
        })
    }
    batch$logger$executed(0, begin, "Retrieving history")

    if (file.exists(pidfile)) file.remove(pidfile)
    invisible(batch$rc$OK)
}
