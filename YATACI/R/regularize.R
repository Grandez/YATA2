TSTRegularization = R6::R6Class("YATA.CI.REG"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,inherit    = YATACIBase
   ,public = list(
       db         = NULL
      ,objOper    = NULL
      ,initialize = function(mode) {
          super$initialize(mode, "Regularizaciones")
          self$db      = Factory$getDB()
          self$objOper = Factory$getObject(Codes$object$operation)
       }
      ,finalize   = function() {
          message("Deleting TSTTransfer")
        }
      ,initEnv = function() {
          TablesDB = YATADB:::DBDict$tables
          tbls   = list( TablesDB$Position
                        ,TablesDB$Operations, TablesDB$OperControl, TablesDB$OperLog
                        ,TablesDB$Flows
                        ,TablesDB$Regularization
                       )
          tryCatch({
             tblPos = Factory$getTable(Tables$position)
             db$begin()
             lapply(tbls, function(tbl) db$execute(paste("DELETE FROM", tbl)))
             tblPos$add(list(camera="YATA", currency="FIAT", balance="50000", available="50000"))
             db$commit()
          }, error = function (e) {
               db$rollback()
              .error(e, "iniciando entorno")
          })
      }
      ,buy = function(amount, price) {
          oper( type=Codes$oper$buy, base="FIAT", counter="BTC"
               ,amount=amount * price, value=amount, price = price)
      }
      ,sell = function(amount, price) {
          oper( type=Codes$oper$sell, base="BTC", counter="FIAT"
               ,amount=amount, value=amount * price, price = price)
      }
   )
  ,private = list(
      dataOper= list( camera   = "YATA", base     = "FIAT", counter  = "BTC"
                      ,value    = 1000  , amount   = 10   , price    = 100
                      ,reason   = 1     , alert    = 3    , target   = 0
                      ,deadline = 5     , stop     = 0    , limit    = 0
                      ,comment = "Test operation")
      ,oper = function(...) {
          values = args2list(...)
          data = list.merge(dataOper, values)
          tryCatch(
              objOper$add(data$type, data)
                   , error = function (e) {
                       browser()
                       .error(e, "Registrando Operacion")
                       })
      }


  )
)

.reg_profit_simple  = function(cls) {
    cls$lbl("Regularizing BTC with profit")
    cls$initEnv()
    cls$db$begin()
    idOper = tryCatch({
       cls$buy (amount=10, price=100)
       cls$sell(amount=10, price=150)
       idOper = cls$objOper$regularize("YATA", "BTC")
       cls$db$commit()
       idOper
    }, error = function (e) {
        browser()
       cls$db$rollback()
       .error(e, "Preparando case")
    })

    rc = tryCatch({
         rows = list(
                   list(table=Tables$position,   rows = 2)
                  ,list(table=Tables$operations, rows = 3)
                  ,list(table=Tables$flows,      rows = 6)
                )
         checkNumRows(rows)

         values = list( balance  = 0, available = 0
                       ,buyHigh  = 0, buyLow    = 0, buyLast  = 0, buyNet  = 0
                       ,sellHigh = 0, sellLow   = 0, sellLast = 0, sellNet = 0
                       ,buy      = 0, sell      = 0, value    = 0, profit  = 0
                      )
        checkRowValues(Tables$position, list(camera="YATA", currency="BTC"), values)

         values = list( balance  = 50500, available = 50500
                       ,buyHigh  =  1500, buyLow    =  1500, buyLast  = 1500, buyNet  =   1
                       ,sellHigh =  1000, sellLow   =  1000, sellLast = 1000, sellNet =   1
                       ,buy      =  1500, sell      =  1000, value    =    1, profit  = 500
                      )
        checkRowValues(Tables$position, list(camera="YATA", currency="FIAT"), values)

        values = list(base="BTC", counter="FIAT", amount=10, value=500,price=50)
        checkRowValues(Tables$operations, list(id=idOper), values)
        FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    FALSE
}
.reg_loss_simple  = function(cls) {
    cls$lbl("Regularizing BTC with loss")
    cls$initEnv()
    cls$db$begin()
    idOper = tryCatch({
       cls$buy (amount=10, price=100)
       cls$sell(amount=10, price= 50)
       idOper = cls$objOper$regularize("YATA", "BTC")
       cls$db$commit()
       idOper
    }, error = function (e) {
       cls$db$rollback()
       .error(e, "Preparando case")
    })

    rc = tryCatch({
         rows = list(
                   list(table=Tables$position,   rows = 2)
                  ,list(table=Tables$operations, rows = 3)
                  ,list(table=Tables$flows,      rows = 6)
                )
         checkNumRows(rows)

         values = list( balance  = 0, available = 0
                       ,buyHigh  = 0, buyLow    = 0, buyLast  = 0, buyNet  = 0
                       ,sellHigh = 0, sellLow   = 0, sellLast = 0, sellNet = 0
                       ,buy      = 0, sell      = 0, value    = 0, profit  = 0
                      )
        checkRowValues(Tables$position, list(camera="YATA", currency="BTC"), values)

         values = list( balance  = 49500, available = 49500
                       ,buyHigh  =   500, buyLow    =   500, buyLast  =  500, buyNet  =    1
                       ,sellHigh =  1000, sellLow   =  1000, sellLast = 1000, sellNet =    1
                       ,buy      =   500, sell      =  1000, value    =    1, profit  = -500
                      )
        checkRowValues(Tables$position, list(camera="YATA", currency="FIAT"), values)

        values = list(base="BTC", counter="FIAT", amount=10, value=-500,price=-50)
        checkRowValues(Tables$operations, list(id=idOper), values)
        FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    FALSE
}

.reg_net  = function(cls) {
    cls$lbl("Regularizing BTC with zero profit")
    cls$initEnv()
    cls$db$begin()
    idOper = tryCatch({
       cls$buy (amount=10, price = 100)
       cls$sell(amount=10, price = 100)
       idOper = cls$objOper$regularize("YATA", "BTC")
       cls$db$commit()
       idOper
    }, error = function (e) {
       cls$db$rollback()
       .error(e, "Preparando case")
    })

    rc = tryCatch({
         rows = list(
                   list(table=Tables$position,       rows = 2)
                  ,list(table=Tables$operations,     rows = 3)
                  ,list(table=Tables$flows,          rows = 6)
                  ,list(table=Tables$regularization, rows = 1)
                )
         checkNumRows(rows)

         values = list( balance  = 0, available = 0
                       ,buyHigh  = 0, buyLow    = 0, buyLast  = 0, buyNet  = 0
                       ,sellHigh = 0, sellLow   = 0, sellLast = 0, sellNet = 0
                       ,buy      = 0, sell      = 0, value    = 0, profit  = 0
                      )
        checkRowValues(Tables$position, list(camera="YATA", currency="BTC"), values)

         values = list( balance  = 50000, available = 50000
                       ,buyHigh  =  1000, buyLow    =  1000, buyLast  = 1000, buyNet  =    1
                       ,sellHigh =  1000, sellLow   =  1000, sellLast = 1000, sellNet =    1
                       ,buy      =  1000, sell      =  1000, value    =    1, profit  =    0
                      )
        checkRowValues(Tables$position, list(camera="YATA", currency="FIAT"), values)

        values = list(base="BTC", counter="FIAT", amount = 10, value = 0,price = 0)
        checkRowValues(Tables$operations, list(id=idOper), values)
        FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    FALSE
}

testRegularizations = function(mode) {
    cls = TSTRegularization$new(mode)

    .reg_profit_simple(cls)
    .reg_loss_simple(cls)
    .reg_net(cls)
    cls = NULL
}
