TSTOperation = R6::R6Class("YATA.CI.OPER"
   ,portable  = FALSE
   ,cloneable = FALSE
   ,lock_class = TRUE
   ,inherit    = YATACIBase
   ,public = list(
       db  = NULL
      ,objOper = NULL

      ,initialize = function(mode) {
          super$initialize(mode, "Operaciones")
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
                       )
          tryCatch({
             tblPos = Factory$getTable(Tables$position)
             db$begin()
             lapply(tbls, function(tbl) db$execute(paste("DELETE FROM", tbl)))
             tblPos$add(list(camera="YATA", currency="FIAT", balance="10000", available="10000"))
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

.oper_buy_01  = function(cls) {
    cls$lbl("Buying BTC 01")

    idOper = cls$buy(amount=10, price = 100)

    rc = tryCatch({
           rows = list(
                        list(table=Tables$position,   rows = 2)
                       ,list(table=Tables$operControl,rows = 1)
                       ,list(table=Tables$operations, rows = 1)
                       ,list(table=Tables$flows,      rows = 2)
                      )
        checkNumRows(rows)
        values = list(balance=10, available=10,buyNet=100,buyHigh=100,buyLow=100,buy=10,sell=0)
        checkRowValues(Tables$position, list(camera="YATA", currency="BTC"), values)
        values = list(balance=9000, available=9000, buyNet=0, sellNet=1, buy=0, sell=1000)
        checkRowValues(Tables$position, list(camera="YATA", currency="FIAT"), values)
        values = list(value=10, amount=1000,price=100)
        checkRowValues(Tables$operations, list(id=idOper), values)
        FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    FALSE
}
.oper_buy_02  = function(cls) {
    cls$lbl("Buying 10 BTC at 200")
    idOper = cls$buy(amount=10, price = 200)

    rc = tryCatch({
           rows = list(
                        list(table=Tables$position,   rows = 2)
                       ,list(table=Tables$operControl,rows = 2)
                       ,list(table=Tables$operLog    ,rows = 2)
                       ,list(table=Tables$operations, rows = 2)
                       ,list(table=Tables$flows,      rows = 4)
                      )
        checkNumRows(rows)
        values = list(balance=20, available=20,buyHigh=200,buyLow=100,buyNet=150,buy=20,sell=0, value=150)
        checkRowValues(Tables$position, list(camera="YATA", currency="BTC"), values)

        values = list(balance=7000, available=7000, buyNet=0, sellHigh=2000,sellLow=1000,sellNet=1, buy=0, sell=3000)
        checkRowValues(Tables$position, list(camera="YATA", currency="FIAT"), values)
        values = list(value=10, amount=2000,price=200)
        checkRowValues(Tables$operations, list(id=idOper), values)
        FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    rc
}
.oper_sell_01 = function(cls) {
    cls$lbl("Closing position with profit = 0")
    idOper = cls$sell(amount=20, price = 150)

    rc = tryCatch({
           rows = list(
                        list(table=Tables$position,   rows = 2)
                       ,list(table=Tables$operControl,rows = 3)
                       ,list(table=Tables$operLog    ,rows = 3)
                       ,list(table=Tables$operations, rows = 3)
                       ,list(table=Tables$flows,      rows = 6)
                      )
        checkNumRows(rows)
        values = list( balance=0, available=0
                      ,buyHigh  = 200, buyLow  = 100, buyNet  = 150
                      ,sellHigh = 150, sellLow = 150, sellNet = 150, sellLast = 150
                      ,buy      =  20, sell    =  20
                      ,value=0,   profit = 0)
        checkRowValues(Tables$position, list(camera="YATA", currency="BTC"), values)

        values = list( balance  = 10000, available=10000
                      ,buyHigh  =  3000, buyLow   = 3000, buyLast  = 3000, buyNet = 1
                      ,sellHigh =  2000, sellLow  = 1000, sellLast = 2000, sellNet = 1
                      ,buy      =  3000, sell     = 3000, profit   =    0)
        checkRowValues(Tables$position, list(camera="YATA", currency="FIAT"), values)
        values = list(amount = 20, value = 3000, price = 150)
        checkRowValues(Tables$operations, list(id=idOper), values)
        FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    rc
}
.oper_win_01  = function (cls) {
    # FIAT/BTC - 1000 -   10 - 100
    # BTC/FIAT -   10 - 1500 - 150
    # Profit: 500

     cls$lbl("Open and closing position with profit")
     idOper = cls$buy (amount=10, price = 100)
     idOper = cls$sell(amount=10, price = 150)

     rc = tryCatch({
           rows = list(
                        list(table=Tables$operations, rows = 2)
                       ,list(table=Tables$position,   rows = 2)
                       ,list(table=Tables$operControl,rows = 2)
                       ,list(table=Tables$operLog    ,rows = 2)
                       ,list(table=Tables$flows,      rows = 4)
                      )
        checkNumRows(rows)

        values = list( balance=0, available=0
                      ,buyHigh  = 100
                      ,sellHigh = 150, sellLast = 150
                      ,buy      =  10, sell    =  10
                      ,value=0,   profit = 500)
        checkRowValues(Tables$position, list(camera="YATA", currency="BTC"), values)

        values = list( balance  = 10500, available=10500
                      ,buyHigh  =  1500, buyLast  = 1500, buyNet  = 1
                      ,sellHigh =  1000, sellLast = 1000, sellNet = 1
                      ,buy      =  1500, sell     = 1000
                     ,value     =     1, profit   =  500)
        checkRowValues(Tables$position, list(camera="YATA", currency="FIAT"), values)

        values = list(amount = 10, value = 1500, price = 150)
        checkRowValues(Tables$operations, list(id=idOper), values)

        values = list(amount = -10, price = 150)
        checkRowValues(Tables$flows, list(idOper=idOper, currency="BTC"), values)

        values = list(amount = 1500, price = 150)
        checkRowValues(Tables$flows, list(idOper=idOper, currency="FIAT"), values)

         FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    rc

}

testOperations = function(mode) {
    cls = TSTOperation$new(mode)
    cls$initEnv()
    .oper_buy_01(cls)
    .oper_buy_02(cls)
    .oper_sell_01(cls)
     cls$initEnv()
    .oper_win_01(cls)
    cls = NULL
}
