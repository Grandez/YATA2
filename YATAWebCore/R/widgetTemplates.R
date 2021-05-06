yuiLoading = function() { show_modal_spinner(spin="dots") }
yuiLoaded  = function() { remove_modal_spinner()          }

yuiYesNo = function(id=ns("tag"), lblOK, lblKO){ # , cols=4, left=0) {
    # el tag es para crear el nombre completo
    toks = strsplit(id, "-")[[1]]
    prfx = toks[length(toks) - 2]
    toks = paste(toks[1:(length(toks)- 1)], collapse="-")
    if (missing(lblOK)) lblOK = "Aceptar"
    if (missing(lblKO)) lblKO = "Cancelar"
    divMsg = tags$div(class="row",tags$div( id=paste0(toks, "-", prfx, "Msg")
                                           ,tags$span(id=paste0(toks, "-", prfx, "Msg"), "")))

    divBtns = tags$div(class="row yata_buttons"
                      ,tags$div(yuiBtnOK(paste0(toks, "-", prfx, "BtnOK"), lblOK))
                      ,tags$div(yuiBtnKO(paste0(toks, "-", prfx, "BtnKO"), lblKO))
              )
    tagList(tags$div(class="container-fluid", divMsg), tags$div(class="container-fluid", divBtns))
}
yuiRank = function(id,lbl=NULL) { sliderInput(id, lbl, min=-2,max=2,step=1,value=0, ticks=FALSE) }

yuiFlex = function(...) { tags$div(class="yata_flex_row", ...) }
yuiDiv = function(..., id, class) {
    browser()
   cls = ifelse(missing(class), "row", class)
   if (missing(id)) {
      res = tags$div(class=cls, ...)
   }
   else {
      res = tags$div(id = id, class=cls, ...)
   }
   res
}
# yuiLayout = function(id, rows) {
#   makerow = function(row, cols) {
#     td1 = NULL
#     td2 = NULL
#     if (cols == 1 ) {
#         td1 = tags$td(colspan="2", yuiCombo(paste0(id, row, 0)))
#     } else {
#         td1 = tags$td(class="yata_layout_left", yuiCombo(paste0(id, row, 1)))
#         td2 = tags$td(yuiCombo(paste0(id, row, 2)))
#     }
#     tags$tr(class="yata_layout_row", td1, td2)
#   }
#   names(rows) = seq(1,length(rows))
#   trs = lapply(names(rows), function(row) makerow(row, rows[row]))
#   tagList(yuiTitle(5, "Layout"), tags$table(class="yata_layout_table", trs))
# }
