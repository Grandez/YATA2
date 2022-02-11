# To avoid names mangling
# preffix: xxx

.oper_case = function(text) {
    printf("%s", text)
}
.oper_rollback = function(db, e, msg) {
    browser()
    db$rollback()
    throw(msg)
}
.oper_error = function(msg, actual, expected) {
    browser()
    message(" - KO")
    text = paste(msg, "valor:", actual, "- se esperaba", expected)
    message(text)
    throw(text)
}

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
.oper_init_env = function (db) {
    sql = "DELETE FROM"
    tables=list( DBDict$tables$Position
                ,DBDict$tables$Operations, DBDict$tables$OperControl, DBDict$tables$OperLog
                ,DBDict$tables$Flows)

    tryCatch({
        db$begin()
        lapply(tables, function(tbl) db$execute(paste(sql, tbl)))
       .oper_add_position(db, currency="EUR", balance=10000, available=10000)
        db$commit()
    }, error = function (e) { .oper_rollback(db,e, "Error iniciando entorno") })

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
.tst_oper_buy_01 = function(db) {
    .oper_case("Registrando compra 1 ")
    data = list(type = YATACodes$oper$buy, value = 1000, amount = 10, price = 100)
    .tst_oper_add(db, data)

    # Check data
    position = Fact$getObject((YATACodes$object$position))
    df = position$getPosition(camera="CAM01", currency="EUR")
    .oper_check_row(df, list(balance = 9000, available=9000))

    df = position$getPosition(camera="CAM01", currency="BTC")
    checks = list(balance = 10, available=10, buyHigh=100, buyLow=100,buyLast=100, buyNet=100
                                            , sellHigh=0, sellLow=0,sellLast=0, sellNet=0
                                            , buy = 10, sell = 0, value = 100)
    .oper_check_row(df, checks)

    .oper_case("- OK\n")
}
.tst_oper_buy_02 = function(db) {
    .oper_case("Registrando compra 2 ")
    data = list(type = YATACodes$oper$buy, value = 2000, amount   = 10, price    = 200)
    .tst_oper_add(db, data)

    # Check data
    position = Fact$getObject((YATACodes$object$position))
    df = position$getPosition(camera="CAM01", currency="EUR")

    .oper_check_row(df, list(balance = 7000, available=7000))

    df = position$getPosition(camera="CAM01", currency="BTC")
    checks = list(balance = 20, available=20, buyHigh=200, buyLow=100,buyLast=200, buyNet=150
                                            , sellHigh=0, sellLow=0,sellLast=0, sellNet=0
                                            , buy = 20, sell = 0, value = 150)
    .oper_check_row(df, checks)

    .oper_case("- OK\n")
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
browser()

}
testOperations = function() {
    message("Chequeando operaciones ")
    db = Fact$getDB()
    .oper_init_env(db)
    .tst_oper_buy_01 (db)
    .tst_oper_buy_02 (db)
    .tst_oper_sell_01(db)
    .tst_oper_win(db)
}
