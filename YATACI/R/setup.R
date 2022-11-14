prepareEnvironment = function () {
    print  (1, "Creando Base de datos")
    rc = initDataBase()
    result(rc)
    if (rc > 0) return (rc)
    factory = YATACore::YATAFactory$new()
    factory$changeDB("ci")
    checkChangeDB(factory)
    factory
}
initDataBase = function() {
    file = normalizePath(system.file("yataci.sql", package="YATACI"))
    cmd = paste("source", file)
    prc = processx::process$new( "mysql"
                                ,c("-u", "root", "-pjgg", "-e", cmd)
                                ,stdin = file
                                ,stdout = "|"
                                ,stderr = "2>&1")

    prc$wait()
    prc$get_exit_status()
}
checkChangeDB = function(factory) {
    pos = factory$getObject("Position")
    df = pos$getFullPosition()
    if (nrow(df) != 1) fail("Fallo en cambio de base de datos (filas)")
    if (df[1,"camera"]  != YATACODE$CAMFIAT) fail("Fallo en cambio de base de datos (camara)")
}
