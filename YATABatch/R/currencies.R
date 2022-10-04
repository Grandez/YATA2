#' Realiza la carga inicial o recarga de la tabla de monedas
#' Proceso Diario
#'
#' @param console Se ejecuta en una consola (interactivo)
#' @param log     Nivel de detalle de los mensajes
#'
update_currencies = function(logLevel = 0, logOutput = 1) {
   factory = NULL
   batch   = YATABatch$new("currencies", logLevel, logOutput)
   logger  = batch$logger

   if (batch$running) {
      logger$running()
      return (invisible(batch$rc$RUNNING))
   }

   rc = tryCatch({
      browser()
      factory = Factory$new()
      prov    = factory$getDefaultProvider()

      num_coins   = prov$getCurrenciesNumber("coins")
      num_tokens  = prov$getCurrenciesNumber("tokens")
      total_items = num_coins + num_tokens

      logger$log(1, "Updating coins")
      coins  = .updateCurrencies(num_coins, "coins",  logger, factory)
      # logger$log(1, "Updating tokens")
      # tokens = .updateCurrencies(num_coins, "tokens", logger, factory)
   #
   #    logger$process(2, msg$log("CTC_ADDED"), coins$added)
   #    logger$process(1, msg$log("CTC_TOKENS"))
   #
   #    tokens = .update_currencies(num_tokens, "tokens", logger, fact)
   #
   #    logger$process(2, msg$log("CTC_ADDED"), tokens$added)
   #    icons = c(coins$items, tokens$items)
   #    #.update_icons(icons, logger, fact)
         batch$rc$OK
      }, YATAERROR = function (cond) {
              browser()
         batch$rc$FATAL
      }, error = function (cond) {
              browser()
         if (!is.null(factory)) factory$destroy()
         batch$rc$SEVERE
      })
   #    logger$executed(rc, begin, "Executed")
      if (!is.null(factory)) factory$destroy()
      batch$destroy()
      message(paste("update_currencies ending with rc =", rc))
      invisible(rc)
   #
   # beg   = 1
   #
   #
   # browser()
   #     browser()
   # logger$info(2,"Retrieving currencies from %d", beg)
   # df = prov$getCurrencies(beg, 500)
   #
   # rc = tryCatch({
   #    process = TRUE
   #    while (process) {
   #       if (nrow(df) < 500) process = FALSE
   #       logger$info(2,"Updating currencies: %d", beg)
   #       for (row in 1:nrow(df)) {
   #            if (row %% 100 == 1) tbl$db$begin()
   #            tbl$select(id=df[row,"id"])
   #            if (!is.null(tbl$current)) {
   #                tbl$set(slug=df[row,"slug"], rank=df[row,"rank"], active=df[row,"active"])
   #                tbl$apply()
   #             } else {
   #                tbl$add(as.list(df[row,]))
   #             }
   #             if (row %% 100 == 0) tbl$db$commit()
   #       }
   #       tbl$db$commit()
   #       beg = beg + nrow(df)
   #
   #       if (is.null(df) || nrow(df) == 0) process = FALSE
   #       if (process) {
   #           logger$info(2,"Retrieving currencies from %d", beg)
   #           df   = prov$getCurrencies(beg, 500)
   #       }
   #    }
   #       0
   #    }, YATAERROR = function (cond) {
   #            browser()
   #            16
   #    }, error = function (cond) {
   #            browser()
   #            16
   #    })


}

