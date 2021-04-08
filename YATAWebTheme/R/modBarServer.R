modBarServer <- function(id, full, pnlParent, invalidate=FALSE) {
   ns = NS(id)
   df1 = data.frame(tms=seq.Date(as.Date("2020-01-01"), as.Date("2020-01-31"), by="days")
                    ,EUR=runif(n=31, min=200, max=500)
                    ,BTC=runif(n=31, min=20000, max=50000)   
                    ,ETH=runif(n=31, min=2000, max=6000)
                    ,BCH=runif(n=31, min=500, max=3000)   
      )
   moduleServer(id, function(input, output, session) {
          output$plotBar01 = renderPlotly({pltBars(df1[1:5,1:2])})
          output$plotBar02 = renderPlotly({pltBars(df1[1:5,1:2], options=list(markers=TRUE))})
          output$plotBar03 = renderPlotly({pltBars(df1[1:5,1:2], options=list(title="Plot con titulo"))})
          
          output$plotBar11 = renderPlotly({pltBars(df1[1:5,1:3])})
          output$plotBar12 = renderPlotly({pltBars(df1[1:5,1:4], options=list(markers=TRUE))})
          output$plotBar13 = renderPlotly({pltBars(df1[1:5,1:5], options=list(title="Plot con titulo"))})
          
  })
}    
