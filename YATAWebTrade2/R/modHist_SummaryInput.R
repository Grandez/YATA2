modHistSummInput = function(id, title) {
   ns = NS(id)
   lblCurrency = WEB$msg$get("LBL.CURRENCY")
   left = tagList(
      fluidRow( column(4, WEB$msg$get("LBL.OPER"))
               ,column(8, guiCombo( ns("cboOper"), choices=WEB$combo$operations(all=TRUE))))
     ,fluidRow( column(4, WEB$msg$get("LBL.CURRENCY"))
               ,column(8, guiComboSelect(ns("cboCurrency"),choices=WEB$combo$currencies(id=FALSE),text=lblCurrency)))
     ,fluidRow( column(4, WEB$msg$get("LBL.CAMERA"))
               ,column(8, guiCombo(ns("cboCamera"), choices=WEB$combo$cameras(all=TRUE))))
     ,fluidRow( column(4, WEB$msg$get("LBL.SINCE"))
               ,column(8, dateInput(ns("dtDate"), label=NULL, value="2020-01-01")))
   )
   main = tagList(
      br()
   #   ,fluidRow( guiColumn(1)
   #            ,guiColumn(1, h4(WEB$msg$get("LBL.OPER")))
   #            ,guiColumn(1,
   #            ,guiColumn(1, h4(lblCurrency))
   #            ,guiColumn(2 ,guiComboSelect(ns("cboCurrency")
   #                         ,choices=WEB$combo$currencies(id=FALSE),text=lblCurrency))
   #
   #            ,guiColumn(1, h4(WEB$msg$get("LBL.CAMERA")))
   #            ,guiColumn(1, guiCombo(ns("cboCamera"), choices=WEB$combo$cameras(all=TRUE)))
   #            ,guiColumn(1, h4(WEB$msg$get("LBL.SINCE")))
   #            ,guiColumn(1, dateInput(ns("dtDate"), label=NULL, value="2020-01-01"))
   #
   #            #,guiColumn(1)
   # )
   ,fluidRow(yuiTable(ns("tblHistory")))
  )
  list(left=left, main=main, right=NULL)
}

# modHistSummInput = function(id, title="") {
#     ns = NS(id)
#     main = tagList(h2("Historia de operaciones")
#         ,fluidRow(column(6, yuiPlot(ns("plotRevenue"))),column(6, yuiPlot(ns("plotRank"))))
#         ,fluidRow(column(6, yuiTable(ns("tblRevenue"))))
#         # ,fluidRow(yuiBox(ns("opClosed"), "Operaciones Cerradas",   yuiDataTable(ns("tblDetClosed"))))
#         # ,fluidRow(yuiBox(ns("opExec"),   "Operaciones ejecutadas", yuiDataTable(ns("tblDetExec"))))
#     )
#     list(left=NULL, main=main, right=NULL)
# }
