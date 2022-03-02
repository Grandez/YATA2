loadIcons = function(source= ".", verbose=3) {
    if (bitwAnd(verbose, 1)) cat("Cargando iconos ...")
    if (bitwAnd(verbose, 2)) cat("\n")
    env = YATACore::YATAENV$new()
    YATAFactory$env = env
    tblIcons = YATAFactory$getTable("Icons", env$getDBBase())
    setwd(source)
    files = list.files(all.files = FALSE)
    nfiles = 0
    for (file in files) {
        tmp = strsplit(file, ".", fixed=TRUE)
        base = tmp[[1]][1]
        ext = tmp[[1]][2]
        nfo = file.info(file)
        if (!nfo$isdir) {
            if (bitwAnd(verbose, 2)) msg("Icono", base)
            if ((nfiles %% 10) == 0) db.begin()
            nfiles = nfiles + 1
            data = readBin(file, "raw", nfo$size)
            tblIcons$add(base, ext, data)
            info = file.info(file)
            if ((nfiles %% 10) == 0) db.commit()
        }
    }
    if (bitwAnd(verbose, 1)) cat("\n")
}
