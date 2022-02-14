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
             tblPos$add(list(camera="YATA", currency="EUR", balance="10000", available="10000"))
             db$commit()
          }, error = function (e) {
               db$rollback()
              .error(e, "iniciando entorno")
          })
      }
      ,add = function(...) {
          values = args2list(...)
          data = list( camera   = "YATA", base     = "EUR", counter  = "BTC"
                      ,value    = 1000  , amount   = 10   , price    = 100
                      ,reason   = 1     , alert    = 3    , target   = 0
                      ,deadline = 5     , stop     = 0    , limit    = 0
                      ,comment = "Test operation")
          data = list.merge(data, values)
          tryCatch( objOper$add(data$type, data)
                   , error = function (e) .error(e, "Registrando Operacion"))
      }
   )
)



# To avoid names mangling
# preffix: xxx

# .oper_case = function(text) {
#     printf("%s", text)
# }
# .oper_rollback = function(db, e, msg) {
#     browser()
#     db$rollback()
#     throw(msg)
# }
# .oper_error = function(msg, actual, expected) {
#     browser()
#     message(" - KO")
#     text = paste(msg, "valor:", actual, "- se esperaba", expected)
#     message(text)
#     throw(text)
# }

.oper_add_position = function(db, ...) {
    df = data.frame (
              camera    = c("CAM01")
             ,currency  = c("EUR")
             ,balance   = c(0.0)
             ,available = c(0.0)
             ,buyHigh   = c(0.0)
             ,buyLow    = c(0.0)
             ,buyLast   = c(0.0)
             ,buyNet    = c(0.0)
             ,sellHigh  = c(0.0)
             ,sellLow   = c(0.0)
             ,sellLast  = c(0.0)
             ,sellNet   = c(0.0)
             ,buy       = c(0.0)
             ,sell      = c(0.0)
             ,value     = c(0.0)
             ,since     = c(as.POSIXct("2022-02-02 09:00"))
             ,last      = c(as.POSIXct("2022-02-02 09:00"))
             ,cc        = c(NA)

            )
    args = args2list(...)
    # lapply falla, supongo que por la secuencia o el entorno
    # lapply(names(args), function(col) {
    for (col in names(args)) df[1, col] = args[[col]]
    tbl = Fact$getTable(YATATables$Position)
    tbl$add(df)
}
.tst_oper_add = function(db, values) {
    data = list()
    data$camera   = "CAM01"
    data$base     = "EUR"
    data$counter  = "BTC"  # Tiene que existir
    data$value    = 1000
    data$amount   = 10
    data$price    = 100
    data$reason   = 1
    data$alert    = 3
    data$target   = 0
    data$deadline = 5
    data$stop     = 0
    data$limit    = 0
    data$comment = "Test de compra"
    data = list.merge(data, values)

    oper = Fact$getObject(YATACodes$object$operation)

    tryCatch({
        oper$add(data$type, data)
    }, error = function (e) { .oper_rollback(db,e, "Error registrando compra") })

}
.oper_check_row = function(df, checks) {
    if (nrow(df) != 1)             .oper_error("Filas erroneas:", nrow(df), 1)
    lapply(names(checks), function(col){
        if (df[1,col] != checks[[col]]) .oper_error(paste(col, "erroneo:"), df[1,col], checks[[col]])
    })
}
.oper_buy_01 = function(cls) {
    cls$out("Buying BTC 01")
    cls$initEnv()
    idOper = cls$add(type=Codes$oper$buy, value = 1000, amount = 10, price = 100)

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
        checkRowValues(Tables$position, list(camera="YATA", currency="EUR"), values)
        values = list(amount=10, value=1000,price=100)
        checkRowValues(Tables$operations, list(id=idOper), values)
        FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    FALSE
}
.oper_buy_02 = function(cls) {
    cls$out("Buying 10 BTC at 200")
    idOper = cls$add(type=Codes$oper$buy, value = 2000, amount = 10, price = 200)

    rc = tryCatch({
           rows = list(
                        list(table=Tables$position,   rows = 2)
                       ,list(table=Tables$operControl,rows = 2)
                       ,list(table=Tables$operLog    ,rows = 2)
                       ,list(table=Tables$operations, rows = 2)
                       ,list(table=Tables$flows,      rows = 4)
                      )
        checkNumRows(rows)
        values = list(balance=20, available=20,buyNet=150,buyHigh=200,buyLow=100,buy=20,sell=0, value=150)
        checkRowValues(Tables$position, list(camera="YATA", currency="BTC"), values)
        values = list(balance=7000, available=7000, buyNet=0, sellHigh=2000,sellLow=1000,sellNet=1, buy=0, sell=3000)
        checkRowValues(Tables$position, list(camera="YATA", currency="EUR"), values)
        values = list(amount=10, value=2000,price=200)
        checkRowValues(Tables$operations, list(id=idOper), values)
        FALSE
    }, error = function(e) { TRUE })

    if (rc) return (TRUE)
    cls$ok()
    FALSE
}

.tst_oper_sell_01 = function(db) {
    .oper_case("Registrando venta 1 ")
    data = list( type = YATACodes$oper$sell
                ,base="BTC", counter="EUR",value=20, amount=3000,price= 150)
    .tst_oper_add(db, data)

    # Check data
    position = Fact$getObject((YATACodes$object$position))
    df = position$getPosition(camera="CAM01", currency="EUR")

    .oper_check_row(df, list(balance = 10000, available=10000))

    df = position$getPosition(camera="CAM01", currency="BTC")
    checks = list(balance = 0, available=0, buyHigh=200, buyLow=100,buyLast=200, buyNet=150
                                            , sellHigh=150, sellLow=150,sellLast=150, sellNet=150
                                            , buy = 20, sell = 20, value = 0, profit=0)
    .oper_check_row(df, checks)

    .oper_case("- OK\n")
}

.tst_oper_win = function (db) {
    .oper_case("Registrando operacion con beneficio")
    .oper_init_env(db)
     data = list(type = YATACodes$oper$buy, value = 1000, amount   = 10, price    = 100)
    .tst_oper_add(db, data)
     Sys.sleep(2)
     data = list( type = YATACodes$oper$sell
                ,base="BTC", counter="EUR",value=10, amount=3000,price= 150)

    .tst_oper_add(db, data)

     position = Fact$getObject((YATACodes$object$position))

     df = position$getPosition(camera="CAM01", currency="EUR")
     checks = list(balance = 12000, buyHigh=3000, buyNet=1, sellHigh=1000, buy = 3000, sell = 1000, profit=2000)
    .oper_check_row(df, checks)

     df = position$getPosition(camera="CAM01", currency="BTC")
     checks = list(balance = 0, buyHigh=100, buyNet=100, sellLow=150, buy = 10, sell = 10, profit=2000)
    .oper_check_row(df, checks)

}
# testOperations = function() {
#     message("Chequeando operaciones ")
#     db = Fact$getDB()
#     .oper_init_env(db)
#     .tst_oper_buy_01 (db)
#     .tst_oper_buy_02 (db)
#     .tst_oper_sell_01(db)
#     .tst_oper_win(db)
# }



testOperations = function(mode) {
    cls = TSTOperation$new(mode)
    .oper_buy_01(cls)
    .oper_buy_02(cls)
    cls = NULL
}
