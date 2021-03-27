modPosInput = function(id, title) {
    ns = NS(id)
    left = tagList(
         fluidRow(column(4, "Updated:"),column(8, yuiLabelDate(ns("dtLast"))))
        ,fluidRow(column(4, "Interval"),column(8, yuiNumericInput(ns("numInterval"))))
        ,fluidRow(column(4, "History") ,column(8, yuiNumericInput(ns("numDays"), value=15,step=1,min=7,max=60)))
        ,hr() 
        ,fluidRow(column(4, yuiTitle(5, "Monitors"))
                 ,column(8, style="text-align: right;", yuiCheck(ns("chkMonitors")))
          )
        ,hr()
        ,yuiTitle(5, "Plots")
        # ,fluidRow( column(4, yuiTitle4("Plots"))
        #           ,column(8, style="text-align: right;", yuiCheck(ns("chkPlots")))
        
        ,fluidRow(column(4, "Left"),  column(8, yuiCombo(ns("cboPlot1"))))
        ,fluidRow(column(4, "Right"), column(8, yuiCombo(ns("cboPlot2"))))
        ,hr() 
        ,yuiTitle(5, "Data")
        # ,fluidRow( column(4, yuiTitle4("Data"))
        #           ,column(8, style="text-align: right;", awesomeCheckbox(inputId = "Id045",NULL,value = TRUE)))      
        ,fluidRow(column(4, "Left"),  column(8, yuiCombo(ns("cboData1"))))
        ,fluidRow(column(4, "Right"), column(8, yuiCombo(ns("cboData2"))))
      
      ,hr() 
        ,yuiTitle(5, "Mejores")
        ,fluidRow(column(4, "Top"),      column(8, yuiIntegerInput(ns("numBestTop"),value=15,step=1,min=5,max=30)))
        ,fluidRow(column(4, "Interval"), column(8, yuiCombo(ns("cboBestFrom"), 
                                                   choices=c("Hora"=1,"Dia"=24,"Semana"=7,"Mes"=30),selected=24)))
        ,tags$br()
#        ,fluidRow(column(4),  
#                  column(8
      ,  yuiFlex(yuiBtnOK(ns("btnLayoutOK"),"Aceptar"), yuiBtnKO(ns("btnLayoutKO"),"Anular"))
    )
    main = tagList(
       yuiBlock(id, 0, 1, fluidRow(tags$div(id=ns("monitor"), class="yata_monitors")))
      ,yuiBlock(id, 1, 2, yuiPlot(ns("plot1")), yuiPlot(ns("plot2")))
      ,yuiBlock(id, 2, 2)

      #  fluidRow(column(6,yuiPlot(ns("plotLeft"))), column(6,yuiPlot(ns("plotRight"))))
      # ,fluidRow( column(6,fluidRow(id="tablesLeft", tags$div(id="dataLeft", uiOutput(ns("dl")))))
      #           ,column(6,fluidRow(id="tablesRight", uiOutput(ns("dr")))))
         #  ,fluidRow(id="divPosGlobal"
         #           ,yuiBox(ns("tblPosGlobal"), "Posicion Global", DT::dataTableOutput(ns("tblPosGlobal")))
         #    )
         #  ,fluidRow(id="divPosLast")
         # )
         # ,column(6,yuiBox(ns("boxBest"), yuiLabelText(ns("lblBest")),DT::dataTableOutput(ns("tblBest"))))
#      )
    )
    list(left=left, main=main, right=NULL)
}
