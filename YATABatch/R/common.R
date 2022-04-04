.add2database = function (df, tbl) {
    colNames = tbl$getColumnNames(colnames(df))
    tblName  = tbl$getDBTableName()
    datafile = file.path(Sys.getenv("YATA_SITE"), "data/tmp/", tblName)
    datafile = gsub("\\\\", "/", datafile) # Lo de win/unix

    datafile = paste0(datafile, ".dat")


    write.table(df, datafile, dec=".", sep=";", quote=FALSE, row.names = FALSE, col.names=FALSE)
    res = YATAExec$new()$import(basename(datafile), obj$getDBName(), colNames)
    file.remove(datafile)
}
