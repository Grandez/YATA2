OBJOperation = R6::R6Class("OBJ.OPERATION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        initialize = function(idOper) {
            super$initialize()
            private$prtOper        = YATAFactory$getTable(YATACodes$tables$Operations)
            private$tblFlows       = YATAFactory$getTable(YATACodes$tables$Flows)
            # private$tblOperControl = YATAFactory$getTable(YATACodes$tables$OperControl)
            # private$tblOperLog     = YATAFactory$getTable(YATACodes$tables$OperLog)
            private$objPos         = YATAFactory$getObject(YATACodes$object$position)

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

            self$current        = args2list(...)
            self$current$type   = type
            self$current$id     = YATATools::getID()
            self$current$idOper = self$current$id
            if (type %in% c(YATACodes$oper$sell, YATACodes$oper$close)) {
                self$current$amount = current$amount * -1
            }
            tryCatch({
                db$begin()
                if (type == YATACodes$oper$xfer)  operXfer()
                if (type == YATACodes$oper$oper)  operOper()
                if (type == YATACodes$oper$buy)   operOper()
                if (type == YATACodes$oper$sell)  operOper()
#                if (type == YATACodes$oper$close) operClose()
#                if (type == YATACodes$oper$split) {}
                if (type == YATACodes$oper$net)  {}
#                generateLog()
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
            tryCatch({
               db$begin()
               if (!is.na(current$idParent)) {
                   prtOper$setField("active", YATACodes$flag$inactive)
                   prtOper$apply()
               }
               if (current$type == YATACodes$oper$sell) acceptSell(price, amount, fee)
               if (current$type != YATACodes$oper$sell) acceptBuy (price, amount, fee)
               db$commit()
               FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                TRUE
            })
        }
        ,execute = function(gas = 0, id=NULL) {
            browser()
            # La operacion se ha realizado, esta en el wallet
            if (!is.null(id)) select(id)
            tryCatch({
               db$begin()
               if (current$type == YATACodes$oper$sell) res = executeSell(gas)
               if (current$type != YATACodes$oper$sell) res = executeBuy (gas)
               db$commit()
               FALSE
            },error = function(cond) {
               message(cond)
               db$rollback()
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
                currency = current$base
                imp      = current$amount * current$price
                if (current$type == YATACodes$oper$sell) {
                    currency = current$counter
                    imp      = current$amount * -1
                }
                objPos$updateAvailable(current$camera, currency, imp)
                prtOper$set(status = YATACodes$status$cancelled, active = YATACodes$flag$inactive)
                prtOper$apply()
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
#                   tblOperLog$remove      (idOper = current$id)
#                   tblOperControl$remove  (idOper = current$id)
                   prtOper$remove         (id = current$id)
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
                prtOper$set(status = YATACodes$status$rejected, active = YATACodes$flag$inactive)
                prtOper$apply()
                generateLog()
                db$commit()
                FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                TRUE
            })
        }
        ,close   = function(...) {
            browser()
            split = FALSE
            data = args2list(...)
            select(data$id)
            tryCatch({
                db$begin()

                # Es un split
                if(data$amount != current$amount) split = TRUE
                stat = ifelse(split, YATACodes$oper$split, YATACodes$oper$close)
                prtOper$update( list(active  = YATACodes$flag$parent
                               ,status  = stat
                               ,reason  = data$reason
                               ,comment = data$comment))

                # Creamos el split
                if (split) {
                    diff = current$amount - data$amount
                    select(current$id, create=TRUE)
                    current$idParent = data$id
                    self$current = list.merge(self$current, data)
                    current$amount = diff
                    current$status = YATACodes$oper$oper
                    current$active = YATACodes$flag$active
                    prtOper$update(current)
                }

                #Creamos la venta
                self$current$type   = YATACodes$oper$sell
                self$current$amount = data$amount
                self$current$price  = data$price
                self$current$parent = data$id
                self$current$reason = data$reason
                operOper()
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
#            tblOperLog$table(idOper = current$id)
        }
        ##############################
        # General
        ##############################
        ,select            = function(idOper, create=FALSE) {
            prtOper$select(id = idOper, create=create)
            self$current = prtOper$current
            self$current$idOper = prtOper$current$id
            if (full) tblFlows$select(idOper = idOper)
            invisible(self)
        }
        ,getPending        = function()    { getOperations(status=YATACodes$status$pending)   }
        ,getAccepted       = function()    { getOperations(status=YATACodes$status$accepted)  }
        ,getExecuted       = function()    { getOperations(status=YATACodes$status$executed)  }
        ,getCancelled      = function()    { getOperations(status=YATACodes$status$cancelled) }
        ,getRejected       = function()    { getOperations(status=YATACodes$status$rejected)  }
        ,getActive         = function(...) { prtOper$table(active=YATACodes$flag$active, ...) }
        ,getOperations     = function(...) { prtOper$table(...)                               }
        ,getOperation      = function (id) {
            res = prtOper$table(id=id)
            if (nrow(res) != 1) return (NULL)
            as.list(res)
        }
        ,getFlows          = function(idOper)    {
            if (!missing(idOper)) select(idOper)
            tblFlows$dfCurrent
        }
#        ,getDateBegin      = function(currency) { prtOper$getDateBegin(currency) }
        ,setAlert = function(fecha=NULL) {
            if (is.null(fecha)) {
                prtOper$setField("alert", DBDict$flag$inactive)
            }
            else {
                prtOper$setField("alert", DBDict$flag$active)
                prtOper$setField("dtAlert", fecha)
            }
            prtOper$apply()
            invisible(self)
        }
        ,getReasons        = function(type) {
            gral = parms$getSubgroup(DBParms$group$reasons, DBParms$reasons$gral)
            oth  = parms$getSubgroup(DBParms$group$reasons, type)
            df = rbind(gral, oth)
            df$value = paste0("REASON.", df$value)
            df$name  = "MISSING"
            msgs = YATAFactory$getMSG()
            for (row in 1:nrow(df)) {
                data = msgs$get(df[row,"value"])
                df[row, "name"] = msgs$get(df[row,"value"])
            }
            df[order(df$id),c("id", "name")]
        }
    )
    ,private = list(
        # Tablas asociadas
        prtOper        = NULL
#       ,tblOperControl = NULL
#       ,tblOperLog     = NULL
       ,objPos         = NULL
       ,tblFlows       = NULL
       ,addRecord      = function(table) {
           # browser()
           #   cols = names(table$getColNames())
           #   table$add(current[cols])
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
#               addRecord(tblOperLog)
            }
        }
       # ,updateOperControl = function(fee=0,gas=0) {
       #     tblOperControl$select(id=self$current$id, create=TRUE)
       #     tblOperControl$addField(DBDict$fields$fee, fee)
       #     tblOperControl$addField(DBDict$fields$gas, gas)
       #     tblOperControl$apply()
       #  }
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
           prtOper$add(current)

           self$current$base    = self$current$currency
           self$current$counter = self$current$currency

           # Descontar de la fuente si no es externa
           if (current$from != "EXT") {
               amount = current$amount * -1
               self$current$camera = current$from
               addFlow (YATACodes$flow$xferOut, current$base, amount, 1)
           }

           # regularizar el destino si no es externo
           if (current$to != "EXT") {
               self$current$camera = current$to
               addFlow (YATACodes$flow$xferIn,  current$counter, current$amount, 1)
           }
           objPos$transfer(current$from, current$to, current$currency, current$amount)
        }
       ,operOper     = function() {
           browser()
           # Abre una operacion de compra o venta
           self$current$active = YATACodes$flag$active
           self$current$status = YATACodes$status$pending

           days = ifelse(is.null(self$current$alert), lubridate::days(parms$getAlertDays(1))
                                                    , self$current$alert)
           self$current$dtAlert = Sys.Date() + lubridate::days(days)
           self$current$alert   = YATACodes$flag$active

           prtOper$add(current)
#           addRecord(private$prtOper)
#           addRecord(private$tblOperControl)

           # amount   = (self$current$amount * self$current$price) * -1
           # currency = current$base
           # # Si es venta descontamos counter, si no base
           # if (current$type == YATACodes$oper$sell) {
           #     currency = current$counter
           #     amount   = self$current$amount
           # }
           # objPos$updateAvailable(current$camera, currency, amount)
       }
       # ,operClose    = function() {
       #     nCurrent = self$current
       #     select(current$id)
       #     browser()
       #     self$current$type = YATACodes$oper$sell
       #     self$current$amount = nCurrent$amount
       #     self$current$price = nCurrent$price
       #     operOper()
       #     select(current$parent)
       #     prtOper$set(parent=current$id, reason=current$reason)
       #     prtOper$apply()
       #
       # }
       ,acceptBuy    = function(price, amount, fee) {
           # Acepta una compra, puede haber cambiado el precio y la cantidad
           # Se aplican las tasas
           data = list( status=YATACodes$status$accepted
                       ,amount=amount
                       ,price=price
                       ,fee=fee
                       ,reason=YATACodes$reason$accept
                       ,logType=YATACodes$log$accept
           )
           imp  = amount * price * -1
           prtOper$update(data)
           addFlow(YATACodes$flow$output, current$base, imp, 1)
           if (fee != 0) addFlow(YATACodes$flow$fee, imp * fee / 100, 1)
           objPos$updateOper(current$camera, current$base, imp, 1, fee)
       }
       ,acceptSell   = function(price, amount, fee) {
           # Acepta una compra, puede haber cambiado el precio y la cantidad
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
               prtOper$set(status=YATACodes$status$accepted, amount=newAmount, price=newPrice)
               prtOper$apply()
               addFlow(YATACodes$flow$output, current$counter, oldAmount, 1)
               if (regularize) addFlow(YATACodes$flow$regInput,current$counter,diffAmount,1)
               addFlow(YATACodes$flow$pending, current$base, newAmount * -1, newPrice)
               if (impFee != 0) {
                   addFlow(YATACodes$flow$fee, self$current$counter, impFee,    newPrice)
                   objPos$updateBalance(current$camera, current$base, impFee * -1)
               }
               if (diffAmount != 0) objPos$updateAvailable(current$camera, current$counter, diffAmount)
               objPos$update(current$camera, current$counter, newAmount, newPrice, FALSE)

               if (current$parent != 0) {
                   select(current$parent)
                   prtOper$set(status=YATACodes$status$closed, active=YATACodes$flag$inactive)
                   prtOper$apply()
               }
               db$commit()
               FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                TRUE
            })

       }
       ,executeBuy   = function(gas = 0) {
           # Acepta una compra, puede haber cambiado el precio y la cantidad
           # Se aplican las tasas
           data = list( status=YATACodes$status$executed
                       ,gas=gas
                       ,reason=YATACodes$reason$executed
                       ,logType=YATACodes$log$executed
           )
           prtOper$update(data)
           addFlow(YATACodes$flow$input, current$counter, current$amount, current$price)
           if (gas != 0) addFlow(YATACodes$flow$gas, current$counter, gas * amount * -1 / 100, 1) #current$price)
           objPos$updateOper(current$camera, current$counter, current$amount, current$price, gas)
        }
       ,executeSell  = function(gas = 0) {
           # Ejecuta una venta
           tblFlows$select(idOper = current$idOper, type = YATACodes$flow$pending)
           tblFlows$set(type = YATACodes$flow$input)
           tblFlows$apply()

           if (gas != 0)  {
               gas = (gas * current$amount) / -100
               addFlow(YATACodes$flow$gas, current$counter, gas, 1) #current$price)
               objPos$updateBalance(current$camera, current$counter, gas, available=TRUE)
           }
           updateOperControl(gas=gas)
           objPos$update(current$camera, current$base, current$amount * current$price * -1, current$price)

        }
       ,createTables = function() {
            private$prtOper        = YATAFactory$getTable(YATACodes$tables$Operations)
            private$tblFlows       = YATAFactory$getTable(YATACodes$tables$Flows)
#            private$tblOperControl = YATAFactory$getTable(YATACodes$tables$OperControl)
#            private$tblOperLog     = YATAFactory$getTable(YATACodes$tables$OperLog)
       }
    )
)
