checkEnv = function() {
    msg = YATASTD$new()
    var = Sys.getenv("YATA_ROOT")
    if (nchar(var) == 0) msg$fatal(16, "Missing environment variable YATA_ROOT")
}
