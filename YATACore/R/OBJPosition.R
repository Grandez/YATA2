OBJPosition = R6::R6Class("OBJ.POSITION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print           = function() { message("Position")}
       ,initialize      = function(factory) {
           super$initialize(factory)
           private$prtPosition = factory$getTable(codes$tables$Position)
       }
       ,getCameras = function() {
          df = prtPosition$getCameras()
          as.list(df[df$camera != "CASH",1])
       }
       ,getGlobalPosition = function() {
          df = prtPosition$getGlobalPosition()
          df = add_column(df, value = df$balance * df$price, .after="price")
          yataSetClasses(df, dat=c("since", "last"))
       }
       ,getPosition       = function(camera, currency) { prtPosition$getPosition(camera, currency) }
       ,getCameraPosition = function(camera, balance=FALSE, available = FALSE) {
           df = prtPosition$getCameraPosition(camera, balance, available)
           # df = df[,2:ncol(df)]
           # browser()
           # df = add_column(df, value = df$balance * df$price, .after="price")
           #
           # yataSetClasses(df, dat=c("since", "last"))
      }
      ,transfer = function(from, to, currency, amount) {
         if (from != "EXT") {
             res = prtPosition$select(camera=from, currency=currency, create=TRUE)
             prtPosition$set(balance   = prtPosition$current$balance   - amount)
             prtPosition$set(available = prtPosition$current$available - amount)
             prtPosition$apply()
         }
         if (to != "EXT") {
             res = prtPosition$select(camera=to, currency=currency, create=TRUE)
             browser()
             prtPosition$set(balance   = prtPosition$current$balance   + amount)
             prtPosition$set(available = prtPosition$current$available + amount)
             prtPosition$apply()
         }
      }
      ,updateOper = function(camera, currency, amount, price, prcTaxes) {
          if (amount == 0) return()
          prtPosition$select(camera=camera, currency=currency, create=TRUE)
          curr  = prtPosition$current

          pSell = curr$priceSell
          nSell = curr$sell
          # Si amount es positivo es compra, si no venta
          if (amount < 0) {
              pSell = (pSell * nSell) - (amount * price)
              pSell = ifelse((nSell - amount) == 0, 0, pSell / (nSell - amount))
              nSell = nSell - amount
              prtPosition$set(priceSell = pSell, sell=nSell)
              nBalance = amount * price
          }

          pBuy = curr$priceBuy
          nBuy = curr$buy
          if (amount > 0) {
              pBuy = (pBuy * nBuy) + (amount * price)
              pBuy = ifelse((nBuy + amount) == 0, 0, pBuy / (nBuy + amount))
              nBuy = nBuy + amount
              prtPosition$set(priceBuy = pBuy, buy=nBuy)
              nBalance = amount
          }
          pPrice = 0
          if ((nBuy - nSell) != 0) pPrice = ((pBuy * nBuy) - (pSell * nSell)) / (nBuy - nSell)

          prtPosition$setField("price", pPrice)

          tax = 0
          if (prcTaxes != 0) {
              tax = nBalance * prcTaxes / 100
              if (tax > 0) tax = tax * -1
          }
          prtPosition$setField("balance", curr$balance + nBalance + tax)
          prtPosition$apply()
      }
      ,update = function(camera, currency, amount, price, available=TRUE) {
          # Actualiza balance y calcula precios
          prtPosition$select(camera=camera, currency=currency, create=TRUE)
          curr  = prtPosition$current
          if (available) { # Solo descontar available
              prtPosition$set("available", curr$available + amount)
          }
          if (currency != "EUR") curr = getPrices(prtPosition$current, amount, price)
          prtPosition$set( balance   = prtPosition$current$balance + amount
                          ,buy       = curr$buy
                          ,sell      = curr$sell
                          ,priceBuy  = curr$priceBuy
                          ,priceSell = curr$priceSell
                          ,price     = curr$price
              )
          prtPosition$apply()
      }
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
    )
)
