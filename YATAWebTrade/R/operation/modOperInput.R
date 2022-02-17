modOperInput = function(id, title) {
    ns = NS(id)
    main = tagList(
       tabsetPanel(id=ns("pnlOpType")
         ,tabPanel("Posicion",    value=ns("pos"),   YATAModule(ns("pos")))
         ,tabPanel("Operar",      value=ns("oper"),  YATAModule(ns("oper")))
         ,tabPanel("Transferir",  value=ns("xfer"),  YATAModule(ns("xfer")))
         ,tabPanel("Regularizar", value=ns("reg"),   YATAModule(ns("reg")))
         ,tabPanel("cerrada",     value=ns("detail"),   tags$div(id=ns("detail"), YATAModule(ns("detail"))))
         # ,tabPanel("",   value="detail",    YATAModule(ns("detail")))
         ,tabPanel("",   value=ns("dummy"),     "")
      )

    )
    list(left=NULL, main=main, right=NULL)        
}