modOperInput = function(id, title) {
    ns = NS(id)
    lbl = WEB$getLabelsMenuOper()
    main = tagList(
       tabsetPanel(id=ns("pnlOpType")
         ,tabPanel(lbl$POSITION,   value=ns("pos"),  YATAModule(ns("pos")))
         ,tabPanel(lbl$OPER,       value=ns("mov"),  YATAModule(ns("mov")))
         # ,tabPanel(lbl$XFER,       value=ns("xfer"), YATAModule(ns("xfer")))
         # ,tabPanel(lbl$REGULARIZE, value=ns("reg"),  YATAModule(ns("reg")))
         # ,tabPanel(lbl$HISTORY,    value=ns("hist"), YATAModule(ns("hist")))
         #
         # ,tabPanel("cerrada",     value=ns("detail"),   tags$div(id=ns("detail"), YATAModule(ns("detail"))))
         # ,tabPanel("",   value="detail",    YATAModule(ns("detail")))
         ,tabPanel("",   value=ns("dummy"),     "")
      )

    )
    list(left=NULL, main=main, right=NULL)
}
