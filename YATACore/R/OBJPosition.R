OBJPosition = R6::R6Class("OBJ.POSITION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print           = function() { message("Position Object")}
       ,initialize      = function(factory) {
           super$initialize(factory)
           private$tblPosition = factory$getTable("Position")
       }
       ,getCameras = function() {
          df = tblPosition$getCameras()
          df[df$balance != 0,]
          as.list(df[df$camera != YATACODE$CAMFIAT,1])
       }
       ,getCurrencies = function(balance = FALSE, available= FALSE) {
           df = tblPosition$table()
           df = df[df$currency != YATACODE$CTCFIAT,]
           if (balance)   df = df[df$balance   > 0,]
           if (available) df = df[df$available > 0,]
           unique(df$currency)
       }
       ,getByCurrency = function(currency, balance=FALSE, available=FALSE) {
           df = tblPosition$table(currency = currency)
           # Quitar la camara FIAT
           df = df[df$camera != YATACODE$CAMFIAT,]
           if (balance)   df = df[df$balance  > 0,]
           if (available) df = df[df$available > 0,]
           df
       }
       ,getFullPosition   = function() { tblPosition$table()             }
       ,getGlobalPosition = function() { tblPosition$getGlobalPosition() }
       ,getPosition       = function(camera, currency) {
           df = tblPosition$getPosition(camera, currency)
           self$current = tblPosition$current
           df
         }
       ,getCameraPosition = function(camera, balance=FALSE, available = FALSE) {
           tblPosition$getCameraPosition(camera, balance, available)
       }
       ,getCurrencyPosition = function(currency) { tblPosition$getCurrencyPosition(currency) }
       ,getFiatPosition = function(fiat) {
           df = tblPosition$getCurrencyPosition(0)
           # oper = factory$getObject(self$codes$object$operation)
           # cIn  = oper$getOperations(base="EXT")
           # cOut = oper$getOperations(counter="EXT")
           # inv  = getGlobalPosition()
           # inv  = inv[inv$currency != fiat,]
           # list(total = sum(cIn$amount), reimb=sum(cOut$amount) * -1, invest=sum(inv$balance * inv$priceBuy))
list(total = 1, reimb=1 * -1, invest=sum(1 * 1))
      }
       ,getCurrenciesHistory = function() {
         df = tblPosition$table()
         df = df[!df$currency == 0,]
         if(nrow(df) == 0) return (df)
         df = df %>% group_by(currency) %>%
                     summarise(currency, balance=mean(balance), available=mean(available)
                                       , buy=mean(buy),         sell=mean(sell)
                                       , profit=mean(profit))
         df
      }
       ,getRegularizations = function() { tblPosition$getRegularizations() }
       ,transfer = function(...) {
           args = YATATools::args2list(...)

           impOut = args$amount
           if (!is.null(args$feeOut) && args$feeOut > 0) impOut = impOut + args$feeOut

           res = tblPosition$select(camera=args$from, currency=args$currency)
           tblPosition$set(balance   = tblPosition$current$balance   - impOut)
           tblPosition$set(available = tblPosition$current$available - impOut)
           tblPosition$apply()

           res = tblPosition$select(camera=args$to, currency=args$currency, create=TRUE)

           nvalue = tblPosition$current$balance * tblPosition$current$net
           nvalue = nvalue + (args$amount * args$value)
           nvalue = nvalue / (tblPosition$current$balance + args$amount)
           tblPosition$set(net       = nvalue)

           impOut = args$amount
           if (!is.null(args$feeIn) && args$feeIn > 0) impOut = impOut - args$feeIn

           tblPosition$set(balance   = tblPosition$current$balance   + impOut)
           tblPosition$set(available = tblPosition$current$available + impOut)
           tblPosition$apply()
           invisible(self)
      }
       ,updatePositions = function(data) {
          # Requires: camera, base, counter, amount, value, price, prcTaxes
          # Call 2 times because base is sell and counter is buy (distinct field names)
          # Amount sale de base y entra en counter
          if (data$amount == 0 || data$value == 0) return (invisible(self))
          .updateBase(data)
          if (data$major == 2) .updateCounter(data)
      }
       ,updateOper = function(camera, currency, amount, price, prcTaxes) {
          #JGG Hay que revisar modificado sin querer
          # if (amount == 0) return()
          # tblPosition$select(camera=camera, currency=currency, create=TRUE)
          # curr  = tblPosition$current
          #
          # pSell = curr$priceSell
          # nSell = curr$sell
          # pBuy = curr$priceBuy
          # nBuy = curr$buy
          # if (amount > 0) {
          #     pBuy = (pBuy * nBuy) + (amount * price)
          #     pBuy = ifelse((nBuy + amount) == 0, 0, pBuy / (nBuy + amount))
          #     nBuy = nBuy + amount
          #     tblPosition$set(priceBuy = pBuy, buy=nBuy)
          #     nBalance = amount
          # }
          # pPrice = 0
          # if ((nBuy - nSell) != 0) pPrice = ((pBuy * nBuy) - (pSell * nSell)) / (nBuy - nSell)
          #
          # tblPosition$setField("price", pPrice)
          #
          # tax = 0
          # if (prcTaxes != 0) {
          #     tax = nBalance * prcTaxes / 100
          #     if (tax > 0) tax = tax * -1
          # }
          # tblPosition$setField("balance",   curr$balance + nBalance + tax)
          # tblPosition$setField("available", curr$balance + nBalance + tax)
          # tblPosition$apply()
      }
      # ,update = function(camera, currency, amount, price, available=TRUE) {
      #     # Actualiza balance y calcula precios
      #     tblPosition$select(camera=camera, currency=currency, create=TRUE)
      #     curr  = tblPosition$current
      #     if (available) { # Solo descontar available
      #         tblPosition$set("available", curr$available + amount)
      #     }
      #     if (currency != "EUR") curr = getPrices(tblPosition$current, amount, price)
      #     tblPosition$set( balance   = tblPosition$current$balance + amount
      #                     ,buy       = curr$buy
      #                     ,sell      = curr$sell
      #                     ,priceBuy  = curr$priceBuy
      #                     ,priceSell = curr$priceSell
      #                     ,price     = curr$price
      #         )
      #     tblPosition$apply()
      # }
      ,updateAvailable = function(camera, currency, amount) {
          # Solo actualiza disponible
          tblPosition$select(camera=camera, currency=currency)
          tblPosition$set(available = tblPosition$getField("available") + amount)
          tblPosition$apply()
      }
      ,updateBalance   = function(camera, currency, amount, available=TRUE) {
          # Solo actualiza balance y/o disponible
          tblPosition$select(camera=camera, currency=currency)
          tblPosition$set(balance = tblPosition$current$balance + amount)
          if (available) {
              tblPosition$set(available = tblPosition$current$available + amount)
          }
          tblPosition$apply()
      }
      ,updatePosition  = function(values) {
           tblPosition$select(camera=values$camera,currency=values$currency, create=TRUE)
           tblPosition$set(values)
           tblPosition$apply()
       }
      ,empty_data      = function() { tblPosition$emptydf() }
      ##################################################
      ### Caches
      ##################################################
    )
    ,private = list(
        tblPosition  = NULL
       ,getPrices = function(current, amount, price) {
           nCurr = current
           if (amount == 0) return (current)
           if (amount > 0 ) {
               nBuy = (nCurr$buy * nCurr$priceBuy) + (amount * price)
               nCurr$buy = (nCurr$buy + amount)
               nCurr$priceBuy = nBuy / nCurr$buy
           }
           if (amount < 0) {
               nBuy = (nCurr$sell * nCurr$priceSell) + (amount * price * -1)
               nCurr$sell = (nCurr$sell - amount)
               nCurr$priceSell = nBuy / nCurr$sell
           }
           nCurr$price = (nCurr$sell * nCurr$priceSell) + (nCurr$buy * nCurr$priceBuy)
           nCurr$price = nCurr$price / (nCurr$buy + nCurr$sell)
           nCurr
       }
       ,.updateBase = function(data) {
         # De aqui salen VALUE UNIDADES EL PRECIO ES 1/PRECIO
           tblPosition$select(camera=data$camera, currency=data$base, create=TRUE)
           self$current  = tblPosition$current

           if (data$base == 0) return (.updateBaseFiat(data)) # compra

           tblPosition$setField("available", current$available - data$ctcOut)
           if (data$major == 2) .calculateBaseOperation(data)
           tblPosition$apply()
       }
      ,.updateCounter = function(data) {
          tblPosition$select(camera=data$camera, currency=data$counter, create=TRUE)
          self$current  = tblPosition$current

          if (data$counter == 0) return (.updateCounterFiat(data))

          if (current$buy_low == 0)  self$current$buy_low = data$price + 1

          tblPosition$setField("buy_last",   data$price)
          if (data$price > current$buy_high) tblPosition$setField("buy_high", data$price)
          if (data$price < current$buy_low)  tblPosition$setField("buy_low",  data$price)

          wrk = (current$buy * current$buy_net) + (data$ctcIn * data$price)
          self$current$buy_net = wrk / (current$buy + data$ctcIn)
          tblPosition$setField("buy_net",  current$buy_net)

          tblPosition$setField("balance",   current$balance   + data$ctcIn)
          tblPosition$setField("available", current$available + data$ctcIn)

          self$current$buy = current$buy + data$ctcIn
          tblPosition$setField("buy",  current$buy)

          wrk = (current$buy * current$buy_net) - (current$sell * current$sell_net)
          den = current$buy - current$sell
          wrk = ifelse(den == 0, 0, wrk / den)
          self$current$net = wrk
          tblPosition$setField("net", current$net)

          # profit se actualiza si hay compras y ventas
          # if (current$buy > 0 && current$sell > 0) {
          #     tblPosition$setField("profit", (current$buy_net  * current$buy) -
          #                                    (current$sell_net * current$sell))
          # }

          tblPosition$apply()
      }
      ,.updateBaseFiat = function (data) {
           amount = data$ctcOut + data$fee
           tblPosition$setField("available", current$available - amount)
           if (data$major == 2) { # Ejecutado
               if (current$sell_low == 0)  self$current$sell_low = data$value + 1

               tblPosition$setField("sell_last",   data$ctcOut)
               if (data$value > current$sell_high) tblPosition$setField("sell_high", data$ctcOut)
               if (data$value < current$sell_low)  tblPosition$setField("sell_low",  data$ctcOut)
               tblPosition$setField("sell_net",  1)

               tblPosition$setField("sell",  current$sell + data$ctcOut)
               tblPosition$setField("net", 1)
               tblPosition$setField("balance",   current$balance   - amount)
           }
           tblPosition$apply()
      }
      ,.updateCounterFiat = function (data) {
           amount = data$ctcIn - data$fee
           tblPosition$setField("available", current$available + amount)
           if (data$major == 2) { # Ejecutado
               if (current$buy_low == 0)  self$current$buy_low = data$ctcIn + 1

               tblPosition$setField("buy_last",   data$ctcIn)
               if (data$value > current$buy_high) tblPosition$setField("buy_high", data$ctcIn)
               if (data$value < current$buy_low)  tblPosition$setField("buy_low",  data$ctcIn)
               tblPosition$setField("buy_net",  1)

               tblPosition$setField("buy",  current$buy + data$ctcIn)
               tblPosition$setField("net", 1)
               tblPosition$setField("balance",   current$balance   + amount)
               tblPosition$setField("profit", current$buy + data$ctcIn - current$sell)
           }
           tblPosition$apply()
      }
     ,.calculateBaseOperation = function(data) {
           if (current$sell_low == 0)  self$current$sell_low = data$price + 1

           tblPosition$setField("sell_last",   data$price)
           if (data$price > current$sell_high) tblPosition$setField("sell_high", data$price)
           if (data$price < current$sell_low)  tblPosition$setField("sell_low",  data$price)

           wrk = (current$sell * current$sell_net) + data$value
           wrk = wrk / (current$sell + data$ctcOut)
           self$current$sell_net = wrk
           tblPosition$setField("sell_net",  current$sell_net)

           self$current$sell = current$sell + data$ctcOut
           tblPosition$setField("sell",  current$sell)

           tblPosition$setField("balance",   current$balance   - data$ctcOut)


           wrk = (current$buy * current$buy_net) - (current$sell * current$sell_net)
           den = current$buy - current$sell
           wrk = ifelse(den == 0, 0, wrk / den)
           self$current$net = wrk
           tblPosition$setField("net", current$net)

          # profit se actualiza en las ventas (base es la crypto)
           browser()
          if (current$buy > 0 && current$sell > 0) {
              tblPosition$setField("profit", (current$sell_net * current$sell) -
                                             (current$buy_net  * current$buy))
          }
     }
    )
)
