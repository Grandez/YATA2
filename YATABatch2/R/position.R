# Para ajustar la posicion mientras falla
recreatePosition = function(verbose) {
    tmsBeg = Sys.time()
    setVerbose(verbose)
    browser()
    # Actualiza las monedas que maneja cada exchange
    # Obtiene los exchanges
    # a cada uno de ellos le aplica la lista de monedas
#    codes   = YATACore::YATACodes
    fact    = YATACore::YATAFACTORY$new()
    tblOper = fact$getTable  ("Operations")
    df = tblOper$table()
    counters = unique(df$counter)
    movs = lapply(counters, function(x)
        list(balance=0.0, available=0.0,price=0.0,buy=0.0,sell=0.0,priceBuy=0.0,priceSell=0.0, res = 0.0))
    names(movs) = counters
    movs$EUR = list(balance=0.0, available=0.0,price=1,buy=1,sell=1,priceBuy=1,priceSell=1, res = 0.0)
    browser()
    for (row in 1:nrow(df)) {
        if (df[row,"counter"] == "BAR") next
        if (df[row, "type"] == 4) {
            movs[["EUR"]]$balance  = movs[["EUR"]]$balance + df[row,"amount"]
            movs[["EUR"]]$available = movs[["EUR"]]$available + df[row,"amount"]
            next
        }
        counter = df[row,"counter"]
        movs[[counter]]$balance   = movs[[counter]]$balance + df[row,"amount"]
        movs[[counter]]$available = movs[[counter]]$available - df[row,"amount"]
        if (df[row,"amount"] > 0) {
            if (movs[[counter]]$buy == 0.0) {
                movs[[counter]]$buy = df[row,"amount"]
                movs[[counter]]$priceBuy = df[row,"price"]
            } else {
                item = movs[[df[row,"counter"]]]
                medio = ((item$buy * item$priceBuy) + (df[row,"amount"] * df[row,"price"])) /
                        (item$buy + df[row,"amount"])
                movs[[counter]]$priceBuy = medio
                movs[[counter]]$buy = movs[[counter]]$buy + df[row,"amount"]
            }
            movs[[counter]]$res = movs[[counter]]$res - (df[row, "price"] * df[row,"amount"])
            movs$EUR$balance = movs$EUR$balance - (df[row,"amount"] * df[row,"price"])
            movs$EUR$available = movs$EUR$balance

        }
        if (df[row,"amount"] < 0) {
            df[row,"amount"] = df[row,"amount"] * -1
            if (movs[[counter]]$sell == 0.0) {
                movs[[counter]]$sell = df[row,"amount"]
                movs[[counter]]$priceSell = df[row,"price"]
            } else {
                item = movs[[df[row,"counter"]]]
                medio = ((item$sell * item$priceSell) + (df[row,"amount"] * df[row,"price"])) /
                        (item$sell + df[row,"amount"])
                movs[[counter]]$priceSell = medio
                movs[[counter]]$sell = movs[[counter]]$buy + df[row,"amount"]
            }
            movs[[counter]]$res = movs[[counter]]$res + (df[row, "price"] * df[row,"amount"])
            movs$EUR$balance = movs$EUR$balance + (df[row,"amount"] * df[row,"price"])
            movs$EUR$available = movs$EUR$balance

        }


    }
    browser()
    # db      = tblExch$getDB()
    # df = prov$getProviders()
    # if (nrow(df) == 0) {
    #     warn("No hay proveedores activos")
    #     return (invisible(1))
    # }
    # # apply(df, 1, .updCurrencies)
    # for (row in 1:nrow(df)) {
    #     lst = as.list(df[row,])
    #     if (lst$id == "MKTCAP") next
    #     log(2, "Obteniendo exchanges de %s", lst$name)
    #     provider = fact$getProvider(lst$id, lst$object)
    #     dfc = provider$getCurrencies()
    #     if (nrow(dfc) == 0) next
    #     df1 = data.frame(camera=rep(lst$id, nrow(dfc)))
    #     dfc = cbind(df1, dfc[,c("symbol", "id")])
    #     db$begin()
    #     tryCatch({
    #         tblExch$updateBulk(data=dfc, camera = lst$id)
    #         db$commit()
    #     },error = function(e) {
    #         warn("Error en updateBulk")
    #         info(e)
    #         db$rollback()
    #     })
    # }
    # summary(1, "%d exchanges procesados", nrow(df))
    # summary(2, "Elapsed: %s", elapsed(tmsBeg, Sys.time()))
    invisible(0)
}
