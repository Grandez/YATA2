updateHistory = function(output=1, log=1) {
    logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/history.log")
    pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/history.pid")
    batch   = YATABatch$new("History")

    cat(Sys.time(), "history", "Inicia updateHistory\n", sep=";", file=logfile, append=TRUE)
    if (file.exists(pidfile)) {
        cat(Sys.time(), "history", "EXISTE pid file\n", sep=";", file=logfile, append=TRUE)
        return (batch$rc$RUNNING)
    }
    cat(Sys.getpid(), file=pidfile, sep="\n")
    cat(Sys.time(), "history", "No existe pid file\n", sep=";", file=logfile, append=TRUE)

    count = 0
    begin = as.numeric(Sys.time())

    batch$fact$setLogger(batch$logger)

    fact = YATACore::YATAFactory$new()
    octc = fact$getObject(fact$CODES$object$currencies)
    hist = fact$getObject(fact$CODES$object$history)
    prov = fact$getObject(fact$CODES$object$providers)
    ctc  = octc$getCurrencies()
    rng  = hist$getRanges()
    df   = left_join(ctc, rng, by=c("id", "symbol"))
    #JGG OJO AL 2021-01-01 COMO FECHA FIJA
    df[is.na(df$min), "min"] = as.Date.character("2021-01-01")
    df[is.na(df$max), "max"] = as.Date.character("2021-01-01")
    cat(Sys.time(), "history", "Antes del for\n", sep=";", file=logfile, append=TRUE)
    for (row in 1:nrow(ctc)) {
         tryCatch({
    cat(Sys.time(), "history", sprintf("%5d - Retrieving history for %s\n", row, df[row,"name"]), sep=";", file=logfile, append=TRUE)
           batch$logger$batch("%5d - Retrieving history for %s", row, df[row,"name"])
           data = prov$getHistory(df[row, "id"], df[row,"max"])
           if (!is.null(data)) {
               if (difftime(Sys.time(), df[1,"max"], unit="days") >= 2) {
                   cat(Sys.time(), "history", "Inserta datos\n", sep=";", file=logfile, append=TRUE)
                   data$id = df[row, "id"]
                   data$symbol = df[row, "symbol"]
                   hist$add(data)
                   if ((row %% 2) == 0) Sys.sleep(1) # Para cada 2
               } else {
                   cat(Sys.time(), "history", "No hay datos\n", sep=";", file=logfile, append=TRUE)
               }
           }
           else {
               cat(Sys.time(), "history", "data es NULL\n", sep=";", file=logfile, append=TRUE)
           }
        }, error = function(cond) {
            cat(Sys.time(), "history", "ERROR", cond, sep=";", file=logfile, append=TRUE)
            # Nada. Ignoramos errores de conexion, duplicates, etc
        })
    }
    cat(Sys.time(), "history", "Acaba for\n", sep=";", file=logfile, append=TRUE)
    batch$logger$executed(0, begin, "Retrieving history")
    if (file.exists(pdifile)) file.remove(pidfile)
    invisible(batch$rc$OK)
}
