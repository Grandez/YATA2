transfers = function (factory) {
   camera = "CI1"
   println(0, crayon::bold("Verificando transferencias"))
   xfer_init          (factory, camera)
   xfer_no_available  (factory, camera)
   xfer_reset         (factory, camera)
   xfer_comissions    (factory, camera)
}
xfer_init          = function (factory, camera) {
    print  (1, "Transferencia basica total")
    # Transferir los 10000 a la camara
    data = list(
        from = "CASH"
       ,to   = camera
       ,currency  = 0
       ,amount    = 10000
       ,value     = 1
    )
    tryCatch({
       oper = factory$getObject("Operation")
       id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Position")
       df = tbl$table(camera = "CASH")
       if (nrow(df) == 0)          stop("No hay registro de camara CASH")
       if (nrow(df) >  1)          stop("Demasiadas posiciones para CASH")
       if (df[1,"balance"]   != 0) stop("Balance de CASH no es cero")
       if (df[1,"available"] != 0) stop("Disponible de CASH no es cero")
       if (df[1,"net"]       != 1) stop("Neto en CASH siempre debe ser 1")
       df = tbl$table(camera = camera)
       if (nrow(df) == 0)              stop(sprintf("No hay registro de camara %s", camera))
       if (nrow(df) >  1)              stop(sprintf("Demasiadas posiciones para %s", camera))
       if (df[1,"balance"]   != 10000) stop(sprintf("Balance de %s no es 10000", camera))
       if (df[1,"available"] != 10000) stop(sprintf("Disponible de %s no es 10000", camera))
       if (df[1,"net"]       != 1)     stop(sprintf("Neto de %s deberia ser 1", camera))
       tbl = factory$getTable("Transfers")
       df = tbl$table()
       if (nrow(df) != 1)             stop("Diferente numero de transferencias")
       if (df[1,"amount"]   != 10000) stop("Cantidad transferida no es 10000")
       if (df[1,"value"]    != 1)     stop("El valor/precio deberia ser 1")

       tbl = factory$getTable("Flows")
       df = tbl$table()
       if (nrow(df) != 2)             stop("Deberia haber 2 flujos")
       df1 = df[df$type == YATACODE$flow$xferIn,]
       if (nrow(df1) != 1)             stop(sprintf("Falta el flujo de entrada: %d", YATACODE$flow$xferIn))
       if (df1[1,"amount"] !=  10000)  stop("La cantidad de la transferencia no es -10000")
       if (df1[1,"price"]  !=      1)  stop("El precio de la transferencia no es 1")

       df1 = df[df$type == YATACODE$flow$xferOut,]
       if (nrow(df1) != 1)             stop(sprintf("Falta el flujo de salida: %d", YATACODE$flow$xferIn))
       if (df1[1,"amount"] != -10000)  stop("La cantidad de la transferencia no es 10000")
       if (df1[1,"price"]  !=      1)  stop("El precio de la transferencia no es 1")

      result(0)
  }, error = function (cond) {
      result(-1)
      fail(cond$message)
  })
}
xfer_no_available  = function (factory, camera) {
    print  (1, "Transferencia sin capital")
    # Transferir los 10000 a la camara
    data = list(
        from = "CASH"
       ,to   = camera
       ,currency  = 0
       ,amount    = 10000
       ,value     = 1
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
       ,value     = 1
    )
    tryCatch({
       oper = factory$getObject("Operation")
       id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Transfers")
       df = tbl$table()
       if (nrow(df) != 2)             stop("Diferente numero de transferencias. Se esperaba 2")
       df = df[df$id == id,]
       if (df[1,"amount"]   != 10000) stop("Cantidad transferida no es 10000")
       if (df[1,"value"]    != 1)     stop("El valor/precio deberia ser 1")

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

       tbl = factory$getTable("Flows")
       df = tbl$table()
       if (nrow(df) != 4)             stop("Deberia haber 4 flujos")
       df1 = df[df$type == YATACODE$flow$xferIn,]
       if (nrow(df1) != 2)             stop(sprintf("Faltan flujos de entrada: %d", YATACODE$flow$xferIn))
       df1 = df1[df1$idOper == id,]
       if (df1[1,"amount"] !=  10000)  stop("La cantidad de la transferencia no es 10000")
       if (df1[1,"price"]  !=      1)  stop("El precio de la transferencia no es 1")

       df1 = df[df$type == YATACODE$flow$xferOut,]
       if (nrow(df1) != 2)             stop(sprintf("Faltan flujos de salida: %d", YATACODE$flow$xferIn))
       df1 = df1[df1$idOper == id,]
       if (df1[1,"amount"] != -10000)  stop("La cantidad de la transferencia no es -10000")
       if (df1[1,"price"]  !=      1)  stop("El precio de la transferencia no es 1")

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
xfer_comissions    = function (factory, camera) {
    print  (1, "Transferencia con comisiones")
    # Transferir los 10000 a la camara
    data = list(
        from      = "CASH"
       ,to        = camera
       ,currency  = 0
       ,amount    = 9000
       ,value     = 1
       ,feeOut    = 100
       ,feeIn     = 10
    )
    tryCatch({
       oper = factory$getObject("Operation")
       id = oper$xfer(data)

       # Checks
       tbl = factory$getTable("Transfers")
       df = tbl$table()
       if (nrow(df) != 3)             stop("Diferente numero de transferencias (1). Se esperaban 3")
       df1 = df[df$cameraOut == "CASH",]
       if (nrow(df1) != 2)            stop("Diferente numero de transferencias (2). Se esperaban 2")
       df1 = df[df$cameraOut == camera,]
       if (nrow(df1) != 1)            stop("Diferente numero de transferencias (3). Se esperaban 1")

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
       if (nrow(df) != 8)             stop("Deberia haber 8 flujos")
       df1 = df[df$type == YATACODE$flow$xferIn,]
       if (nrow(df1) != 3)             stop(sprintf("Faltan flujos de entrada: %d", YATACODE$flow$xferIn))
       df1 = df[df$type == YATACODE$flow$xferOut,]
       if (nrow(df1) != 3)             stop(sprintf("Faltan flujos de salida: %d", YATACODE$flow$xferOut))

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
