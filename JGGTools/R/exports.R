HashMap = function() { JGGHashMap$new() }
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
jgg_list_merge = function(lst1, lst2) {
    if (is.null(lst1)) return (lst2)
    rlist::list.merge(lst1, lst2)
}
