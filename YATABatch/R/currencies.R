#' Realiza la carga inicial o recarga de la tabla de monedas
#'
#' @param console Se ejecuta en una consola (interactivo)
#' @param log     Nivel de detalle de los mensajes
#'
loadCurrencies = function(console=FALSE, log=1) {

}
#' Hay dos procesos
#' El proceso inicial (Poner el YATA.cfg) tiene que leerlas monedas de marketcap
#' y generar un ficheropara hacer un load masivo
#'
#' El segundo es similar pero para actualizar el rango de las monedas y pequeños detalles
#' O sea, hace lo mismo que el otro pero esta vez va moneda a moneda actualizando
#' Con los iconos lo mismo
#'
#'
#'
# updateWriteCurrencies = function(fact, outFile, max) {
#     browser()
#     #log(1, "Retrieving currencies from CoinMarketCap")
#         fact    = YATACore::YATAFACTORY$new()
#         outFile = "pepe.txt"
#     fOut = file(outFile, open="wt", blocking=FALSE)
#     prov = fact$getProvider("MKTCAP", "MarketCap")
#     max = 3000
#
#     start = 1
#     limit = 1000
#     nrows = 0
#     while (start < max) {
#        #log(2, "Retrieving 1000 currencies from %d", start)
#        df = prov$unloadCurrencies(start,1000)
#        nrows = nrows + nrow(df)
#        add = ifelse(start == 1, FALSE, TRUE)
#        write.table( df[,c("id", "name", "symbol", "slug","rank")]
#                    ,fOut
#                    ,append=add
#                    ,row.names=FALSE, col.names=FALSE
#                    ,fileEncoding = "UTF-8", sep=",")
#        start = start + limit
#     }
#     close(fOut)
#     nrows
# }
#
# updateCurrencies = function(verbose) {
# # Actualiza la monedas y sus cosas desde coinmarketcap
#     browser()
#     tmsBeg = Sys.time()
#     #setVerbose(verbose)
#     # Actualiza las monedas que maneja cada exchange
#     # Obtiene los exchanges
#     # a cada uno de ellos le aplica la lista de monedas
#     #codes   = YATACore::YATACodes
#     fact    = YATACore::YATAFACTORY$new()
#     prov    = fact$getObject (fact$codes$object$providers)
#     tblExch = fact$getTable  (fact$codes$tables$exchanges)
#     db      = tblExch$getDB()
#     df      = prov$getProviders()
#     if (nrow(df) == 0) {
#         warn("No hay proveedores activos")
#         return (invisible(1))
#     }
#     #JGG Por ahora solo marketcap
#     df = df[df$id == "MKTCAP", ]
#     # apply(df, 1, .updCurrencies)
#     for (row in 1:nrow(df)) {
#         lst = as.list(df[row,])
# #        if (lst$id == "MKTCAP") next
# #        log(2, "Obteniendo exchanges de %s", lst$name)
#         provider = fact$getProvider(lst$id, lst$object)
#         dfc = provider$getCurrencies()
#         if (nrow(dfc) == 0) next
#         df1 = data.frame(camera=rep(lst$id, nrow(dfc)))
#         dfc = cbind(df1, dfc[,c("symbol", "id")])
#         db$begin()
#         tryCatch({
#             tblExch$updateBulk(data=dfc, camera = lst$id)
#             db$commit()
#         },error = function(e) {
#             warn("Error en updateBulk")
#             info(e)
#             db$rollback()
#         })
#     }
#     summary(1, "%d exchanges procesados", nrow(df))
#     summary(2, "Elapsed: %s", elapsed(tmsBeg, Sys.time()))
#     invisible(0)
#     # mktcap = YATAFactory$getProvider("MKTCAP", "MarketCap")
#     # currencies = YATAFactory$getObject(YATACodes$object$currencies)
#     # db    = YATAFactory$getDBBase()
#     # current = currencies$getDF()
#     # current = current[,c("id", "name", "prty")]
#     # page = 0
#     # df = mktcap$getCurrencies()
#     # nuevos = 0
#     #
#     # while (!is.null(df) && nrow(df) > 0) {
#     #     Sys.sleep(2)
#     #     message("Pagina ", page)
#     #     df$prty = seq(1:nrow(df)) + (page * 100)
#     #     # Miramos las nuevas, name.y sera NA
#     #     lj = left_join(df, current, by="id")
#     #     news = lj[is.na(lj$name.y),]
#     #     if (nrow(news) > 0) {
#     #         df = news[,c(2,1,3)]
#     #         colnames(df) = c("id", "name", "prty")
#     #         current = rbind(current, df)
#     #         nuevos = nuevos + nrow(news)
#     #         db$begin()
#     #         tryCatch({currencies$addBulk(df)
#     #                   db$commit()
#     #             },error = function(cond) {
#     #                 message("ERROR: " , cond)
#     #                 db$rollback()
#     #             }
#     #         )
#     #     }
#     #     page = page + 1
#     #     df = mktcap$getCurrencies(page)
#     # }
#     # message("Nuevos creados ", nuevos)
# }
#
# .updateExch = function(fact, exchange) {
#     exch = fact$get(exchange)
#     ctcs = exch$currencies()
#     #Borrar
#     # Insertar las monedas
# }
#
# updateIcons = function(verbose) {
#     browser()
#      tmsBeg = Sys.time()
#     setVerbose(verbose)
#     base = "P:/R/YATA2/YATACore/inst/extdata/icons/"
#     # Actualiza las monedas que maneja cada exchange
#     # Obtiene los exchanges
#     # a cada uno de ellos le aplica la lista de monedas
#     codes   = YATACore::YATACodes
#     fact    = YATACore::YATAFACTORY$new()
#     tblCurrencies = fact$getTable("Currencies")
#     inc = 250
#     beg = 1
#     end = inc
#     db  = tblCurrencies$getDB()
#     df  = tblCurrencies$queryRaw("SELECT ID, ICON FROM CURRENCIES WHERE ID BETWEEN ? AND ?", list(beg, end))
#     while (nrow(df) > 0) {
#
#         db$begin()
#         for (i in 1:nrow(df)) {
#             if (is.na(df[i, "ICON"])) {
#                 ico = paste0(df[i, "ID"], ".png")
#                 if (file.exists(paste0(base, ico))) {
#                     tblCurrencies$execRaw("UPDATE CURRENCIES SET ICON = ? WHERE ID ?", list(ico, df[i,"ID"]))
#                     browser()
#                 }
#             }
#         }
#         db$commit()
#         browser()
#         beg = inc + beg
#         end = end + inc
#     }
#     fact$clear()
#
# }
