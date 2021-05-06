.YATATabCreate = function(tabset, title, id) {
    evt1  = paste0("Shiny.setInputValue('", tabset, "Close', '", id, "');")
    evt2  = paste0("Shiny.setInputValue('", tabset, "Click', '", id, "');")

    tags$span(id = paste0(tabset, id), class="yata_tabset_item"
              , tags$span(class="fas fa-times",onclick=evt1)
              , tags$span(title, onclick=evt2))
}
YATATab = function(title, id) {
   if (missing(id)) id = title
   list(id=id, title=title)
}
YATATabRemove = function(panel, item) {
   stmt = paste0("const source = document.getElementById('", panel, "');\n")
   stmt = paste0(stmt,"const target = document.getElementById('", panel, item, "');\n")
   stmt = paste0(stmt,"source.removeChild(target);")
   shinyjs::runjs(stmt)
}
YATATabAppend = function(panel, title, id) {
    tab = YATATab(title, id)
    span = .YATATabCreate(panel, tab$title, tab$id)
    shiny::insertUI(paste0("#", panel), where="beforeEnd", span, immediate=TRUE)
}

YATATabPanel = function(id, ...) {
    div = tags$div(id=id, class="yata_tabset")
    items = lapply(list(...), function(x) .YATATabCreate(id, x$title, x$id))
    tagAppendChildren(div, tagList(items))
}
YATATabsetPanel = function(tabset, subtabset) {
    # A lo bruto
    # for (idx in length(tabset$children[[1]]):1) tabset$children[[1]][[i+1]] = tabset$children[[1]][[i]]
    # tabset$children[[1]][[1]] = subtabset
    # tt = tabset$children[[1]]
    # idx = length(tt) + 1
    # tt[[idx]] = subtabset
    tabset$children[[1]] = tagAppendChild(tabset$children[[1]], subtabset)
#    tabset$children[[1]] = tt
    tabset
}
