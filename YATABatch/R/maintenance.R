updateExchanges = function (logoutput, loglevel) {
    browser()
    process = "exchanges"
    logLbl  = "%5d - Retrieving exchanges pairs for %s\n"
    logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/", process, ".log")

    count = 0
    begin = as.numeric(Sys.time())
    batch = YATABatch$new(process)

    if (!missing(logoutput)) batch$logger$setLogOutput (logoutput)
    if (!missing(loglevel))  batch$logger$setLogLevel  (loglevel)

    fact  = batch$fact
    batch$fact$setLogger(batch$logger)

    objExch  = fact$getObject(fact$CODES$object$exchanges)
    objProv  = fact$getDefaultProvider()

    df = objExch$getExchanges()
    #hasta aqui
    row = 1
    browser()
    while (row <= nrow(df)) {
         tryCatch({
           batch$logger$batch(sprintf(logLbl, row, df[row,"name"]))
           data = objProv$getExchangeMarkets(df[row,"slug"])
           objExch$deletePairs(df[row,"idExch"])
           .add2database(data, objExch$getTablePairs())
        }, error = function(cond) {
            browser()
            cat(cond$message, "\n")
            # Nada. Ignoramos errores de conexion, duplicates, etc
        })
        row = row + 1
    }
    batch$logger$executed(0, begin, "Retrieving history")

    if (file.exists(pidfile)) file.remove(pidfile)
    invisible(batch$rc$OK)
}

updateExchangesPairs = function (logoutput, loglevel) {
    process = "exchange_pairs"
    logLbl  = "%5d - Retrieving exchange pairs for %s\n"
    logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/", process, ".log")

    count = 0
    begin = as.numeric(Sys.time())
    batch = YATABatch$new(process)

    if (!missing(logoutput)) batch$logger$setLogOutput (logoutput)
    if (!missing(loglevel))  batch$logger$setLogLevel  (loglevel)

    fact  = batch$fact
    batch$fact$setLogger(batch$logger)

    objExch  = fact$getObject(fact$CODES$object$exchanges)
    objProv  = fact$getDefaultProvider()

    df = objExch$getExchanges()
    row = 1
    browser()
    while (row <= nrow(df)) {
         tryCatch({
           batch$logger$batch(sprintf(logLbl, row, df[row,"name"]))
           data = objProv$getExchangeMarkets(df[row,"slug"])
           objExch$deletePairs(df[row,"idExch"])
           .add2database(data, objExch$getTablePairs())
        }, error = function(cond) {
            browser()
            cat(cond$message, "\n")
            # Nada. Ignoramos errores de conexion, duplicates, etc
        })
        row = row + 1
    }
    batch$logger$executed(0, begin, "Retrieving history")

    if (file.exists(pidfile)) file.remove(pidfile)
    invisible(batch$rc$OK)
}
