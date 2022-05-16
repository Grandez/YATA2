HashMap = function()        { YATABaseMap$new() }
ini     = function(iniFile) { YATABaseIni$new(iniFile) }
map     = function()        { YATABaseMap$new()        }
str     = function()        { YATABaseStr$new()        }

#' Convierte un conjunto de parametros en una lista nombrada
args2list = function(...) {
  args = list(...)
  if (length(args) == 0) return (NULL)
  if (length(args) == 1) {
      if ("shiny.tag" %in% class(args[[1]])) return (args)
      if (is.list(args[[1]])) return (args[[1]])
      if (is.vector(args[[1]]) && length(args[[1]]) > 1) return (as.list(args[[1]]))
  }
  args
}

loadTable = function (df, table, dbname, suffix=NULL, replace=TRUE ) {
    datafile = file.path(Sys.getenv("YATA_SITE"), "data/tmp/", table)
    datafile = gsub("\\\\", "/", datafile) # Lo de win/unix

    if (is.null(suffix)) suffix = ".dat"
    datafile = paste0(datafile, suffix)

    write.table(df, file=file(datafile,"wb"), dec=".", sep=";", quote=FALSE, eol="\n"
                            , row.names = FALSE, col.names=FALSE, na="NULL")
    suppressWarnings(closeAllConnections())
    exec = YATAExec$new()
    res = exec$import(basename(datafile), dbname, colnames(df))
    file.remove(datafile)
    res
}
jgg_get_active_ns = function(id) {
    data = strsplit(id, "-")
    data[[1]][length(data[[1]])]
}

