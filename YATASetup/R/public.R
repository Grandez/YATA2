yata_test = function() {
    obj = YATASetup$new()
    message("Esta todo bien")
}
yata_ports = function() {
    setup = YATASetup$new()
    core <- system.file(package = "YATACore")
    if (nzchar(core)) setup$fatal("YATACore is not available yet")
    core_available = supressWarnings(require("YATACore"))
    message("Hecho")

}
