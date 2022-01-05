source("R/IND_MA.R")


IND_SMA.1 <- R6Class("IND_SMA.1", inherit=IND_MA,
   public = list(
         name="Media movil Threshold"
        ,symbol="SMAT"
   )
   ,private = list(
        .parameters = list(range=7)
       ,.thresholds = list(buy=3.0,sell=3.0)
    )

)


