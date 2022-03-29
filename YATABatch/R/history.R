updateHistory = function(output=1, log=1) {
    pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/start_history.pid")
    batch   = YATABatch$new("History", output, log)

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
    df   = left_join(ctc, rng, by=c("id", "symbol"))
    #JGG OJO AL 2021-01-01 COMO FECHA FIJA
    df[is.na(df$min), "min"] = as.Date.character("2021-01-01")
    df[is.na(df$max), "max"] = as.Date.character("2021-01-01")
    for (row in 1:nrow(ctc)) {
         tryCatch({
           batch$logger$batch("%5d - Retrieving history for %s", row, df[row,"name"])
           data = prov$getHistory(df[row, "id"], df[row,"max"])
           if (!is.null(data)) {
               if (difftime(Sys.time(), df[1,"max"], unit="days") >= 2) {
                   data$id = df[row, "id"]
                   data$symbol = df[row, "symbol"]
                   hist$add(data)
                   if ((row %% 2) == 0) Sys.sleep(1) # Para cada 2
               }
           }
        }, error = function(cond) {
            # Nada. Ignoramos errores de conexion, duplicates, etc
        })
   }
    batch$logger$executed(0, begin, "Retrieving history")
    if (file.exists(pdifile)) file.remove(pidfile)
    invisible(batch$rc$OK)
}
