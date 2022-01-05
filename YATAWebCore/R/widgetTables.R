# yuiDataTable = function(id) { DT::dataTableOutput(id) }

yuiTable          = function(id)   { reactableOutput(id) }
updTable          = function(data) { renderReactable({ .updTable(data, NULL)       })}
updTableSingle    = function(data) { renderReactable({ .updTable(data, "single")   })}
updTableMultiple  = function(data) { renderReactable({ .updTable(data, "multiple") })}
updTbl            = function(data) { .updTable(data, "multiple") }
updTableSelection = function(table, sel) { updateReactable(table, selected = sel) }
.updTable = function(data, selection) {
   click = NULL
   .makeScript = function(info) {
       if (is.null(info$event)) return (NULL)
       tgt = info$event
       if (!is.null(info$target)) tgt = info$target
       click = paste0("function(rowInfo, colInfo) {"
#                      ,"window.alert('Details for row ' + rowInfo.index + ':\\n' + JSON.stringify(rowInfo.row, null, 2));"
                      ,"yataTableclick (rowInfo, colInfo, '", info$event, "', '", tgt, "');"
                      ,"}")

       click
   }
   df      = data$df
   info    = data$info
   columns = df$columns

   colnames(df) = titleCase(colnames(df))
    if (!is.null(info)) click = .makeScript(info)
    df  = .yataSetClasses(df, info$types)
    df  = .adjustValues(df)
    cols = .formatColumns(df, columns)

    buttons = NULL
    # Botones
    if (!is.null(info$buttons) && length(info$buttons) > 0) {
        buttons = lapply(info$buttons, function(btn) {
                         do.call(colDef, list( name = "", sortable = FALSE
                                              ,width = 48
                                              ,style=list(`text-align` = "center")
                                              ,cell = function() btn))
        })
        if (is.null(names(info$buttons))) {
            btnNames = c(paste0("Button", seq(1, length(info$buttons))))
        } else {
            btnNames = names(info$buttons)
        }
        names(buttons) = btnNames
        dfNames = colnames(df)
        for (i in 1:length(buttons)) df = cbind(df, NA)

        colnames(df) = c(dfNames, btnNames)
    }
    if (length(cols) >  0 && length(buttons) > 0) cols = list.merge(cols, buttons)
    if (length(cols) == 0 && length(buttons) > 0) cols = buttons
    reactable(df, striped = TRUE, compact=TRUE
                                  , pagination=FALSE
                                  , selection = selection
                                  , wrap = FALSE
                                  , onClick = JS(click)
                                  , columns = cols
    )
}


###############################################################
# REVISAR

