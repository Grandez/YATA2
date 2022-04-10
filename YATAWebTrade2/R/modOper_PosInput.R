modOperPosInput = function(id, title="") {
    ns = NS(id)
    noOpen   = WEB$getMsg("OPER.OPEN.NONE")
    noAccept = WEB$getMsg("OPER.ACCEPT.NONE")
    noExec   = WEB$getMsg("OPER.EXECUTE.NONE")
    boxOpen  = WEB$getMsg("BOX.OPER.OPEN")
    boxPend  = WEB$getMsg("BOX.OPER.PEND")
    boxExec  = WEB$getMsg("BOX.OPER.EXEC")
    blocks = c("Plot" = "plotOpen", "Data"="data", "None"="none")
    left = tagList(
         fluidRow(column(4, "Up"),   column(8, guiCombo(ns("cboUp"), choices=blocks, selected="plot")))
        ,fluidRow(column(4, "Down"), column(8, guiCombo(ns("cboDown"), choices=blocks, selected="data")))
    )

    main = tagList(
      tags$div(id=ns("plot"), yuiPlot(ns("plotOpen")))
#      fluidRow(id=ns("block_1")), fluidRow(id=ns("block_2"))
      #    ,guiBlocks(ns("blocks")
      #     ,tags$div(id=ns("data"), style="width: 100%;"
                   ,tags$div(style="width: 100%;", guiBox(ns("opOpen"), boxOpen,
                     # yuiDataTable(ns("tblOpen"))
                            yuiTable(ns("tblOpen"))
                           ,hidden(tags$span(id=ns("noOpen"), noOpen))
                   ))
                   ,hidden(fluidRow(id=ns("divPend")
                             ,column(6, guiBox(ns("opPending"),  boxPend,
                                                yuiTable(ns("tblPending"))
                                               ,hidden(tags$span(id=ns("noPending"), noAccept))
                                        )
                                    )
                             ,column(6, guiBox( ns("opAccepted"), boxExec
                                               ,yuiTable(ns("tblAccepted"))
                                               ,hidden(tags$span(id=ns("noAccepted"), noExec))
                                        )
                              )
                         )
                     )
                   ,hidden(tags$div(id=ns("nodata"), h2("No hay operaciones pendientes")))
      )
    list(left=left, main=main, right=NULL)
}
