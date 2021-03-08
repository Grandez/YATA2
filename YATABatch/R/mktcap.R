# MarketCap identifica las monedas por un id
# Tambien apunta a su icono
# Pero con el webscrapping no funciona bien
# Bajamos con el inspector la tabla y la parseamos

updateID = function(pattern,verbose="silent") {
    raiz = dirname(pattern)
    pat  = paste0(basename(pattern), ".+\\.txt$")
    files = list.files(raiz,pat,full.names=TRUE)
    for (file in files) processFile(file, verbose)
}

processFile = function(file, verbose) {
    if (verbose != "silent") message("Procesando ", basename(file))
    data = readLines(file)
    lines = unlist(lapply(data, function(x) strsplit(data, "<tr", fixed=TRUE)))
    datos = lines[grepl("coin-logo", lines, fixed=TRUE)]
    message("Hay ", length(datos), " iconos")
    res = lapply(datos, function(x) parseRow(x))
    updData(res, verbose)
#    file.rename(file, paste0(file, ".ok"))
}
parseRow = function(fila) {
    cols = strsplit(fila, "<td")
    cols = cols[[1]]
     datos = cols[grepl("coin-logo", cols, fixed=TRUE)]
     if (length(datos) > 0) {
         datos = datos[[1]]
         idx    = str_locate(datos[[1]], "https.+png")
         icon   = substr(datos[[1]], idx[1],idx[2])
         idx    = str_locate(icon, "/[0-9]+\\.png")
         id     = substr(icon, idx[1]+1,idx[2]-4)
         idx    = str_locate_all(datos[[1]],">[a-zA-Z0-9 ]+</p>")
         idx    = idx[[1]]
         if (length(idx) != 4) {
             name   = substr(datos[[1]], idx[1]+1,idx[2]-4)
             symbol = substr(datos[[1]], idx[1]+1,idx[2]-4)
         }
         else {
             name   = substr(datos[[1]], idx[1,1]+1,idx[1,2]-4)
             symbol = substr(datos[[1]], idx[2,1]+1,idx[2,2]-4)
         }
     }
     list(id=id, name=name, symbol=symbol, icon=icon)
}
updData = function(info, verbose) {
#    furl = file("P:/R/YATA2/YATAExternal/bin/geticons.bat", open="at",blocking=FALSE)
        furl = "P:/R/YATA2/YATAExternal/bin/geticons.bat"
    # fact = YATACore::YATAFACTORY$new()
    # db = fact$getDBBase()
    # db$begin()
    # tblCurr = YATAFactory$getTable(YATACodes$tables$Currencies)
    # tblExch = YATAFactory$getTable(YATACodes$tables$Exchanges)
    for (idx in 1:length(info)){
        change = FALSE
        item = info[[idx]]
        ic   = paste0(item$symbol, ".png")
        # res  = tblCurr$select(id=item$symbol)
        # tryCatch({
        #    if (res) {
        #        if (is.na(tblCurr$current$key) || tblCurr$current$key == 0) {
        #            change = TRUE
        #            tblCurr$set(key=item$id, icon=ic)
        #            tblCurr$apply()
        #        }
        #    }
        #    else {
        #        change = TRUE
        #        tblCurr$add(list(id=item$symbol, name=item$name, prty=item$id, icon=ic))
        #    }
        #    res = tblExch$select(camera="MKTCAP", symbol=item$symbol)
        #    if (!res) {
        #        tblExch$add(list(camera="MKTCAP", symbol=item$symbol, id=item$id))
                if (verbose == "detail") message("\tAdded ", item$id, item$name)
        #    }
        # }, error = function(e) message("ERROR: ", e))
        # if (change) {
            stmt = "timeout 2 ;"
            stmt = paste(stmt, paste("curl", item$icon, "-o", paste0(item$id, "_", ic)))
            write(stmt ,file=furl, append=TRUE)
        # }
    }
 #   db$commit()
#    close(furl)
 #   fact$finalize()
}