.updTableButtons = function(df, buttons) {
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
.getOptions = function(df, ...) {
    args = list(...)
    opts = list(
       searching = FALSE
      ,paging = FALSE
    )

    if (length(args) == 0) return (opts)
    if (length(args) == 1 && is.list(args[[1]])) args = args[[1]]

    if (!is.null(args$page)) {
        opts$pageLength = args$page[[1]]
        opts$paging = TRUE
    }
    # opts$searching = args$search # ifelse(is.null(args$search), FALSE, TRUE)

    if (!is.null(args$noSort)) {
        colDefs = lapply(seq(1:ncol(df)), function(x) NULL)
        for (col in args$noSort) colDefs[[col]] = list(orderable=FALSE)
        opts$columns=colDefs
    }
    opts
}

#################################################################
yuiTablePosition = function(id, dfbase, dfAux, ...) {
    df = dfbase
    df$value = dfbase$price * dfbase$balance
    yataDataTableFormat({df}, style='auto', type="position")
}


yuiRenderTable = function(df, type, buttons=NULL, ...) {
    data = .yuiRenderTableBase(df, buttons)
    if (is.null(data)) return (NULL)

    opts = .getOptions(data, ...)
    #DT::renderDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', options=opts)
    yataDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', type="gral", options=opts)
}
yuiRenderTablePaged = function(df, type, page=15, buttons=NULL, ...) {
    data = .yataRenderTableBase(df, buttons)
    if (is.null(data)) return (NULL)
    opts = .getOptions(data, ...)
    opts$paging = TRUE
    opts$pageLength = page
#    renderDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', options=opts)
#    .yatarenderDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', type="juan", options=opts)
    yataDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', type="gral", options=opts)
}
.yuiRenderTableBase = function(df, buttons=NULL) {
    if (is.null(df)) return (NULL)
    data = df

    if (!is.null(buttons) && nrow(df) > 0) {
        cols = ncol(df)
        code = lapply(strsplit(buttons, "__"), function(x) paste0(x[[1]], seq(1,nrow(df)), x[[2]]))
        dfb = as.data.frame(code)
        colnames(dfb) = paste0("col", seq(1,ncol(dfb)))
        dfb = tidyr::unite(dfb, "btn", colnames(dfb), sep=" ", remove=TRUE)
        colnames(dfb) = ""
        data = cbind(df, dfb)
    }
    colnames(data) = titleCase(colnames(data))
    data
}
.getOptions = function(df, ...) {
    args = list(...)
    opts = list(
       searching = FALSE
      ,paging = FALSE
    )

    if (length(args) == 0) return (opts)
    if (length(args) == 1 && is.list(args[[1]])) args = args[[1]]

    if (!is.null(args$page)) {
        opts$pageLength = args$page[[1]]
        opts$paging = TRUE
    }
    # opts$searching = args$search # ifelse(is.null(args$search), FALSE, TRUE)

    if (!is.null(args$noSort)) {
        colDefs = lapply(seq(1:ncol(df)), function(x) NULL)
        for (col in args$noSort) colDefs[[col]] = list(orderable=FALSE)
        opts$columns=colDefs
    }
    opts
}

#####################################################
### Tables                                        ###
#####################################################

# updTablePosition = function(df, ...) {
#     if (is.null(df)) return (NULL)
#     colnames(df) = titleCase(colnames(df))
#     yataDataTable({df}, type="position")
# }

# updTableOperations = function(df, buttons=NULL, ...) {
#   yataDTButtons
#    if (!is.null(buttons)) df = .updTableButtons(df, buttons)
#    colnames(df) = titleCase(colnames(df))
#
#    dt =  yataDT({df}, type="operation")
#    # dt = dt %>%  YATADT::formatStyle("Value", color = DT::styleInterval(cuts=c(-Inf,0,+Inf)
#    #                         , values=c("red","black","green","green")))
#
#    if ("Balance" %in% colnames(df)) {
#         dt = dt %>%  YATADT::formatStyle("Balance",
#                              color = DT::styleInterval( cuts=c(-Inf,0,+Inf)
#                                                        ,values=c("red","red","green","green")))
#    }
#
#    yataDTRender(dt)
# }
updTableBest = function(df) {
    colnames(df) = titleCase(colnames(df))
    dt = yataDT({df}, type="best", selection="single")
    dt = YATADT::formatStyle(dt, colnames(df)[3:6], color = DT::styleInterval(cuts=c(-Inf,0,+Inf)
                            , values=c("red","darkred","darkgreen","green")))
    yataDTRender(dt)
  #  yataDataTable({df}, type="best", selection="single")
}


.yataGetClasses = function() {
   c( "text"  , "label"
     ,"number", "integer", "percentage", "amount"
     ,"date"  , "time"   , "tms" )
}
.yataSetClasses = function(df, types) {
    # pvl es porcentaje impreso: 23,45%
    # prc es porcentaje real   : 0,2345
    cc = list(imp=c(), pvl = c(), prc = c(), tms=c(), int=c(), lbl=c(), dat=c(), tim=c(), btn=c())
    if (!is.null(types)) cc = list.merge(cc, types)

    if (is.character(cc$imp)) cc$imp = which(colnames(df) %in% cc$imp)
    if (is.character(cc$prc)) cc$prc = which(colnames(df) %in% cc$prc)
    if (is.character(cc$pvl)) cc$pvl = which(colnames(df) %in% cc$pvl)
    if (is.character(cc$tms)) cc$tms = which(colnames(df) %in% cc$tms)
    if (is.character(cc$int)) cc$int = which(colnames(df) %in% cc$int)
    if (is.character(cc$lbl)) cc$lbl = which(colnames(df) %in% cc$lbl)
    if (is.character(cc$dat)) cc$dat = which(colnames(df) %in% cc$dat)
    if (is.character(cc$tim)) cc$tim = which(colnames(df) %in% cc$tim)
    if (is.character(cc$btn)) cc$btn = which(colnames(df) %in% cc$btn)
    for (idx in 1:ncol(df)) {
        cls = class(df[,idx])
        if (idx %in% cc$pvl)      { class(df[,idx]) = c(cls, "type_percentage"); df[,idx] = df[,idx] / 100; next}
        if (idx %in% cc$prc)      { class(df[,idx]) = c(cls, "type_percentage"); next}
        if (idx %in% cc$tms)      { class(df[,idx]) = c(cls, "type_tms");        next}
        if (idx %in% cc$int)      { class(df[,idx]) = c(cls, "type_integer");    next}
        if (idx %in% cc$imp)      { class(df[,idx]) = c(cls, "type_price");      next}
        if (idx %in% cc$lbl)      { class(df[,idx]) = c(cls, "type_label");      next}
        if (idx %in% cc$dat)      { class(df[,idx]) = c(cls, "type_date");       next}
        if (idx %in% cc$tim)      { class(df[,idx]) = c(cls, "type_time");       next}
        if (idx %in% cc$btn)      { class(df[,idx]) = c(cls, "type_button");     next}
        if ("numeric"   %in% cls) { class(df[,idx]) = c(cls, "type_number");     next}
        if ("character" %in% cls)   class(df[,idx]) = c(cls, "type_text")
    }
    df
}

.colorize = function(df, columns) {

    for (idx in 1:ncol(df)) {
         if (class(df[,idx]) %in% "type_percentage") {

         }
    }
}

.formatColumns = function(df, columns) {
   fmt = list()
   if (!is.null(columns)) fmt = columns

    for (idx in 1:ncol(df)) {
         item = list()
         if ( "type_percentage" %in% class(df[,idx])) {
              item$format = colFormat(percent=TRUE, separators = TRUE, digits=YATAWEBDEF$scale,locales = "es-ES")
              item$style = function(value) {
                   if (value > 0) color = "#008000" else if (value < 0) color = "#e00000"  else color <- "#777"
                   bold = ifelse (abs(value) > 0.02, "bold", "normal")
                   list(color = color, fontWeight = bold)
              }

         }
         if ( "type_price" %in% class(df[,idx])) {
              item$format = colFormat(separators = TRUE, locales = "es-ES")
         }
         colname = colnames(df)[idx]
         if (!is.null(fmt[[colname]]) && length(fmt[[colname]]) > 0) {
             if (length(item) > 0) fmt[[colname]] = list.merge(item, fmt[[colname]])
         } else {
             if (length(item) > 0) {
                 item$name = colname
                 fmt[[colname]] = item
             }
         }
    }
    lapply(fmt, function(item) do.call(colDef, item))
}
.adjustValues = function (df) {
    if (nrow(df) > 0) {
        for (row in 1:nrow(df)) {
             for (idx in 1:ncol(df)) {
                  if ("type_price" %in% class(df[,idx])) {
                      df[row,idx] = ifelse(df[row,idx] > 999                     , round(df[row,idx],0), df[row,idx])
                      df[row,idx] = ifelse(df[row,idx] > 99 && df[row,idx] < 1000, round(df[row,idx],2), df[row,idx])
                      df[row,idx] = ifelse(df[row,idx] > 1  && df[row,idx] <  100, round(df[row,idx],3), df[row,idx])
                      df[row,idx] = ifelse(df[row,idx] < 1                       , round(df[row,idx],6), df[row,idx])
                  }
             }
        }
    }
    df
}
