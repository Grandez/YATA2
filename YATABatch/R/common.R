.add2database = function (df, obj) {
    colNames = obj$getColumnNames(colnames(df))
    tblName  = obj$getDBTableName()
    datafile = file.path(Sys.getenv("YATA_SITE"), "data/tmp/", tblName)
    datafile = gsub("\\\\", "/", datafile) # Lo de win/unix
    datafile = paste0(datafile, ".dat")

    write.table(df, datafile, dec=".", sep=";", quote=FALSE, row.names = FALSE, col.names=FALSE)
    res = YATAExec$new()$import(basename(datafile), obj$getDBName(), colNames)
    file.remove(datafile)
}
