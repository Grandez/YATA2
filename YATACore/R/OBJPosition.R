OBJPosition = R6::R6Class("OBJ.POSITION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print           = function() { message("Position")}
       ,initialize      = function(factory) {
           super$initialize(factory)
           private$prtPosition = factory$getTable(codes$tables$position)
       }
       ,getCameras = function() {
          df = prtPosition$getCameras()
          df[df$balance != 0,]
          as.list(df[df$camera != "CASH",1])
       }
       ,getGlobalPosition = function(full = FALSE) {
          df = prtPosition$getGlobalPosition()
          if (!full) df = df[df$balance > 0,]
          df
        }
       ,getPosition       = function(camera, currency) { prtPosition$getPosition(camera, currency) }
       ,getCameraPosition = function(camera, balance=FALSE, available = FALSE) {
           df = prtPosition$getCameraPosition(camera, balance, available)
           df[df$balance != 0,]
       }
       ,getCurrencyPosition = function(currency) { prtPosition$getCurrencyPosition(currency) }
       ,getFiatPosition = function(fiat) {
           oper = factory$getObject(codes$object$operation)
           cIn  = oper$getOperations(base="EXT")
           cOut = oper$getOperations(counter="EXT")
           inv  = getGlobalPosition()
           inv  = inv[inv$currency != fiat,]
           list(total = sum(cIn$amount), reimb=sum(cOut$amount) * -1, invest=sum(inv$balance * inv$priceBuy))
      }
       ,getHistoryCurrencies = function() {
         df = prtPosition$table()
         df = df[!df$currency %in% c("EUR", "USD"),]
         df = df %>% group_by(currency) %>% summarise(currency, min(since))
         colnames(df) = c("symbol", "since")
         df
      }
       ,getRegularizations = function() { prtPosition$getRegularizations() }
       ,transfer = function(from, to, currency, amount) {
         if (from != "EXT") {
             res = prtPosition$select(camera=from, currency=currency, create=TRUE)
             prtPosition$set(balance   = prtPosition$current$balance   - amount)
             prtPosition$set(available = prtPosition$current$available - amount)
             prtPosition$apply()
         }
         if (to != "EXT") {
             res = prtPosition$select(camera=to, currency=currency, create=TRUE)
             prtPosition$set(balance   = prtPosition$current$balance   + amount)
             prtPosition$set(available = prtPosition$current$available + amount)
             prtPosition$apply()
         }
      }
       ,updatePositions = function(data) {
          # Requires: camera, base, counter, amount, value, price, prcTaxes
          # Call 2 times because base is sell and counter is buy (distinct field names)
          # Amount sale de base y entra en counter
          if (data$amount == 0 || data$value == 0) return (invisible(self))
#browser()
          .updateBase(data)
          .updateCounter(data)
      }
       ,updateOper = function(camera, currency, amount, price, prcTaxes) {
          #JGG Hay que revisar modificado sin querer
          # if (amount == 0) return()
          # prtPosition$select(camera=camera, currency=currency, create=TRUE)
          # curr  = prtPosition$current
          #
          # pSell = curr$priceSell
          # nSell = curr$sell
          # pBuy = curr$priceBuy
          # nBuy = curr$buy
          # if (amount > 0) {
          #     pBuy = (pBuy * nBuy) + (amount * price)
          #     pBuy = ifelse((nBuy + amount) == 0, 0, pBuy / (nBuy + amount))
          #     nBuy = nBuy + amount
          #     prtPosition$set(priceBuy = pBuy, buy=nBuy)
          #     nBalance = amount
          # }
          # pPrice = 0
          # if ((nBuy - nSell) != 0) pPrice = ((pBuy * nBuy) - (pSell * nSell)) / (nBuy - nSell)
          #
          # prtPosition$setField("price", pPrice)
          #
          # tax = 0
          # if (prcTaxes != 0) {
          #     tax = nBalance * prcTaxes / 100
          #     if (tax > 0) tax = tax * -1
          # }
          # prtPosition$setField("balance",   curr$balance + nBalance + tax)
          # prtPosition$setField("available", curr$balance + nBalance + tax)
          # prtPosition$apply()
      }
      # ,update = function(camera, currency, amount, price, available=TRUE) {
      #     # Actualiza balance y calcula precios
      #     prtPosition$select(camera=camera, currency=currency, create=TRUE)
      #     curr  = prtPosition$current
      #     if (available) { # Solo descontar available
      #         prtPosition$set("available", curr$available + amount)
      #     }
      #     if (currency != "EUR") curr = getPrices(prtPosition$current, amount, price)
      #     prtPosition$set( balance   = prtPosition$current$balance + amount
      #                     ,buy       = curr$buy
      #                     ,sell      = curr$sell
      #                     ,priceBuy  = curr$priceBuy
      #                     ,priceSell = curr$priceSell
      #                     ,price     = curr$price
      #         )
      #     prtPosition$apply()
      # }
      ,updateAvailable = function(camera, currency, amount) {
          # Solo actualiza disponible
          prtPosition$select(camera=camera, currency=currency)
          prtPosition$set(available = prtPosition$getField("available") + amount)
          prtPosition$apply()
      }
      ,updateBalance = function(camera, currency, amount, available=TRUE) {
          # Solo actualiza balance y/o disponible
          prtPosition$select(camera=camera, currency=currency)
          prtPosition$set(balance = prtPosition$current$balance + amount)
          if (available) {
              prtPosition$set(available = prtPosition$current$available + amount)
          }
          prtPosition$apply()
      }

       # ,updatePosition    = function(currency, amount, balance=TRUE, available=TRUE, price = 0.0) {
       #     # Actualiza la cuenta currency (base o counter)
       #     prtPos$select(camera=current$camera,currency=currency, create=TRUE)
       #     oldAv    = prtPos$getField("available")
       #     oldBa    = prtPos$getField("balance")
       #     oldPrice = prtPos$getField("price")
       #
       #     if (price == 0) price = oldPrice
       #     if (available)  prtPos$setField("available",  oldAv + amount)
       #     if (balance  )  prtPos$setField("balance",    oldBa + amount)
       #
       #     if ((oldBa + amount) != 0) {
       #         medio = (oldBa * oldPrice) + (amount * price)
       #         medio = medio / (oldBa + amount)
       #         prtPos$setField("price", medio)
       #     }
       #     prtPos$apply()
       # }

      ##################################################
      ### Caches
      ##################################################
    )
    ,private = list(
        prtPosition  = NULL
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
           prtPosition$select(camera=data$camera, currency=data$base, create=TRUE)
           self$current  = prtPosition$current
           # El Euro me lleva loco
           if (data$base == "EUR") return (.updateBaseEuro(data))

           if (current$sellLow == 0)  self$current$sellLow = data$price + 1

           prtPosition$setField("sellLast",   data$price)
           if (data$price > current$sellHigh) prtPosition$setField("sellHigh", data$price)
           if (data$price < current$sellLow)  prtPosition$setField("sellLow",  data$price)

           wrk = (current$sell * current$sellNet) + data$amount
           self$current$sellNet = wrk / (current$sell + data$value)
           prtPosition$setField("sellNet",  current$sellNet)

           self$current$sell = current$sell + data$value
           prtPosition$setField("sell",  current$sell)

           prtPosition$setField("balance",   current$balance   - data$value)
           prtPosition$setField("available", current$available - data$value)

           wrk = (current$buy * current$buyNet) - (current$sell * current$sellNet)
           den = current$buy - current$sell
           wrk = ifelse(den == 0, 0, wrk / den)
           prtPosition$setField("value", wrk)

          # profit se actualiza si hay compras y ventas
          if (current$buy > 0 && current$sell > 0) {
              prtPosition$setField("profit", (current$sellNet * current$sell) -
                                             (current$buyNet  * current$buy))
          }

           prtPosition$apply()
       }
      ,.updateCounter = function(data) {
          prtPosition$select(camera=data$camera, currency=data$counter, create=TRUE)
          self$current  = prtPosition$current

          if (data$counter == "EUR") return (.updateCounterEuro(data))

          if (current$buyLow == 0)  self$current$buyLow = data$price + 1

          prtPosition$setField("buyLast",   data$price)
          if (data$price > current$buyHigh) prtPosition$setField("buyHigh", data$price)
          if (data$price < current$buyLow)  prtPosition$setField("buyLow",  data$price)

          wrk = (current$buy * current$buyNet) + (data$amount * data$price)
          self$current$buyNet = wrk / (current$buy + data$amount)
          prtPosition$setField("buyNet",  current$buyNet)

          prtPosition$setField("balance",   current$balance   + data$amount)
          prtPosition$setField("available", current$available + data$amount)

          self$current$buy = current$buy + data$amount
          prtPosition$setField("buy",  current$buy)

          wrk = (current$buy * current$buyNet) - (current$sell * current$sellNet)
          den = current$buy - current$sell
          wrk = ifelse(den == 0, 0, wrk / den)
          prtPosition$setField("value", wrk)

          # profit se actualiza si hay compras y ventas
          if (current$buy > 0 && current$sell > 0) {
              prtPosition$setField("profit", (current$buyNet  * current$buy) -
                                             (current$sellNet * current$sell))
          }

          prtPosition$apply()
      }
      ,.updateBaseEuro = function (data) {
           if (current$sellLow == 0)  self$current$sellLow = data$value + 1

           prtPosition$setField("sellLast",   data$value)
           if (data$value > current$sellHigh) prtPosition$setField("sellHigh", data$value)
           if (data$value < current$sellLow)  prtPosition$setField("sellLow",  data$value)
           prtPosition$setField("sellNet",  1)

           prtPosition$setField("sell",  current$sell + data$value)
           prtPosition$setField("value", 1)
           prtPosition$setField("balance",   current$balance   - data$value)
           prtPosition$setField("available", current$available - data$value)
           prtPosition$apply()
      }
      ,.updateCounterEuro = function (data) {
           if (current$buyLow == 0)  self$current$buyLow = data$amount + 1

           prtPosition$setField("buyLast",   data$amount)
           if (data$amount > current$buyHigh) prtPosition$setField("buyHigh", data$amount)
           if (data$amount < current$buyLow)  prtPosition$setField("buyLow",  data$amount)
           prtPosition$setField("buyNet",  1)

           prtPosition$setField("buy",  current$buy + data$amount)
           prtPosition$setField("value", 1)
           prtPosition$setField("balance",   current$balance   + data$amount)
           prtPosition$setField("available", current$available + data$amount)
           prtPosition$setField("profit", current$buy + data$amount - current$sell)
           prtPosition$apply()
      }
    )
)
