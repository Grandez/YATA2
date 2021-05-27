library(shiny)
library(ggplot2)

library(randomizeR)

Plot = R6::R6Class("MODPLOT"
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,portable   = FALSE
  ,public = list(
     plot = NULL
    ,alfa = NULL
    ,beta = 0
    ,df   = NULL
    ,tg   = 0
    ,initialize = function(df, plot, eq) {
       self$plot = plot
       self$df = df
       self$alfa = eq$a
       self$beta = eq$b
    }
    ,getEquation = function() {
        sprintf(paste0("$$y = ", alfa, "x + ", beta, "$$"))
     }
  )

  )
Models = R6::R6Class("YATA.PANEL"
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,public = list(
     df       = NULL
    ,dfw      = NULL
    ,plots = list(NULL)
    ,equs  = list(NULL)
    ,step = 0
    ,color = NULL
    ,numplots = 6
  )
)

model = Models$new()
