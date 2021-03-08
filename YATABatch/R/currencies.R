updateCurrencies = function(verbose) {
    tmsBeg = Sys.time()
    setVerbose(verbose)
    # Actualiza las monedas que maneja cada exchange
    # Obtiene los exchanges
    # a cada uno de ellos le aplica la lista de monedas
    codes   = YATACore::YATACodes
    fact    = YATACore::YATAFACTORY$new()
    prov    = fact$getObject (codes$object$providers)
    tblExch = fact$getTable  (codes$tables$Exchanges)
    db      = tblExch$getDB()
    df = prov$getProviders()
    if (nrow(df) == 0) {
        warn("No hay proveedores activos")
        return (invisible(1))
    }
    # apply(df, 1, .updCurrencies)
    for (row in 1:nrow(df)) {
        lst = as.list(df[row,])
        if (lst$id == "MKTCAP") next
        log(2, "Obteniendo exchanges de %s", lst$name)
        provider = fact$getProvider(lst$id, lst$object)
        dfc = provider$getCurrencies()
        if (nrow(dfc) == 0) next
        df1 = data.frame(camera=rep(lst$id, nrow(dfc)))
        dfc = cbind(df1, dfc[,c("symbol", "id")])
        db$begin()
        tryCatch({
            tblExch$updateBulk(data=dfc, camera = lst$id)
            db$commit()
        },error = function(e) {
            warn("Error en updateBulk")
            info(e)
            db$rollback()
        })
    }
    summary(1, "%d exchanges procesados", nrow(df))
    summary(2, "Elapsed: %s", elapsed(tmsBeg, Sys.time()))
    invisible(0)
    # mktcap = YATAFactory$getProvider("MKTCAP", "MarketCap")
    # currencies = YATAFactory$getObject(YATACodes$object$currencies)
    # db    = YATAFactory$getDBBase()
    # current = currencies$getDF()
    # current = current[,c("id", "name", "prty")]
    # page = 0
    # df = mktcap$getCurrencies()
    # nuevos = 0
    #
    # while (!is.null(df) && nrow(df) > 0) {
    #     Sys.sleep(2)
    #     message("Pagina ", page)
    #     df$prty = seq(1:nrow(df)) + (page * 100)
    #     # Miramos las nuevas, name.y sera NA
    #     lj = left_join(df, current, by="id")
    #     news = lj[is.na(lj$name.y),]
    #     if (nrow(news) > 0) {
    #         df = news[,c(2,1,3)]
    #         colnames(df) = c("id", "name", "prty")
    #         current = rbind(current, df)
    #         nuevos = nuevos + nrow(news)
    #         db$begin()
    #         tryCatch({currencies$addBulk(df)
    #                   db$commit()
    #             },error = function(cond) {
    #                 message("ERROR: " , cond)
    #                 db$rollback()
    #             }
    #         )
    #     }
    #     page = page + 1
    #     df = mktcap$getCurrencies(page)
    # }
    # message("Nuevos creados ", nuevos)
}

.updateExch = function(fact, exchange) {
    exch = fact$get(exchange)
    ctcs = exch$currencies()
    #Borrar
    # Insertar las monedas
}
