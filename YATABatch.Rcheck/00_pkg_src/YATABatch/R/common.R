.add2database = function (df, obj) {
    colNames = obj$getColumnNames(colnames(df))
    tblName  = obj$getDBTableName()
    datafile = file.path(Sys.getenv("YATA_SITE"), "data/tmp/", tblName)
    datafile = gsub("\\\\", "/", datafile) # Lo de win/unix

    datafile = paste0(datafile, ".dat")

    write.table(df, file=file(datafile,"wb"), dec=".", sep=";", quote=FALSE, eol="\n"
                            , row.names = FALSE, col.names=FALSE)
    suppressWarnings(closeAllConnections())
    exec = YATAExec$new()
    res = exec$import(basename(datafile), obj$getDBName(), colNames)
    file.remove(datafile)
}
