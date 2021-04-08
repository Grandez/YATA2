yataDFOutput = function(df, types=NULL,colorize=NULL, ...) {
   dt = yataDT(df, types=NULL,colorize=NULL, ...)
   yataDTRender(dt, ...)
}
#
# yataDTOutput = function(df, types=NULL,colorize=NULL, ...) {
#    dt = yataDT(df, types=NULL,colorize=NULL, ...)
#    yataDTRender(df, ...)
# }
yataDTRender = function(dt, ...) {
    renderDataTable(dt, escape=FALSE, style='auto', ...)
}

yataDT = function(data,types=NULL,colorize=NULL, ...) {
   data = .yataSetClasses(data, types)
   colnames(data) = titleCase(colnames(data))

    # las clases propias son las ultimas
    mt = lapply(1:ncol(data), function(x) class(data[,x]))
    mt = unlist(lapply(mt, function(x) x[[length(x)]]))

    align = .yataGetAlignment(mt)
    lstOpts = list()
    lstAlign = list()
    if (length(align$right) > 0) lstAlign = list(list(className="dt-right", targets = align$right))
    if (length(lstAlign) > 0) lstOpts = list(columnDefs=lstAlign)

    dt = datatable(data, escape=FALSE, rownames = FALSE, options = lstOpts, ...)
    dt = .yataFormat(dt, mt)

    if (!is.null(colorize)) {
        colorize = titleCase(colorize)
        dt = dt %>% YATADT::formatStyle( colorize
                                        ,color = DT::styleInterval( cuts=c(-Inf,0,+Inf)
                                        ,values=c("red","darkred","darkgreen","green")))
   }
   dt
}
yataDataTable = function(data, ...) {
    colnames(data) = titleCase(colnames(data))
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
#    yataDTRender(dt, ...)
}
.yataFormat          = function(dt, mt) {
    for (cls in yataGetClasses()) {
        clsname = paste0("yata", cls)
        cols = which(mt == clsname)
        if (length(cols) > 0) dt = eval(parse(text=paste0("yataFormat", cls,"(dt, cols)")))
    }
    dt
}

yataDTUpDown         = function(dt, cols) {
    dt %>% YATADT::formatStyle( cols, color = DT::styleInterval(cuts=c(-Inf,0,+Inf)
                               ,values=c("red","darkred","darkgreen","green")))
}
yataFormatText       = function(dt, cols) { dt }
yataFormatLabel      = function(dt, cols) { dt }
yataFormatNumber     = function(dt, cols) { formatCurrency(dt, columns=cols, currency="", mark=".", dec.mark=",") }
yataFormatInteger    = function(dt, cols) { formatRound  (dt, columns=cols, digits=0,    mark=".") }
yataFormatPercentage = function(dt, cols) {formatPercentage  (dt, columns=cols, digits=3,    mark=".", dec.mark=",") }
yataFormatAmount     = function(dt, cols) { yataFormatNumber(dt, cols) }
yataFormatDate       = function(dt,cols) {
    formatDate(dt, columns=cols, method = 'toLocaleDateString',
                   params = list('es-ES',  list(year = 'numeric', month = 'numeric', day = 'numeric')))
}
yataFormatTime       = function(dt,cols) {
    formatDate(dt, columns=cols, method = 'toLocaleDateString',
                   params = list('es-ES',  list(year = 'numeric', month = 'numeric', day = 'numeric')))
}
yataFormatTms        = function(dt,cols) {
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

.yataGetClasses = function() {
   c( "Text"  , "Label"
     ,"Number", "Integer", "Percentage", "Amount"
     ,"Date"  , "Time"   , "Tms" )
}
.yataSetClasses = function(df, types) {
    cc = list(prc = c(), tms=c(), int=c(), lbl=c(), dat=c(), tim=c(), imp =c())
    if (!is.null(types)) cc = list.merge(cc, types)

    if (is.character(cc$prc)) prc = which(colnames(df) %in% cc$prc)
    if (is.character(cc$tms)) tms = which(colnames(df) %in% cc$tms)
    if (is.character(cc$int)) int = which(colnames(df) %in% cc$int)
    if (is.character(cc$lbl)) lbl = which(colnames(df) %in% cc$lbl)
    if (is.character(cc$dat)) dat = which(colnames(df) %in% cc$dat)
    if (is.character(cc$tim)) tim = which(colnames(df) %in% cc$tim)
    if (is.character(cc$imp)) imp = which(colnames(df) %in% cc$imp)
    for (idx in 1:ncol(df)) {
        cls = class(df[,idx])
        if (idx %in% cc$prc) { class(df[,idx]) = c(cls, "yataPercentage"); next}
        if (idx %in% cc$tms) { class(df[,idx]) = c(cls, "yataTms");        next}
        if (idx %in% cc$int) { class(df[,idx]) = c(cls, "yataInteger");    next}
        if (idx %in% cc$imp) { class(df[,idx]) = c(cls, "yataAmount");     next}
        if (idx %in% cc$lbl) { class(df[,idx]) = c(cls, "yataLabel");      next}
        if (idx %in% cc$dat) { class(df[,idx]) = c(cls, "yataDate");       next}
        if (idx %in% cc$tim) { class(df[,idx]) = c(cls, "yataTime");       next}

        if ("numeric"   %in% cls) class(df[,idx]) = c(cls, "yataNumber")
        if ("character" %in% cls) class(df[,idx]) = c(cls, "yataText")
    }
    df
}

yataDTButtons = function(df, buttons) {
     data = df
     cols = ncol(df)
     code = lapply(strsplit(buttons, "__"), function(x) paste0(x[[1]], seq(1,nrow(df)), x[[2]]))
     dfb = as.data.frame(code)
     colnames(dfb) = paste0("col", seq(1,ncol(dfb)))
     dfb = tidyr::unite(dfb, "btn", colnames(dfb), sep=" ", remove=TRUE)
     data = cbind(df, dfb)
     cols = colnames(data)
     cols[length(cols)] = ""
     colnames(data) = titleCase(cols)
     data
}
