modOperInput = function(id) {
    ns = NS(id)
    lbl = WEB$getLabelsMenuOper()
    main = tagList(
       shiny::tabsetPanel(id=ns("mnuOper")
         ,shiny::tabPanel(lbl$POSITION,   value=ns("pos"),  YATAUI(ns("pos")))
         ,shiny::tabPanel(lbl$OPER,       value=ns("mov"),  YATAUI(ns("mov")))
         ,shiny::tabPanel(lbl$XFER,       value=ns("xfer"), YATAUI(ns("xfer")))
         # ,shiny::tabPanel(lbl$REGULARIZE, value=ns("reg"),  YATAUI(ns("reg")))
         # ,shiny::tabPanel(lbl$HISTORY,    value=ns("hist"), YATUI(ns("hist")))
         #
         # ,tabPanel("cerrada",     value=ns("detail"),   tags$div(id=ns("detail"), YATAWebShiny::JGGModule(ns("detail"))))
         # ,tabPanel("",   value="detail",    YATAWebShiny::JGGModule(ns("detail")))
#         ,YATAPanel("",   value=ns("dummy"),     "")
      )

    )
    list(left=NULL, main=main, right=NULL)
}
