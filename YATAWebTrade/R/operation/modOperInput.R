modOperInput = function(id, title) {
    ns = NS(id)
    main = tagList(
       tabsetPanel(id=ns("pnlOpType")
         ,tabPanel("Posicion",   value=ns("pos"),    YATAModule(ns("pos")))
         ,tabPanel("Operar",      value=ns("oper"),   YATAModule(ns("oper")))
         ,tabPanel("Transferir",  value=ns("xfer"),   YATAModule(ns("xfer")))
#         ,tabPanel("Historia",    value=ns("hist"),   YATAModule(ns("hist")))
         ,tabPanel("cerrada",            value=ns("detail"),   tags$div(id=ns("detail"), YATAModule(ns("detail"))))
#         ,tabPanel("Detalle",     value=ns("detail"), YATAModule(ns("detail")))
         ,tabPanel("",  value=ns("dummy"),"")
      )

    )
    list(left=NULL, main=main, right=NULL)        
}