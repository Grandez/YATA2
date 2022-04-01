# En lugar de esperar a tener todas las monedas vamos cargando bloque por bloque
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
           cat("ENTRA EN REPEAT\n")
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
         cat("ERROR EN GETSESSION DATA", cond$code, " - Continua\n")
     })
     count
}
updateSession = function(max = 0) {
    count   = 0
    begin   = as.numeric(Sys.time())
    batch   = YATABatch$new("Tickers")
    rc      = batch$rc$OK
    pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/tickers.pid")
        logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/tickers.log")
cat(Sys.time(), "tickers", "Inicia updateSession\n", sep=";")
cat(Sys.time(), "tickers", "Inicia updateSession\n", sep=";", file=logfile, append=TRUE)
    batch$fact$setLogger(batch$logger)
    # if (file.exists(pidfile)) {
    #     cat(Sys.time(), "tickers", "Existe PID\n", sep=";")
    #     cat(Sys.time(), "tickers", "Existe PID\n", sep=";", file=logfile, append=TRUE)
    #     return (batch$rc$RUNNING)
    # }
    cat(Sys.getpid(), file=pidfile, sep="\n")
    cat(Sys.time(), "tickers", "NO Existe PID\n", sep=";")
cat(Sys.time(), "tickers", "NO Existe PID\n", sep=";", file=logfile, append=TRUE)

   session = batch$fact$getObject(batch$fact$CODES$object$session)

#   while (count < 15) { # Para que se pare automaticamente
   while (count < 5) { # Para que se pare automaticamente
      rc0 = tryCatch({
               batch$logger$batch("Retrieving tickers")
               last = as.POSIXct(Sys.time())
               session$updateLastUpdate(last, 0)
               total = .getSessionData(batch, last, max, session)
               cat(Sys.time(), "tickers", "Obtiene datos\n", sep=";")
               cat(Sys.time(), "tickers", "Obtiene datos\n", sep=";", file=logfile, append=TRUE)
               session$updateLastUpdate(last, total)
               batch$logger$batch("OK")
               #Sys.sleep(15 * 60)
               Sys.sleep(2 * 60)
               cat(Sys.time(), "tickers", "sE ACTIVA\n", sep=";")
               cat(Sys.time(), "tickers", "sE ACTIVA\n", sep=";", file=logfile, append=TRUE)
               count = count + 1
               batch$rc$OK
            }, YATAERROR = function (cond) {
               cat(Sys.time(), "tickers", "ERROR", "YATAERROR\n", sep=";", file=logfile, append=TRUE)
                       for (i in names(cond)) cat(Sys.time(), "tickers", "ERROR", cond$i, "\n", sep=";")
               cat(Sys.time(), "tickers", "ERROR", "YATAERROR\n", sep=";")
               batch$rc$FATAL
            }, error = function(cond) {
               cat(Sys.time(), "tickers", "ERROR")
               for (i in names(cond)) cat(Sys.time(), "tickers", "ERROR", cond$i, "\n", sep=";")
               cat(Sys.time(), "tickers", "ERROR", "GENERAL\n", sep=";", file=logfile, append=TRUE)
              batch$rc$SEVERE
            })
      if (rc0 > rc) rc = rc0
   }

  if (file.exists(pidfile)) file.remove(pidfile)
  cat(Sys.time(), "tickers", "ACABA PROCESO\n", sep=";")
  cat(Sys.time(), "tickers", "ACABA PROCESO\n", sep=";", file=logfile, append=TRUE)
  batch$logger$executed(rc, begin, "Retrieving tickers")
  invisible(rc)
}
