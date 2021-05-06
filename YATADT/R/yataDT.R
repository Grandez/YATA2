yataDFOutput = function(df, header=NULL, type="gral", opts=list(),  ...) {
   dt = yataDT(df,header, type, opts,...)
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
yataDT = function(data,header=header, type="gral", opts, ...) {
    colnames(data) = titleCase(colnames(data))
    if (!is.null(opts$names)) colnames(data) = opts$names

    data = .yataSetClasses(data, opts$types)

    # las clases propias son las ultimas
    mt = lapply(1:ncol(data), function(x) class(data[,x]))
    mt = unlist(lapply(mt, function(x) x[[length(x)]]))

    align = .yataGetAlignment(mt)
    lstOpts = list(ordering = FALSE)
    lstAlign = list()
    if (length(align$right) > 0) lstAlign = list(list(className="dt-right", targets = align$right))
    if (length(lstAlign)    > 0) lstOpts$columnDefs=lstAlign
    if (!is.null(opts$sortable)) lstOpts$ordering = opts$sortable
    sel = ifelse (is.null(opts$selectable), "single", "none")

    dt = datatable(data, escape=FALSE, rownames = FALSE, container=header, type=type, selection = sel, options = lstOpts, ...)
    dt = .yataFormat(dt, mt)

    if (!is.null(opts$color)) dt = .applyColor(dt, opts$color)
    dt
}

yataDT2 = function(data,types=NULL,colorize=NULL, header=NULL, ...) {
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
                                        ,color = DT::styleInterval( cuts=c(-Inf,-1, 1,+Inf)
                                        #,values=c("red","darkred","black", "darkgreen","green")))
        ,values=c("red","yellow","black", "blue","green")))
   }
   dt
}
yataDataTable = function(data, ...) {
    browser()
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
    for (cls in .yataGetClasses()) {
        clsname = paste0("yata_dat_", cls)
        cols = which(mt == clsname)
        if (length(cols) > 0) dt = eval(parse(text=paste0("yataFormat", cls,"(dt, cols)")))
    }
    dt
}

yataDTUpDown         = function(dt, cols) {
    dt %>% YATADT::formatStyle( cols, color = DT::styleInterval(cuts=c(-Inf,-1, 1,+Inf)
                               #,values=c("red","darkred","black", "darkgreen","green")))
        ,values=c("red","yellow","black", "blue","green")))
}
yataFormattext       = function(dt, cols) { dt }
yataFormatlabel      = function(dt, cols) { dt }
yataFormatnumber     = function(dt, cols) { formatCurrency(dt, columns=cols, currency="", mark=".", dec.mark=",") }
yataFormatinteger    = function(dt, cols) { formatRound  (dt, columns=cols, digits=0,    mark=".") }
yataFormatpercentage = function(dt, cols) { formatPercentage  (dt, columns=cols, digits=3,    mark=".", dec.mark=",") }
yataFormatamount     = function(dt, cols) { yataFormatNumber(dt, cols) }
yataFormatdate       = function(dt,cols) {
    formatDate(dt, columns=cols, method = 'toLocaleDateString',
                   params = list('es-ES',  list(year = 'numeric', month = 'numeric', day = 'numeric')))
}
yataFormattime       = function(dt,cols) {
    formatDate(dt, columns=cols, method = 'toLocaleDateString',
                   params = list('es-ES',  list(year = 'numeric', month = 'numeric', day = 'numeric')))
}
yataFormattms        = function(dt,cols) {
    formatDate(dt, columns=cols, method = 'toLocaleDateString',
                   params = list('es-ES',  list(year = 'numeric', month = 'numeric', day = 'numeric')))
}

.yataGetAlignment = function (mt) {
    # Simplemente, en funcion de la clase, define la alineacion
    # En DT las columnas empiezan por cero
    la = c()
    ra = c()
    ca = c()
    for (cls in .yataGetClasses()) {
        clsname = paste0("yata_dat_", cls)
        cols = which(mt == clsname)
        if (length(cols) > 0) {
            cols = cols - 1 # 0 indexed
            if (cls %in% c("text", "label")) {
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
   c( "text"  , "label"
     ,"number", "integer", "percentage", "amount"
     ,"date"  , "time"   , "tms" )
}
.yataSetClasses = function(df, types) {

    cc = list(prc = c(), tms=c(), int=c(), lbl=c(), dat=c(), tim=c(), imp =c(), btn=c())
    if (!is.null(types)) cc = list.merge(cc, types)

    if (is.character(cc$prc)) cc$prc = which(colnames(df) %in% cc$prc)
    if (is.character(cc$tms)) cc$tms = which(colnames(df) %in% cc$tms)
    if (is.character(cc$int)) cc$int = which(colnames(df) %in% cc$int)
    if (is.character(cc$lbl)) cc$lbl = which(colnames(df) %in% cc$lbl)
    if (is.character(cc$dat)) cc$dat = which(colnames(df) %in% cc$dat)
    if (is.character(cc$tim)) cc$tim = which(colnames(df) %in% cc$tim)
    if (is.character(cc$imp)) cc$imp = which(colnames(df) %in% cc$imp)
    if (is.character(cc$btn)) cc$btn = which(colnames(df) %in% cc$btn)
    for (idx in 1:ncol(df)) {
        cls = class(df[,idx])
        if (idx %in% cc$prc)      { class(df[,idx]) = c(cls, "yata_dat_percentage");
            df[,idx] = round(df[,idx], 3)
            next
        }
        if (idx %in% cc$tms)      { class(df[,idx]) = c(cls, "yata_dat_tms");        next}
        if (idx %in% cc$int)      { class(df[,idx]) = c(cls, "yata_dat_integer");    next}
        if (idx %in% cc$imp)      { class(df[,idx]) = c(cls, "yata_dat_amount");     next}
        if (idx %in% cc$lbl)      { class(df[,idx]) = c(cls, "yata_dat_label");      next}
        if (idx %in% cc$dat)      { class(df[,idx]) = c(cls, "yata_dat_date");       next}
        if (idx %in% cc$tim)      { class(df[,idx]) = c(cls, "yata_dat_time");       next}
        if (idx %in% cc$btn)      { class(df[,idx]) = c(cls, "yata_dat_button");     next}
        if ("numeric"   %in% cls) { class(df[,idx]) = c(cls, "yata_dat_number");     next}
        if ("character" %in% cls) class(df[,idx]) = c(cls, "yata_dat_text")
    }
    df
}

.applyColor = function(dt, color) {
    if (!is.null(color$var)) {
        dt = dt %>% YATADT::formatStyle( color$var
                                        ,color = DT::styleInterval( cuts=c(-Inf,-0.02,0.02,+Inf)
                                        #,values=c("red","darkred","black", "darkgreen","green")))
        ,values=c("red","yellow","black", "blue","green")))
    }
    if (!is.null(color$date)) {
        dt = dt %>% YATADT::formatStyle( color$date
                                        ,backgroundColor  = DT::styleInterval( cuts=c(-Inf,Sys.Date(),+Inf)
                                        ,values=c("white","lightgreen","lightgreen","red")))
   }
   dt
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
