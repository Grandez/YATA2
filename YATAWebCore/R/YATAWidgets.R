# yataPageTitle = function(title) {
#   tags$div(class="yata-title", tags$p(title))
# }
# yataTitle = function(txt) {
#   div(class="yata-title", txt)
# }
#
# yataRowButtons = function(...) { div(class="yata-row-buttons", ...) }
#
#
# yataLabel = function(text) { tags$span(text) }
# yataLabelNumeric = function(value, dec=-1) { tags$span(style="text-align: right", yataTextNumeric(value,dec)) }
# # yataIcon = function(code) {
# #    code = toupper(code)
# #    lst = list(src = normalizePath(system.file(paste0("extdata/icons/", code, ".png"), package="YATAWebCore")), alt="Icono de la moneda", contentType = "image/png")
# #    renderImage({lst}, deleteFile = FALSE)
# # }
#
# yataCtcServer = function(id, monitor, init=TRUE) {
#   repDiv = function (id, id2, ...) {
#      removeUI(selector = paste0("#", id, id2), immediate=TRUE)
#      insertUI(selector = paste0("#", id), where = "beforeEnd", immediate=TRUE, ui=tagList(...))
#   }
#   getClass = function(value) {
#      cls = "yataDeltaNone"
#      if (value > 0) cls = "yataDeltaUp"
#      if (value < 0) cls =" yataDeltaDown"
#       cls
#   }
#
#    cls = "yataDeltaNone"
#
#    # Precio
#    id0 =  paste0(id, "-price")
#    id1 = "-value"
#    id2 = paste0(id0, "-delta")
#    id3 = "-delta-value"
#
#    if (init) repDiv(id0, id1, tags$p(id=paste0(id0, id1), class=cls, number2string(monitor$price, 2)))
#
#    delta = (monitor$current / monitor$price) - 1
#    ic = tags$span(yataIconDown())
#    if (delta > 0) ic = tags$span(yataIconUp())
#    if (delta < 0) ic = tags$span(yataIconDown())
#
#    repDiv(id2, id1, ic, tags$span(tags$p(id=paste0(id2, id1), class=getClass(delta), number2percentage(delta))))
#
#    # Session
#    id0 =  paste0(id, "-session")
#    if (init) repDiv(id0, id1, ic, tags$p(id=paste0(id0, id1), number2string(monitor$session, 2)))
#
#    delta =  (monitor$current / monitor$session) - 1
#    repDiv(id0, id1, ic, tags$span(tags$p(id=paste0(id0, id3), class=getClass(delta), number2percentage(delta))))
#
#    # Last
#    id0 =  paste0(id, "-last")
#
#    delta = monitor$last - monitor$current
#    repDiv(id0, id1, ic, tags$span(tags$p(id=paste0(id0, id1), class=getClass(delta), number2string(monitor$current))))
# }
#
# yataIconUp = function() {
#   icon("caret-up", "fa-4x yataUp")
# }
# yataIconDown = function() {
#   icon("caret-down", "fa-4x yataDown")
# }
# yataFormHeader = function(title=NULL, type="primary") {
#   tags$div(class=paste0("yata-form-header yata-", type), h3(title))
# }



yuiYesNo = function(id, lblOK, lblKO, left = 0, width = 12) {
    # base es cualquier cosa, queremos mod1-mod2-....-xxx
    base = strsplit(id, "-")[[1]]
    base = base[1:length(base)-1]
    base = paste(base, collapse="-")
    if (missing(lblOK)) {
        lblOK = "OK"
        lblKO = "KO"
    }
    divs = tags$div( tags$div(class="row",guiLabelText(id=paste0(base, "-msg")))
                    ,tags$div( class="row yata_buttons"
                              ,yuiBtnOK(paste0(base, "-btnOK"), lblOK)
                              ,yuiBtnKO(paste0(base, "-btnKO"), lblKO))
    )
    if (left > 0) {
      tagList( fluidRow(yuiColumn(left), guiColumn(width, divs)))
    } else {
      tagList(tags$div(class="container-fluid", divs))
    }
}
