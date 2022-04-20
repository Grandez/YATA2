OBJOperation = R6::R6Class("OBJ.OPERATION"
    ,inherit    = OBJBase
    ,portable   = FALSE
    ,cloneable  = FALSE
    ,lock_class = TRUE
    ,public = list(
        initialize = function(Factory) {
            super$initialize(Factory)
            private$prtOper        = Factory$getTable(self$codes$tables$operations)
            private$tblFlows       = Factory$getTable(self$codes$tables$flows)
            private$objPos         = Factory$getObject(self$codes$object$position)
        }
        ##############################
        # Operaciones
        ##############################
        ,xfer  = function(...) { add(self$codes$oper$xfer, ...) }
        ,open  = function(...) { add(self$codes$oper$oper, ...) }
        ,buy   = function(...) { add(self$codes$oper$buy,  ...) }
        ,sell  = function(...) { add(self$codes$oper$sell, ...) }
        ,bid   = function(...) { add(self$codes$oper$bid,  ...) }
        ,ask   = function(...) { add(self$codes$oper$ask,  ...) }
        ,split = function()   { error("Split no implementado todavia")}
        ,net   = function()   { error("Net no implementado todavia")}
        ,add   = function(type, ...) {
            tryCatch({
                db$begin()
                idOper = addOper(type, ...)
                db$commit()
                idOper
            },error = function(cond) {
                db$rollback()
                message(cond$message)
                YATABase:::propagateError(cond)
                0
          })
        }
        ,regularize = function(camera, currency) {
            tryCatch({
                db$begin()
                idOper = addRegulatization(camera, currency)
                db$commit()
                idOper
            },error = function(cond) {
                db$rollback()
                message(cond)
                YATABase:::propagateError(cond)
                0
          })
        }
        ##############################
        # Acciones sobre operacion
        ##############################
        #JGG Temporal
        ,accept  = function(price=0, amount=0, fee = 0, id=NULL) {
            if (!is.null(id)) select(id)
            tryCatch({
               db$begin()
               if (!is.null(current$idParent) && !is.na(current$idParent)) {
                   prtOper$setField("active", self$codes$flag$inactive)
                   prtOper$apply()
               }
           # Acepta una compra, puede haber cambiado el precio y la cantidad
           # Se aplican las tasas
           data = list( status=self$codes$status$accepted
                       ,amount=amount
                       ,price=price
                       ,fee=fee
                       ,reason=self$codes$reason$accept
                       ,logType=self$codes$log$accept
           )

           prtOper$update(data)
           if (amount < 0) { # Es enta
               ctc = current$counter
               imp = amount
           } else {
               ctc = current$base
               imp  = amount * price * -1
               price = 1
           }

           addFlow(self$codes$flow$output, ctc, imp, price)
           if (fee != 0) addFlow(self$codes$flow$fee, imp * fee / 100, 1)
           objPos$updateOper(current$camera, ctc, imp, price, fee)
               #
               # if (current$type == self$codes$oper$sell) acceptSell(price, amount, fee)
               # if (current$type != self$codes$oper$sell) acceptBuy (price, amount, fee)
               db$commit()
               FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                YATABase:::propagateError(cond)
                TRUE
            })
        }
        ,execute = function(gas = 0, id=NULL) {
            # La operacion se ha realizado, esta en el wallet
            if (!is.null(id)) select(id)
            ctc = current$counter
            cant = current$amount

            data = list( status=self$codes$status$executed
                        ,gas=gas
                        ,reason=self$codes$reason$executed
                        ,logType=self$codes$log$executed
            )
            # Es la venta de una posicion abierta
            if (current$type == self$codes$oper$sell) {
                ctc = current$base
                cant = current$amount * current$price * -1
                if (current$parent > 0) {
                    data$active = self$codes$flag$inactive
                    data$amountOut = current$amount * -1
                    data$priceOut  = current$price
                }
            }

            tryCatch({
               db$begin()
               prtOper$update(data)
               addFlow(self$codes$flow$input, ctc, cant, current$price)
               if (gas != 0) addFlow(self$codes$flow$gas, current$counter, gas * amount * -1 / 100, 1) #current$price)
               objPos$updateOper(current$camera, ctc, cant, current$price, gas)
               db$commit()
               FALSE
            },error = function(cond) {
               message(cond)
               db$rollback()
               YATABase:::propagateError(cond)
               TRUE
            })
        }
        ,cancel  = function(comment=NULL, delete=FALSE, id=NULL) {
            res = FALSE
            if (!is.null(id)) select(id)
            self$current$comment = comment
            if (current$active != self$codes$flag$active ||
                current$status != self$codes$status$pending) {
                error("La operacion no se puede cancelar")
            }
            # marca la operacion como cancelada
            res = tryCatch({
                db$begin()
                currency = current$base
                imp      = current$amount * current$price
                if (current$type == self$codes$oper$sell) {
                    currency = current$counter
                    imp      = current$amount * -1
                }
                objPos$updateAvailable(current$camera, currency, imp)
                prtOper$set(status = self$codes$status$cancelled, active = self$codes$flag$inactive)
                prtOper$apply()
                db$commit()
                FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                YATABase:::propagateError(cond)
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
                   YATABase:::propagateError(cond)
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
                if (current$type %in% c(self$codes$oper$oper, self$codes$oper$buy)) {
                    updatePosition(self$current$base, current$amount * current$price, FALSE, TRUE)
                }
                prtOper$set(status = self$codes$status$rejected, active = self$codes$flag$inactive)
                prtOper$apply()
                db$commit()
                FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                YATABase:::propagateError(cond)
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

                stat = ifelse(split, self$codes$oper$split, self$codes$oper$close)
                prtOper$update( list(active  = self$codes$flag$parent
                               ,status  = stat
                               ,reason  = data$reason
                               ,comment = data$comment
                               ,priceOut  = current$price
                               ,amountOut = current$amount
                               ,rank    = data$rank))

                if (split) {
                    diff = current$amount - data$amount
                    select(current$id, create=TRUE)
                    current$idParent = data$id
                    self$current = list.merge(self$current, data)
                    current$amount = diff
                    current$status = self$codes$oper$oper
                    current$active = self$codes$flag$active
                    prtOper$update(current)
                }

                #Creamos la venta
                #self$current$type   = self$codes$oper$sell
                self$current$amount = data$amount
                self$current$price  = data$price
                self$current$parent = data$id
                self$current$reason = data$reason
                addOper(type=self$codes$oper$sell, current)
                FALSE
            },error = function(cond) {
                message(cond)
                db$rollback()
                YATABase:::propagateError(cond)
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
                YATABase:::propagateError(cond)
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
        ,getPending    = function()    { getOperations(status=self$codes$status$pending)   }
        ,getAccepted   = function()    { getOperations(status=self$codes$status$accepted)  }
        ,getActive     = function()    { getOperations(status=self$codes$status$executed)  }
        ,getCancelled  = function()    { getOperations(status=self$codes$status$cancelled) }
        ,getRejected   = function()    { getOperations(status=self$codes$status$rejected)  }
        ,getOpen       = function()    { getOperations(status=self$codes$status$executed
                                                      ,active=self$codes$flag$active) }
        ,getSons       = function(group, type) {
            if (missing(type)) {
               getOperations(inValues=list(parent=group))
            }
            else {
                getOperations(type=type, inValues=list(parent=group))
            }
        }
        ,getHistory    = function()    {
            dfCounter = prtOper$getInactiveCounters(self$codes$flag$inactive)
            if (nrow(dfCounter) == 0) return (NULL)
            if (is.null(dfReg)) private$dfReg = objPos$getRegularizations()
            dfj = left_join(dfCounter, dfReg, by=c("camera", "counter"))
            if (nrow(dfj) == 0) return (NULL)
            df = NULL
            for (row in 1:nrow(dfj)) {
                dft = prtOper$getInactives(dfj[row,"camera"], dfj[row,"counter"], dfj[row,"last"])
                if (is.null(df)) df = dft
                else             df = rbind(df, dft)
            }
            df
        }
        ,getClosed    = function()    {
            dfCounter = prtOper$getInactiveCounters(self$codes$flag$parent)
            if (nrow(dfCounter) == 0) return (NULL)
            if (is.null(dfReg)) private$dfReg = objPos$getRegularizations()
            dfj = left_join(dfCounter, dfReg, by=c("camera", "counter"))
            if (nrow(dfj) == 0) return (NULL)
            df = NULL
            for (row in 1:nrow(dfj)) {
                dft = prtOper$getClosed(dfj[row,"camera"], dfj[row,"counter"], dfj[row,"last"])
                if (is.null(df)) df = dft
                else             df = rbind(df, dft)
            }
            df
        }
        ,getMovements  = function(camera, currency, since=NULL) {
           df1   = prtOper$tableInterval(from=since, to= NULL, camera=camera, base=currency)
           df2   = prtOper$tableInterval(from=since, to= NULL, camera=camera, counter=currency)
           df    = rbind(df1, df2)
           # Los id son tms luego ordenamos descendente
           df[order(df$id, decreasing=TRUE),]
        }
        ,getOperations = function(...) { prtOper$get(...)   }
        ,getOperation  = function (id) {
            res = prtOper$table(id=id)
            if (nrow(res) != 1) return (NULL)
            as.list(res)
        }
        ,getFlows          = function(idOper)    {
            if (!missing(idOper)) select(idOper)
            tblFlows$dfCurrent
        }
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
        ,getFlowsByCurrency = function (currency) {
            tblFlows$table(currency = currency)
        }
    )
    ,private = list(
        # Tablas asociadas
        prtOper        = NULL
       ,objPos         = NULL
       ,dfReg          = NULL
       ,tblFlows       = NULL
       ,tblReg         = NULL
       ,addFlow        = function(type, currency, amount, price) {
           data = list(
              idOper   = current$idOper
             ,idFlow   = Factory$getID()
             ,type     = type
             ,currency = currency
             ,amount   = amount
             ,price    = price
           )
           tblFlows$add(data)
       }
       ,operXfer     = function() {
           # TRansfiere entre dos camaras
           # Genera:
           # 1. Registro de transferencia
           # 2. Operaciones de transferencia en las dos camaras
           # 3. Flujos asociados a la transferencia

           objPos$getPosition(camera=current$from, currency=current$currency)
           value = objPos$current$value

           tblPos  = Factory$getTable(self$codes$tables$transfer)
           tblXfer = Factory$getTable(self$codes$tables$transfer)
           idXfer = Factory$getID()
           xfer = list(
               id        = idXfer
              ,cameraIn  = current$to
              ,cameraOut = current$from
              ,currency  = current$currency
              ,amount    = current$amount
              ,value     = value
           )
           tblXfer$add(xfer)

           idOut = Factory$getID()
           idIn  = Factory$getID()
           data = list(
                id      = idOut
               ,camera  = current$from
               ,base    = current$currency
               ,counter = current$currency
               ,value   = current$amount
               ,amount  = current$amount
               ,price   = value
               ,parent  = idXfer
               ,active  = self$codes$flag$inactive
               ,status  = self$codes$status$executed
               ,type    = self$codes$oper$xfer
           )
           prtOper$add(data)

           data$id     = idIn
           data$camera = current$to
           prtOper$add(data)

           # Posiciones
           objPos$transfer(current$from, current$to, current$currency, current$amount, value)

           # Flujos

           flow = list(
                idOper   = idOut
               ,idFlow   = Factory$getID()
               ,type     = self$codes$flow$xferOut
               ,currency = current$currency
               ,amount   = current$amount * -1
               ,price    = value
           )
           tblFlows$add(flow)

           flow$idOper = idIn
           flow$type   = self$codes$flow$xferIn
           flow$amount  = current$amount
           tblFlows$add(flow)

           self$current$idOper = idXfer
       }
       ,addOper   = function(type, ...) {
            # Se llama desde add y desde close
            # Genera una operacion, devuelve el id
            # Si hay error devuelve TRUE
            self$current        = args2list(...)
            self$current$type   = type
            self$current$major  = type %/% 10
            self$current$minor  = type %%  10
            self$current$id     = Factory$getID()
            self$current$idOper = self$current$id
            # if (type %in% c(self$codes$oper$sell, self$codes$oper$close)) {
            #     self$current$amount = current$amount * -1
            # }
            if (self$current$major < 3 ) makeOper()
            if (type == self$codes$oper$xfer)  operXfer()
            # if (type == self$codes$oper$buy)   operOper2()
            # if (type == self$codes$oper$sell)  operOper2()
#            if (type == self$codes$oper$close) operClose()
#            if (type == self$codes$oper$split) {}
            if (type == self$codes$oper$net)  {}
            self$current$idOper
       }
       ,makeOper     = function() {
           if (is.null(current$value)) current$value = current$price * current$amount
           objPos$updatePositions   (current)
           #JGG REVISAR
           self$current$active = self$codes$flag$active
           # self$current$active = ifelse (current$type == self$codes$oper$oper
           #                                             , self$codes$flag$active
           #                                             , self$codes$flag$inactive)
           self$current$status = ifelse(current$major == 1, self$codes$status$pending
                                                          , self$codes$status$executed)

           days = ifelse(is.null(self$current$alert), lubridate::days(parms$getAlertDays(1))
                                                    , self$current$alert)
           self$current$dtAlert = Sys.Date() + lubridate::days(days)
           self$current$alert   = self$codes$flag$active

#           amount = ifelse(current$base == "$FIAT", current$amount, current$value)
           #JGG Temporal mientras no procesemos el flujo de request/accept/execute
           self$current$amountIn  = current$amount
           self$current$amountOut = current$amount
           self$current$priceIn   = self$current$price
           self$current$priceOut  = self$current$price

           self$current$prcTaxes   = 0
           if (current$type == self$codes$oper$sell) {
               res = calculateExpense(current$camera, current$base, current$amount)
               self$current$expense = res$expense
               self$current$alive   = res$alive
               self$current$profit = self$current$value - self$current$expense
           }
           prtOper$add(current)

           if (current$status == self$codes$status$executed) {
               addFlow(self$codes$flow$output,  current$base,    current$ctcOut * -1, current$price)
               addFlow(self$codes$flow$input,   current$counter, current$ctcIn,       current$price)
           }

           # if (!is.null(current$idParent) && !is.na(current$idParent)) {
           #     select(idParent)
           #     current$flag = self$codes$flags$parent
           #     current$amountOut = current$amount
           #     current$priceOut  = current$price
           #     prtOper$apply()
           # }
       }
       ,acceptBuy    = function(price, amount, fee) {
           # Acepta una compra, puede haber cambiado el precio y la cantidad
           # Se aplican las tasas
           data = list( status=self$codes$status$accepted
                       ,amount=amount
                       ,price=price
                       ,fee=fee
                       ,reason=self$codes$reason$accept
                       ,logType=self$codes$log$accept
           )
           imp  = amount * price * -1
           prtOper$update(data)
           addFlow(self$codes$flow$output, current$base, imp, 1)
           if (fee != 0) addFlow(self$codes$flow$fee, imp * fee / 100, 1)
           objPos$updateOper(current$camera, current$base, imp, 1, fee)
       }
      ,addRegulatization = function(camera, currency) {
            # Genera el registro de regularizacion

            self$current$idOper = Factory$getID()
            if (is.null(tblReg)) private$tblReg = Factory$getTable(self$codes$tables$regularization)

            objPos$getPosition(camera=camera, currency=currency)

            position        = objPos$current
            position$id     = Factory$getID()
            position$date   = as.POSIXct(Sys.time())
            position$period = getRegularizationPeriod(camera, currency, objPos$current$tms)
            position$idOper = current$idOper

            tblReg$add(position)

            price  = ifelse(position$sell == 0, 0, position$profit / position$sell)
            value  = position$profit
            sell   = position$sell

            operation = list(
                 id       = current$idOper
                ,idOper   = current$idOper
                ,type     = self$codes$oper$reg
                ,active   = self$codes$flag$inactive
                ,status   = self$codes$status$executed
                ,camera   = camera
                ,base     = currency
                ,counter  = "$FIAT"
                ,value    = position$profit
                ,amount   = position$sell
                ,price    = price
                ,priceIn  = price
                ,priceOut = price
                ,parent   = position$id
            )
            prtOper$add(operation)

            cost = calculateExpense(camera, currency, position$sell)
            wrk = (position$buyNet * position$buy) - (cost$expense * position$sell)
            wrk = ifelse (position$balance == 0, 0, wrk / position$balance)

            position$buy      = position$balance
            position$buyHigh  = wrk
            position$buyLow   = wrk
            position$buyLast  = wrk
            position$buyNet   = wrk

            position$sell     = 0
            position$sellHigh = 0
            position$sellLow  = 0
            position$sellLast = 0
            position$sellNet  = 0

            position$profit   = 0
            position$value    = wrk
            position$since    = format(Sys.time(), "%Y-%m-%d %H:%M:%S")

            objPos$updatePosition(position)

            addFlow(self$codes$flow$input,  "$FIAT",   value, price)
            addFlow(self$codes$flow$output, currency, sell,  price)

            current$idOper
      }
      ,getRegularizationPeriod = function (camera, currency, since) {
          tblReg$tableLimit(camera=camera, currency=currency)
          if (!is.null(tblReg$current)) since = tblReg$current$date
          diff = difftime(Sys.time(), since, unit="days")
          as.integer(round(diff, digits=0))
      }
       ,calculateExpense = function(camera, currency, amount) {
           # Calcula el coste de la operaciones de compra asociadas a la venta
           # Funciona como una cola LIFO
           # Si hay compras en medio, se añaden a sell y se quitan despues

           value = 0
           sell  = 0
           pend  = amount

           df = getMovements(camera, currency)

           nrow = 0
           while ( pend > 0) {
               nrow = nrow + 1
               # Esto no puede ocurrir
               if (nrow > nrow(df)) { nrow = nrow -1; break }
               if (df[nrow, "type"] == self$codes$oper$xfer) break # Regularizacion.
               if (df[nrow, "type"] != self$codes$oper$sell && df[nrow,"type"] != self$codes$oper$buy) {
                   next
               }

               if (df[nrow,"type"] == self$codes$oper$sell) {
                   sell = sell + df[nrow,"amount"]
                   next
               }
               sell = sell - df[nrow,"value"]
               if (sell >= 0) next   # Pendiente procesar esa compra
               value = value - (sell * df[nrow, "price"])
               pend = pend + sell
               sell = 0
           }

           diff = difftime(Sys.time(), df[nrow, "tms"], unit="days")
           diff = as.integer(round(diff, digits=0))
           list(expense=value, alive=diff)
       }

    )
)
