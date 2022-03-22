yuiFormTable = function(...) {
   divTbl  = tags$div(class="yata_centered")
   tbl  = tags$table(class="yata_form")
   #rows = lapply(list(...), function(row) .makeRow(row))
   divTbl = tagAppendChild(divTbl,tagAppendChildren(tbl, ...))
   # if (width < 12) {
   #     left = floor((12-width)/2)
   #     if (left > 0) return (fluidRow(column(left), column(width, divTbl)))
   # }
   # fluidRow(column(width, divTbl))
   divTbl
}

yuiFormRow = function (...) {
    row = tags$tr()
    items = lapply(list(...), function(col) tags$td(col))
    tagAppendChildren(row, items) #list.append(items, cellMsg))
}

# .makeRow = function(item) {
#     browser()
#     row = tags$tr()
#     items = lapply(item, function(col) tags$td(col))
#     tagAppendChildren(row, items) #list.append(items, cellMsg))
# }
