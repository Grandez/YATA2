getID = function() {
  epoch = as.integer(Sys.time()) - 1577836860 # Restamos el epoch desde 2020-01-01
  epoch = (epoch %% 1000000)                  # Quitamos el digito significativo
  epoch = epoch * 100                         # Le damos 2 menos significativos
  private$.cnt = private$.cnt + 1     # Contador estatico
  epoch + .cnt
}
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
