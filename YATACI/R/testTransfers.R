testTransfers = function () {
   println(0, crayon::bold("Verificando transferencias"))
   camera  = "CI1"
   camera2 = "CI2"

   # Transferencias CASH a/desde fuera
   factory = prepareEnvironment()
   xfer_ext_in           (factory, camera)
   xfer_ext_out          (factory, camera)
   xfer_ext_in_2         (factory, camera)
   xfer_ext_no_available (factory, camera)
   xfer_out_comission    (factory, camera)

   # Transferencias CASH a/desde camara
   factory$destroy()
   factory = prepareEnvironment()
   xfer_ext_in         (factory, camera)
   xfer_cash_in        (factory, camera)
   xfer_cash_out       (factory, camera)
   xfer_cash_comission (factory, camera)

   xfer_add_position   (factory, camera)
   xfer_no_available   (factory, camera,  camera2)
   xfer_no_comission   (factory, camera,  camera2)
   xfer_simple         (factory, camera,  camera2)
   xfer_restore        (factory, camera2, camera )
   factory$destroy()
}
xfer_ext_in           = function (factory, camera)   {
   # Transferir 1000 al sistema
   print  (1, "Carga inicial")

   data = list(from=YATACODE$CAMEXT, to = YATACODE$CAMFIAT, amount = 1000, date=Sys.Date())
    tryCatch({
       oper = factory$getObject("Operation")

       id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Position")
       df = tbl$table(camera = YATACODE$CAMFIAT, currency = YATACODE$CTCFIAT)
       if (nrow(df) != 1)          stop("FIAT: Registros de posicion invalidos")
       tgt = list( balance   = 1000, available = 1000
                  ,sell_high =    0, sell_low  =    0, sell_last =    0, sell_net = 0
                  ,buy_high  = 1000, buy_low   = 1000, buy_last  = 1000, buy_net  = 1
                  ,buy       = 1000, sell      =    0, net       =    1, result   = 0)
       checkRecord("FIAT position", as.list(df[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table()
       if (nrow(df) != 1)             stop("Diferente numero de transferencias")
       tgt = list( cameraOut = YATACODE$CAMEXT
                  ,cameraIn  = YATACODE$CAMFIAT
                  ,currency  = YATACODE$CTCFIAT
                  ,amount = data$amount)
       checkRecord("Transfer", as.list(df[1,]), tgt)
       tbl = factory$getTable("Flows")
       df = tbl$table(idOper = id)
       if (nrow(df) != 1)             stop("Flujos incorrectos")
       tgt = list( type = YATACODE$flow$xferIn, camera  = YATACODE$CAMFIAT, amount = data$amount, price = 1)
       checkRecord("Flow", as.list(df[1,]), tgt)

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_ext_out          = function (factory, camera)   {
   # Devolver 1000 del sistema
   print  (1, "Recuperar capital")

   data = list(from=YATACODE$CAMFIAT, to = YATACODE$CAMEXT, amount = 1000, date=Sys.Date())
   tryCatch({
      oper = factory$getObject("Operation")

      id = oper$xfer(data)

      # Checks
      tbl = factory$getTable("Position")
      df = tbl$table(camera = YATACODE$CAMFIAT, currency = YATACODE$CTCFIAT)
      if (nrow(df) != 1)          stop("FIAT: Registros de posicion invalidos")
      tgt = list( balance   =     0, available =    0
                 ,sell_high =  1000, sell_low  = 1000, sell_last = 1000, sell_net = 1
                 ,buy_high  =  1000, buy_low   = 1000, buy_last  = 1000, buy_net  = 1
                 ,buy       =  1000, sell      = 1000, net       =    1, result   = 0)
       checkRecord("FIAT position", as.list(df[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table(id = id)
       if (nrow(df) != 1)             stop("Diferente numero de transferencias")
       tgt = list( cameraIn  = YATACODE$CAMEXT
                  ,cameraOut = YATACODE$CAMFIAT
                  ,currency  = YATACODE$CTCFIAT
                  ,amount    = data$amount
                  ,price     = 1)
       checkRecord("Transfer", as.list(df[1,]), tgt)
       tbl = factory$getTable("Flows")
       df = tbl$table(idOper = id)
       if (nrow(df) != 1)             stop("Flujos incorrectos")
       tgt = list( type = YATACODE$flow$xferOut, camera  = YATACODE$CAMFIAT, amount = data$amount * -1, price = 1)
       checkRecord("Flow", as.list(df[1,]), tgt)

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_ext_in_2         = function (factory, camera)   {
   # Transferir 1000 al sistema
   print  (1, "Recarga inicial")

   data = list(from=YATACODE$CAMEXT, to = YATACODE$CAMFIAT, amount = 1000, date=Sys.Date())
    tryCatch({
       oper = factory$getObject("Operation")

       id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Position")
       df = tbl$table(camera = YATACODE$CAMFIAT, currency = YATACODE$CTCFIAT)
       if (nrow(df) != 1)          stop("FIAT: Registros de posicion invalidos")
       tgt = list( balance   = 1000, available = 1000
                  ,sell_high =  1000, sell_low = 1000, sell_last = 1000, sell_net = 1
                  ,buy_high  =  1000, buy_low  = 1000, buy_last  = 1000, buy_net  = 1
                  ,buy       =  2000, sell     = 1000, net       =    1, result   = 0)
       checkRecord("FIAT position", as.list(df[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table(id = id)
       if (nrow(df) != 1)             stop("Diferente numero de transferencias")
       tgt = list( cameraOut = YATACODE$CAMEXT
                  ,cameraIn  = YATACODE$CAMFIAT
                  ,currency  = YATACODE$CTCFIAT
                  ,amount = data$amount)
       checkRecord("Transfer", as.list(df[1,]), tgt)
       tbl = factory$getTable("Flows")
       df = tbl$table(idOper = id)
       if (nrow(df) != 1)             stop("Flujos incorrectos")
       tgt = list( type = YATACODE$flow$xferIn, camera  = YATACODE$CAMFIAT, amount = data$amount, price = 1)
       checkRecord("Flow", as.list(df[1,]), tgt)

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_ext_no_available = function (factory, camera)   {
    print  (1, "Transferencia sin disponible")
    # No hay disponible
    data = list(from=YATACODE$CAMFIAT, to = YATACODE$CAMEXT, amount = 1000, feeOut = 100, date=Sys.Date())

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
xfer_out_comission    = function (factory, camera)   {
    print  (1, "Transferencia sin disponible")
    # No hay disponible
    data = list(from=YATACODE$CAMFIAT, to = YATACODE$CAMEXT, amount =  900, feeOut = 100, date=Sys.Date())

   tryCatch({
      oper = factory$getObject("Operation")

      id = oper$xfer(data)

      # Checks
      tbl = factory$getTable("Position")
      df = tbl$table(camera = YATACODE$CAMFIAT, currency = YATACODE$CTCFIAT)
      if (nrow(df) != 1)          stop("FIAT: Registros de posicion invalidos")
      tgt = list( balance   =     0, available =    0
                 ,sell_high =  1000, sell_low  =  900, sell_last =  900, sell_net = 1
                 ,buy_high  =  1000, buy_low   = 1000, buy_last  = 1000, buy_net  = 1
                 ,buy       =  2000, sell      = 1900, net       =    1, result   = 0)
       checkRecord("FIAT position", as.list(df[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table(id = id)
       if (nrow(df) != 1)             stop("Diferente numero de transferencias")
       tgt = list( cameraIn  = YATACODE$CAMEXT
                  ,cameraOut = YATACODE$CAMFIAT
                  ,currency  = YATACODE$CTCFIAT
                  ,amount    = data$amount
                  ,price     = 1)
       checkRecord("Transfer", as.list(df[1,]), tgt)
       tbl = factory$getTable("Flows")
       df = tbl$table(idOper = id)
       if (nrow(df) != 2)             stop("Flujos incorrectos")
       df1 = df[df$type == YATACODE$flow$xferOut,]
       if (nrow(df1) != 1)             stop("Flujo de transferencia no existe")
       tgt = list( camera  = YATACODE$CAMFIAT, currency = YATACODE$CTCFIAT, amount = data$amount * -1, price = 1)
       checkRecord("Flow", as.list(df1[1,]), tgt)
       df1 = df[df$type == YATACODE$flow$fee,]
       if (nrow(df1) != 1)             stop("Flujo de transferencia no existe")
       tgt = list( camera  = YATACODE$CAMFIAT, currency = YATACODE$CTCFIAT, amount = data$feeOut * -1, price = 1)
       checkRecord("Flow", as.list(df1[1,]), tgt)

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_cash_in          = function (factory, camera)   {
   # Transferir 1000 al camera
   print  (1, "FIAT A CAM")

   data = list(from=YATACODE$CAMFIAT, to = camera, currency = YATACODE$CTCFIAT, amount = 1000, date=Sys.Date())
   tryCatch({
      oper = factory$getObject("Operation")

      id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Position")
       df = tbl$table(camera = data$from, currency = data$currency)
       if (nrow(df) != 1)          stop("FIAT: Registros de posicion invalidos")
       tgt = list( balance   =     0, available =    0
                  ,sell_high =     0, sell_low  =    0, sell_last =    0, sell_net = 0
                  ,buy_high  =  1000, buy_low   = 1000, buy_last  = 1000, buy_net  = 1
                  ,buy       =  1000, sell      =    0, net       =    1, result   = 0)
       checkRecord("FIAT position", as.list(df[1,]), tgt)

       df = tbl$table(camera = data$to, currency = data$currency)
       if (nrow(df) != 1)          stop("FIAT: Registros de posicion invalidos")
       tgt = list( balance   =  1000, available = 1000
                  ,sell_high =     0, sell_low  =    0, sell_last =    0, sell_net = 0
                  ,buy_high  =  1000, buy_low   = 1000, buy_last  = 1000, buy_net  = 1
                  ,buy       =  1000, sell      =    0, net       =    1, result   = 0)
       checkRecord("CAMERA position", as.list(df[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table(id = id)
       if (nrow(df) != 1)             stop("Diferente numero de transferencias")
       tgt = list( cameraOut = data$from
                  ,cameraIn  = data$to
                  ,currency  = data$currency
                  ,amount    = data$amount)
       checkRecord("Transfer", as.list(df[1,]), tgt)

       tbl = factory$getTable("Flows")
       df = tbl$table(idOper = id)
       if (nrow(df) != 2)             stop("Flujos incorrectos")
       df1 = df[df$type == YATACODE$flow$xferIn,]
       if (nrow(df1) != 1)             stop("Falta flujo de entrada")
       tgt = list(camera = data$to, amount = data$amount, price = 1)
       checkRecord("Flow", as.list(df1[1,]), tgt)
       df1 = df[df$type == YATACODE$flow$xferOut,]
       if (nrow(df1) != 1)             stop("Falta flujo de salida")
       tgt = list(camera = data$from, amount = data$amount * -1, price = 1)
       checkRecord("Flow", as.list(df1[1,]), tgt)

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_cash_out         = function (factory, camera)   {
   # Transferir 1000 al FIAT
   print  (1, "CAM A FIAT")

   data = list(from=camera, to = YATACODE$CAMFIAT, currency = YATACODE$CTCFIAT, amount = 1000, date=Sys.Date())
   tryCatch({
      oper = factory$getObject("Operation")

      id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Position")
       df = tbl$table(camera = data$from, currency = data$currency)
       if (nrow(df) != 1)          stop("FIAT: Registros de posicion invalidos")
       tgt = list( balance   =     0, available =    0
                  ,sell_high =  1000, sell_low  = 1000, sell_last = 1000, sell_net = 1
                  ,buy_high  =  1000, buy_low   = 1000, buy_last  = 1000, buy_net  = 1
                  ,buy       =  1000, sell      = 1000, net       =    1, result   = 0)
       checkRecord("CAMERA position", as.list(df[1,]), tgt)

       df = tbl$table(camera = data$to, currency = data$currency)
       if (nrow(df) != 1)          stop("FIAT: Registros de posicion invalidos")
       tgt = list( balance   =  1000, available = 1000
                  ,sell_high =     0, sell_low  =    0, sell_last =    0, sell_net = 0
                  ,buy_high  =  1000, buy_low   = 1000, buy_last  = 1000, buy_net  = 1
                  ,buy       =  1000, sell      =    0, net       =    1, result   = 0)
       checkRecord("CAMERA position", as.list(df[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table(id = id)
       if (nrow(df) != 1)             stop("Diferente numero de transferencias")
       tgt = list( cameraOut = data$from
                  ,cameraIn  = data$to
                  ,currency  = data$currency
                  ,amount    = data$amount)
       checkRecord("Transfer", as.list(df[1,]), tgt)

       tbl = factory$getTable("Flows")
       df = tbl$table(idOper = id)
       if (nrow(df) != 2)             stop("Flujos incorrectos")
       df1 = df[df$type == YATACODE$flow$xferIn,]
       if (nrow(df1) != 1)             stop("Falta flujo de entrada")
       tgt = list(camera = data$to, amount = data$amount, price = 1)
       checkRecord("Flow", as.list(df1[1,]), tgt)
       df1 = df[df$type == YATACODE$flow$xferOut,]
       if (nrow(df1) != 1)             stop("Falta flujo de salida")
       tgt = list(camera = data$from, amount = data$amount * -1, price = 1)
       checkRecord("Flow", as.list(df1[1,]), tgt)

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_cash_comission   = function (factory, camera)   {
   # Transferir 500 a camera con comisiones
   print  (1, "FIAT A CAM COMISSIONs")

   data = list( from=YATACODE$CAMFIAT, to = camera, currency = YATACODE$CTCFIAT, date=Sys.Date()
               ,amount = 500, feeOut = 100, feeIn = 50)
   tryCatch({
      oper = factory$getObject("Operation")

      id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Position")
       # FIAT
       df = tbl$table(camera = data$from, currency = data$currency)
       if (nrow(df) != 1)          stop("FIAT: Registros de posicion invalidos")
       tgt = list( balance   =   400, available =  400
                  ,sell_high =     0, sell_low  =    0, sell_last =    0, sell_net = 0
                  ,buy_high  =  1000, buy_low   = 1000, buy_last  = 1000, buy_net  = 1
                  ,buy       =  1000, sell      =    0, net       =    1, result   = 0)
       checkRecord("FIAT position", as.list(df[1,]), tgt)
       # Camera
       df = tbl$table(camera = data$to, currency = data$currency)
       if (nrow(df) != 1)          stop("CAMERA: Registros de posicion invalidos")
       tgt = list( balance   =  450, available = 450
                  ,sell_high =  1000, sell_low  = 1000, sell_last = 1000, sell_net = 1
                  ,buy_high  =  1000, buy_low   =  500, buy_last  =  500, buy_net  = 1
                  ,buy       =  1500, sell      = 1000, net       =    1, result   = 0)
       checkRecord("CAMERA position", as.list(df[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table(id = id)
       if (nrow(df) != 1)             stop("Diferente numero de transferencias")
       tgt = list( cameraOut = data$from
                  ,cameraIn  = data$to
                  ,currency  = data$currency
                  ,amount    = data$amount)
       checkRecord("Transfer", as.list(df[1,]), tgt)

       tbl = factory$getTable("Flows")
       df = tbl$table(idOper = id)
       if (nrow(df) != 4)             stop("Flujos incorrectos")
       df1 = df[df$type == YATACODE$flow$xferIn,]
       if (nrow(df1) != 1)             stop("Falta flujo de entrada")
       tgt = list(camera = data$to, amount = data$amount, price = 1)
       checkRecord("Flow", as.list(df1[1,]), tgt)
       df1 = df[df$type == YATACODE$flow$xferOut,]
       if (nrow(df1) != 1)             stop("Falta flujo de salida")
       tgt = list(camera = data$from, amount = data$amount * -1, price = 1)
       checkRecord("Flow", as.list(df1[1,]), tgt)
       df1 = df[df$type == YATACODE$flow$fee & df$camera == data$from,]
       if (nrow(df1) != 1)             stop("Falta comision de salida")
       tgt = list(amount = data$feeOut * -1, price = 1)
       checkRecord("Flow", as.list(df1[1,]), tgt)
       df1 = df[df$type == YATACODE$flow$fee & df$camera == data$to,]
       if (nrow(df1) != 1)             stop("Falta comision de entrada")
       tgt = list(amount = data$feeIn * -1, price = 1)
       checkRecord("Flow", as.list(df1[1,]), tgt)

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_add_position     = function (factory, camera)   {
  print  (1, "Creando posicion")
  data = list( camera   = camera, currency = 1, balance = 10, available = 5
              ,buy_high  = 100, buy_low  = 100, buy_last  = 100, buy_net  = 100
              ,sell_high =   0, sell_low =   0, sell_last =   0, sell_net =   0
              ,buy       =  10, sell     =   0, net       = 100)
  tryCatch({
     db = factory$getDB()
     tbl = factory$getTable("Position")
     db$begin()
     tbl$add(data)
     db$commit()
     result(0)
  }, error = function (cond) {
     fail("ERROR CREANDO POSICION")
  })
}
xfer_no_available     = function (factory, from, to) {
   # Transferir 10 que no hay
   print  (1, "No hay disponible")

   data = list(from=from, to=to, amount = 10, currency = 1)
    tryCatch({
       oper = factory$getObject("Operation")
       id = oper$xfer(data)
       result(-1)
       fail("LOGICAL Exception not thrown")
    }, LOGICAL = function (cond) {
       result(0)
    }, error = function (cond) {
       result(-1)
       fail(cond$message)
    })
}
xfer_no_comission     = function (factory, from, to) {
   # Transferir 10 que no hay
   print  (1, "No hay para comision")

   data = list(from=from, to=to, amount=5, currency = 1, feeOut=500)
    tryCatch({
       oper = factory$getObject("Operation")
       id = oper$xfer(data)
       result(-1)
       fail("LOGICAL Exception not thrown")
    }, LOGICAL = function (cond) {
       result(0)
    }, error = function (cond) {
       result(-1)
       fail(cond$message)
    })
}
xfer_simple           = function (factory, from, to) {
   # Transferir a cam2
   print  (1, "CAM a CAM")

   data = list(from=from, to=to, currency=1, amount=5)
   tryCatch({
      oper = factory$getObject("Operation")
      id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Position")
       df = tbl$table(camera = data$from, currency = data$currency)
       if (nrow(df) != 1)          stop("FROM: Registros de posicion invalidos")
       tgt = list( balance   =     5, available =    0
                  ,sell_high =     0, sell_low  =    0, sell_last =    0, sell_net =   0
                  ,buy_high  =   100, buy_low   =  100, buy_last  =  100, buy_net  = 100
                  ,buy       =    10, sell      =    0, net       =  100, result   =   0)
       checkRecord("Camera from position", as.list(df[1,]), tgt)

       df = tbl$table(camera = data$to, currency = data$currency)
       if (nrow(df) != 1)          stop("TO: Registros de posicion invalidos")
       tgt = list( balance   =     5, available =    5
                  ,sell_high =     0, sell_low  =    0, sell_last =    0, sell_net = 0
                  ,buy_high  =     0, buy_low   =    0, buy_last  =    0, buy_net  = 0
                  ,buy       =     0, sell      =    0, net       =  100, result   = 0)
       checkRecord("Camera to position", as.list(df[1,]), tgt)

       tbl = factory$getTable("Transfers")
       df = tbl$table(id = id)
       if (nrow(df) != 1)             stop("Diferente numero de transferencias")
       tgt = list( cameraOut = data$from
                  ,cameraIn  = data$to
                  ,currency  = data$currency
                  ,amount    = data$amount
                  ,price     = 100)
       checkRecord("Transfer", as.list(df[1,]), tgt)

       tbl = factory$getTable("Flows")
       df = tbl$table(idOper = id)
       if (nrow(df) != 2)             stop("Flujos incorrectos")
       df1 = df[df$type == YATACODE$flow$xferIn,]
       if (nrow(df1) != 1)             stop("Falta flujo de entrada")
       tgt = list(camera = data$to, amount = data$amount, price = 100)
       checkRecord("Flow", as.list(df1[1,]), tgt)
       df1 = df[df$type == YATACODE$flow$xferOut,]
       if (nrow(df1) != 1)             stop("Falta flujo de salida")
       tgt = list(camera = data$from, amount = data$amount * -1, price = 100)
       checkRecord("Flow", as.list(df1[1,]), tgt)

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_restore          = function (factory, from, to) {
   # Transferir a cam2
   print  (1, "Restore CAM a CAM")

   data = list(from=from, to=to, currency=1, amount=5)
   tryCatch({
      oper = factory$getObject("Operation")
      id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Position")
       df = tbl$table(camera = data$from, currency = data$currency)
       if (nrow(df) != 1)          stop("FROM: Registros de posicion invalidos")
       tgt = list( balance   =     0, available =    0
                  ,sell_high =     0, sell_low  =    0, sell_last =    0, sell_net =   0
                  ,buy_high  =     0, buy_low   =    0, buy_last  =    0, buy_net  =   0
                  ,buy       =     0, sell      =    0, net       =  100, result   =   0)
       checkRecord("Camera from position", as.list(df[1,]), tgt)

       df = tbl$table(camera = data$to, currency = data$currency)
       if (nrow(df) != 1)          stop("TO: Registros de posicion invalidos")
       tgt = list( balance = 10, available = 5
                  ,buy_high  = 100, buy_low  = 100, buy_last  = 100, buy_net  = 100
                  ,sell_high =   0, sell_low =   0, sell_last =   0, sell_net =   0
                  ,buy       =  10, sell     =   0, net       = 100)
       checkRecord("Camera to position", as.list(df[1,]), tgt)

       # tbl = factory$getTable("Transfers")
       # df = tbl$table(id = id)
       # if (nrow(df) != 1)             stop("Diferente numero de transferencias")
       # tgt = list( cameraOut = data$from
       #            ,cameraIn  = data$to
       #            ,currency  = data$currency
       #            ,amount    = data$amount
       #            ,price     = 100)
       # checkRecord("Transfer", as.list(df[1,]), tgt)
       #
       # tbl = factory$getTable("Flows")
       # df = tbl$table(idOper = id)
       # if (nrow(df) != 2)             stop("Flujos incorrectos")
       # df1 = df[df$type == YATACODE$flow$xferIn,]
       # if (nrow(df1) != 1)             stop("Falta flujo de entrada")
       # tgt = list(camera = data$to, amount = data$amount, price = 100)
       # checkRecord("Flow", as.list(df1[1,]), tgt)
       # df1 = df[df$type == YATACODE$flow$xferOut,]
       # if (nrow(df1) != 1)             stop("Falta flujo de salida")
       # tgt = list(camera = data$from, amount = data$amount * -1, price = 100)
       # checkRecord("Flow", as.list(df1[1,]), tgt)

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
