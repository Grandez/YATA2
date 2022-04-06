updateHistory = function(logoutput, loglevel, backward=FALSE) {
#JGG
#  PARECE QUE HA HABIDO CAMBIOS Y SOLO DEVUELVE HASTA 180/1 DIAS EN LUGAR DE TODO EL RANGO
#  y QUE ADEMAS SOLO DA UN AGNO
#  ESTO NO ES PROBLEMA EN CONDICIONES NORMALES QUE SOLO PEDIMOS UNOS DIAS
#  PERO SI PARA PROCESOS MAS MASIVOS
#  ASI QUE IREMOS POR BUCLES DE 90 DIAS
#  ADEMAS HAY UN PROBLEMCA CON LOS BUFFERS DE LOS FICHEROS
#  A VECES SE LANZA EL IMPORT ANTES DE QUE SE HAYAN ACABADO DE GRABAR LOS DATOS
#  ALGORITMO:
#     - SI EL RANGO HA RECUPERAR ES MAYOR QUE UNO DADO
#         - LO PARTIMOS EN TROZOS (EVITAR EL LIMITE DE 180)
#         - EJECUTAMOS DE NUEVO LA DETECCION DEL RANGO EXISTENTE (EVITAR PROBLEMA DE BUFFER)
#         - SI HAY FALLO EN EL PROCESO PASAMOS AL SIGUIENTE (EVITAR SALTOS)

    process = "history"
    logfile = paste0(Sys.getenv("YATA_SITE"), "/data/log/", process, ".log")
    pidfile = paste0(Sys.getenv("YATA_SITE"), "/data/wrk/", process, ".pid")

    batch = YATABatch$new("History")
    fact  = batch$fact

    #if (file.exists(pidfile) && !unload) return (batch$rc$RUNNING)
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

    #JGG OJO AL 2021-12-31 COMO FECHA FIJA
    df[is.na(df$min), "min"] = as.Date.character("2021-12-31")
    df[is.na(df$max), "max"] = as.Date.character("2021-12-31")

    pid  = Sys.getpid() %% 2
    from = ifelse(pid == 0, 1, nrow(ctc))
    to   = ifelse(pid == 0, nrow(ctc), 1)

    byChunks = FALSE
    for (row in from:to) {
       if (difftime(Sys.time(), df[row,"max"], unit="days") <= 1) next
       rc2 = tryCatch({
           batch$logger$batch("%5d - Retrieving history for %s",row,df[row,"name"])
           repeat {
               to = Sys.Date()
               byChunk = FALSE
               if (as.integer(to - df[row,"max"], unit="days") > 121) {
                   to = as.Date(df[row,"max"]) + 121
                   byChunk = TRUE
               }
               data = prov$getHistory(df[row, "id"], as.Date(df[row,"max"]) + 1, to)
               if (!is.null(data)) {
                   data$id = df[row, "id"]
                   data$symbol = df[row, "symbol"]
                   .add2database(data, hist)
                    if ((row %% 2) == 0) Sys.sleep(1) # Para cada 2
               }
               if (!byChunk) break
               rng  = hist$getRanges(df[row,"id"])
               if (nrow(rng) == 0 || is.na(rng[1,"max"])) {
                   df[row,"max"] = "2019-12-31"
               } else {
                   df[row,"max"] = rng[1,"max"]
               }
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
