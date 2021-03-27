modOperInput = function(id, title) {
    ns = NS(id)
    main = tagList(
       tabsetPanel(id=ns("pnlOpType")
         ,tabPanel("Posicion",   value=ns("pos"),    YATAModule(ns("pos")))
         ,tabPanel("Operar",      value=ns("oper"),   YATAModule(ns("oper")))
         ,tabPanel("Transferir",  value=ns("xfer"),   YATAModule(ns("xfer")))
         ,tabPanel("Historia",    value=ns("hist"),   YATAModule(ns("hist")))
#         ,tabPanel("Detalle",     value=ns("detail"), YATAModule(ns("detail")))
      )

    )
    list(left=NULL, main=main, right=NULL)        
}