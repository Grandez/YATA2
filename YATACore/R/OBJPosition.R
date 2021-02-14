OBJPosition = R6::R6Class("OBJ.POSITION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        print           = function() { message("Positions Object")}
       ,initialize      = function() {
           super$initialize()
           private$prtPosition = YATAFactory$getTable(YATACodes$tables$Position)
       }
       ,getCameras = function() {
          df = prtPosition$getCameras()
          as.list(df[,1])
       }
       ,getGlobalPosition = function() {
          df = prtPosition$getGlobalPosition()
          df$value = df$balance * df$price
          yataSetClasses(df)
       }
       ,getPosition       = function(camera, currency) { prtPosition$getPosition(camera, currency) }
       ,getCameraPosition = function(camera, balance=FALSE, available = FALSE) {
           df = prtPosition$getCameraPosition(camera, balance, available)
           df$value = df$balance * df$price
           yataSetClasses(df, dat=c(6))
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
             prtPosition$set(balance   = prtPosition$current$balance   + amount)
             prtPosition$set(available = prtPosition$current$available + amount)
             prtPosition$apply()
         }
      }
      ,update = function(camera, currency, amount, price, available=TRUE) {
          # Actualiza balance y calcula precios
          prtPosition$select(camera=camera, currency=currency, create=TRUE)
          curr  = prtPosition$current
          if (available) { # Solo descontar available
              prtPosition$set(available = curr$available + amount)
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
