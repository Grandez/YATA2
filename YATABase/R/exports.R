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
map = function() { YATABaseMap$new() }
str = function() { YATABaseStr$new() }
