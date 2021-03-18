OBJOperation = R6::R6Class("OBJ.OPERATION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        initialize = function(factory) {
            super$initialize(factory)
            private$prtOper        = factory$getTable(codes$tables$Operations)
            private$tblFlows       = factory$getTable(codes$tables$Flows)
            # private$tblOperControl = factory$getTable(codes$tables$OperControl)
            # private$tblOperLog     = factory$getTable(codes$tables$OperLog)
            private$objPos         = factory$getObject(codes$object$position)
        }
        ##############################
        # Operaciones
        ##############################
        ,xfer  = function(...) { add(codes$oper$xfer, ...) }
        ,open  = function(...) { add(codes$oper$oper, ...) }
        ,buy   = function(...) { add(codes$oper$buy,  ...) }
        ,sell  = function(...) { add(codes$oper$sell, ...) }
        ,split = function()   { error("Split no implementado todavia")}
        ,net   = function()   { error("Net no implementado todavia")}
        ,add   = function(type, ...) {
            # Genera una operacion, devuelve el id
            # Si hay error devuelve TRUE
            self$current        = args2list(...)
            self$current$type   = type
            self$current$id     = YATATools::getID()
            self$current$idOper = self$current$id
            if (type %in% c(codes$oper$sell, codes$oper$close)) {
                self$current$amount = current$amount * -1
            }
            tryCatch({
                db$begin()
                if (type == codes$oper$xfer)  operXfer()
                if (type == codes$oper$oper)  operOper()
                if (type == codes$oper$buy)   operOper()
                if (type == codes$oper$sell)  operOper()
#                if (type == codes$oper$close) operClose()
#                if (type == codes$oper$split) {}
                if (type == codes$oper$net)  {}
                db$commit()
                self$current$idOper
            },error = function(cond) {
                brower()
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
               if (!is.null(current$idParent) && !is.na(current$idParent)) {
                   prtOper$setField("active", codes$flag$inactive)
                   prtOper$apply()
               }
               if (current$type == codes$oper$sell) acceptSell(price, amount, fee)
               if (current$type != codes$oper$sell) acceptBuy (price, amount, fee)
               db$commit()
               FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                TRUE
            })
        }
        ,execute = function(gas = 0, id=NULL) {
            # La operacion se ha realizado, esta en el wallet
            if (!is.null(id)) select(id)
            data = list( status=codes$status$executed
                        ,gas=gas
                        ,reason=codes$reason$executed
                        ,logType=codes$log$executed
            )
            # Es la venta de una posicion abierta
            if (current$type == codes$oper$sell && current$parent > 0) {
                data$active = codes$flag$inactive
            }
            tryCatch({
               db$begin()
               prtOper$update(data)
               addFlow(codes$flow$input, current$counter, current$amount, current$price)
               if (gas != 0) addFlow(codes$flow$gas, current$counter, gas * amount * -1 / 100, 1) #current$price)
               objPos$updateOper(current$camera, current$counter, current$amount, current$price, gas)
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
            if (current$active != codes$flag$active ||
                current$status != codes$status$pending) {
                error("La operacion no se puede cancelar")
            }
            # marca la operacion como cancelada
            res = tryCatch({
                db$begin()
                currency = current$base
                imp      = current$amount * current$price
                if (current$type == codes$oper$sell) {
                    currency = current$counter
                    imp      = current$amount * -1
                }
                objPos$updateAvailable(current$camera, currency, imp)
                prtOper$set(status = codes$status$cancelled, active = codes$flag$inactive)
                prtOper$apply()
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
                if (current$type %in% c(codes$oper$oper, codes$oper$buy)) {
                    updatePosition(self$current$base, current$amount * current$price, FALSE, TRUE)
                }
                prtOper$set(status = codes$status$rejected, active = codes$flag$inactive)
                prtOper$apply()
                db$commit()
                FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                TRUE
            })
        }
        ,close   = function(...) {
            split = FALSE
            data = args2list(...)
            select(data$id)
            tryCatch({
                db$begin()

                # Es un split
                if(data$amount != current$amount) split = TRUE
                stat = ifelse(split, codes$oper$split, codes$oper$close)
                prtOper$update( list(active  = codes$flag$parent
                               ,status  = stat
                               ,reason  = data$reason
                               ,comment = data$comment
                               ,rank    = data$rank))

                # Creamos el split
                if (split) {
                    diff = current$amount - data$amount
                    select(current$id, create=TRUE)
                    current$idParent = data$id
                    self$current = list.merge(self$current, data)
                    current$amount = diff
                    current$status = codes$oper$oper
                    current$active = codes$flag$active
                    prtOper$update(current)
                }

                #Creamos la venta
                #self$current$type   = codes$oper$sell
                self$current$amount = data$amount
                self$current$price  = data$price
                self$current$parent = data$id
                self$current$reason = data$reason
                add(type=codes$oper$sell, current)
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
#                generateLog()
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
            invisible(self)
        }
        ,getPending        = function()    { getOperations(status=codes$status$pending)   }
        ,getAccepted       = function()    { getOperations(status=codes$status$accepted)  }
        ,getExecuted       = function()    { getOperations(status=codes$status$executed)  }
        ,getCancelled      = function()    { getOperations(status=codes$status$cancelled) }
        ,getRejected       = function()    { getOperations(status=codes$status$rejected)  }
        ,getActive         = function(...) { prtOper$table(active=codes$flag$active, ...) }
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
            # JGG Checked
            gral = parms$getSubgroup(DBParms$group$reasons, DBParms$reasons$gral)
            oth  = parms$getSubgroup(DBParms$group$reasons, type)
            df = rbind(gral, oth)
            df$value = paste0("REASON.", df$value)
            df$name  = "MISSING"
            for (row in 1:nrow(df)) {
                df[row, "name"] = factory$MSG$get(df[row,"value"])
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
       ,operXfer     = function() {
           self$current$camera  = "XFER"
           self$current$base    = self$current$from
           self$current$counter = self$current$to
           self$current$price   = 1
           self$current$active  = codes$flag$inactive
           self$current$status  = codes$status$executed

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
               addFlow (codes$flow$xferOut, current$base, amount, 1)
           }

           # regularizar el destino si no es externo
           if (current$to != "EXT") {
               self$current$camera = current$to
               addFlow (codes$flow$xferIn,  current$counter, current$amount, 1)
           }
           objPos$transfer(current$from, current$to, current$currency, current$amount)
        }
       ,operOper     = function() {
           # Abre una operacion de compra o venta
           self$current$active = codes$flag$active
           self$current$status = codes$status$pending

           days = ifelse(is.null(self$current$alert), lubridate::days(parms$getAlertDays(1))
                                                    , self$current$alert)
           self$current$dtAlert = Sys.Date() + lubridate::days(days)
           self$current$alert   = codes$flag$active

           prtOper$add(current)
       }
       ,acceptBuy    = function(price, amount, fee) {
           # Acepta una compra, puede haber cambiado el precio y la cantidad
           # Se aplican las tasas
           data = list( status=codes$status$accepted
                       ,amount=amount
                       ,price=price
                       ,fee=fee
                       ,reason=codes$reason$accept
                       ,logType=codes$log$accept
           )
           imp  = amount * price * -1
           prtOper$update(data)
           addFlow(codes$flow$output, current$base, imp, 1)
           if (fee != 0) addFlow(codes$flow$fee, imp * fee / 100, 1)
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
               prtOper$set(status=codes$status$accepted, amount=newAmount, price=newPrice)
               prtOper$apply()
               addFlow(codes$flow$output, current$counter, oldAmount, 1)
               if (regularize) addFlow(codes$flow$regInput,current$counter,diffAmount,1)
               addFlow(codes$flow$pending, current$base, newAmount * -1, newPrice)
               if (impFee != 0) {
                   addFlow(codes$flow$fee, self$current$counter, impFee,    newPrice)
                   objPos$updateBalance(current$camera, current$base, impFee * -1)
               }
               if (diffAmount != 0) objPos$updateAvailable(current$camera, current$counter, diffAmount)
               objPos$update(current$camera, current$counter, newAmount, newPrice, FALSE)

               if (current$parent != 0) {
                   select(current$parent)
                   prtOper$set(status=codes$status$closed, active=codes$flag$inactive)
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
       ,createTables = function() {
            private$prtOper        = factory$getTable(codes$tables$Operations)
            private$tblFlows       = factory$getTable(codes$tables$Flows)
#            private$tblOperControl = factory$getTable(codes$tables$OperControl)
#            private$tblOperLog     = factory$getTable(codes$tables$OperLog)
       }
    )
)

