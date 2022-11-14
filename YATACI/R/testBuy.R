testBuySell = function () {
   println(0, crayon::bold("Verificando Buy/Sell"))
   camera  = "CI1"
   factory = prepareEnvironment()

   xfer_ext_in         (factory, camera)
   xfer_cash_in        (factory, camera)

   buy_half            (factory, camera)
#    buy_comission      (factory, camera)
#    buy_no_available_1 (factory, camera)
#    buy_no_available_2 (factory, camera)
#    factory$destroy()
#
#    # Compra y venta
#    factory = prepareEnvironment()
#    xfer_init(factory, camera)
#    buy_simple         (factory, camera)
#    sell_simple        (factory, camera)
#    buy_2_up           (factory, camera)

}
buy_half         = function(factory, camera) {
  print  (1, "Compra simple")
  tryCatch({
    oper = factory$getObject("Operation")
    op   = list(camera=camera, currency=1, amount=5, price=100)
    id   = oper$buy(op)

    # checks
    tbl = factory$getTable("Operations")
    df = tbl$table()
    if (nrow(df) != 1)          stop(sprintf("Incorrecto numero de operaciones: %d", nrow(df)))
    tgt = list( type   = YATACODE$oper$buy, camera=camera, base = 0, counter = 1
               ,amount = 1, value  = 100, price = 100
               ,active = 1, parent = 0
               ,status = YATACODE$status$executed)
    checkRecord("Operations", as.list(df[1,]), tgt)

    tbl = factory$getTable("Flows")
    df = tbl$table(idOper = id)
    if (nrow(df) != 2)          stop(sprintf("Incorrecto numero de flujos: %d", nrow(df)))
    df1 = df[df$amount < 0,]
    if (nrow(df1) != 1)          stop(sprintf("Incorrecto numero de flujos de salida: %d", nrow(df1)))
    tgt = list( type   = YATACODE$flow$output, currency=0, amount=-100, price=1)
    checkRecord("Flow Output", as.list(df1[1,]), tgt)
    df1 = df[df$amount > 0,]
    if (nrow(df1) != 1)          stop(sprintf("Incorrecto numero de flujos de entrada: %d", nrow(df1)))
    tgt = list( type   = YATACODE$flow$input, currency=1, amount=1, price=100)
    checkRecord("Flow Input", as.list(df1[1,]), tgt)

    tbl = factory$getTable("Position")
    df = tbl$table(camera = camera)
    if (nrow(df) != 2)          stop(sprintf("Incorrecto numero de posiciones: %d", nrow(df)))
    df1 = df[df$currency == 0,]
    tgt = list( balance = 9900, available = 9900
               ,sell_high = 100, sell_low = 100, sell_last = 100, sell_net = 1
               ,buy_high  =   0, buy_low  =   0, buy_last  =   0, buy_net  = 0
               ,buy       =   0, sell     = 100, net       =   1, profit   = 0)
    checkRecord("Base position", as.list(df1[1,]), tgt)
    df1 = df[df$currency == 1,]
    tgt = list( balance   =   1, available =   1
               ,buy_high  = 100, buy_low   = 100, buy_last  = 100, buy_net  = 100
               ,sell_high =   0, sell_low  =   0, sell_last =   0, sell_net =   0
               ,buy       =   1, sell      =   0, net       = 100, profit   =   0)
    checkRecord("Counter position", as.list(df1[1,]), tgt)

    result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond)
  })

}
buy_comission      = function(factory, camera) {
  print  (1, "Compra con comision")
  tryCatch({
    oper = factory$getObject("Operation")
    data = list(
             type    = YATACODE$oper$buy
            ,amount  = 1
            ,price   = 100
            ,value   = 1 * 100
            ,camera  = camera
            ,reason  = 0
            ,base    = 0
            ,counter = 1
            ,ctcIn   = 1
            ,ctcOut  = 1 * 100
            ,fee     = 10
         )
    id = oper$add(data$type, data)

    # checks
    tbl = factory$getTable("Operations")
    df = tbl$table()
    if (nrow(df) != 2)          stop(sprintf("Incorrecto numero de operaciones: %d", nrow(df)))
    tgt = list( type   = YATACODE$oper$buy, camera=camera, base = 0, counter = 1
               ,amount = 1, value  = 100, price = 100
               ,active = 1, parent = 0
               ,status = YATACODE$status$executed)
    checkRecord("Operations", as.list(df[1,]), tgt)
    checkRecord("Operations", as.list(df[2,]), tgt)

    tbl = factory$getTable("Flows")
    df = tbl$table(idOper = id)
    if (nrow(df) != 3)          stop(sprintf("Incorrecto numero de flujos: %d", nrow(df)))
    df1 = df[df$type == YATACODE$flow$fee,]
    if (nrow(df1) != 1)          stop(sprintf("Incorrecto numero de flujos de comision: %d", nrow(df1)))
    tgt = list( type   = YATACODE$flow$fee, currency=0, amount=-10, price=1)
    tbl = factory$getTable("Position")
    df = tbl$table(camera = camera)
    if (nrow(df) != 2)          stop(sprintf("Incorrecto numero de posiciones: %d", nrow(df)))
    df1 = df[df$currency == 0,]
    tgt = list( balance = 9790, available = 9790
               ,sell_high = 100, sell_low = 100, sell_last = 100, sell_net = 1
               ,buy_high  =   0, buy_low  =   0, buy_last  =   0, buy_net  = 0
               ,buy       =   0, sell     = 200, net       =   1, profit   = 0)
    checkRecord("Base position", as.list(df1[1,]), tgt)
    df1 = df[df$currency == 1,]
    tgt = list( balance   =   2, available = 2
               ,sell_high =   0, sell_low  =   0, sell_last =   0, sell_net =   0
               ,buy_high  = 100, buy_low   = 100, buy_last  = 100, buy_net  = 100
               ,buy       =   2, sell      =   0, net       = 100, profit   =   0)
    checkRecord("Counter position", as.list(df1[1,]), tgt)

    result(0)
  }, FAILED = function(cond) {
      cat("\n")
  }, error = function (cond) {
      result(-1)
      fail(cond)
  })

}
buy_no_available_1 = function(factory, camera) {
  print  (1, "Compra sin disponible")
  tryCatch({
    oper = factory$getObject("Operation")
    data = list(
             type    = YATACODE$oper$buy
            ,amount  = 10
            ,price   = 1000
            ,value   = 10000
            ,camera  = camera
            ,reason  = 0
            ,base    = 0
            ,counter = 1
            ,ctcIn   = 10
            ,ctcOut  = 10000
            ,fee     = 10
         )
    id = oper$add(data$type, data)
    result(-1)
    fail("Not available exception not launched")
  }, LOGICAL = function(cond) {
      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond)
  })

}
buy_no_available_2 = function(factory, camera) {
  print  (1, "Compra sin disponible 2")
  tryCatch({
    oper = factory$getObject("Operation")
    data = list(
             type    = YATACODE$oper$buy
            ,amount  = 10
            ,price   = 900
            ,value   = 9000
            ,camera  = camera
            ,reason  = 0
            ,base    = 0
            ,counter = 1
            ,ctcIn   = 10
            ,ctcOut  = 9000
            ,fee     = 800
         )
    id = oper$add(data$type, data)
    result(-1)
    fail("Not available exception not launched")
  }, LOGICAL = function(cond) {
      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond)
  })

}
sell_simple        = function(factory, camera) {
  print  (1, "Venta total")
  tryCatch({
    oper = factory$getObject("Operation")
    data = list(
             type    = YATACODE$oper$sell
            ,amount  = 1
            ,price   = 100
            ,camera  = camera
            ,base    = 1
            ,counter = 0
         )

    id = oper$sell(data)

    # checks
    tbl = factory$getTable("Operations")
    df = tbl$table(type = YATACODE$oper$sell)
    if (nrow(df) != 1)          stop(sprintf("Incorrecto numero de operaciones: %d", nrow(df)))
    tgt = list( type   = YATACODE$oper$sell, camera=camera, base = 1, counter = 0
               ,amount = 1, price = 100, value  = 100
               ,active = 1, parent = 0
               ,status = YATACODE$status$executed)
    checkRecord("Operations", as.list(df[1,]), tgt)

    tbl = factory$getTable("Flows")
    df = tbl$table(idOper = id)
    if (nrow(df) != 2)          stop(sprintf("Incorrecto numero de flujos: %d", nrow(df)))

    tbl = factory$getTable("Position")
    df = tbl$table(camera = camera)
    if (nrow(df) != 2)          stop(sprintf("Incorrecto numero de posiciones: %d", nrow(df)))
    df1 = df[df$currency == 0,]
    tgt = list( balance   = 10000, available = 10000
               ,sell_high = 100,   sell_low  = 100,   sell_last = 100, sell_net = 1
               ,buy_high  = 100,   buy_low   = 100,   buy_last  = 100, buy_net  = 1
               ,buy       = 100,   sell      = 100,   net       =   1, profit   = 0)
    checkRecord("Counter position", as.list(df1[1,]), tgt)
    df1 = df[df$currency == 1,]
    tgt = list( balance   =   0, available =   0
               ,buy_high  = 100, buy_low   = 100, buy_last  = 100, buy_net  = 100
               ,sell_high = 100, sell_low  = 100, sell_last = 100, sell_net = 100
               ,buy       =   1, sell      =   1, net       =   0, profit   =   0)
    checkRecord("Base position", as.list(df1[1,]), tgt)

    result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond)
  })

}
buy_2_up           = function(factory, camera) {
  print  (1, "Dos Compras")
  tryCatch({
    oper = factory$getObject("Operation")
    data = list(amount  = 5, price   = 100, camera  = camera, base    = 0, counter = 1)
    browser()
    id = oper$buy(data)
return()
    data$price = 200
    browser()
    id = oper$buy(data)
    return()
    # checks
    tbl = factory$getTable("Operations")
    df = tbl$table()
    if (nrow(df) != 4)          stop(sprintf("Incorrecto numero de operaciones: %d", nrow(df)))
    # tgt = list( type   = YATACODE$oper$buy, camera=camera, base = 0, counter = 1
    #            ,amount = 1, value  = 100, price = 100
    #            ,active = 1, parent = 0
    #            ,status = YATACODE$status$executed)
    # checkRecord("Operations", as.list(df[1,]), tgt)

    tbl = factory$getTable("Flows")
    df = tbl$table()
    if (nrow(df) != 10)          stop(sprintf("Incorrecto numero de flujos: %d", nrow(df)))
    # df1 = df[df$amount < 0,]
    # if (nrow(df1) != 1)          stop(sprintf("Incorrecto numero de flujos de salida: %d", nrow(df1)))
    # tgt = list( type   = YATACODE$flow$output, currency=0, amount=-100, price=1)
    # checkRecord("Flow Output", as.list(df1[1,]), tgt)
    # df1 = df[df$amount > 0,]
    # if (nrow(df1) != 1)          stop(sprintf("Incorrecto numero de flujos de entrada: %d", nrow(df1)))
    # tgt = list( type   = YATACODE$flow$input, currency=1, amount=1, price=100)
    # checkRecord("Flow Input", as.list(df1[1,]), tgt)

    tbl = factory$getTable("Position")
    df = tbl$table(camera = camera)
    if (nrow(df) != 2)          stop(sprintf("Incorrecto numero de posiciones: %d", nrow(df)))
    df1 = df[df$currency == 0,]
    tgt = list( balance = 9900, available = 9900
               ,sell_high = 100, sell_low = 100, sell_last = 100, sell_net = 1
               ,buy_high  =   0, buy_low  =   0, buy_last  =   0, buy_net  = 0
               ,buy       =   0, sell     = 100, net       =   1, profit   = 0)
    checkRecord("Base position", as.list(df1[1,]), tgt)
    df1 = df[df$currency == 1,]
    tgt = list( balance   =   1, available =   1
               ,buy_high  = 100, buy_low   = 100, buy_last  = 100, buy_net  = 100
               ,sell_high =   0, sell_low  =   0, sell_last =   0, sell_net =   0
               ,buy       =   1, sell      =   0, net       = 100, profit   =   0)
    checkRecord("Counter position", as.list(df1[1,]), tgt)

    result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond)
  })

}
