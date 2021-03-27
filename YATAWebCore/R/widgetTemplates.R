yuiBlock = function(id, row=1, cols=2, ...) {
  size = ifelse(12 / cols == 12, "", paste0("col-lg-", 12/cols))
  ui = list(...)
  idGrp = paste(id, "block", row, sep="_")
  divGroup = tags$div(id=idGrp, style="display: flex;")
  for (idx in 1:cols) {
       idBlk = paste(idGrp, idx, sep="_")
       divBlock = tags$div(id=idBlk, class=size)
       divContent = tags$div(id=paste(idBlk, "content", sep="_"))
       if (length(ui) >= idx) divContent = tagAppendChildren(divContent, ui[[idx]])
       divGroup = tagAppendChild(divGroup, tagAppendChild(divBlock, divContent))
  }
  divGroup
}

updBlock = function(id, row, col, ui) {
  parent   = paste0(id, "_block_", row, "_", col)
  parentID = paste0("#", parent)
  dat      = paste0(parent, "_content")
  datID    = paste0("#", dat)

  removeUI(datID, immediate = TRUE)
  insertUI(parentID,"afterBegin", tags$div(id=dat), immediate=TRUE)
  insertUI(datID,   "afterBegin", ui, immediate=TRUE)
}

yuiYesNo = function(id=ns("tag"), lblOK, lblKO){ # , cols=4, left=0) {
    toks = strsplit(id, "-")[[1]]
    toks = paste(toks[1:(length(toks)- 1)], collapse="-")
#    lcol = ifelse (left==0,  floor((12 - cols) / 2), left)#
    if (missing(lblOK)) lblOK = "Aceptar"
    if (missing(lblKO)) lblKO = "Cancelar"
    divMsg = tags$div(class="row",tags$div( id=paste(toks, "msg", sep="-"),tags$span(id=paste0(toks, "-msg_dat"), "")))

    # divMsg = tags$div(class="row"
    #                   ,tags$div(class=paste0("col-lg-", lcol))
    #                   ,tags$div( id=paste(toks, "msg", sep="-")
    #                             ,class=paste0("col-lg-", cols), tags$span(id=paste0(toks, "-msg_dat"), "")))

    divBtns = tags$div(class="row yata_buttons"
                      ,tags$div(yuiBtnOK(paste(toks, "btnOK", sep="-"), lblOK))
                      ,tags$div(yuiBtnKO(paste(toks, "btnKO", sep="-"), lblKO))
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
