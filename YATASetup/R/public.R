yata_test = function() {
    obj = YATASetup$new()
    message("Esta todo bien")
}
yata_ports = function(port=NULL, url=NULL) {
    setup = YATASetup$new()
    if (is.null(port)) setup$fatal("Port base missing")

    core <- system.file(package = "YATACore")
    if (nchar(core) == 0) setup$fatal("YATACore is not available yet")
    core_available = suppressWarnings(require("YATACore"))
    factory = YATACore::YATAFACTORY$new()
    parms = factory$getObject("parms")
    db    = factory$getDBBase()
    db$begin()
    tryCatch({
        parms$updateParameter(1,4,2, port)
        if (!is.null(url)) parms$updateParameter(1,4,1, url)
        db$commit()
    }, error = function(cond) {
        db$rollback()
        stop("Error actualizando parametros")
    })
}
