# Componente que muestra una lista de opciones en modo tabla
# Pone un columna de error
yuiFormTable = function(...) {
  div = tags$div(class="yataCentered")
  tbl = tags$table(class="yataForm")
  rows = lapply(list(...), function(item) {
                row = tags$tr()
                items = lapply(item, function(col) tags$td(col))
                #cellMsg = tags$td()
                tagAppendChildren(row, items) #list.append(items, cellMsg))
               })
  tagAppendChild(div,tagAppendChildren(tbl, rows))
}
