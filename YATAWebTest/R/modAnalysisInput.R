modAnaInput = function(id, title) {
    ns = NS(id)
    left = tagList(
         guiCombo(ns("cboCounter"), choices="")
,dateRangeInput('dateRange2',
      label = paste('Date range input 2: range is limited,',
       'dd/mm/yy, language: fr, week starts on day 1 (Monday),',
       'separator is "-", start view is year'),
      start = Sys.Date() - 3, end = Sys.Date() + 3,
      min = Sys.Date() - 10, max = Sys.Date() + 10,
      separator = " - ", format = "dd/mm/yy",
      startview = 'year', language = 'fr', weekstart = 1
    )
        ,guiCombo(ns("cboPlot11"),  "Plot data1" , choices="")
        ,guiCombo(ns("cboPlot12"),  "Plot data1" , choices="")        
        ,guiCombo(ns("cboPlot21"),  "Plot data1" , choices="")        
        ,guiCombo(ns("cboPlot22"),  "Plot data1" , choices="")                
     )
    main = tagList(
       fluidRow(column(6,yuiPlot(ns("plot1"))), column(6,yuiPlot(ns("plot2"))))
      # ,fluidRow(column(8
      # ,fluidRow(id="divPosGlobal"
      #              ,yuiBox(ns("tblPosGlobal"), "Posicion Global", DT::dataTableOutput(ns("tblPosGlobal")))
      #    )
      #     ,fluidRow(id="divPosLast")
      #    )
      )
    list(left=left, main=main, right=NULL)
}
