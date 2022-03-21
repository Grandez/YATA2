OBJPosition = R6::R6Class("OBJ.POSITION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print           = function() { message("Position")}
       ,initialize      = function(Factory) {
           super$initialize(Factory)
           private$tblPosition = Factory$getTable(self$codes$tables$position)
       }
       ,getCameras = function() {
          df = tblPosition$getCameras()
          df[df$balance != 0,]
          as.list(df[df$camera != "CASH",1])
       }
       ,getGlobalPosition = function(full = FALSE) {
          df = tblPosition$getGlobalPosition()
          if (!full) df = df[df$balance > 0,]
          df
        }
       ,getPosition       = function(camera, currency) {
           df = tblPosition$getPosition(camera, currency)
           self$current = tblPosition$current
           df
         }
       ,getCameraPosition = function(camera, balance=FALSE, available = FALSE) {
           df = tblPosition$getCameraPosition(camera, balance, available)
           df[df$balance != 0,]
       }
       ,getCurrencyPosition = function(currency) { tblPosition$getCurrencyPosition(currency) }
       ,getFiatPosition = function(fiat) {
           df = tblPosition$getCurrencyPosition("$FIAT")
           # oper = Factory$getObject(self$codes$object$operation)
           # cIn  = oper$getOperations(base="EXT")
           # cOut = oper$getOperations(counter="EXT")
           # inv  = getGlobalPosition()
           # inv  = inv[inv$currency != fiat,]
           # list(total = sum(cIn$amount), reimb=sum(cOut$amount) * -1, invest=sum(inv$balance * inv$priceBuy))
list(total = 1, reimb=1 * -1, invest=sum(1 * 1))
      }
       ,getHistoryCurrencies = function() {
         df = tblPosition$table()
         df = df[!df$currency == "$FIAT",]
         df = df %>% group_by(currency) %>% summarise(currency, min(since))
         colnames(df) = c("symbol", "since")
         df
      }
       ,getRegularizations = function() { tblPosition$getRegularizations() }
       ,transfer = function(from, to, currency, amount, value) {
           res = tblPosition$select(camera=from, currency=currency)
           tblPosition$set(balance   = tblPosition$current$balance   - amount)
           tblPosition$set(available = tblPosition$current$available - amount)
           tblPosition$apply()

           res = tblPosition$select(camera=to, currency=currency, create=TRUE)

           nvalue = tblPosition$current$balance * tblPosition$current$value
           nvalue = nvalue + (amount * value)
           nvalue = nvalue / (tblPosition$current$balance + amount)

           tblPosition$set(value     = nvalue)
           tblPosition$set(balance   = tblPosition$current$balance   + amount)
           tblPosition$set(available = tblPosition$current$available + amount)
           tblPosition$apply()
           invisible(self)

         # if (from != "EXT") {
         #     res = tblPosition$select(camera=from, currency=currency, create=TRUE)
         # }
         # if (to != "EXT") {
         #
         #     tblPosition$apply()
         # }
      }
       ,updatePositions = function(data) {
          # Requires: camera, base, counter, amount, value, price, prcTaxes
          # Call 2 times because base is sell and counter is buy (distinct field names)
          # Amount sale de base y entra en counter
          if (data$amount == 0 || data$value == 0) return (invisible(self))
          .updateBase(data)
          .updateCounter(data)
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
      ,updateBalance = function(camera, currency, amount, available=TRUE) {
          # Solo actualiza balance y/o disponible
          tblPosition$select(camera=camera, currency=currency)
          tblPosition$set(balance = tblPosition$current$balance + amount)
          if (available) {
              tblPosition$set(available = tblPosition$current$available + amount)
          }
          tblPosition$apply()
      }
      ,updatePosition    = function(values) {
           tblPosition$select(camera=values$camera,currency=values$currency, create=TRUE)
           tblPosition$set(values)
           tblPosition$apply()
       }

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

           if (data$base == "$FIAT") return (.updateBaseFiat(data))

           if (current$sellLow == 0)  self$current$sellLow = data$price + 1

           tblPosition$setField("sellLast",   data$price)
           if (data$price > current$sellHigh) tblPosition$setField("sellHigh", data$price)
           if (data$price < current$sellLow)  tblPosition$setField("sellLow",  data$price)

           wrk = (current$sell * current$sellNet) + data$value
           wrk = wrk / (current$sell + data$amount)
           self$current$sellNet = wrk
           tblPosition$setField("sellNet",  current$sellNet)

           self$current$sell = current$sell + data$amount
           tblPosition$setField("sell",  current$sell)

           tblPosition$setField("balance",   current$balance   - data$amount)
           tblPosition$setField("available", current$available - data$amount)

           wrk = (current$buy * current$buyNet) - (current$sell * current$sellNet)
           den = current$buy - current$sell
           wrk = ifelse(den == 0, 0, wrk / den)
           self$current$value = wrk
           tblPosition$setField("value", current$value)

          # profit se actualiza si hay compras y ventas
          if (current$buy > 0 && current$sell > 0) {
              tblPosition$setField("profit", (current$sellNet * current$sell) -
                                             (current$buyNet  * current$buy))
          }

           tblPosition$apply()
       }
      ,.updateCounter = function(data) {
          tblPosition$select(camera=data$camera, currency=data$counter, create=TRUE)
          self$current  = tblPosition$current

          if (data$counter == "$FIAT") return (.updateCounterFiat(data))

          if (current$buyLow == 0)  self$current$buyLow = data$price + 1

          tblPosition$setField("buyLast",   data$price)
          if (data$price > current$buyHigh) tblPosition$setField("buyHigh", data$price)
          if (data$price < current$buyLow)  tblPosition$setField("buyLow",  data$price)

          wrk = (current$buy * current$buyNet) + (data$value * data$price)
          self$current$buyNet = wrk / (current$buy + data$value)
          tblPosition$setField("buyNet",  current$buyNet)

          tblPosition$setField("balance",   current$balance   + data$value)
          tblPosition$setField("available", current$available + data$value)

          self$current$buy = current$buy + data$value
          tblPosition$setField("buy",  current$buy)

          wrk = (current$buy * current$buyNet) - (current$sell * current$sellNet)
          den = current$buy - current$sell
          wrk = ifelse(den == 0, 0, wrk / den)
          self$current$value = wrk
          tblPosition$setField("value", current$value)

          # profit se actualiza si hay compras y ventas
          if (current$buy > 0 && current$sell > 0) {
              tblPosition$setField("profit", (current$buyNet  * current$buy) -
                                             (current$sellNet * current$sell))
          }

          tblPosition$apply()
      }
      ,.updateBaseFiat = function (data) {
           if (current$sellLow == 0)  self$current$sellLow = data$amount + 1

           tblPosition$setField("sellLast",   data$amount)
           if (data$amount > current$sellHigh) tblPosition$setField("sellHigh", data$amount)
           if (data$amount < current$sellLow)  tblPosition$setField("sellLow",  data$amount)
           tblPosition$setField("sellNet",  1)

           tblPosition$setField("sell",  current$sell + data$amount)
           tblPosition$setField("value", 1)
           tblPosition$setField("balance",   current$balance   - data$amount)
           tblPosition$setField("available", current$available - data$amount)
           tblPosition$apply()
      }
      ,.updateCounterFiat = function (data) {
           if (current$buyLow == 0)  self$current$buyLow = data$value + 1

           tblPosition$setField("buyLast",   data$value)
           if (data$value > current$buyHigh) tblPosition$setField("buyHigh", data$value)
           if (data$value < current$buyLow)  tblPosition$setField("buyLow",  data$value)
           tblPosition$setField("buyNet",  1)

           tblPosition$setField("buy",  current$buy + data$value)
           tblPosition$setField("value", 1)
           tblPosition$setField("balance",   current$balance   + data$value)
           tblPosition$setField("available", current$available + data$value)
           tblPosition$setField("profit", current$buy + data$value - current$sell)
           tblPosition$apply()
      }
    )
)
