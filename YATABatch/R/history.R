loadHistoryBackward = function(interval=20, verbose) {
    # Carga desde la ultima sesion hasta ayer
    batch$begin()
    batch$setVerbose(verbose)
    history = batch$fact$getObject(batch$codes$object$history)
    df = history$getRanges()
    if (nrow(df) == 0) {
        message("System is up-to-date")
        batch$end(batch$NODATA)
    }
    df[is.na(df$min), "min"] = Sys.Date() - 1

    for (row in 1:nrow(df)) {
         message(sprintf("%5d Retrieving %20s - %s", row, df[row,"symbol"], df[row, "name"]))
         if(.addHistory(history, df[row,"id"], df[row, "symbol"], df[row,"min"] - 30, df[row,"min"]))
            Sys.sleep(interval)
    }
    message("proceso acabado")
    batch$end(batch$OK)
}
loadHistoryForward = function(interval=20, verbose) {
    # Carga desde la ultima sesion hasta ayer
    browser()
    batch$begin()
    batch$setVerbose(verbose)
    history = batch$fact$getObject(batch$codes$object$history)
    df = history$getRanges()
    df[is.na(df$max), "max"] = Sys.Date() - 30
    to = Sys.Date() - 1
    df = df[df$max < (to - 1),]
    if (nrow(df) == 0) {
        message("System is up-to-date")
        batch$end(batch$NODATA)
    }
    for (row in 1:nrow(df)) {
         message(sprintf("%5d Retrieving %20s - %s", row, df[row,"symbol"], df[row, "name"]))
         if(.addHistory(history, df[row,"id"], df[row, "symbol"], df[row,"max"] + 1, to))
            Sys.sleep(interval)
    }
    message("proceso acabado")
    batch$end(batch$OK)
}
.chkMissingDaysCTC = function(ctc, history) {
    days = history$getSessionDays(ctc)
    days$diff = rollapply(days$tms, 2, function(x) x[1] - x[2], fill=0, align="right")
    days = days[days$diff < -1,]
    if (nrow(days) > 0) days$ctc = ctc
    days
}
checkMissingDays = function(verbose) {
    # Busca los datos de history que tienen saltos
    batch$begin()
    batch$setVerbose(verbose)
    history = batch$fact$getObject(batch$codes$object$history)
    ctcs = history$getActiveCurrencies()
    res = sapply(ctcs$symbol, .chkMissingDaysCTC, history)
    pending = res[lapply(res, nrow) > 0]
    if (nrow(pending) > 0) {
        pending = merge(pending, ctcs)
        pending$from = pending$tms + 1
        pending$to   = pending$tms - (pending$diff - 1)
    }
    browser()
    message("proceso acabado")
    batch$end(batch$OK)
}
loadHistoryInit = function(verbose) {
    browser()
    tmsBeg = Sys.time()
    setVerbose(verbose)
    history = batch$fact$getObject(batch$codes$object$history)
    browser()
    df = history$getRanges()
    browser()

}
.addHistory = function(history, id, symbol, from, to) {
   session = batch$fact$getObject(batch$codes$object$session)
   df = session$getHistorical("EUR", id, from, to)
   if (is.null(df))   { message("Datos son NULL"); return(FALSE) }
   if (nrow(df) == 0) { message("No hay datos");   return(FALSE) }

   df$tms = as.Date(df$tms)
   df$symbol = symbol
   history$addBulk(df)
   TRUE
}

