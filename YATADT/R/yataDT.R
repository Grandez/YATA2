yataDT = function(data, ...) {
    # las clases propias son las ultimas
    mt = lapply(1:ncol(data), function(x) class(data[,x]))
    mt = unlist(lapply(mt, function(x) x[[length(x)]]))
    align = .yataGetAlignment(mt)
    lstOpts = list()
    lstAlign = list()
    if (length(align$right) > 0) lstAlign = list(list(className="dt-right", targets = align$right))
    if (length(lstAlign) > 0) lstOpts = list(columnDefs=lstAlign)
    dt = datatable(data, escape=FALSE, rownames = FALSE, options = lstOpts, ...)
    .yataFormat(dt, mt)
}
yataDTRender = function(dt, ...) {
    renderDataTable(dt, escape=FALSE, style='auto', ...)
}
yataDataTable = function(data, ...) {
    dt = yataDT(data, ...)
    # las clases propias son las ultimas
    # mt = lapply(1:ncol(data), function(x) class(data[,x]))
    # mt = unlist(lapply(mt, function(x) x[[length(x)]]))
    #
    # align = .yataGetAlignment(mt)
    # lstOpts = list()
    # lstAlign = list()
    # if (length(align$right) > 0) lstAlign = list(list(className="dt-right", targets = align$right))
    # if (length(lstAlign) > 0) lstOpts = list(columnDefs=lstAlign)
    # dt = datatable(data, escape=FALSE, rownames = FALSE, options = lstOpts, ...)
    # dt = .yataFormat(dt, mt)
    # renderDataTable(dt, escape=FALSE, style='auto', ...)
    yataDTRender(dt, ...)
}

.yataFormat = function(dt, mt) {
    for (cls in yataGetClasses()) {
        clsname = paste0("yata", cls)
        cols = which(mt == clsname)
        if (length(cols) > 0) dt = eval(parse(text=paste0("yataFormat", cls,"(dt, cols)")))
    }
    dt
}
yataFormatText    = function(dt, cols) { dt }
yataFormatLabel   = function(dt, cols) { dt }
yataFormatNumber  = function(dt, cols) { formatCurrency(dt, columns=cols, currency="", mark=".", dec.mark=",") }
yataFormatInteger = function(dt, cols) { formatRound  (dt, columns=cols, digits=0,    mark=".") }
yataFormatPercentage = function(dt, cols) { formatPercentage  (dt, columns=cols, digits=2,    mark=".", dec.mark=",") }
yataFormatAmount  = function(dt, cols) { yataFormatNumber(dt, cols) }
yataFormatDate = function(dt,cols) {
    formatDate(dt, columns=cols, method = 'toLocaleDateString',
                   params = list('es-ES',  list(year = 'numeric', month = 'numeric', day = 'numeric')))
}
yataFormatTime = function(dt,cols) {
    formatDate(dt, columns=cols, method = 'toLocaleDateString',
                   params = list('es-ES',  list(year = 'numeric', month = 'numeric', day = 'numeric')))
}
yataFormatTms = function(dt,cols) {
    formatDate(dt, columns=cols, method = 'toLocaleDateString',
                   params = list('es-ES',  list(year = 'numeric', month = 'numeric', day = 'numeric')))
}

.yataGetAlignment = function (mt) {
    # Simplemente, en funcion de la clase, define la alineacion
    # En DT las columnas empiezan por cero
    la = c()
    ra = c()
    ca = c()
    for (cls in yataGetClasses()) {
        clsname = paste0("yata", cls)
        cols = which(mt == clsname)
        if (length(cols) > 0) {
            cols = cols - 1 # 0 indexed
            if (cls %in% c("Text", "Label")) {
                la = c(la,cols)
            }
            else {
                ra = c(ra, cols)
            }
        }
    }
    list(left=la, center=ca, right=ra)
}
