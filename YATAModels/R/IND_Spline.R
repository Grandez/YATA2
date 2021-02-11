library(R6)
IND_Spline <- R6Class("IND_Spline", inherit=YATAIndicator,
   public = list(
        name="Linear trend"
       ,symbolBase="MA"
       ,symbol="MA"
       #' @description Calculate the best spline line for the data
       #' @param data    Values to spline
       #' @param ind     Not used
       #' @param columns Not used
       ,Spline = function(data=NULL, ind=NULL, columns=NULL) {
           res1 = supsmu(data$df[,data$ORDER], data$df[,data$PRICE])
           res2 = supsmu(data$df[,data$ORDER], data$df[,data$VOLUME])
           list(list(res1[["y"]]), list(res2[["y"]]))
       }

       ,initialize         = function(parms=NULL,thres=NULL) { super$initialize(parms,thres) }
    )
    ,private = list(

    )
)


