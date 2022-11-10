modTestInput = function(id) {
   ns = NS(id)
   main = tagList(h2("Pagina de test"))
   list(left=NULL, main=main, right=NULL)
}

# modPosInput = function(id) {
#     ns = NS(id)
#    left = tagList(
#          br()
#         ,yuiTitle(5, "Show")
#         ,fluidRow(column(4, "Plot"),column(8, style="text-align: right;", guiCheck(ns("chkPlot"))))
#         ,fluidRow(column(4, "Open"),column(8, style="text-align: right;", guiCheck(ns("chkPos"))))
#         ,fluidRow(column(4, "Full"),column(8, style="text-align: right;", guiCheck(ns("chkFull"))))
#         ,fluidRow(column(4, "Include FIAT"),column(8, style="text-align: right;", guiCheck(ns("chkFiat"))))
#    )
#     main = tagList(
#         h2("Pagina")
#        ,tags$div( id=ns("blkPlot"),style="width: 100%", guiBox(ns("Plot")
#                       ,guiLabelText(ns("lblPlot")), yuiTable(ns("tblPlot"))))
#
#             ,tags$div( id=ns("blkGlobal"),style="width: 100%", guiBox(ns("Global")
#                       ,guiLabelText(ns("lblGlobal")), yuiTable(ns("tblGlobal"))))
#
#
# #        shiny::tabsetPanel(id=ns("mnuOper")
# #          ,shiny::tabPanel(lbl$POSITION,   value=ns("pos"),  YATAModule(ns("pos")))
# #          ,shiny::tabPanel(lbl$OPER,       value=ns("mov"),  YATAModule(ns("mov")))
# #          ,shiny::tabPanel(lbl$XFER,       value=ns("xfer"), YATAModule(ns("xfer")))
# #          ,shiny::tabPanel(lbl$REGULARIZE, value=ns("reg"),  YATAModule(ns("reg")))
# #          ,shiny::tabPanel(lbl$HISTORY,    value=ns("hist"), YATAModule(ns("hist")))
# #          #
# #          # ,tabPanel("cerrada",     value=ns("detail"),   tags$div(id=ns("detail"), YATAWebShiny::JGGModule(ns("detail"))))
# #          # ,tabPanel("",   value="detail",    YATAWebShiny::JGGModule(ns("detail")))
# # #         ,YATAPanel("",   value=ns("dummy"),     "")
# #       )
#
#     )
#     list(left=left, main=main, right=NULL)
# }