.updateCurrencies = function(count, type, logger, factory) {
    results = list(added = 0, updated=0, items=c())
    block   = 250
    beg     = 1
    process = TRUE

#    msg   = factory$msg
    prov = factory$getDefaultProvider()
    tbl  = factory$getTable("Currencies")

    #df   = prov$getCurrencies(beg, block, type)
    df   = prov$getCurrencies(beg, block)
    while (process) {
         rows = nrow(df)
         if (rows < block) process = FALSE
#         logger$info(3, msg$log("CTC_UPDATING"), type, beg)
         tbl$db$begin()
         for (row in 1:nrow(df)) {
            id = as.integer(df[row,"id"])
              tbl$select(id=df[row,"id"])
              if (!is.null(tbl$current)) {
                 if (.checkChanges(as.list(df[row,]),tbl)) {
                     logger$log(1, paste("Updating", df[row, "symbol"]))
                     results$updated = results$updated + 1
                     tbl$apply()
                 }
               } else {
                  logger$log(1, paste("Adding", df[row, "symbol"]))
                  tbl$add(as.list(df[row,]))
                  results$added = results$added + 1
                  results$items = c(results$items,df[row,"id"])
               }
         }
         tbl$db$commit()
         beg = as.integer(df[nrow(df), "rank"]) + 1
         #if (process) df   = prov$getCurrencies(beg, block, type)
         if (process) df   = prov$getCurrencies(beg, block)
    }
    results
}
.checkChanges = function (data, tbl) {
    changed = FALSE
    if (data$active != tbl$current$active) {
        tbl$set(active = data$active)
        changed = TRUE
    }
    if (data$rank != tbl$current$rank) {
        tbl$set(rank = data$rank)
        changed = TRUE
    }
    if (is.na(tbl$current$mktcap) || data$mktcap != tbl$current$mktcap) {
        tbl$setField("mktcap" ,data$mktcap)
        changed = TRUE
    }
    if (as.Date(data$since, origin="1970-01-01") != tbl$current$since) {
        tbl$set(since = as.Date(data$since, "1970-01-01"))
        changed = TRUE
    }
    changed
}
.update_icons = function(items, logger, factory) {
    for (id in items) {

    }
    results = list(added = 0, items=c())
    block   = 100
    beg     = count - block
    process = TRUE

    msg   = factory$msg
    prov  = factory$getDefaultProvider()
    tbl   = factory$getTable(factory$codes$tables$currencies)

    df = prov$getCurrencies(beg, block, type)

    while (process) {
         if (nrow(df) < block) process = FALSE
         logger$info(3, msg$log("CTC_UPDATING"), type, beg)
         tbl$db$begin()
         for (row in nrow(df):1) {
              tbl$select(id=df[row,"id"])
              if (!is.null(tbl$current)) {
                  process = FALSE
                  break
               } else {
                  tbl$add(as.list(df[row,]))
                  results$added = results$added + 1
                  results$items = c(results$items,df[row,"id"])
               }
         }
         tbl$db$commit()
         beg = beg - block
         if (beg < 1) process = FALSE
         if (process) df   = prov$getCurrencies(beg, block, type)
    }
    results
}

