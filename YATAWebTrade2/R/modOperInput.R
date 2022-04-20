modOperInput = function(id) {
    ns = NS(id)
    lbl = WEB$getLabelsMenuOper()
    main = tagList(
       shiny::tabsetPanel(id=ns("mnuOper")
         ,shiny::tabPanel(lbl$POSITION,   value=ns("pos"),  YATAModule(ns("pos")))
         ,shiny::tabPanel(lbl$OPER,       value=ns("mov"),  YATAModule(ns("mov")))
         # ,tabPanel(lbl$XFER,       value=ns("xfer"), YATAWebShiny::JGGModule(ns("xfer")))
         # ,tabPanel(lbl$REGULARIZE, value=ns("reg"),  YATAWebShiny::JGGModule(ns("reg")))
         # ,tabPanel(lbl$HISTORY,    value=ns("hist"), YATAWebShiny::JGGModule(ns("hist")))
         #
         # ,tabPanel("cerrada",     value=ns("detail"),   tags$div(id=ns("detail"), YATAWebShiny::JGGModule(ns("detail"))))
         # ,tabPanel("",   value="detail",    YATAWebShiny::JGGModule(ns("detail")))
#         ,YATAPanel("",   value=ns("dummy"),     "")
      )

    )
    list(left=NULL, main=main, right=NULL)
}
