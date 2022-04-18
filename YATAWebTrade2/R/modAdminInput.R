modAdminInput = function(id, title) {
    ns = NS(id)
    main = tagList(
       YATATabsetPanel(id=ns("pnlOpType")
         ,YATAPanel(lbl$POSITION,   value=ns("pos"),  YATAWebShiny::JGGModule(ns("pos")))
         ,YATAPanel(lbl$OPER,       value=ns("mov"),  YATAWebShiny::JGGAModule(ns("mov")))
      )

    )
    list(left=NULL, main=main, right=NULL)
}
