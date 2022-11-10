testBuySell = function () {
   println(0, crayon::bold("Verificando Buy/Sell"))
   camera  = "CI1"
   factory = prepareEnvironment()
   xfer_init(factory, camera)

   buy_simple(factory, camera)

   factory$destroy()
}
buy_simple = function(factory, camera) {
  print  (1, "Compra simple")
  tryCatch({
    oper = factory$getObject("Operation")
    data = list(
             type    = YATACODE$oper$buy
            ,amount  = 1
            ,price   = 100
            ,value   = 1 * 100
            ,fee     = 0
            ,gas     = 0
            ,camera  = camera
            ,reason  = 0
            ,base    = 0
            ,counter = 1
            ,ctcIn   = 1
            ,ctcOut  = 1 * 100
         )
    browser()
    id = oper$add(data$type, data)

    # checks
       # Checks
       tbl = factory$getTable("Operations")
       df = tbl$table()
       if (nrow(df) != 1)          stop(sprintf("Incorrecto numero de operaciones: %d", nrow(df)))
       tgt = list( type   = YATACODE$oper$buy, camera=camera, base = 0, counter = 1
                  ,amount = 1, value  = 100, price = 100
                  ,active = 1, parent = 0
                  ,status = YATACODE$status$executed)
       checkRecord("Operations", as.list(df[1,]), tgt)
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
      fail(cond)
  })

}
