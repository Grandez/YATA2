modAdminInput = function(id) {
   ns = NS(id)
   lbl = WEB$getLabelsMenuAdmin()
   #main = tagList(
    main =   shiny::tabsetPanel(id=ns("mnuAdmin")
         ,YATATab(lbl$PREF,       id=ns("pref"), YATAModule(ns("pref")))
         ,YATATab(lbl$PORTFOLIO,  id=ns("portfolio"), YATAModule(ns("portfolio")))

       # YATATabsetPanel(id=ns("mnuAdmin")
       #   ,YATATab(lbl$PREF,       id=ns("pref"),       YATAModule(ns("pref")))
       #   ,YATATab(lbl$PORTFOLIO,  id=ns("portfolio"),  YATAModule(ns("portfolio")))
         # ,tabPanel(lbl$XFER,       value=ns("xfer"), YATAWebShiny::JGGModule(ns("xfer")))
         # ,tabPanel(lbl$REGULARIZE, value=ns("reg"),  YATAWebShiny::JGGModule(ns("reg")))
         # ,tabPanel(lbl$HISTORY,    value=ns("hist"), YATAWebShiny::JGGModule(ns("hist")))
         #
         # ,tabPanel("cerrada",     value=ns("detail"),   tags$div(id=ns("detail"), YATAWebShiny::JGGModule(ns("detail"))))
         # ,tabPanel("",   value="detail",    YATAWebShiny::JGGModule(ns("detail")))
#         ,YATAPanel("",   value=ns("dummy"),     "")
      )

#    )

   # main = tagList(
   #      YATATabsetPanel(
   #         YATATab(lbl$PREF,   id=ns("pref"),  JGGModule(ns("pref")))
   #        ,id=ns("mnuAdmin"))
   # )

   list(left=NULL, main=main, right=NULL)
}

