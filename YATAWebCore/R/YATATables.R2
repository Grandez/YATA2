yataTablePosition = function(id, dfbase, dfAux, ...) {
  browser()
    df = dfbase
    df$value = dfbase$price * dfbase$balance
    yataDataTable({df}, rownames=FALSE, escape=FALSE, style='auto', type="gral")

}
yataRenderTable = function(df, type, buttons=NULL, ...) {
    data = .yataRenderTableBase(df, buttons)
    if (is.null(data)) return (NULL)

    opts = .getOptions(data, ...)
    #DT::renderDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', options=opts)
    yataDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', type="gral", options=opts)
}
yataRenderTablePaged = function(df, type, page=15, buttons=NULL, ...) {
    data = .yataRenderTableBase(df, buttons)
    if (is.null(data)) return (NULL)
    opts = .getOptions(data, ...)
    opts$paging = TRUE
    opts$pageLength = page
#    renderDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', options=opts)
#    .yatarenderDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', type="juan", options=opts)
    yataDataTable({data}, rownames=FALSE, escape=FALSE, style='auto', type="gral", options=opts)
}
.yataRenderTableBase = function(df, buttons=NULL) {
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
