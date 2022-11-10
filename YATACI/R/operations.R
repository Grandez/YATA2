    # ,oper = list( bid   = 10, ask   = 11
    #              ,buy   = 20, sell  = 21
    #              ,open  = 30, close = 31
    #              ,xfer  = 40, reg   = 41
    #              ,split = 50, net   = 51
    #              )

testOperations = function() {
    banner("OPERATIONS")
    logger = YATALogger$new("YATACI", 9, 1)
    factory = .prepareOperations()
    rc = transfers(factory)
    # println(0, crayon::bold("Ejecutando compras"))
    # buying(factory)
    # rc
}

.prepareOperations = function () {
    print  (1, "Creando Base de datos")
    rc = initDataBase()
    result(rc)
    if (rc > 0) return (rc)
    factory = YATACore::YATAFactory$new()
    factory$changeDB("ci")
    .checkChangeDB(factory)
    factory
}
.checkChangeDB = function(factory) {
    pos = factory$getObject("Position")
    df = pos$getFullPosition()
    if (nrow(df) != 1) fail("Fallo en cambio de base de datos (filas)")
    if (df[1,"camera"]  != "CASH") fail("Fallo en cambio de base de datos (camara)")
    if (df[1,"balance"] != 10000)  fail("Fallo en cambio de base de datos (balance)")
}
