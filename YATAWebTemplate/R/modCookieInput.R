modCookieInput = function(id, title) {
   ns = NS(id)
   # items = list(
   #      Pos     = list(label = WORD$POS,   plot=TRUE, table=TRUE)
   #     ,Session = list(label = WORD$SESS,  plot=TRUE, table=TRUE)
   #     ,Top     = list(label = WORD$TOP,   plot=TRUE, table=TRUE)
   #     ,Trend   = list(label = WORD$TREND, plot=TRUE, table=TRUE)
   #     ,Fav     = list(label = WORD$FAV,   plot=TRUE, table=TRUE)
   #     ,Full = list(label = paste(WORD$POS, WORD$FULL),  plot=TRUE, table=TRUE)
   # )
    main = tagList( h3("Panel Cookies"), verbatimTextOutput(ns("cookies")))

    list(left=NULL, main=main, right=NULL, header=NULL)
}
