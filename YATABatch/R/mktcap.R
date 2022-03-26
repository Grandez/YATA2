# MarketCap identifica las monedas por un id
# Tambien apunta a su icono
# Pero con el webscrapping no funciona bien
# Bajamos con el inspector la tabla y la parseamos

unloadCurrencies = function(max=3000, verbose=25) {
    # max es el numero de monedas a guardar
    tmsBeg = Sys.time()
    fact   = NULL
    rc     = 0
    nctc   = 0
    setVerbose(verbose)
    tryCatch({
       fact = YATACore::YATAFACTORY$new()
       dirtmp = tempdir()
       fileName = paste0("/currencies_",strftime(Sys.Date(),"%Y%m%d"), ".csv")
       outFile  = normalizePath(paste0(dirtmp,fileName), mustWork = FALSE)
       nctc     = .writeCurrencies(fact, outFile, max)
       scripts  = .createScript   (fact, dirtmp, outFile)
       log(1, "Executing scripts")
      .scriptSQL(script=scripts$loader, connInfo=scripts$conn)
    }
    ,error = function (e) {
        message("FALLA CON EL TEMA DE PASARLE USUARIO Y PASSWORD")
        rc = 16
        err("Procesando Currencies")
        cont("INFO: %s", e)
    }
    ,finally = function() {
       .deleteFiles(outFile, scripts)
       fact$clear()
    })
    summary(1, "%d exchanges procesados", nctc)
    summary(2, "Elapsed: %s", elapsed(tmsBeg, Sys.time()))

    rc
}
.writeCurrencies = function(fact, outFile, max) {
    log(1, "Retrieving currencies from CoinMarketCap")
    fOut = file(outFile, open="wt", blocking=FALSE)
    prov = fact$getProvider("MKTCAP", "MarketCap")

    start = 1
    limit = 1000
    nrows = 0
    while (start < max) {
       log(2, "Retrieving 1000 currencies from %d", start)
       df = prov$unloadCurrencies(start,1000)
       nrows = nrows + nrow(df)
       add = ifelse(start == 1, FALSE, TRUE)
       write.table( df[,c("id", "name", "symbol", "slug","rank")]
                   ,fOut
                   ,append=add
                   ,row.names=FALSE, col.names=FALSE
                   ,fileEncoding = "UTF-8", sep=",")
       start = start + limit
    }
    close(fOut)
    nrows
}
.createScript = function(fact, dirtmp, outFile) {
    browser()
    if (Sys.info()["sysname"] == "Windows") outFile = gsub("\\", "\\\\", outFile, fixed=TRUE)
    log(1, "Generating scripts to load data")
    info = fact$parms$getDBInfo(0)
    loader = normalizePath(paste0(dirtmp, "/load.sql"), mustWork = FALSE)
    fLoader = file(loader, open="wt", blocking=FALSE)
    writeLines(paste("USE", info$dbname, ";"), fLoader)
    writeLines(paste0("LOAD DATA LOCAL INFILE '", outFile, "'"), fLoader)
    writeLines("REPLACE"                                   , fLoader)
    writeLines("INTO TABLE CURRENCIES"                     , fLoader)
    writeLines("FIELDS TERMINATED BY ',' ENCLOSED BY '\"'" , fLoader)
    if (Sys.info()["sysname"] == "Windows") {
        writeLines("LINES TERMINATED BY '\\r\\n'"          , fLoader)
    }
    writeLines("(ID, NAME, SYMBOL, SLUG, RANK)"            , fLoader)
    writeLines(";"                                         , fLoader)
    close(fLoader)

    conn = normalizePath(paste0(dirtmp, "/cnx.cnf"), mustWork = FALSE)
    fConn = file(conn, open="wt", blocking=FALSE)
    writeLines("[client]", fConn)
    writeLines(paste0("user="    , info$user)    , fConn)
    writeLines(paste0("password=", info$password), fConn)
    close(fConn)

    list(loader=loader, conn=conn)
}
# updateID = function(pattern,verbose="silent") {
#     raiz = dirname(pattern)
#     pat  = paste0(basename(pattern), ".+\\.txt$")
#     files = list.files(raiz,pat,full.names=TRUE)
#     for (file in files) processFile(file, verbose)
# }
#
# processFile = function(file, verbose) {
#     if (verbose != "silent") message("Procesando ", basename(file))
#     data = readLines(file)
#     lines = unlist(lapply(data, function(x) strsplit(data, "<tr", fixed=TRUE)))
#     datos = lines[grepl("coin-logo", lines, fixed=TRUE)]
#     message("Hay ", length(datos), " iconos")
#     res = lapply(datos, function(x) parseRow(x))
#     updData(res, verbose)
# #    file.rename(file, paste0(file, ".ok"))
# }
# parseRow = function(fila) {
#     cols = strsplit(fila, "<td")
#     cols = cols[[1]]
#      datos = cols[grepl("coin-logo", cols, fixed=TRUE)]
#      if (length(datos) > 0) {
#          datos = datos[[1]]
#          idx    = str_locate(datos[[1]], "https.+png")
#          icon   = substr(datos[[1]], idx[1],idx[2])
#          idx    = str_locate(icon, "/[0-9]+\\.png")
#          id     = substr(icon, idx[1]+1,idx[2]-4)
#          idx    = str_locate_all(datos[[1]],">[a-zA-Z0-9 ]+</p>")
#          idx    = idx[[1]]
#          if (length(idx) != 4) {
#              name   = substr(datos[[1]], idx[1]+1,idx[2]-4)
#              symbol = substr(datos[[1]], idx[1]+1,idx[2]-4)
#          }
#          else {
#              name   = substr(datos[[1]], idx[1,1]+1,idx[1,2]-4)
#              symbol = substr(datos[[1]], idx[2,1]+1,idx[2,2]-4)
#          }
#      }
#      list(id=id, name=name, symbol=symbol, icon=icon)
# }
# updData = function(info, verbose) {
# #    furl = file("P:/R/YATA2/YATAExt/bin/geticons.bat", open="at",blocking=FALSE)
#         furl = "P:/R/YATA2/YATAExt/bin/geticons.bat"
#     # fact = YATACore::YATAFACTORY$new()
#     # db = fact$getDBBase()
#     # db$begin()
#     # tblCurr = YATAFactory$getTable(YATACodes$tables$Currencies)
#     # tblExch = YATAFactory$getTable(YATACodes$tables$Exchanges)
#     for (idx in 1:length(info)){
#         change = FALSE
#         item = info[[idx]]
#         ic   = paste0(item$symbol, ".png")
#         # res  = tblCurr$select(id=item$symbol)
#         # tryCatch({
#         #    if (res) {
#         #        if (is.na(tblCurr$current$key) || tblCurr$current$key == 0) {
#         #            change = TRUE
#         #            tblCurr$set(key=item$id, icon=ic)
#         #            tblCurr$apply()
#         #        }
#         #    }
#         #    else {
#         #        change = TRUE
#         #        tblCurr$add(list(id=item$symbol, name=item$name, prty=item$id, icon=ic))
#         #    }
#         #    res = tblExch$select(camera="MKTCAP", symbol=item$symbol)
#         #    if (!res) {
#         #        tblExch$add(list(camera="MKTCAP", symbol=item$symbol, id=item$id))
#                 if (verbose == "detail") message("\tAdded ", item$id, item$name)
#         #    }
#         # }, error = function(e) message("ERROR: ", e))
#         # if (change) {
#             stmt = "timeout 2 ;"
#             stmt = paste(stmt, paste("curl", item$icon, "-o", paste0(item$id, "_", ic)))
#             write(stmt ,file=furl, append=TRUE)
#         # }
#     }
#  #   db$commit()
# #    close(furl)
#  #   fact$finalize()
# }
#
#}
