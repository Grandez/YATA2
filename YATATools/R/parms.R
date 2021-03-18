#' Convierte un conjunto de parametros en una lista nombrada
args2list = function(...) {
    args = list(...)
    if (length(args) == 0) return (NULL)
    if (length(args) == 1 && is.list(args[[1]])) return (args[[1]])
    if (length(args) == 1 && is.vector(args[[1]]) && length(args[[1]]) > 1) return (as.list(args[[1]]))
    args
}
