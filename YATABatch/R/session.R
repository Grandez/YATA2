# En lugar de esperar a tener todas las monedas vamos cargando bloque por bloque
.add2database = function (df, session) {
    colnames = session$getColumnNames(colnames(df))
    datafile = file.path(Sys.getenv("YATA_SITE"), "data/tmp", session$getDBTableName())
    datafile = gsub("\\\\", "/", datafile) # Lo de win/unix
    datafile = paste0(datafile, ".dat")

    write.table(df, datafile, dec=".", sep=";", quote=FALSE, row.names = FALSE, col.names=FALSE)
    res = YATAExec$new()$import(basename(datafile), "data", colnames)
    file.remove(datafile)
}
.getSessionData = function(batch, last, max, session) {
    count = 0
    dft   = NULL
    provider      = batch$fact$getObject(batch$fact$CODES$object$providers)
    tblCurrencies = batch$fact$getTable(batch$fact$CODES$tables$currencies)
    pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/start_session.pid")

    tryCatch({
       data = provider$getTickers(500, 1)
       if (max == 0) max = data$total

       repeat {
          df = data$df
          df[,c("name", "slug")] = NULL

          # Puede haber symbol repetidos (no por id)
          # Se han cambiado en la tabla de currencies
          df1 = df[,c("id", "symbol")]
          ctc = tblCurrencies$table()
          df2 = ctc[,c("id", "symbol")]
          dfs = inner_join(df1, df2, by="id")
          df2 = dfs[,c(1,3)]
          df  = left_join(df, df2, by="id")
          df$symbol = df$symbol.y
          df        = df[,-ncol(df)]

          df$last = last
          dft = rbind(dft, df)
          if (nrow(dft) > 0) .add2database(dft, session)
          count = count + nrow(dft)
          start = data$from + data$count
          if (start >= max) break;
          data = provider$getTickers(500, start)
        }
     }, error = function (cond) {
         cat("ERROR EN GETSESSION DATA - Continua\n")
     })
     count
}

#JGG NOTE
# De vez en cuando da duplicados al insertar
# El motivo no lo tengo claro, puede ser que repita datos la WEB
# Para evitar esos errores cargamos la tabla con mysql que los errores no bloquean
#
# .appendLatest = function(batch, session, last, max) {
#     browser()
#     count = 0
#
#     df = .getSessionData(batch, last, max, session)
#     if (nrow(df) == 0) return (count)
#     count = nrow(df)
#
#     colnames = session$getColumnNames(colnames(df))
#     datafile = file.path(Sys.getenv("YATA_SITE"), "data/tmp", session$getDBTableName())
#     datafile = gsub("\\\\", "/", datafile) # Lo de win/unix
#     datafile = paste0(datafile, ".dat")
#
#     write.table(df, datafile, dec=".", sep=";", quote=FALSE, row.names = FALSE, col.names=FALSE)
#     res = YATAExec$new()$import(basename(datafile), "eata", colnames)
#     file.remove(datafile)
#     count
# }
updateSession = function(max = 0) {
    count   = 0
    begin   = as.numeric(Sys.time())
    batch   = YATABatch$new("Tickers")
    pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/tickers.pid")
        logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/tickers.log")
cat(Sys.time(), "tickers", "Inicia updateSession\n", sep=";", file=logfile, append=TRUE)
    batch$fact$setLogger(batch$logger)
    if (file.exists(pidfile)) {
        cat(Sys.time(), "tickers", "Existe PID\n", sep=";", file=logfile, append=TRUE)
        return (batch$rc$RUNNING)
    }
    cat(Sys.getpid(), file=pidfile, sep="\n")
cat(Sys.time(), "tickers", "NO Existe PID\n", sep=";", file=logfile, append=TRUE)
    rc = tryCatch({
       session = batch$fact$getObject(batch$fact$CODES$object$session)

       while (count < 15) { # Para que se pare automaticamente
          batch$logger$batch("Retrieving tickers")
          last = as.POSIXct(Sys.time())
          session$updateLastUpdate(last, 0)
          total = .getSessionData(batch, last, max, session)
          cat(Sys.time(), "tickers", "Obtiene datos\n", sep=";", file=logfile, append=TRUE)
          session$updateLastUpdate(last, total)
          batch$logger$batch("OK")
          Sys.sleep(15 * 60)
          cat(Sys.time(), "tickers", "sE ACTIVA\n", sep=";", file=logfile, append=TRUE)
          count = count + 1
       }
       batch$rc$OK
    }, YATAERROR = function (cond) {
        cat(Sys.time(), "tickers", "ERROR", cond, "YATAERROR\n", sep=";", file=logfile, append=TRUE)
       batch$rc$FATAL
    }, error = function(cond) {
        cat(Sys.time(), "tickers", "ERROR", cond, "GENERAL\n", sep=";", file=logfile, append=TRUE)
       message(cond)
       batch$rc$SEVERE
    })

    if (file.exists(pidfile)) file.remove(pidfile)
    cat(Sys.time(), "tickers", "ACABA PROCESO\n", sep=";", file=logfile, append=TRUE)
    batch$logger$executed(rc, begin, "Retrieving tickers")
    invisible(rc)
}
