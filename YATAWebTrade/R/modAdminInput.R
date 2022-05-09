modAdminInput = function(id) {
   ns = NS(id)
   lbl = WEB$getLabelsMenuAdmin()

    main = tagList(
       shiny::tabsetPanel(id=ns("mnuAdmin")
         ,YATATab(lbl$PREF,       id=ns("pref"),      YATAModule(ns("pref")))
         ,YATATab(lbl$EXCHANGES,  id=ns("exch"),      YATAModule(ns("exch")))
         ,YATATab(lbl$PORTFOLIO,  id=ns("portfolio"), YATAModule(ns("portfolio")))
      )
    )
    list(left=NULL, main=main, right=NULL)
}

