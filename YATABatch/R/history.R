updateHistory = function(output=1, log=1, unload=FALSE) {
    browser()
    logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/history.log")
    pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/history.pid")

    batch   = YATABatch$new("History")
    if (file.exists(pidfile) && !unload) return (batch$rc$RUNNING)
    cat(paste0(Sys.getpid(),"\n"), file=pidfile)
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

    #JGG Chapu para guardar en tabla o descargar
    if (unload) {
        df$min = "2020-01-01"
        df$max = "1999-12-31"
    } else {
        #JGG OJO AL 2021-01-01 COMO FECHA FIJA
        df[is.na(df$min), "min"] = as.Date.character("2020-01-01")
        df[is.na(df$max), "max"] = as.character(Sys.Date())
    }
    pid = Sys.getpid() %% 2
    from = ifelse(pid == 0, 1,         nrow(ctc))
    to   = ifelse(pid == 0, nrow(ctc), 1)

    for (row in from:to) {

         tryCatch({
           cat(sprintf("%5d - Retrieving history for %s\n", row, df[row,"name"]))
           batch$logger$batch("%5d - Retrieving history for %s", row, df[row,"name"])
           if (difftime(Sys.time(), df[row,"max"], unit="days") <= 1) next
           data = prov$getHistory(df[row, "id"], df[row,"max"])
           if (!is.null(data)) {
               data$id = df[row, "id"]
               data$symbol = df[row, "symbol"]
               .add2database(data, hist, unload=unload, sfx=row)
               if ((row %% 2) == 0) Sys.sleep(1) # Para cada 2
           }
        }, error = function(cond) {
            cat(cond$message, "\n")
            # Nada. Ignoramos errores de conexion, duplicates, etc
        })
    }
    batch$logger$executed(0, begin, "Retrieving history")

    if (file.exists(pidfile)) file.remove(pidfile)
    invisible(batch$rc$OK)
}
