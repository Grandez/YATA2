modOperPosInput = function (id) {
   ns = NS(id)
   main = tagList(h2("Posicion"))
   list(left=NULL, main=main, right=NULL)
}

# modOperPosInput = function(id, title="") {
#     ns = NS(id)
#     lbl = WEB$getLabelsMenuOper(cached=TRUE)
#     blocks = c("Plot" = "plotOpen", "Data"="data", "None"="none")
#     left = tagList(
#          fluidRow(column(4, "Up"),   column(8, guiCombo(ns("cboUp"), choices=blocks, selected="plot")))
#         ,fluidRow(column(4, "Down"), column(8, guiCombo(ns("cboDown"), choices=blocks, selected="data")))
#     )
#
#     main = tagList(
#       tags$div(id=ns("plot"), yuiPlot(ns("plotOpen")))
# #      fluidRow(id=ns("block_1")), fluidRow(id=ns("block_2"))
#       #    ,guiBlocks(ns("blocks")
#       #     ,tags$div(id=ns("data"), style="width: 100%;"
#                    ,tags$div(style="width: 100%;", guiBox(ns("opOpen"), lbl$OPER_OPEN,
#                      # yuiDataTable(ns("tblOpen"))
#                             yuiTable(ns("tblOpen"))
#                            ,hidden(tags$span(id=ns("noOpen"), lbl$OPEN_NONE))
#                    ))
#                    ,hidden(fluidRow(id=ns("divPend")
#                              ,column(6, guiBox(ns("opPending"),  lbl$OPER_PEND,
#                                                 yuiTable(ns("tblPending"))
#                                                ,hidden(tags$span(id=ns("noPending"), lbl$ACCEPT_NONE))
#                                         )
#                                     )
#                              ,column(6, guiBox( ns("opAccepted"), lbl$OPER_EXEC
#                                                ,yuiTable(ns("tblAccepted"))
#                                                ,hidden(tags$span(id=ns("noAccepted"), lbl$EXEC_NONE))
#                                         )
#                               )
#                          )
#                      )
#                    ,hidden(tags$div(id=ns("nodata"), h2(lbl$NO_OPER)))
#       )
#     list(left=left, main=main, right=NULL)
# }