updateRank = function(logOutput, logLevel) {
    # JGG TO DO
    invisible(0)
}
#' Obtiene la cotizacion de las monedas en el momento actual
#'
#' @param max     Numero maximo de monedas a procesar (0 - Todas)
#' @param console Se ejecuta en una consola (interactivo)
#' @param log     Nivel de detalle de los mensajes
#'
updateTickers = function(max=0, console=FALSE, log=1) {
   logger = YATABase::YATALogger$new("currencies", console, log)
   logger$process(1, "Retrieving Tickers from CoinMarketCap")

   beg   = 1
   count = 0
   limit = ifelse (max > 0 && max < 500, max, 500)
   begin = as.numeric(Sys.time())
   codes = YATACore::YATACODES$new()
   fact  = YATACore::YATAFACTORY$new()
   prov  = fact$getProviderBase()
   tbl   = fact$getTable(codes$tables$session)

   logger$info(2,"Retrieving tickers %d", beg)
   df = prov$getTickers(beg, limit)

   rc = tryCatch({
      process = TRUE
      while (process) {
         count = count + nrow(df)
         if (nrow(df) <  limit) process = FALSE
         if (count    >= max)   process = FALSE
         logger$info(2,"Updating currencies: %d", beg)
         for (row in 1:nrow(df)) {
              if (row %% 100 == 1) tbl$db$begin()
              tbl$add(as.list(df[row,]))
              if (row %% 100 == 0) tbl$db$commit()
         }
         tbl$db$commit()
         beg = beg + nrow(df)
         if (is.null(df) || nrow(df) == 0) process = FALSE

         if (process) {
             if (max > 0 && (max - count) < 500) limit = max - count
             logger$info(2,"Retrieving tickers %d", beg)
             df   = prov$getTickers(beg, 500)
         }
      }
         0
      }, YATAERROR = function (cond) {
              browser()
              16
      }, error = function (cond) {
              browser()
              16
      })

      logger$executed(rc, elapsed=as.numeric(Sys.time()) - begin, "Executed")
}
updateIconsCurrency = function(maximum, force=FALSE, console=1, log=1) {
   # Obtiene los iconos de las monedas ausentes
    browser()
    url = "https://s2.coinmarketcap.com/static/img/coins/200x200/"
    factory  = YATACore::YATAFACTORY$new()
    exec     = YATABase::YATAExec$new()

    codes = factory$codes
    msg   = factory$msg

    site = Sys.getenv("YATA_SITE")
    if (nchar(site) == 0) {
        message("ERROR: Missing YATA_SITE environment variable")
        return (invisible(16))
    }
    fileDir = normalizePath(paste0(Sys.getenv("YATA_SITE"), "/ext/icons/currencies"))
    tblCtc  = factory$getTable(codes$tables$currencies)
    tblCtc$db$begin()

    files = list.files(fileDir)
    files = suppressWarnings(na.omit(as.integer(gsub(".png", "", files, fixed = TRUE))))
    files = sort(files)
    tbl   = tblCtc$table()

    iFile   = 1
    iRow    = 1
    updates = 1
    while (iFile <= length(files) && iRow <= nrow(tbl) ) {
        if (updates %% 50 == 0) {
            tblCtc$db$commit()
            tblCtc$db$begin()
        }
        iconTbl = tbl[iRow, "id"]
        iconFile = files[iFile]
        if (is.na(iconTbl)) {
            message("descargar ", iRow)
            ico = paste0(tbl[iRow, "id"], ".png")
            tbl[iRow, "icon"] = ico
            res = exec$unload(paste0(url, ico), fileDir)
            if (res$status == 0) {
                tblCtc$update(list(icon=ico), id=tbl[iRow, "id"])
                updates = updates + 1
            }
            next
        }
        if (iconTbl == iconFile) {
            iFile = iFile + 1
            iRow  = iRow + 1
            next
        }
        if (iconTbl < iconFile) {
            message("descargar 2: ", iconTbl)
            ico = paste0(tbl[iRow, "id"], ".png")
            res = exec$unload(paste0(url, ico), fileDir)
            if (res$status == 0) {
                tblCtc$update(list(icon=ico), id=tbl[iRow, "id"])
                updates = updates + 1
            }
            iRow  = iRow + 1
            next
        }
        iFile = iFile + 1
    }
    while (iRow <= nrow(tbl) ) {
        message("descargar ", iRow)
        iRow = iRow + 1
    }
    tblCtc$db$commit()
    browser()
      total_items = prov$getCurrenciesNumber("all")
      num_coins  = prov$getCurrenciesNumber("coins")
      num_tokens = prov$getCurrenciesNumber("tokens")

      logger = YATABase::YATALogger$new("Currencies", logOutput, logLevel)
      logger$process(1, msg$log("CTC_CURRENCIES"))

   batch  = YATABatch$new("icons", console, log)
   begin  = as.numeric(Sys.time())
   logger = batch$log

   logger$process(1, "Updating icons for currencies")
   .updateIconsTable(batch)
   browser()
   .createURLList(batch)
   logger$executed(rc, elapsed=as.numeric(Sys.time()) - begin, "Executed")
}
.updateIconsTable = function(batch) {
   begin  = as.numeric(Sys.time())
   tbl    = batch$fact$getTable(batch$codes$tables$currencies)

   df     = tbl$table()
   count  = 0  # Hacemos commit cada 50
   tbl$db$begin()
   batch$log$process(2, "Updating icons field on %d currencies", nrow(df))
   for (row in 1:nrow(df)) {
       batch$log$process(5, "Parsing currency", df[nrow, "name"])
       if (!is.na(df[row, "icon"]) && difftime(df[row,"tms"], Sys.time(), unit="days") < 7) next
       resp = YATABase$http$get(paste0("https://coinmarketcap.com/currencies/", df[row,"slug"]))
       if (resp$status_code != 200) {
            YATABase$cond$HTTP(paste("Retrieving currency", df[row,"slug"]),
                               action="GET", origin=resp$status_code)
       }
       content = YATABase$http$content(resp)
       g = regexpr("200x200/[0-9a-zA-Z]+\\.png", content)
       if (g != -1) {
           tbl$select(id = df[row,"id"]) # Existe
           tbl$setField("icon", substr(content, g[1] + 8, g[1] + attr(g, "match.length")[1] - 1))
           tbl$apply()
           count = count + 1
       }
       if ((count %% 50) == 0) {
           tbl$db$commit()
           tbl$db$begin()
       }
    }
    tbl$db$commit()
}
.createURLList = function (batch) {
    batch$log$process(2, "Generating URL List")
    url = "https://s2.coinmarketcap.com/static/img/coins/200x200/"
    f   = paste0(Sys.getenv("HOME"), "/icons_url.txt")
    suppressWarnings(file.remove(f))
    root = paste0(Sys.getenv("YATA_SITE"), "/ext/icons")
    if(.Platform$OS.type == "windows") root = "P:/R/YATA2/ext/icons"
    tbl = batch$fact$getTable(batch$codes$tables$currencies)
    df  = tbl$table()
    for (row in 1:nrow(df)) {
        nfo = file.info(paste0(root, "/", df[row,"icon"]))
        if (is.na(nfo[1,"size"])) { # No existe
            cat(paste0(url,df[row,"icon"], "\n"), file=f, append=TRUE)
            next
        }
        if (nfo[1,"size"] < 1000) { # Malo
            cat(paste0(url,df[row,"icon"], "\n"), file=f, append=TRUE)
        }
    }
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
