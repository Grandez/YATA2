# En los proveedores que no soportan EUR con loadDefaults
ProviderBase = R6::R6Class("PROVIDER.BASE"
   ,portable = FALSE
   ,cloneable = FALSE
   ,lock_class = FALSE
   ,public = list(
       name = NULL
      ,code = NULL
      ,info = NULL
      ,status = NULL   # Control del error
      ,initialize  = function(code, name, EUR) {
          self$code = code
          self$name = name

          private$created = Sys.time()
          private$lastGet = as.Date.POSIXct(1)
          private$EUR     = EUR
          #private$dbf     = dbf
          # tbl = dbf$getTable("Path")
          # private$dfPath = tbl$table(provider = code)
          # tbl = dbf$getTable("Providers")
          # tbl$select(id=code)
          # self$info = tbl$current
      }
      ,print       = function()         { message(name, " provider")}
      ,getCurrencies = function(from, max) { stop("Este metodo es virtual")}

      ,setLimits   = function(limits)   { private$limits = limits }
      ,setInterval = function(interval) { private$interval = interval }
      ,getLatests  = function(base, counter) { stop("Este metodo es temporañ")}

      # Metodos

      ,ticker        = function() { stop("Este metodo es virtual")}
      ,session       = function(base, counter, interval, from, to) { stop("Este metodo es virtual")}
      ,getDaySession = function(base, counter,           from, to) { stop("Este metodo es virtual")}
      ,currencies    = function() { stop("Este metodo es virtual")}
      ,getCloseSession = function(base, counter, day) { stop("Este metodo es virtual")}

   )
   ,private = list(resp = NULL
       ,limits  = c(.Machine$integer.max,.Machine$integer.max,.Machine$integer.max)   # Limites de peticiones pos segundo,minuto y hora
       ,current   = c(0,0,0)   # Actual
       ,lastGet   = NULL   # Marca de tiempo
       ,interval  = 1   # Intervalo en minutos
       ,created   = NULL
       ,EUR       = NULL
       ,dbf       = NULL
       ,dfTickers = NULL   # Tabla de valores actuales
       ,config    = NULL   # Parametros de configuracion
       ,fiats     = c("EUR", "USD", "USDT", "USDC")
       # ,tblPath   = NULL
       # ,dfPath    = NULL
       ,get       = function(url) {
           # No va por la hora, si no por el intervalo de tiempo
           # Ignoramos segundos
           dt = Sys.time()
           if (!is.null(lastGet)) {
               if (difftime(dt, lastGet, units="mins")  > 1) private$current[2] = 0
               if (difftime(dt, lastGet, units="hours") > 1) private$current[3] = 0
           }
           private$lastGet = dt
           private$current = private$current + 1
           if (private$current[2] >= private$limits[2]) {
               message("Esperando por exceso de peticiones por minuto")
               Sys.sleep(62)
           }
           if (private$current[3] >= private$limits[3]) {
               message("Esperando por exceso de peticiones por hora")
               Sys.sleep(3610)
           }
           resp = httr::GET(url)
           jsonlite::fromJSON(httr::content(resp, as="text", encoding="UTF-8"))
       }
       ,.getLatest = function(base, counter) {
           value = 1
           idx   = 1
           loadTickers()

           path = .getPath(base,counter)
           pair = c(path[1], path[2], path[3])
           while (idx <= length(path)) {
               pair = c(path[idx], path[idx+1], path[idx+2])
               value = calcPrice(value, pair)
               idx = idx + 3
           }
           if (!base %in% pair) value = calcPrice(value, c("EUR","USD", "NRM"))
           lst = list(last=value)
           lst
       }
       ,calcPrice = function(value, pair) {
           df = subset(dfTickers, base == pair[1] & counter == pair[2])
           res = (df$highest + df$lowest) / 2
           if (pair[3] == "INV") res = 1 / res
           value * res
       }
       #  ,.getPath = function(base, counter) {
       #     df = dfPath[dfPath$base == base & dfPath$counter == counter,]
       #     if (nrow(df) == 0)  {
       #         path = findPath(base, counter)
       #     } else {
       #         path = df$path
       #     }
       #     if (is.null(path)) stop("No hay camino")
       #     strsplit(path, "/")[[1]]
       # }
       # ,findPath = function (base, counter, add=TRUE) {
       #     path = searchPath(base, counter)
       #     if (add) {  # Se graba el bueno y el malo
       #         data = list(provider = self$code, base=base,counter=counter,path=path)
       #         tblPath$add(data, isolated=TRUE)
       #     }
       #     path
       # }
       ,findPathOld      = function (base, counter, add=TRUE) {
           path = dfPath[dfPath$base == base & dfPath$counter == counter,]
           if (nrow(path) > 0) return (path[1,"path"])

           path = NULL
           idx = 4
           res = searchPath(base, counter)

           if (!is.null(res)) {
               path = mountPath("", res[1:3])
               while(idx < length(res)) {
                    tag = res[idx]
                    if (tag %in% c("INV", "NRM")) {
                        path = mountPath(path, res[idx], res[idx - 1], res[idx + 1])
                    } else {
                        path = mountPath(path, res[idx+1], res[idx - 1], res[idx])
                    }
                    idx = idx + 2
               }
           }
           if (add) {
               data = list(provider = self$code, base=base,counter=counter,path=path)
               tblPath$add(data, isolated=TRUE)
           }
           path
       }
       ,mountPath = function(path, ...) {
           flds = list(...)
           if (length(flds) == 1) {
               flds = flds[[1]]
           }
           else {
               flds = unlist(flds)
           }
           if (flds[1] != "INV") res = paste(flds[2], flds[3], flds[1], sep="/")
           if (flds[1] == "INV") res = paste(flds[3], flds[2], flds[1], sep="/")
           paste(res,path,sep="/")
       }
       ,checkPair = function(base, counter) {
           dfb = dfTickers[dfTickers$base == base | dfTickers$counter == base,]
           dfc = dfTickers[dfTickers$base == counter | dfTickers$counter == counter,]
           ifelse (nrow(dfb) == 0 || nrow(dfc) == 0, TRUE, FALSE)
       }
       ,namecols = function(df, left) {
           if (left)  colnames(df) = c(paste0("from", seq(1,(ncol(df) - 1))), "chk")
           if (!left) colnames(df) = c("chk", paste0("to", seq(1,(ncol(df) - 1))))
           df
       }
       ,makejoin = function(df1, df2, left) {
           df = inner_join(df1, df2, by="chk")
           if ( left) df = namecols(df, TRUE)
           if (!left) df = namecols(df, FALSE)
           df
       }
       ,.invert = function(df) {
          # JGG hay que revisar
           df[,2:ncol(df)] = 1 / df[,2:ncol(df)]
           df
       }
       ,.adjustDFSession = function(prov, base, counter, df) {
           df$tms = as.POSIXct(df$tms, origin="1970-01-01")
           df$quoteVolume = NULL
           names(df)[names(df) == "weightedAverage"] = "average"

           prov    = rep(prov, nrow(df))
           base    = rep(base, nrow(df))
           counter = rep(counter, nrow(df))
           df0     = data.frame(provider=prov, base=base, counter=counter)
           cbind(df0, df)
       }
       # ,.adjust = function(df, price) {
       #    # JGG hay que revisar
       #     df[,2:ncol(df)] = df[,2:ncol(df)] *
       #     df
       # }
      ,.applyFiat = function(df, base, counter, from, to) {
           # Euro va por dias
           dfEur = EUR$getSessionDays(base, counter, asDate(from), asDate(to))
           colnames(dfEur) = c("date", "otro", "USD")
           dfEur$date = as.Date(dfEur$date)
           df$date = asDate(df$tms)
           df = left_join(df, dfEur, by="date")
           df = df %>% fill(USD)
           df[,2:8] = df[,2:8] * df$USD
           df[,1:(ncol(df) - 3)]
        }
       ,findCTC = function(dfwrk, ctc, seen, left) {
           act = "NRM"
           # df, monedas a buscar, monedas vistas, from o to
           idx = ifelse(left, 1,2)
           fields = c("counter", "base")
           if (left) fields = rev(fields)
           df = dfwrk[eval(parse(text=paste0("dfwrk$",fields[1]))) %in% ctc,]
           if (nrow(df) > 0) {
               df = df[! df[,ifelse(left, 2, 1)] %in% seen,]
           }
           else {
              df = dfwrk[eval(parse(text=paste0("dfwrk$",fields[2]))) %in% ctc,]
              if (nrow(df) > 0) {
                  df = df[! df[,1] %in% seen,]
                  act = "INV"
                  df = df[,c(2,1)]
              }
           }
           if (nrow(df) > 0) {
               if (left)  {
                   df = cbind(act, df)
                   colnames(df) = c("act1", "chk", "to1")
               } else {
                   df = cbind(df   , act)
                   colnames(df) = c("to1", "chk", "act1")
               }
           }
           df
       }
       ,searchPath = function(base, counter) {
           dfwrk = dfTickers[,c("base", "counter")]
           dfe = dfwrk[dfwrk$base == counter | dfwrk$counter == counter,]
           if (nrow(dfe) == 0) return (NULL)
           # Miramos como counter
           dfc = dfwrk[dfwrk$counter == counter, ]
           if (nrow(dfc) > 0) {
               dff = dfc[dfc$base %in% fiats,]
               if (nrow(dff) > 0) {
                   for (fiat in fiats) {
                        if (nrow(dff[dff$base == fiat,]) == 1) return (paste(fiat, counter, "NORM", sep="/"))
                   }
               }
           } else {
               dfc = dfwrk[dfwrk$base == counter, ]
               dff = dfc[dfc$counter %in% fiats,]
               if (nrow(dff) > 0) {
                   for (fiat in fiats) {
                        if (nrow(dff[dff$base == fiat,]) == 1) return (paste(counter, fiat, "INV", sep="/"))
                   }
               }
           }
           error("Casos raros")
       }
       ,searchPathOld = function(base, counter) {
           # Base y counter existen
           # Primero buscamos partiendo de base=base
           # Si no existe el camino y existe counter=base
           # Buscamos por esa rama
           res = NULL
           dfwrk = dfTickers[,c("base", "counter")]
           # Primero buscamos por base (existe como base o como counter)
           df = dfwrk[dfwrk$base == base,]
           if (nrow(df) > 0) {
               dffrom = findCTC(dfwrk, base, "", TRUE)
               res    = internalSearch(dfwrk, dffrom, base, counter)
           }
           if (is.null(res)) {
               df = dfwrk[dfwrk$counter == base,]
               if (nrow(df) > 0) {
                   dffrom = findCTC(dfwrk, base, "", TRUE)
                   res = internalSearch(dfwrk, dffrom, base, counter)
               }
           }
           res
       }
       ,internalSearch     = function (dfwrk, dffrom, base, counter) {
           lseen = c(base)
           rseen = c()

           # Ya estan base y counter en la lista?
           dfj = dffrom %>% filter_all(any_vars(. == counter))
           if (nrow(dfj) > 0) return (as.vector(dfj[1,]))

           dfto   = findCTC(dfwrk, counter, rseen, FALSE)
           if (nrow(dffrom) == 0 || nrow(dfto) == 0) {
               stop("par invalido")
               yataError("Par invalido", paste(base,counter, "/"), "CURRENCIES", "exchange")
           }

           # primera vez
           colnames(dffrom) = c("act1", "from1", "chk")
           colnames(dfto)   = c("chk" , "to1", "act2")
           dfj = makejoin(dffrom, dfto, TRUE)
           if (nrow(dfj) > 0 ) return (as.vector(dfj[1,]))
           rseen=unique(dfto$to1)
#           colnames(dffrom) = c("act1", "chk", "to1")
#           done = ifelse(nrow(dfj) > 0, TRUE, FALSE)

           repeat {
              df = findCTC(dfwrk, dffrom$chk, lseen, TRUE )
              if (nrow(df) == 0) break; # No hay camino
              lseen = unique(c(lseen, df$from1))
              dffrom = makejoin(dffrom, df, TRUE)
              dfj = makejoin(dffrom, dfto, TRUE)
              if (nrow(dfj) > 0) break;

              df = findCTC(dfwrk, dfto$chk, rseen, FALSE)
              if (nrow(df) == 0) break; # No hay camino
              rseen = unique(c(rseen, df$to1))
              dfto  = makejoin(df, dfto, FALSE)
              dfj   = makejoin(dffrom, dfto, TRUE)
              if (nrow(dfj) > 0) break;
           }

           if (nrow(dfj) == 0) return (NULL)
           message(rev(as.vector(dfj[1,])))
           as.vector(dfj[1,])
      }
       ,addDefaults  = function() {
#            eur = EUR$latest("EUR", "USD")
#            # Ponemos cambios por defecto para que los encuentre
#            # Por definicion USDT, USDC son monedas USD
#            dfUSD  = data.frame(base="USD",  counter=c("USDT", "USDC"))
#            # dfUSDT = data.frame(base="USDT", counter="USD") # c("USD", "USDC"))
#            # dfUSDC = data.frame(base="USDC", counter=c("USD", "USDT"))
# #           dft    = rbind(dfUSD, dfUSDT, dfUSDC)
#            dfv    = data.frame( last=1,lowest=1,highest=1,change=0
#                                       ,baseVolume=1,quoteVolume=1,active=1
#                                       ,high=1, low=1)
#            df     = cbind(dfUSD, dfv)
           eur = EUR$latest("EUR", "USD")
           usd = 1/eur
           dfe = data.frame(base="EUR", counter="USD", last=usd     ,lowest=usd
                                                     , highest=usd  ,change=0
                                                     , baseVolume=1 ,quoteVolume=1
                                                     , active=1
                                                     , high=usd     ,low=usd)
           dft = data.frame(base="EUR", counter="USDT", last=usd     ,lowest=usd
                                                     , highest=usd  ,change=0
                                                     , baseVolume=1 ,quoteVolume=1
                                                     , active=1
                                                     , high=usd     ,low=usd)
           dfc = data.frame(base="EUR", counter="USDC", last=usd     ,lowest=usd
                                                     , highest=usd  ,change=0
                                                     , baseVolume=1 ,quoteVolume=1
                                                     , active=1
                                                     , high=usd     ,low=usd)

           # dfu = data.frame(base="USD", counter="EUR", last=usd     ,lowest=usd
           #                                           , highest=usd  ,change=0
           #                                           , baseVolume=1 ,quoteVolume=1
           #                                           , active=1
           #                                           , high=usd      ,low=usd)
          private$dfTickers = rbind(private$dfTickers, dfe, dft,dfc)
       }
      ,mountURL = function(page) {
          url = info$url
          len = nchar(url)
          last = substr(url, len, len)
          beg = ""
          if (nchar(page) > 0) beg = substr(page,1,1)
          if (last == "/") {
              if (beg == "/") {
                 url = paste0(url, substr(page,2,nchar(page)))
              } else {
                 url = paste0(url,page)
              }
          } else {
              if (beg == "/") {
                 url = paste0(url,page)
              } else {
                 url = paste(url, page, sep="/")
              }
          }
          url
      }
   )

)
