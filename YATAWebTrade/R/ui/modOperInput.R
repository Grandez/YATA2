modOperInput = function(id, title) {
    ns = NS(id)
    main = tagList(
       tabsetPanel(id=ns("pnlOpType")
         ,tabPanel("Posicion",   value=ns("pos"),    YATAModule(ns("pos")))
         # ,tabPanel("Abrir",      value=ns("open"),   YATAModule(ns("open")))
         # ,tabPanel("Cerrar",     value=ns("close"),  YATAModule(ns("close")))
         # ,tabPanel("Comprar",    value=ns("buy"),    YATAModule(ns("buy")))
         ,tabPanel("Operar",     value=ns("oper"),   YATAModule(ns("oper")))
         ,tabPanel("Transferir", value=ns("xfer"),   YATAModule(ns("xfer")))
         ,tabPanel("Detalle",     value=ns("detail"), YATAModule(ns("detail")))
      )
    )
    list(left=NULL, main=main, right=NULL)        
}