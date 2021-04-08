yuiBlocks = function(id, ...) { tags$div(id=id, class="yata_blocks_container", ...) }

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
