modLineServer <- function(id, full) {
   ns = NS(id)
   df1 = data.frame(tms=seq.Date(as.Date("2020-01-01"), as.Date("2020-01-31"), by="days")
                    ,EUR=runif(n=31, min=200, max=500)
                    ,BTC=runif(n=31, min=20000, max=50000)   
                    ,ETH=runif(n=31, min=2000, max=6000)
                    ,BCH=runif(n=31, min=500, max=3000)   
      )
   moduleServer(id, function(input, output, session) {
          output$plotLine01 = renderPlotly({pltLines(df1[,1:2])})
          output$plotLine02 = renderPlotly({pltLines(df1[,1:2], options=list(markers=TRUE))})
          output$plotLine03 = renderPlotly({pltLines(df1[,1:2], options=list(title="Plot con titulo"))})
          
          output$plotLine11 = renderPlotly({pltLines(df1[,1:3])})
          output$plotLine12 = renderPlotly({pltLines(df1[,1:4], options=list(markers=TRUE))})
          output$plotLine13 = renderPlotly({pltLines(df1[,1:5], options=list(title="Plot con titulo"))})
          
  })
}    
