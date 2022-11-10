WDGTablePosition = R6::R6Class("YATA.WEB.TABLE.POS"
  ,portable   = TRUE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = WDGTable
  ,public = list(
      print = function () { message("Widget for position") }
     ,initialize = function(factory) {
         super$initialize("Position", private$table_defs, private$col_defs, private$col_groups)
#        super$initialize("Position", event="none", factory=factory, table=table_attr)
     }
    ,set    = function(data) {
        private$data = data[,names(private$col_defs)]
        invisible(self)
     }
    ,render = function(type=c("short", "long"), global=FALSE) {
        super$render()
        # type = match.arg(type)
        # headPos   = c("balance", "available", "buy", "sell", "value", "profit")
        # headDates = c("since",   "last",      "tms")
        #
        # if (nrow(df) == 0) {
        #     df = dfEmpty
        # } else {
        #     df$value = df$balance * df$net
        # }
        # if (nrow(df) > 0 && type == "short") df = df[,cols_short]
        # if (type == "long") {
        #     headBuy  = c("buy_high",  "buy_low", "buy_net")
        #     headSell = c("sell_high", "sell_low","sell_net")
        #     if (!global) {
        #         headBuy  = c(headBuy, "buy_last")
        #         headSell = c(headBuy, "sell_last")
        #     }
        #     groups = list( colGroup(name = "Posicion", columns = headPos)
        #                   ,colGroup(name = "Compra",   columns = headBuy)
        #                   ,colGroup(name = "Venta",    columns = headSell)
        #                   ,colGroup(name = "Fechas",   columns = headDates))
        #     private$table_attr$columnGroups = groups
        # }
        # #JGG No se porque, pero se pierde col_Defs
        # if (is.null(private$table_attr$columns)) private$table_attr$columns = private$col_defs
        # setTableAttributes(reactable=table_attr)
#        super_render(df)
    }
   )
  ,private = list(
       cols_short = c("currency", "balance", "net", "value", "profit", "day", "week", "month", "since")
      ,df      = NULL
      ,dfEmpty = NULL
      ,table_defs = list(
           striped = TRUE
          ,compact=TRUE
          ,pagination=FALSE
          ,selection = "multiple"
          ,wrap = FALSE
          ,class               = "yata_tbl_position"
                                  # , onClick = reactable::JS(click)
                                  # , columns = cols
      )
      ,col_defs = list(
           id        = list(show = FALSE)
          ,symbol    = list(name="symbol",     type="label")
          ,name      = list(name="name",       type="label")
          ,balance   = list(name="balance",    type="price")
          ,available = list(name="available",  type="price")
          ,net       = list(name="price",      type="price")
          ,buy       = list(name="buy",        type="price")
          ,sell      = list(name="sell",       type="price")
          ,profit    = list(name="profit",     type="price")
          ,buy_high  = list(name="high",       type="price")
          ,buy_low   = list(name="low",        type="price")
          ,buy_last  = list(name="last",       type="price")
          ,buy_net   = list(name="net",        type="price")
          ,sell_high = list(name="high",       type="price")
          ,sell_low  = list(name="low",        type="price")
          ,sell_last = list(name="last",       type="price")
          ,sell_net  = list(name="net",        type="price")

          # ,value     = list(name="value",      type="value")
          # ,profit    = list(name="profit",     type="price")
          ,since     = list(name="since",      type="date" )
          ,tms       = list(name="tms",        type="date"  )
          ,last      = list(name="last",       type="date" )
          # ,day       = list(name="day",        type="prc" )
          # ,week      = list(name="week",       type="prc" )
          # ,month     = list(name="month",      type="prc" )
       )
      ,col_groups = list( Buy   = c("buy_high",  "buy_net",  "buy_low",  "buy_last")
                         ,Sell  = c("sell_high", "sell_net", "sell_low", "sell_last")
                         ,Dates = c("since", "last", "tms")
                         )
  )
)
