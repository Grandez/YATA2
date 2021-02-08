OBJOperation = R6::R6Class("OBJ.OPERATION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        initialize = function(idOper) {
            super$initialize()
            createTables()
            if (!missing(idOper)) getOperation(idOper)
        }
        ##############################
        # Operaciones
        ##############################
        ,xfer  = function(...) { add(YATACodes$oper$xfer, ...) }
        ,open  = function(...) { add(YATACodes$oper$oper, ...) }
        ,buy   = function(...) { add(YATACodes$oper$buy,  ...) }
        ,sell  = function(...) { add(YATACodes$oper$sell, ...) }
        ,split = function()   { error("Split no implementado todavia")}
        ,net   = function()   { error("Net no implementado todavia")}
        ,add   = function(type, ...) {
            # Genera una operacion, devuelve el id
            # Si hay error devuelve TRUE
            args = list(...)
            if (length(args) == 1 && is.list(args)) args = args[[1]]

            self$current        = args
            self$current$type   = type
            self$current$id     = YATATools::getID()
            self$current$idOper = self$current$id
            if (type == YATACodes$oper$sell) self$current$amount = self$current$amount * -1
            tryCatch({
                db$begin()
                if (type == YATACodes$oper$xfer) operXfer()
                if (type == YATACodes$oper$oper) operOper()
                if (type == YATACodes$oper$buy)  operOper()
                if (type == YATACodes$oper$sell) operOper()
                if (type == YATACodes$oper$split) {}
                if (type == YATACodes$oper$net)  {}
                generateLog()
                db$commit()
                self$current$idOper
            },error = function(cond) {
                db$rollback()
                message(cond)
                0
          })
        }
        ##############################
        # Acciones sobre operacion
        ##############################
        ,accept  = function(price=0, amount=0, fee = 0, id=NULL) {
            if (!is.null(id)) select(id)
            if (current$type == YATACodes$oper$sell) res = acceptSell(price, amount, fee)
            if (current$type != YATACodes$oper$sell) res = acceptBuy (price, amount, fee)
            res
        }
        ,execute = function(gas = 0, id=NULL) {
            # La operacion se ha realizado, esta en el wallet
            if (!is.null(id)) select(id)
            tryCatch({
               db$begin()
               tblOper$set(status=YATACodes$status$executed)
               if (current$type != YATACodes$oper$oper) tblOper$set(active=YATACodes$flag$inactive)
               tblOper$apply()
               if (current$type == YATACodes$oper$sell) executeSell(gas)
               if (current$type != YATACodes$oper$sell) executeBuy(gas)
               db$commit()
               FALSE
            },error = function(cond) {
               message(cond)
               YATADB$rollback()
               TRUE
            })
        }
        ,cancel  = function(comment=NULL, delete=FALSE, id=NULL) {
            res = FALSE
            if (!is.null(id)) select(id)
            self$current$comment = comment
            if (current$active != YATACodes$flag$active ||
                current$status != YATACodes$status$pending) {
                error("La operacion no se puede cancelar")
            }
            # marca la operacion como cancelada
            res = tryCatch({
                db$begin()
                if (current$type %in% c(YATACodes$oper$oper, YATACodes$oper$buy)) {
                    updatePosition(self$current$base, current$amount * current$price, FALSE, TRUE)
                }
                tblOper$set(status = YATACodes$status$cancelled, active = YATACodes$flag$inactive)
                tblOper$apply()
                generateLog()
                db$commit()
                FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                TRUE
            })
            if (delete) {
                res = tryCatch({
                   db$begin()
                   tblFlows$remove        (idOper = current$id)
                   tblOperLog$remove      (idOper = current$id)
                   tblOperControl$remove  (idOper = current$id)
                   tblOper$remove         (id = current$id)
                   db$commit()
                   FALSE
                }, error = function(cond) {
                   message(cond)
                   db$rollback()
                   TRUE
                })
            }
            res
        }
        ,reject  = function(comment=NULL, id=NULL) {
            if (!is.null(id)) select(id)
            self$currrent$comment = comment
            tryCatch({
                db$begin()
                if (current$type %in% c(YATACodes$oper$oper, YATACodes$oper$buy)) {
                    updatePosition(self$current$base, current$amount * current$price, FALSE, TRUE)
                }
                tblOper$set(status = YATACodes$status$rejected, active = YATACodes$flag$inactive)
                tblOper$apply()
                generateLog()
                db$commit()
                FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                TRUE
            })
        }
        ,comment = function(comment=NULL, id=NULL) {
            if (is.null(comment)) return (FALSE)
            if (!is.null(id)) select(id)
            tryCatch({
                db$begin()
                generateLog()
                db$commit()
                FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                TRUE
            })
        }
        ,getComments = function(id = NULL) {
            if (!is.null(id)) select(id)
            tblOperLog$table(idOper = current$id)
        }
        ##############################
        # General
        ##############################
        ,select            = function(idOper, full=FALSE) {
            tblOper$select(id = idOper)
            self$current = tblOper$current
            self$current$idOper = tblOper$current$id
            if (full) tblFlows$select(idOper = idOper)
            invisible(self)
        }
        ,getPending        = function()    { getOperations(status=YATACodes$status$pending)   }
        ,getAccepted       = function()    { getOperations(status=YATACodes$status$accepted)  }
        ,getExecuted       = function()    { getOperations(status=YATACodes$status$executed)  }
        ,getCancelled      = function()    { getOperations(status=YATACodes$status$cancelled) }
        ,getRejected       = function()    { getOperations(status=YATACodes$status$rejected)  }
        ,getActive         = function(...) { tblOper$table(active=YATACodes$flag$active, ...) }
        ,getOperationsExt  = function(...) { tblOper$table( ...) }
        ,getFullOperations = function(...) {
            df = tblOper$table(...)
            if (nrow(df) > 0) {
                df2 = tblOperControl$table(invalues=list(id=df$id))
                df = inner_join(df, df2)
            }
            df
        }
        ,getOperation      = function (id, full=FALSE) {
            res = tblOper$table(id = id)
            if (nrow(res) != 1) return (NULL)
            as.list(res)
         }
        ,getFlows          = function(idOper)    {
            if (!missing(idOper)) select(idOper, full=TRUE)
            tblFlows$dfCurrent
        }
        ,getDateBegin      = function(currency) { tblOper$getDateBegin(currency) }
        ,setAlert = function(fecha=NULL) {
            if (is.null(fecha)) {
                tblOper$setField("alert", DBDict$flag$inactive)
            }
            else {
                tblOper$setField("alert", DBDict$flag$active)
                tblOper$setField("dtAlert", fecha)
            }
            tblOper$apply()
            invisible(self)
        }
    )
    ,private = list(
        # Tablas asociadas
        tblOper        = NULL
       ,tblOperControl = NULL
       ,tblOperLog     = NULL
       ,tblPos         = NULL
       ,tblFlows       = NULL
       ,addRecord      = function(table) {
             cols = names(table$getColNames())
             table$add(current[cols])
       }
       ,addFlow        = function(type, currency, amount, price) {
           data = list(
              idOper   = self$current$idOper
             ,idFlow   = YATATools::getID()
             ,type     = type
             ,currency = currency
             ,amount   = amount
             ,price    = price
           )
           tblFlows$add(data)
       }
       ,generateLog       = function() {
            if (!is.null(current$comment)) {
               self$current$idLog   = YATATools::getID()
               self$current$idOper  = current$id
               addRecord(tblOperLog)
            }
        }
       ,updatePosition    = function(currency, amount, balance=TRUE, available=TRUE, price = 0.0) {
           # Actualiza la cuenta currency (base o counter)
           tblPos$select(camera=current$camera,currency=currency, create=TRUE)
           oldAv    = tblPos$getField("available")
           oldBa    = tblPos$getField("balance")
           oldPrice = tblPos$getField("price")

           if (price == 0) price = oldPrice
           if (available)  tblPos$setField("available",  oldAv + amount)
           if (balance  )  tblPos$setField("balance",    oldBa + amount)

           if ((oldBa + amount) != 0) {
               medio = (oldBa * oldPrice) + (amount * price)
               medio = medio / (oldBa + amount)
               tblPos$setField("price", medio)
           }
           tblPos$apply()
       }
       ,updateOperControl = function(fee=0,gas=0) {
           tblOperControl$select(id=self$current$id, create=TRUE)
           tblOperControl$addField(DBDict$fields$fee, fee)
           tblOperControl$addField(DBDict$fields$gas, gas)
           tblOperControl$apply()
        }
       ,operXfer     = function() {
           self$current$camera  = "XFER"
           self$current$base    = self$current$from
           self$current$counter = self$current$to
           self$current$price   = 1
           self$current$active  = YATACodes$flag$inactive
           self$current$status  = YATACodes$status$executed

           # 1 - Grabar la operacion
           # 2 - Grabar los flujos
           # 3 - Actualizar posiciones
          addRecord(private$tblOper)
          self$current$base    = self$current$currency
          self$current$counter = self$current$currency

          # Si el dinero es de fuera, no se genera
          if (self$current$from != "EXT") {
              # Descontar de la fuente
              amount = self$current$amount * -1
              self$current$camera = self$current$from
              addFlow (YATACodes$flow$xferOut, self$current$base, amount, 1)
              updatePosition(self$current$currency, amount, TRUE, TRUE, 1)
          }
          # Incrementar destino
          if (self$current$to != "EXT") {
              self$current$camera = self$current$to
              addFlow (YATACodes$flow$xferIn,  self$current$counter, self$current$amount, 1)
              updatePosition(self$current$currency, self$current$amount, TRUE, TRUE, 1)
          }
       }
       ,operOper     = function() {

           self$current$active = YATACodes$flag$active
           self$current$status = YATACodes$status$pending

           days = ifelse(is.null(self$current$alert), lubridate::days(parms$getAlertDays(1))
                                                    , self$current$alert)
           self$current$dtAlert = Sys.Date() + lubridate::days(days)
           self$current$alert   = YATACodes$flag$active

           addRecord(private$tblOper)
           addRecord(private$tblOperControl)

           amount = (self$current$amount * self$current$price) * -1
           # Si es una venta no se actualiza disponible
           if (current$type != YATACodes$oper$sell)
               updatePosition(current$base, amount, FALSE, TRUE)
       }
       ,acceptBuy    = function(price, amount, fee) {
            oldPrice  = current$price
            oldAmount = current$amount
            newPrice  = ifelse(price  == 0, oldPrice,  price)
            newAmount = ifelse(amount == 0, oldAmount, amount)
            diffAmount = newAmount - oldAmount
            diffPrice  = newPrice  - oldPrice
            impFee     = (newAmount * fee) / -100
            imp        = newAmount * newPrice
            regularize = ifelse(diffAmount != 0 || diffPrice != 0, TRUE, FALSE)

            tryCatch({
               db$begin()
               tblOper$set(status=YATACodes$status$accepted, amount=newAmount, price=newPrice)
               tblOper$apply()
               addFlow(YATACodes$flow$output, self$current$base, oldAmount * -1, oldPrice)
               if (regularize) addFlow(YATACodes$flow$regOutput, self$current$base, diffAmount, diffPrice)
               if (impFee != 0) {
                   addFlow(YATACodes$flow$fee, self$current$base, impFee,    newPrice)
                   updateOperControl(fee = (impFee * -1))
               }
               updatePosition(self$current$base, (imp + impFee) * -1, TRUE, FALSE)
               if (diffAmount != 0) updatePosition(currency, diffAmount, FALSE, TRUE)
               db$commit()
               FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                TRUE
            })
       }
       ,acceptSell   = function(price, amount, fee) {
            oldPrice  = current$price
            oldAmount = current$amount
            newPrice  = ifelse(price  == 0, oldPrice,  price)
            newAmount = ifelse(amount == 0, oldAmount, amount)
            diffAmount = newAmount - oldAmount
            diffPrice  = newPrice  - oldPrice
            impFee     = (newAmount * fee) / -100
            imp        = newAmount * newPrice
            regularize = ifelse(diffAmount != 0 || diffPrice != 0, TRUE, FALSE)

            tryCatch({
               db$begin()
               tblOper$set(status=YATACodes$status$accepted, amount=newAmount, price=newPrice)
               tblOper$apply()
               addFlow(YATACodes$flow$output, current$counter, oldAmount, 1)
               if (regularize) addFlow(YATACodes$flow$regInput,current$counter,diffAmount,1)
               addFlow(YATACodes$flow$pending, current$base, newAmount * -1, newPrice)
               if (impFee != 0) {
                   addFlow(YATACodes$flow$fee, self$current$counter, impFee,    newPrice)
                   updateOperControl(fee = (impFee * -1))
               }
               updatePosition(current$counter, newAmount + (impFee * -1), TRUE, TRUE)
               if (diffAmount != 0) updatePosition(current$counter, diffAmount, FALSE, TRUE)
               db$commit()
               FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                TRUE
            })

       }
       ,executeBuy   = function(gas = 0) {
               flowType = ifelse(current$type == YATACodes$oper$sell
                                ,YATACodes$flow$output
                                ,YATACodes$flow$input)
               addFlow(YATACodes$flow$input, self$current$counter, current$amount, 1) # current$price)
               if (gas != 0)  {
                   gas = (gas * current$amount) / 100
                   addFlow(YATACodes$flow$gas, current$counter, gas * -1, 1) #current$price)
               }
               nAmount = current$amount - gas
               updatePosition(current$counter, nAmount, TRUE, TRUE, price=current$price)
               updateOperControl(gas=gas)
        }
       ,executeSell  = function(gas = 0) {
           tblFlows$select(idOper = current$idOper, type = YATACodes$flow$pending)
           tblFlows$set(type = YATACodes$flow$input)
           tblFlows$apply()

           if (gas != 0)  {
               gas = (gas * current$amount) / -100
               addFlow(YATACodes$flow$gas, current$counter, gas, 1) #current$price)
               updatePosition(current$counter, gas, TRUE, TRUE, 1)
            }
            updatePosition(current$base, current$amount * current$price * -1, TRUE, TRUE)
            updateOperControl(gas=gas)
        }
       ,createTables = function() {
            private$tblOper        = YATAFactory$getTable(YATACodes$tables$Operations)
            private$tblPos         = YATAFactory$getTable(YATACodes$tables$Position)
            private$tblFlows       = YATAFactory$getTable(YATACodes$tables$Flows)
            private$tblOperControl = YATAFactory$getTable(YATACodes$tables$OperControl)
            private$tblOperLog     = YATAFactory$getTable(YATACodes$tables$OperLog)

       }
    )
)

