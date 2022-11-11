OBJOperation = R6::R6Class("OBJ.OPERATION"
   ,inherit    = OBJBase
   ,portable   = FALSE
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
       initialize = function(factory) {
          super$initialize(factory)
          private$tblOper        = factory$getTable("Operations")
          private$tblFlows       = factory$getTable("Flows")
          private$objPos         = factory$getObject("Position")
      }
      ##############################
      # Operaciones
      ##############################
     ,xfer  = function(...) { operXfer(...) }
        # ,open  = function(...) { add(YATACODE$oper$oper, ...) }
     ,buy   = function(...) { add(YATACODE$oper$buy,  ...) }
     ,sell  = function(...) { add(YATACODE$oper$sell, ...) }
        # ,bid   = function(...) { add(YATACODE$oper$bid,  ...) }
        # ,ask   = function(...) { add(YATACODE$oper$ask,  ...) }
        # ,split = function()   { error("Split no implementado todavia")}
        # ,net   = function()   { error("Net no implementado todavia")}
     ,add   = function(type, ...) {
        tryCatch({
           db$begin()
           idOper = addOper(type, ...)
           db$commit()
           idOper
        },error = function(cond) {
            db$rollback()
            YATATools::propagateError(cond)
            0
        })
      }
        # ,regularize = function(camera, currency) {
        #     tryCatch({
        #         db$begin()
        #         idOper = addRegulatization(camera, currency)
        #         db$commit()
        #         idOper
        #     },error = function(cond) {
        #         db$rollback()
        #         message(cond)
        #         YATABase:::propagateError(cond)
        #         0
        #   })
        # }
        ##############################
        # Acciones sobre operacion
        ##############################
        #JGG Temporal
#         ,accept  = function(price=0, amount=0, fee = 0, id=NULL) {
#             if (!is.null(id)) select(id)
#             tryCatch({
#                db$begin()
#                if (!is.null(current$idParent) && !is.na(current$idParent)) {
#                    tblOper$setField("active", YATACODE$flag$inactive)
#                    tblOper$apply()
#                }
#            # Acepta una compra, puede haber cambiado el precio y la cantidad
#            # Se aplican las tasas
#            data = list( status=YATACODE$status$accepted
#                        ,amount=amount
#                        ,price=price
#                        ,fee=fee
#                        ,reason=YATACODE$reason$accept
#                        ,logType=YATACODE$log$accept
#            )
#
#            tblOper$update(data)
#            if (amount < 0) { # Es enta
#                ctc = current$counter
#                imp = amount
#            } else {
#                ctc = current$base
#                imp  = amount * price * -1
#                price = 1
#            }
#
#            addFlow(YATACODE$flow$output, ctc, imp, price)
#            if (fee != 0) addFlow(YATACODE$flow$fee, imp * fee / 100, 1)
#            objPos$updateOper(current$camera, ctc, imp, price, fee)
#                #
#                # if (current$type == YATACODE$oper$sell) acceptSell(price, amount, fee)
#                # if (current$type != YATACODE$oper$sell) acceptBuy (price, amount, fee)
#                db$commit()
#                FALSE
#             },error = function(cond) {
#                 message(cond)
#                 db$rollback()
#                 YATABase:::propagateError(cond)
#                 TRUE
#             })
#         }
#         ,execute = function(gas = 0, id=NULL) {
#             # La operacion se ha realizado, esta en el wallet
#             if (!is.null(id)) select(id)
#             ctc = current$counter
#             cant = current$amount
#
#             data = list( status=YATACODE$status$executed
#                         ,gas=gas
#                         ,reason=YATACODE$reason$executed
#                         ,logType=YATACODE$log$executed
#             )
#             # Es la venta de una posicion abierta
#             if (current$type == YATACODE$oper$sell) {
#                 ctc = current$base
#                 cant = current$amount * current$price * -1
#                 if (current$parent > 0) {
#                     data$active = YATACODE$flag$inactive
#                     data$amountOut = current$amount * -1
#                     data$priceOut  = current$price
#                 }
#             }
#
#             tryCatch({
#                db$begin()
#                tblOper$update(data)
#                addFlow(YATACODE$flow$input, ctc, cant, current$price)
#                if (gas != 0) addFlow(YATACODE$flow$gas, current$counter, gas * amount * -1 / 100, 1) #current$price)
#                objPos$updateOper(current$camera, ctc, cant, current$price, gas)
#                db$commit()
#                FALSE
#             },error = function(cond) {
#                message(cond)
#                db$rollback()
#                YATABase:::propagateError(cond)
#                TRUE
#             })
#         }
#         ,cancel  = function(comment=NULL, delete=FALSE, id=NULL) {
#             res = FALSE
#             if (!is.null(id)) select(id)
#             self$current$comment = comment
#             if (current$active != YATACODE$flag$active ||
#                 current$status != YATACODE$status$pending) {
#                 error("La operacion no se puede cancelar")
#             }
#             # marca la operacion como cancelada
#             res = tryCatch({
#                 db$begin()
#                 currency = current$base
#                 imp      = current$amount * current$price
#                 if (current$type == YATACODE$oper$sell) {
#                     currency = current$counter
#                     imp      = current$amount * -1
#                 }
#                 objPos$updateAvailable(current$camera, currency, imp)
#                 tblOper$set(status = YATACODE$status$cancelled, active = YATACODE$flag$inactive)
#                 tblOper$apply()
#                 db$commit()
#                 FALSE
#             },error = function(cond) {
#                 message(cond)
#                 db$rollback()
#                 YATABase:::propagateError(cond)
#                 TRUE
#             })
#             if (delete) {
#                 res = tryCatch({
#                    db$begin()
#                    tblFlows$remove        (idOper = current$id)
# #                   tblOperLog$remove      (idOper = current$id)
# #                   tblOperControl$remove  (idOper = current$id)
#                    tblOper$remove         (id = current$id)
#                    db$commit()
#                    FALSE
#                 }, error = function(cond) {
#                    message(cond)
#                    db$rollback()
#                    YATABase:::propagateError(cond)
#                    TRUE
#                 })
#             }
#             res
#         }
#         ,reject  = function(comment=NULL, id=NULL) {
#             if (!is.null(id)) select(id)
#             self$currrent$comment = comment
#             tryCatch({
#                 db$begin()
#                 if (current$type %in% c(YATACODE$oper$oper, YATACODE$oper$buy)) {
#                     updatePosition(self$current$base, current$amount * current$price, FALSE, TRUE)
#                 }
#                 tblOper$set(status = YATACODE$status$rejected, active = YATACODE$flag$inactive)
#                 tblOper$apply()
#                 db$commit()
#                 FALSE
#             },error = function(cond) {
#                 message(cond)
#                 db$rollback()
#                 YATABase:::propagateError(cond)
#                 TRUE
#             })
#         }
#         ,close   = function(...) {
#             split = FALSE
#             data = args2list(...)
#             select(data$id)
#             tryCatch({
#                 db$begin()
#
#                 # Es un split
#                 if(data$amount != current$amount) split = TRUE
#
#                 stat = ifelse(split, YATACODE$oper$split, YATACODE$oper$close)
#                 tblOper$update( list(active  = YATACODE$flag$parent
#                                ,status  = stat
#                                ,reason  = data$reason
#                                ,comment = data$comment
#                                ,priceOut  = current$price
#                                ,amountOut = current$amount
#                                ,rank    = data$rank))
#
#                 if (split) {
#                     diff = current$amount - data$amount
#                     select(current$id, create=TRUE)
#                     current$idParent = data$id
#                     self$current = list.merge(self$current, data)
#                     current$amount = diff
#                     current$status = YATACODE$oper$oper
#                     current$active = YATACODE$flag$active
#                     tblOper$update(current)
#                 }
#
#                 #Creamos la venta
#                 #self$current$type   = YATACODE$oper$sell
#                 self$current$amount = data$amount
#                 self$current$price  = data$price
#                 self$current$parent = data$id
#                 self$current$reason = data$reason
#                 addOper(type=YATACODE$oper$sell, current)
#                 FALSE
#             },error = function(cond) {
#                 message(cond)
#                 db$rollback()
#                 YATABase:::propagateError(cond)
#                 TRUE
#             })
#        }
#         ,comment = function(comment=NULL, id=NULL) {
#             if (is.null(comment)) return (FALSE)
#             if (!is.null(id)) select(id)
#             tryCatch({
#                 db$begin()
#                 generateLog()
#                 db$commit()
#                 FALSE
#             },error = function(cond) {
#                 message(cond)
#                 db$rollback()
#                 YATABase:::propagateError(cond)
#                 TRUE
#             })
#         }
#         ,getComments = function(id = NULL) {
#             if (!is.null(id)) select(id)
# #            tblOperLog$table(idOper = current$id)
#         }
        ##############################
        # General
        ##############################
     ,select            = function(idOper, create=FALSE) {
         tblOper$select(id = idOper, create=create)
         self$current = tblOper$current
         self$current$idOper = tblOper$current$id
        invisible(self)
     }
        # ,getPending    = function()    { getOperations(status=YATACODE$status$pending)   }
        # ,getAccepted   = function()    { getOperations(status=YATACODE$status$accepted)  }
        # ,getActive     = function()    { getOperations(status=YATACODE$status$executed)  }
        # ,getCancelled  = function()    { getOperations(status=YATACODE$status$cancelled) }
        # ,getRejected   = function()    { getOperations(status=YATACODE$status$rejected)  }
        # ,getOpen       = function()    { getOperations(status=YATACODE$status$executed
        #                                               ,active=YATACODE$flag$active) }
        # ,getSons       = function(group, type) {
        #     if (missing(type)) {
        #        getOperations(inValues=list(parent=group))
        #     }
        #     else {
        #         getOperations(type=type, inValues=list(parent=group))
        #     }
        # }
        # ,getHistoryByCamera = function(camera, from) {
        #     tblOper$getHistoryByCamera(camera, from)
        # }
        # ,getHistory    = function()    {
        #     dfCounter = tblOper$getInactiveCounters(YATACODE$flag$inactive)
        #     if (nrow(dfCounter) == 0) return (NULL)
        #     if (is.null(dfReg)) private$dfReg = objPos$getRegularizations()
        #     dfj = left_join(dfCounter, dfReg, by=c("camera", "counter"))
        #     if (nrow(dfj) == 0) return (NULL)
        #     df = NULL
        #     for (row in 1:nrow(dfj)) {
        #         dft = tblOper$getInactives(dfj[row,"camera"], dfj[row,"counter"], dfj[row,"last"])
        #         if (is.null(df)) df = dft
        #         else             df = rbind(df, dft)
        #     }
        #     df
        # }
        # ,getClosed    = function()    {
        #     dfCounter = tblOper$getInactiveCounters(YATACODE$flag$parent)
        #     if (nrow(dfCounter) == 0) return (NULL)
        #     if (is.null(dfReg)) private$dfReg = objPos$getRegularizations()
        #     dfj = left_join(dfCounter, dfReg, by=c("camera", "counter"))
        #     if (nrow(dfj) == 0) return (NULL)
        #     df = NULL
        #     for (row in 1:nrow(dfj)) {
        #         dft = tblOper$getClosed(dfj[row,"camera"], dfj[row,"counter"], dfj[row,"last"])
        #         if (is.null(df)) df = dft
        #         else             df = rbind(df, dft)
        #     }
        #     df
        # }
        # ,getMovements  = function(camera, currency, since=NULL) {
        #    df1   = tblOper$tableInterval(from=since, to= NULL, camera=camera, base=currency)
        #    df2   = tblOper$tableInterval(from=since, to= NULL, camera=camera, counter=currency)
        #    df    = rbind(df1, df2)
        #    # Los id son tms luego ordenamos descendente
        #    df[order(df$id, decreasing=TRUE),]
        # }
        # ,getOperations = function(...) { tblOper$get(...)   }
        # ,getOperation  = function (id) {
        #     res = tblOper$table(id=id)
        #     if (nrow(res) != 1) return (NULL)
        #     as.list(res)
        # }
        # ,getFlows          = function(idOper)    {
        #     if (!missing(idOper)) select(idOper)
        #     tblFlows$dfCurrent
        # }
        # ,setAlert = function(fecha=NULL) {
        #     if (is.null(fecha)) {
        #         tblOper$setField("alert", DBDict$flag$inactive)
        #     }
        #     else {
        #         tblOper$setField("alert", DBDict$flag$active)
        #         tblOper$setField("dtAlert", fecha)
        #     }
        #     tblOper$apply()
        #     invisible(self)
        # }
        # ,getFlowsByCurrency = function (currency) {
        #     tblFlows$table(currency = currency)
        # }
   )
  ,private = list(
      tblOper        = NULL
     ,tblFlows       = NULL
     ,tblReg         = NULL
     ,objPos         = NULL
     ,dfReg          = NULL
     ,addFlow        = function(type, currency, amount, price) {
         data = list(
            idOper   = current$idOper
           ,idFlow   = factory$getID()
           ,type     = type
           ,currency = currency
           ,amount   = amount
           ,price    = price
         )
         tblFlows$add(data)
      }
     ,operXfer     = function(...) {
      # Transfiere entre dos camaras
      # Genera:
      # 1. Registro de transferencia
      # 2. Operaciones de transferencia en las dos camaras
      # 3. Flujos asociados a la transferencia

        self$current        = args2list(...)

      # Obtener valor neto
        objPos$getPosition(camera=current$from, currency=current$currency)
        self$current$value = objPos$current$net

      # Validaciones
        if (current$amount <= 0)                       YATATools::LOGICAL("Invalid Amount")
        if (objPos$current$available < current$amount) YATATools::LOGICAL("Invalid Amount")
        if (!is.null(current$feeOut) && current$feeOut < 0) YATATools::LOGICAL("Invalid Comission")
        if (!is.null(current$feeIn)  && current$feeIn  < 0) YATATools::LOGICAL("Invalid Comission")
        if (!is.null(current$feeIn)  && current$feeIn  > current$amount) YATATools::LOGICAL("Invalid Comission")
        if (is.null(current$feeIn))  self$current$feeIn  = 0
        if (is.null(current$feeOut)) self$current$feeOut = 0

        self$current$type      = YATACODE$oper$xfer
        self$current$id        = factory$getID()
        self$current$cameraIn  = current$to
        self$current$cameraOut = current$from

        tryCatch({
           db$begin()
           # Grabar Transferencia
           tblXfer = factory$getTable("Transfers")

           tblXfer$add(self$current)

           # Actualizar posicion
           objPos$transfer(self$current)

           # Grabar flujos para que el saldo pueda calcularse desde los flujos
           flow = list(
                idOper   = current$id
               ,idFlow   = factory$getID()
               ,type     = YATACODE$flow$xferOut
               ,currency = current$currency
               ,amount   = current$amount * -1
               ,price    = current$value
           )
           tblFlows$add(flow)

           flow$idFlow = factory$getID()
           flow$type   = YATACODE$flow$xferIn
           flow$amount = current$amount
           tblFlows$add(flow)

           if (current$feeOut > 0) {
               flow$idFlow = factory$getID()
               flow$type   = YATACODE$flow$fee
               flow$amount = current$feeOut * -1
               tblFlows$add(flow)
           }
           if (current$feeIn > 0) {
               flow$idFlow = factory$getID()
               flow$type   = YATACODE$flow$fee
               flow$amount = current$feeIn * -1
               tblFlows$add(flow)
           }

           db$commit()
           current$id
        },error = function(cond) {
           browser()
           db$rollback()
           YATATools::propagateError(cond)
           0
        })
      }
     ,addOper   = function(type, ...) {
        self$current        = args2list(...)
        self$current$type   = type
        # Major es compra/venta/etc - Minor es el tipo de operacion
        self$current$major  = type %/% 10
        self$current$minor  = type %%  10
        self$current$id     = factory$getID()
        self$current$idOper = self$current$id

        validateOper()

        if (self$current$major < 3 ) makeOper() # buy/bid, sell/ask
        if (type == YATACODE$oper$net)  {}
        self$current$idOper
      }
     ,makeOper     = function() {
         if (is.null(current$value)) current$value = current$price * current$amount

         objPos$updatePositions   (current)

         self$current$active = YATACODE$flag$active
           # self$current$active = ifelse (current$type == YATACODE$oper$oper
           #                                             , YATACODE$flag$active
           #                                             , YATACODE$flag$inactive)
         self$current$status = ifelse(current$major == 1, YATACODE$status$pending
                                                        , YATACODE$status$executed)
         tblOper$add(current)

         # Informacion de logging

         # Informacion de control

#            if (!is.null(self$current$alert)) {
#                self$current$dtAlert = Sys.Date() + lubridate::days(self$current$alert)
#            }
#            # days = ifelse(is.null(self$current$alert), lubridate::days(parms$getAlertDays(1))
#            #                                          , self$current$alert)
#            #
#            # self$current$alert   = YATACODE$flag$active
#
# #           amount = ifelse(current$base == "__FIAT__", current$amount, current$value)
#            #JGG Temporal mientras no procesemos el flujo de request/accept/execute
#            self$current$amountIn  = current$amount
#            self$current$amountOut = current$amount
#            self$current$priceIn   = self$current$price
#            self$current$priceOut  = self$current$price
#
#            self$current$prcTaxes   = 0
#            if (current$type == YATACODE$oper$sell) {
#                res = calculateExpense(current$camera, current$base, current$amount)
#                self$current$expense = res$expense
#                self$current$alive   = res$alive
#                self$current$profit = self$current$value - self$current$expense
#            }
#            tblOper$add(current)

         # flujos
         if (current$status == YATACODE$status$executed) {
             # El precio FIAT siempre es 1
             price = ifelse(current$base == 0, 1, current$price)
             addFlow(YATACODE$flow$output,  current$base,    current$ctcOut * -1, price)
             price = ifelse(current$counter == 0, 1, current$price)
             addFlow(YATACODE$flow$input,   current$counter, current$ctcIn,       price)
             if (current$fee > 0) { # La comision es en FIAT
                 addFlow(YATACODE$flow$fee, 0, current$fee * -1, 1)
             }
         }

#            # if (!is.null(current$idParent) && !is.na(current$idParent)) {
#            #     select(idParent)
#            #     current$flag = YATACODE$flags$parent
#            #     current$amountOut = current$amount
#            #     current$priceOut  = current$price
#            #     tblOper$apply()
#            # }
      }
     ,acceptBuy    = function(price, amount, fee) {
           # Acepta una compra, puede haber cambiado el precio y la cantidad
           # Se aplican las tasas
           data = list( status=YATACODE$status$accepted
                       ,amount=amount
                       ,price=price
                       ,fee=fee
                       ,reason=YATACODE$reason$accept
                       ,logType=YATACODE$log$accept
           )
           imp  = amount * price * -1
           tblOper$update(data)
           addFlow(YATACODE$flow$output, current$base, imp, 1)
           if (fee != 0) addFlow(YATACODE$flow$fee, imp * fee / 100, 1)
           objPos$updateOper(current$camera, current$base, imp, 1, fee)
       }
      ,addRegulatization = function(camera, currency) {
            # Genera el registro de regularizacion

            self$current$idOper = factory$getID()
            if (is.null(tblReg)) private$tblReg = factory$getTable(YATACODE$tables$regularization)

            objPos$getPosition(camera=camera, currency=currency)

            position        = objPos$current
            position$id     = factory$getID()
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
                ,type     = YATACODE$oper$reg
                ,active   = YATACODE$flag$inactive
                ,status   = YATACODE$status$executed
                ,camera   = camera
                ,base     = currency
                ,counter  = "__FIAT__"
                ,value    = position$profit
                ,amount   = position$sell
                ,price    = price
                ,priceIn  = price
                ,priceOut = price
                ,parent   = position$id
            )
            tblOper$add(operation)

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

            addFlow(YATACODE$flow$input,  "__FIAT__",   value, price)
            addFlow(YATACODE$flow$output, currency, sell,  price)

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
               if (df[nrow, "type"] == YATACODE$oper$xfer) break # Regularizacion.
               if (df[nrow, "type"] != YATACODE$oper$sell && df[nrow,"type"] != YATACODE$oper$buy) {
                   next
               }

               if (df[nrow,"type"] == YATACODE$oper$sell) {
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
      ,validateOper = function () {
          if (is.null(current$fee)) self$current$fee = 0
          if (is.null(current$gas)) self$current$gas = 0
          # minor 0 = compra / 1 = venta
          ctc = ifelse(current$minor == 0, current$base, current$counter)
          df = objPos$getPosition(camera = current$camera, currency = ctc)
          impOut = current$ctcOut + current$fee
          if (df[1,"available"] < impOut) YATATools::LOGICAL("Insufficient available for operation")
      }
    )
)
