modOperInput = function(id, title) {
    ns = NS(id)
    lbl = WEB$getLabelsMenuOper()
    main = tagList(
       tabsetPanel(id=ns("pnlOpType")
         ,tabPanel(lbl$POSITION,   value=ns("pos"),  YATAWebShiny::JGGModule(ns("pos")))
         ,tabPanel(lbl$OPER,       value=ns("mov"),  YATAWebShiny::JGGAModule(ns("mov")))
         # ,tabPanel(lbl$XFER,       value=ns("xfer"), YATAWebShiny::JGGModule(ns("xfer")))
         # ,tabPanel(lbl$REGULARIZE, value=ns("reg"),  YATAWebShiny::JGGModule(ns("reg")))
         # ,tabPanel(lbl$HISTORY,    value=ns("hist"), YATAWebShiny::JGGModule(ns("hist")))
         #
         # ,tabPanel("cerrada",     value=ns("detail"),   tags$div(id=ns("detail"), YATAWebShiny::JGGModule(ns("detail"))))
         # ,tabPanel("",   value="detail",    YATAWebShiny::JGGModule(ns("detail")))
         ,tabPanel("",   value=ns("dummy"),     "")
      )

    )
    list(left=NULL, main=main, right=NULL)
}
