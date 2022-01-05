modHistDetailInput = function(id, title="") {
   ns = NS(id)
   lblOper  = YATAWEB$getMsg("LABEL.OPER.SHOW")
   plots = YATAWEB$MSG$getBlock(DBDict$messages$plots, TRUE)
   sels = c("PLOT.SESSION", "PLOT.NONE", "PLOT.VOLUME", "PLOT.NONE")
   objLayout = OBJLayout$new(ns, c(2,2), plots, values=sels,full=FALSE)

   left = tagList( 
       objLayout$getConfig() 
      ,fluidRow(column(4, lblOper),  column(8, style="text-align: right;", yuiCheck(ns("chkOper"))))
    )
    main = tagList(
        h3(textOutput(ns("title")))
        ,yuiBox(ns("boxData"),  "", tags$div(yuiPlot(ns("plot"))))
#        ,yuiPlot(ns("plot2"), height="200px")
        ,yuiBox(ns("boxData"),  "", tags$div(yuiTable(ns("session"))))
    )
    # main = tagList(h3(textOutput(ns("title")))
    #     ,yuiPlot(ns("plot"))
    #     # ,fluidRow(column(6,yuiTable(ns("session"))), column(6, yuiTable(ns("flows"))))
    #     ,yuiTable(ns("session"))
    # )
    list(left=left, main=main, right=NULL)
}
