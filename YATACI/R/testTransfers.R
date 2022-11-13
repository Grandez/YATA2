testTransfers = function () {
   println(0, crayon::bold("Verificando transferencias"))
   camera  = "CI1"
   camera2 = "CI2"
   factory = prepareEnvironment()

   xfer_ext_in       (factory, camera)
   xfer_ext_out      (factory, camera)
   xfer_ext_in_2     (factory, camera)
   xfer_init         (factory, camera)
   xfer_no_available (factory, camera)
   xfer_reset        (factory, camera)
   xfer_comissions    (factory, camera)
   # xfer_cameras       (factory, camera, camera2)
   factory$destroy()
}
xfer_ext_in        = function (factory, camera) {
   # Transferir 10000 al sistema
   print  (1, "Carga inicial")

   data = list(to = "CASH", amount = 10000)
    tryCatch({
       oper = factory$getObject("Operation")
       id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Position")
       df = tbl$table(camera = "CASH")
       if (nrow(df) == 0)          stop("No hay registro de camara CASH")
       if (nrow(df) >  1)          stop("Demasiadas posiciones para CASH")
       tgt = list( balance = 10000, available = 10000
                  ,sell_high =   0, sell_low  =     0, sell_last =   0, sell_net = 0
                  ,buy_high  =   0, buy_low   =     0, buy_last  =   0, buy_net  = 0
                  ,buy       =   0, sell      =     0, net       =   1, profit   = 0)
       checkRecord("CASH position", as.list(df[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table()
       if (nrow(df) != 1)             stop("Diferente numero de transferencias")
       tgt = list( cameraOut = "CASH", cameraIn = "CASH", currency = 0, amount = 10000)
       checkRecord("Transfer", as.list(df[1,]), tgt)
      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_ext_out       = function (factory, camera) {
   # Recuperar 10000 del sistema
   print  (1, "Retirada del sistema")

   data = list(from = "CASH", amount = 10000)
    tryCatch({
       oper = factory$getObject("Operation")
       id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Position")
       df = tbl$table(camera = "CASH")
       if (nrow(df) == 0)          stop("No hay registro de camara CASH")
       if (nrow(df) >  1)          stop("Demasiadas posiciones para CASH")
       tgt = list( balance =     0, available =     0
                  ,sell_high =   0, sell_low  =     0, sell_last =   0, sell_net = 0
                  ,buy_high  =   0, buy_low   =     0, buy_last  =   0, buy_net  = 0
                  ,buy       =   0, sell      =     0, net       =   1, profit   = 0)
       checkRecord("CASH position", as.list(df[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table()
       if (nrow(df) != 2)             stop("Diferente numero de transferencias")
       df1 = df[df$amount > 0,]
       if (nrow(df1) != 1)            stop("No existe transferencia de entrada")
       if (df1[1,"amount"] != 10000)  stop("Transferencia de entrada invalida")
       df1 = df[df$amount <= 0,]
       if (nrow(df1) != 1)            stop("No existe transferencia de salida")
       if (df1[1,"amount"] != -10000) stop("Transferencia de entrada invalida")
       result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_ext_in_2      = function (factory, camera) {
   # Transferir 10000 al sistema
   print  (1, "Carga inicial")

   data = list(to = "CASH", amount = 10000)
    tryCatch({
       oper = factory$getObject("Operation")
       id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Position")
       df = tbl$table(camera = "CASH")
       if (nrow(df) == 0)          stop("No hay registro de camara CASH")
       if (nrow(df) >  1)          stop("Demasiadas posiciones para CASH")
       tgt = list( balance = 10000, available = 10000
                  ,sell_high =   0, sell_low  =     0, sell_last =   0, sell_net = 0
                  ,buy_high  =   0, buy_low   =     0, buy_last  =   0, buy_net  = 0
                  ,buy       =   0, sell      =     0, net       =   1, profit   = 0)
       checkRecord("CASH position", as.list(df[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table()
       if (nrow(df) != 3)             stop("Diferente numero de transferencias")
       result(0)
  }, error = function (cond) {
       result(-1)
       fail(cond$message)
  })
}
xfer_init          = function (factory, camera) {
    print  (1, "Transferencia basica total")
    # Transferir los 10000 a la camara
    data = list(
        from = "CASH"
       ,to   = camera
       ,currency  = 0
       ,amount    = 10000
    )
    tryCatch({
       oper = factory$getObject("Operation")
       id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Position")
       df = tbl$table(camera = "CASH")
       if (nrow(df) != 1)          stop("Demasiadas posiciones para CASH")

       tgt = list( balance = 0, available = 0, net = 1)
       checkRecord("CASH position", as.list(df[1,]), tgt)

       df = tbl$table(camera = camera)
       if (nrow(df) != 1)              stop(sprintf("Posicion invalida para camara %s", camera))
       tgt = list( currency = 0, balance = 10000, available = 10000, net = 1)
       checkRecord("Camara position", as.list(df[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table()
       if (nrow(df) != 4)             stop("Diferente numero de transferencias")
       # tgt = list( amount = 10000, cameraIn = camera, cameraOut = "CASH")
       # checkRecord("Transferencia", as.list(df[1,]), tgt)


       # tbl = factory$getTable("Flows")
       # df = tbl$table()
       # if (nrow(df) != 2)             stop("Deberia haber 2 flujos")
       # df1 = df[df$type == YATACODE$flow$xferIn,]
       # if (nrow(df1) != 1)             stop(sprintf("Falta el flujo de entrada: %d", YATACODE$flow$xferIn))
       # if (df1[1,"amount"] !=  10000)  stop("La cantidad de la transferencia no es -10000")
       # if (df1[1,"price"]  !=      1)  stop("El precio de la transferencia no es 1")
       #
       # df1 = df[df$type == YATACODE$flow$xferOut,]
       # if (nrow(df1) != 1)             stop(sprintf("Falta el flujo de salida: %d", YATACODE$flow$xferIn))
       # if (df1[1,"amount"] != -10000)  stop("La cantidad de la transferencia no es 10000")
       # if (df1[1,"price"]  !=      1)  stop("El precio de la transferencia no es 1")

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_no_available  = function (factory, camera) {
    print  (1, "Transferencia sin capital")
    # No hay disponible
    data = list(
        from = "CASH"
       ,to   = camera
       ,currency  = 0
       ,amount    = 10000
    )
    tryCatch({
       oper = factory$getObject("Operation")
       id = oper$xfer(data)
       result(-1)
       fail("LOGICAL Execption not thrown")
    }, LOGICAL = function (cond) {
       result(0)
    }, error = function (cond) {
       result(-1)
       fail(cond$message)
    })
}
xfer_reset         = function (factory, camera) {
    print  (1, "Transferencia a CASH")
    # Transferir los 10000 a la camara
    data = list(
        from = camera
       ,to   = "CASH"
       ,currency  = 0
       ,amount    = 10000
    )
    tryCatch({
       oper = factory$getObject("Operation")
       id   = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Transfers")
       df = tbl$table()
       if (nrow(df) != 5)             stop("Diferente numero de transferencias. Se esperaba 5")
       df = df[df$id == id,]
       if (df[1,"amount"]   != 10000) stop("Cantidad transferida no es 10000")

       tbl = factory$getTable("Position")
       df = tbl$table(camera = "CASH")
       if (nrow(df) == 0)              stop("No hay registro de camara CASH")
       if (nrow(df) >  1)              stop("Demasiadas posiciones para CASH")
       if (df[1,"balance"]   != 10000) stop("Balance de CASH no es 10000")
       if (df[1,"available"] != 10000) stop("Disponible de CASH no es 10000")
       if (df[1,"net"]       != 1) stop("Neto en CASH siempre debe ser 1")
       df = tbl$table(camera = camera)
       if (nrow(df) == 0)              stop(sprintf("No hay registro de camara %s", camera))
       if (nrow(df) >  1)              stop(sprintf("Demasiadas posiciones para %s", camera))
       if (df[1,"balance"]   !=     0) stop(sprintf("Balance de %s no es 0", camera))
       if (df[1,"available"] !=     0) stop(sprintf("Disponible de %s no es 0", camera))
       if (df[1,"net"]       !=     1) stop(sprintf("Neto de %s deberia ser 1", camera))

       # tbl = factory$getTable("Flows")
       # df = tbl$table()
       # if (nrow(df) != 4)             stop("Deberia haber 4 flujos")
       # df1 = df[df$type == YATACODE$flow$xferIn,]
       # if (nrow(df1) != 2)             stop(sprintf("Faltan flujos de entrada: %d", YATACODE$flow$xferIn))
       # df1 = df1[df1$idOper == id,]
       # if (df1[1,"amount"] !=  10000)  stop("La cantidad de la transferencia no es 10000")
       # if (df1[1,"price"]  !=      1)  stop("El precio de la transferencia no es 1")
       #
       # df1 = df[df$type == YATACODE$flow$xferOut,]
       # if (nrow(df1) != 2)             stop(sprintf("Faltan flujos de salida: %d", YATACODE$flow$xferIn))
       # df1 = df1[df1$idOper == id,]
       # if (df1[1,"amount"] != -10000)  stop("La cantidad de la transferencia no es -10000")
       # if (df1[1,"price"]  !=      1)  stop("El precio de la transferencia no es 1")

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_comissions    = function (factory, camera) {
    print  (1, "Transferencia con comisiones")
    # Transferir los 10000 a la camara
    data = list(
        from      = "CASH"
       ,to        = camera
       ,currency  = 0
       ,amount    = 9000
       ,feeOut    = 100
       ,feeIn     = 10
    )
    tryCatch({
       oper = factory$getObject("Operation")
       id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Transfers")
       df = tbl$table()
       if (nrow(df) != 6)             stop("Diferente numero de transferencias (1). Se esperaban 6")
       df1 = df[df$cameraOut == "CASH",]
       if (nrow(df1) != 3)            stop("Diferente numero de transferencias (2). Se esperaban 3")
       df1 = df[df$cameraOut == camera,]
       if (nrow(df1) != 3)            stop("Diferente numero de transferencias (3). Se esperaban 3")

       tbl = factory$getTable("Position")
       df = tbl$table(camera = "CASH")
       if (nrow(df) == 0)          stop("No hay registro de camara CASH")
       if (nrow(df) >  1)          stop("Demasiadas posiciones para CASH")
       if (df[1,"balance"]   != 900) stop("Balance de CASH invalido")
       if (df[1,"available"] != 900) stop("Disponible de CASH invalido")
       if (df[1,"net"]       != 1) stop("Neto en CASH siempre debe ser 1")
       df = tbl$table(camera = camera)
       if (nrow(df) == 0)              stop(sprintf("No hay registro de camara %s", camera))
       if (nrow(df) >  1)              stop(sprintf("Demasiadas posiciones para %s", camera))
       if (df[1,"balance"]   !=  8990) stop(sprintf("Balance de %s no es 8900", camera))
       if (df[1,"available"] !=  8990) stop(sprintf("Disponible de %s no es 8900", camera))
       if (df[1,"net"]       != 1)     stop(sprintf("Neto de %s deberia ser 1", camera))

       tbl = factory$getTable("Flows")
       df = tbl$table()
       if (nrow(df) != 2)             stop("Deberia haber 8 flujos")
       # df1 = df[df$type == YATACODE$flow$xferIn,]
       # if (nrow(df1) != 3)             stop(sprintf("Faltan flujos de entrada: %d", YATACODE$flow$xferIn))
       # df1 = df[df$type == YATACODE$flow$xferOut,]
       # if (nrow(df1) != 3)             stop(sprintf("Faltan flujos de salida: %d", YATACODE$flow$xferOut))

       df1 = df[df$type == YATACODE$flow$fee,]
       if (nrow(df1) != 2)             stop(sprintf("Faltan flujos de comisiones: %d", YATACODE$flow$fee))
       df1 = df[df$amount ==  -10,]
       if (nrow(df1) != 1)             stop("Flujo de comision de entrada invalido")
       df1 = df[df$amount == -100,]
       if (nrow(df1) != 1)             stop("Flujo de comision de salida invalido")

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_bad_comission = function (factory, camera) {
    print  (1, "Transferencia con exceso de comision")
    # Transferir los 10000 a la camara
    data = list(
        from = "CASH"
       ,to   = camera
       ,currency  = 0
       ,amount    = 10
       ,value     = 1
       ,feeIn     = 15
    )
    tryCatch({
       oper = factory$getObject("Operation")
       id = oper$xfer(data)
       result(-1)
       fail("LOGICAL Execption not thrown")
    }, LOGICAL = function (cond) {
       result(0)
    }, error = function (cond) {
       result(-1)
       fail(cond$message)
    })
}
xfer_cameras       = function (factory, from, to) {
    print  (1, "Transferencia entre camaras")

    tryCatch({
       data = list(from = from, to = to, currency = 0, amount = 8990)
       oper = factory$getObject("Operation")
       id = oper$xfer(data)
       # Checks
       tbl = factory$getTable("Position")
       df = tbl$table()
       if (nrow(df) != 3)          stop(sprintf("Registros de camaras invalido: 3-%d", nrow(df)))
       df1 = df[df$camera == to,]
       if (nrow(df1) != 1)         stop(sprintf("No hay registro para la camara %s", to))
       tgt = list( balance = 8990, available = 8990
               ,sell_high =   0, sell_low =   0, sell_last =   0, sell_net = 0
               ,buy_high  =   0, buy_low  =   0, buy_last  =   0, buy_net  = 0
               ,buy       =   0, sell     =   0, net       =   1, profit   = 0)
       checkRecord("Camara target", as.list(df1[1,]), tgt)
       df1 = df[df$camera == from,]
       if (nrow(df1) != 1)          stop(sprintf("No hay registro para la camara %s", from))
       tgt = list( balance   =   0, available =  0
                  ,sell_high =   0, sell_low =   0, sell_last =   0, sell_net = 0
                  ,buy_high  =   0, buy_low  =   0, buy_last  =   0, buy_net  = 0
                  ,buy       =   0, sell     =   0, net       =   1, profit   = 0)
       checkRecord("Camara base", as.list(df1[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table()
       if (nrow(df) != 4)             stop("Diferente numero de transferencias: 4-%d", nrow(df))
      result(0)
    }, LOGICAL = function(cond) {
       result(-1)
       fail(cond$message)

    }, error = function (cond) {
       result(-1)
       fail(cond$message)
    })
}
