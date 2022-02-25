yata_test = function() {
    obj = YATASetup$new()
    message("Esta todo bien")
}
yata_ports = function() {
#    library(base)
    setup = YATASetup$new()
    core <- system.file(package = "YATACore2")
    if (nchar(core) == 0) setup$fatal("YATACore is not available yet")
    core_available = suppressWarnings(require("YATACore"))
    message("Hecho")

}
