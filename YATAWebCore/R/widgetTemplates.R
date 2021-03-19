# PAra los form habra que cambiar
yuiYesNo = function(id=ns("tag"), lblOK, lblKO, cols=4, left=0) {
    toks = strsplit(id, "-")[[1]]
    toks = paste(toks[1:(length(toks)- 1)], collapse="-")
    lcol = ifelse (left==0,  floor((12 - cols) / 2), left)
    if (missing(lblOK)) lblOK = "Aceptar"
    if (missing(lblKO)) lblKO = "Cancelar"
    divMsg = tags$div(class="row"
                      ,tags$div(class=paste0("col-lg-", lcol))
                      ,tags$div( id=paste(toks, "msg", sep="-")
                                ,class=paste0("col-lg-", cols), tags$span(id=paste0(toks, "-msg_dat"), "")))

    divBtns = tags$div(class="row"
                       ,tags$div(class=paste0("col-lg-", lcol))
                       ,tags$div(class=paste0("col-lg-", cols), style="display: flex; justify-content: space-around;"
                                 ,tags$div(yuiBtnOK(paste(toks, "btnOK", sep="-"), lblOK))
                                 ,tags$div(yuiBtnKO(paste(toks, "btnKO", sep="-"), lblKO))
                       )
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
