yataPageTitle = function(title) {
  tags$div(class="yata-title", tags$p(title))
}
yataTitle = function(txt) {
  div(class="yata-title", txt)
}
# Componente que muestra una lista de opciones en modo tabla
# Pone un columna de error
yataFormTable = function(...) {
  d = tags$div(class="yataCentered")
  tbl = tags$table(class="yataForm")
  rows = lapply(list(...), function(item) {
                row = tags$tr()
                items = lapply(item, function(col) tags$td(col))
                #cellMsg = tags$td()
                tagAppendChildren(row, items) #list.append(items, cellMsg))
               })
  tagAppendChild(d,tagAppendChildren(tbl, rows))
}

yataRowButtons = function(...) { div(class="yata-row-buttons", ...) }



yataTblButton = function(id, table, label, btn) {
   clk = paste0("onclick='Shiny.setInputValue(\"", id, "-btnTable", titleCase(table), "\","
                                              ,"\"", label, "-__\")'")
   data = as.character(btn)
   res = regexpr(">", data, fixed=TRUE)
   base = substr(data, 1, res[1] - 1)
   paste(base, clk, substr(data, res[1], 10000L))
}



.yataNumberFormat = function(value, text,bold,color) {
  cls = "yata_num"
  if (bold) cls = paste(cls, "yata_num_bold")
  if (color) {
     col = if(value > 0) cls = paste(cls, "yata_num_pos")
     col = if(value < 0) cls = paste(cls, "yata_num_neg")
  }
  paste0("<span class='", cls, "'>",text,"</span>")
}

yataTextNumeric   = function(value, dec=-1, bold=TRUE, color=FALSE) {
  text = format(value, big.mark = ".", decimal.mark=",")
  if (dec > -1) text = format(value, big.mark = ".", decimal.mark=",", nsmall=dec)
  .yataNumberFormat(value, text,bold, color)
}
yataTextPercent   = function(value, bold=TRUE, color=FALSE) {
  text = format(value, big.mark = ".", decimal.mark=",", nsmall=2)
  .yataNumberFormat(value, text,bold, color)
}

yataLabel = function(text) { tags$span(text) }
yataLabelNumeric = function(value, dec=-1) { tags$span(style="text-align: right", yataTextNumeric(value,dec)) }
# yataIcon = function(code) {
#    code = toupper(code)
#    lst = list(src = normalizePath(system.file(paste0("extdata/icons/", code, ".png"), package="YATAWebCore")), alt="Icono de la moneda", contentType = "image/png")
#    renderImage({lst}, deleteFile = FALSE)
# }

yataCtcServer = function(id, monitor, init=TRUE) {
  repDiv = function (id, id2, ...) {
     removeUI(selector = paste0("#", id, id2), immediate=TRUE)
     insertUI(selector = paste0("#", id), where = "beforeEnd", immediate=TRUE, ui=tagList(...))
  }
  getClass = function(value) {
     cls = "yataDeltaNone"
     if (value > 0) cls = "yataDeltaUp"
     if (value < 0) cls =" yataDeltaDown"
      cls
  }

   cls = "yataDeltaNone"

   # Precio
   id0 =  paste0(id, "-price")
   id1 = "-value"
   id2 = paste0(id0, "-delta")
   id3 = "-delta-value"

   if (init) repDiv(id0, id1, tags$p(id=paste0(id0, id1), class=cls, number2string(monitor$price, 2)))

   delta = (monitor$current / monitor$price) - 1
   ic = tags$span(yataIconDown())
   if (delta > 0) ic = tags$span(yataIconUp())
   if (delta < 0) ic = tags$span(yataIconDown())

   repDiv(id2, id1, ic, tags$span(tags$p(id=paste0(id2, id1), class=getClass(delta), number2percentage(delta))))

   # Session
   id0 =  paste0(id, "-session")
   if (init) repDiv(id0, id1, ic, tags$p(id=paste0(id0, id1), number2string(monitor$session, 2)))

   delta =  (monitor$current / monitor$session) - 1
   repDiv(id0, id1, ic, tags$span(tags$p(id=paste0(id0, id3), class=getClass(delta), number2percentage(delta))))

   # Last
   id0 =  paste0(id, "-last")

   delta = monitor$last - monitor$current
   repDiv(id0, id1, ic, tags$span(tags$p(id=paste0(id0, id1), class=getClass(delta), number2string(monitor$current))))
}

yataIconUp = function() {
  icon("caret-up", "fa-4x yataUp")
}
yataIconDown = function() {
  icon("caret-down", "fa-4x yataDown")
}
yataFormHeader = function(title=NULL, type="primary") {
  tags$div(class=paste0("yata-form-header yata-", type), h3(title))
}
