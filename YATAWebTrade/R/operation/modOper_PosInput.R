

modOperPosInput = function(id, title) {
    ns = NS(id)
    noOpen   = YATAWEB$getMsg("OPER.OPEN.NONE")
    noAccept = YATAWEB$getMsg("OPER.ACCEPT.NONE")
    noExec   = YATAWEB$getMsg("OPER.EXECUTE.NONE")
    boxOpen  = YATAWEB$getMsg("BOX.OPER.OPEN")
    boxPend  = YATAWEB$getMsg("BOX.OPER.PEND")
    boxExec  = YATAWEB$getMsg("BOX.OPER.EXEC")
    blocks = c("Plot" = "plotOpen", "Data"="data", "None"="none")
    left = tagList(
         fluidRow(column(4, "Up"),   column(8, yuiCombo(ns("cboUp"), choices=blocks, selected="plot")))
        ,fluidRow(column(4, "Down"), column(8, yuiCombo(ns("cboDown"), choices=blocks, selected="data")))
    )

    main = tagList(
      tags$div(id=ns("plot"), yuiPlot(ns("plotOpen")))
#      fluidRow(id=ns("block_1")), fluidRow(id=ns("block_2"))
      #    ,yuiBlocks(ns("blocks")
      #     ,tags$div(id=ns("data"), style="width: 100%;"
                   ,tags$div(style="width: 100%;", yuiBox(ns("opOpen"), boxOpen,  
                     # yuiDataTable(ns("tblOpen"))
                            yuiTable(ns("tblOpen"))
                           ,hidden(tags$span(id=ns("noOpen"), noOpen))
                   ))
                   ,hidden(fluidRow(id=ns("divPend")
                             ,column(6, yuiBox(ns("opPending"),  boxPend,
                                                yuiDataTable(ns("tblPending"))
                                               ,hidden(tags$span(id=ns("noPending"), noAccept))
                                        )
                                    )
                             ,column(6, yuiBox( ns("opAccepted"), boxExec
                                               ,yuiDataTable(ns("tblAccepted"))
                                               ,hidden(tags$span(id=ns("noAccepted"), noExec))
                                        )
                              )
                         )
                     )
                   ,hidden(tags$div(id=ns("nodata"), h2("No hay operaciones pendientes")))
      )
    list(left=left, main=main, right=NULL)
}


