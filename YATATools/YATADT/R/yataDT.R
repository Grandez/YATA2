yataDataTable = function(data, ...) {
    renderDataTable(data, ...)
}

yataDataTableFormat = function(data, ...) {
    # las clases propias son las ultimas
    # sapply si puede hace matriz, sino lista
    mt = lapply(1:ncol(data), function(x) class(data[,x]))
#    if (is.list(mt)) {
        mt = unlist(lapply(mt, function(x) x[[length(x)]]))
    # }
    # else {
    #     mt = mt[nrow(mt),]
    # }
    dt = datatable(data)

    cols = which(mt == "yataNumber")
    if (length(cols) > 0) dt = dt %>% yataFormatNumber(cols)
    cols = which(mt == "yataDate")
    if (length(cols) > 0) dt = dt %>% yataFormatDate(cols)

    renderDataTable(dt, ...)
}

yataFormatNumber = function(dt, cols) {
    formatCurrency(dt, columns=cols, currency="", mark=".", dec.mark=",")
}
yataFormatDate = function(dt,cols) {
    formatDate(dt, columns=cols, method = 'toLocaleDateString',
                   params = list('es-ES',  list(year = 'numeric', month = 'numeric', day = 'numeric')))
}
