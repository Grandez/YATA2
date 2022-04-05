.add2database = function (df, tbl) {
    colNames = tbl$translateColNames(colnames(df))
    tblName  = tbl$getDBTableName()
    datafile = file.path(Sys.getenv("YATA_SITE"), "data/tmp/", tblName)
    datafile = gsub("\\\\", "/", datafile) # Lo de win/unix

    datafile = paste0(datafile, ".dat")

    write.table(df, file=file(datafile,"wb"), dec=".", sep=";", quote=FALSE, eol="\n"
                            , row.names = FALSE, col.names=FALSE)
    closeAllConnections()
    exec = YATAExec$new()
    res = exec$import(basename(datafile), tbl$getDB()$getName(), colNames)
    file.remove(datafile)
}
