modOperInput = function(id, title) {
    ns = NS(id)
    main = tagList(
       tabsetPanel(id=ns("pnlOpType")
         ,tabPanel(WEB$MSG$get("MNU.POSITION"),   value=ns("pos"),  YATAModule(ns("pos")))
         ,tabPanel(WEB$MSG$get("MNU.OPER"),       value=ns("mov"),  YATAModule(ns("mov")))
         ,tabPanel(WEB$MSG$get("MNU.XFER"),       value=ns("xfer"), YATAModule(ns("xfer")))
         ,tabPanel(WEB$MSG$get("MNU.REGULARIZE"), value=ns("reg"),  YATAModule(ns("reg")))
         # 
         # ,tabPanel("cerrada",     value=ns("detail"),   tags$div(id=ns("detail"), YATAModule(ns("detail"))))
         # ,tabPanel("",   value="detail",    YATAModule(ns("detail")))
         ,tabPanel("",   value=ns("dummy"),     "")
      )

    )
    list(left=NULL, main=main, right=NULL)        
}