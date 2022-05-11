WDGTablePosition = R6::R6Class("YATA.WEB.TABLE.POS"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = WDGTable
  ,public = list(
     initialize = function(id="position", factory) {
        createDefaultValues(factory)
        super$initialize(id=id, event="none", table=table_attr)
     }
    ,render = function(df,type=c("short", "long"), global=FALSE) {
        type = match.arg(type)
        headPos   = c("balance", "available", "buy", "sell", "value", "profit")
        headDates = c("since",   "last",      "tms")

        if (nrow(df) == 0) {
            df = dfEmpty
        } else {
            df$value = df$balance * df$net
        }
        if (nrow(df) > 0 && type == "short") df = df[,cols_short]
        if (type == "long") {
            headBuy  = c("buy_high",  "buy_low", "buy_net")
            headSell = c("sell_high", "sell_low","sell_net")
            if (!global) {
                headBuy  = c(headBuy, "buy_last")
                headSell = c(headBuy, "sell_last")
            }
            groups = list( colGroup(name = "Posicion", columns = headPos)
                          ,colGroup(name = "Compra",   columns = headBuy)
                          ,colGroup(name = "Venta",    columns = headSell)
                          ,colGroup(name = "Fechas",   columns = headDates))
            private$table_attr$columnGroups = groups
        }
        setTableAttributes(reactable=table_attr)
        super_render(df)
    }
   )
  ,private = list(
       cols_short = c("currency", "balance", "net", "value", "profit", "day", "week", "month", "since")
      ,dfEmpty = NULL
      ,table_attr = list(
          class               = "yata_tbl_position"
       )

      ,col_defs = list(
           currency  = list(name="currency",   type="label")
          ,balance   = list(name="balance",    type="price")
          ,available = list(name="available",  type="price")
          ,profit    = list(name="profit",     type="price")
          ,buy_high  = list(name="high",       type="price")
          ,buy_low   = list(name="low",        type="price")
          ,buy_last  = list(name="last",       type="price")
          ,buy_net   = list(name="net",        type="price")
          ,sell_high = list(name="high",       type="price")
          ,sell_low  = list(name="low",        type="price")
          ,sell_last = list(name="last",       type="price")
          ,sell_net  = list(name="net",        type="price")
          ,buy       = list(name="buy",        type="price")
          ,sell      = list(name="sell",       type="price")
          ,net       = list(name="price",      type="price")
          ,value     = list(name="value",      type="value")
          ,profit    = list(name="profit",     type="price")
          ,since     = list(name="since",      type="date" )
          ,tms       = list(name="tms",        type="tms"  )
          ,last      = list(name="last",       type="date" )
          ,day       = list(name="day",        type="prc" )
          ,week      = list(name="week",       type="prc" )
          ,month     = list(name="month",      type="prc" )
       )
      ,createDefaultValues = function (factory) {
          objPos = factory$getObject(factory$codes$object$position)
          create_names(factory)
          private$dfEmpty = objPos$empty_data()
          private$table_attr$data = dfEmpty
          private$table_attr$columns = col_defs
      }
      ,create_names = function(factory) {
          labels = factory$parms$getLabelsTable(factory$codes$tables$position)
          lbls   = lapply(names(col_defs), function(name) {
                          list( title=jgg_to_title(name)
                               ,lower = stringr::str_to_lower(name)
                               ,upper = stringr::str_to_upper(name)
                               ,label  = labels[[name]]
                               ,asis  = name
                              )})
          names(lbls) = names(col_defs)
          private$col_names = lbls
      }
      ,attrTable = list( striped = TRUE, compact=TRUE
                        ,pagination=FALSE, selection = "multiple"
                        ,wrap = FALSE
                                  # , onClick = reactable::JS(click)
                                  # , columns = cols
      )
  )
)
WDGTableBest = R6::R6Class("YATA.WEB.TABLE.BEST"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = WDGTable
  ,public = list(
     initialize = function(id="table", factory) {
        createDefaultValues(factory)
        super$initialize(id=id, event="none",table=tbl_attr)
     }
    ,render = function(df) {
        df = df[,c("symbol", "price", "hour", "day", "week", "month")]
        # Meter los botones
        super_render(df)
        # private$dfWork = data
        # colDefs = prepareData(data)
        # if (length(colDefs) > 0) {
        #     if (length(attrTable$columns) > 0) {
        #         private$attrTable$columns  = list.merge(colDefs, private$attrTable$columns)
        #     } else {
        #         private$attrTable$columns  = colDefs
        #     }
        # }
        # lstAttr = list.clean((attrTable)) # remove NULLS
        # obj = do.call(reactable::reactable, list.merge(list(data=private$dfWork), lstAttr))
        # reactable::renderReactable({obj})
    }
    # reactable::reactable(df, striped = TRUE, compact=TRUE
    #                               , pagination=FALSE
    #                               , selection = selection
    #                               , wrap = FALSE
    #                               , onClick = reactable::JS(click)
    #                               , columns = cols
    # )

   )
  ,private = list(
       tbl_attr = list(
           class    = "yata_tbl_position"
       )

      ,col_defs = list(
           symbol    = list(name="available"      ,type = "label"  )
          ,price     = list(name="price"          ,type = "price"  )
          ,hour      = list(name="buy_net"        ,type = "prc100" )
          ,day       = list(name="sell_high"      ,type = "prc100" )
          ,week      = list(name="sell_low"       ,type = "prc100" )
          ,month     = list(name="sell_last"      ,type = "prc100" )
       )


      ,createDefaultValues = function (factory) {
          objPos = factory$getObject(factory$codes$object$position)
          create_names(factory)
          df = objPos$empty_data()
          private$tbl_attr$data = df
          private$tbl_attr$columns = col_defs
      }
      ,create_names = function(factory) {
          labels = factory$parms$getLabelsTable(factory$codes$tables$position)
          lbls   = lapply(names(col_defs), function(name) {
                          list( title=jgg_to_title(name)
                               ,lower = stringr::str_to_lower(name)
                               ,upper = stringr::str_to_upper(name)
                               ,label  = labels[[name]]
                               ,asis  = name
                              )})
          names(lbls) = names(col_defs)
          private$col_names = lbls
      }
      ,attrTable = list( striped = TRUE, compact=TRUE
                        ,pagination=FALSE, selection = "multiple"
                        ,wrap = FALSE
                                  # , onClick = reactable::JS(click)
                                  # , columns = cols
      )
     ,.createButtons = function(btns) {
          private$.buttons = lapply(btns, function(btn) {
                                   do.call(reactable::colDef, list( name = "", sortable = FALSE
                                                ,width = 48
                                                ,style=list(`text-align` = "center")
                                                ,cell = function() btn))
                    })
         if (is.null(names(btns))) {
            btnNames = c(paste0("Button", seq(1, length(btns))))
        } else {
            btnNames = names(btns)
        }
        names(private$.buttons) = btnNames
     }

  )
)
WDGTableOper = R6::R6Class("YATA.WEB.TABLE.POS"
  ,portable   = FALSE
  ,cloneable  = FALSE
  ,lock_class = TRUE
  ,inherit    = WDGTable
  ,public = list(
     initialize = function(id="oper", factory) {
        createDefaultValues(factory)
        super$initialize(id=id, table=table_attr)
     }
    ,render = function(df,type=c("short", "long")) {
        type = match.arg(type)

        if (nrow(df) == 0) df = dfEmpty
        if (nrow(df) > 0 && type == "short") df = df[,cols_short]
        super_render(df)
        # private$dfWork = data
        # colDefs = prepareData(data)
        # if (length(colDefs) > 0) {
        #     if (length(attrTable$columns) > 0) {
        #         private$attrTable$columns  = list.merge(colDefs, private$attrTable$columns)
        #     } else {
        #         private$attrTable$columns  = colDefs
        #     }
        # }
        # lstAttr = list.clean((attrTable)) # remove NULLS
        # obj = do.call(reactable::reactable, list.merge(list(data=private$dfWork), lstAttr))
        # reactable::renderReactable({obj})
    }
    # reactable::reactable(df, striped = TRUE, compact=TRUE
    #                               , pagination=FALSE
    #                               , selection = selection
    #                               , wrap = FALSE
    #                               , onClick = reactable::JS(click)
    #                               , columns = cols
    # )

   )
  ,private = list(
       cols_short = c("currency", "balance", "value", "profit", "day", "week", "month", "since")
      ,dfEmpty = NULL
      ,table_attr = list(data = NULL, columns = NULL
             ,bordered            = FALSE
          ,compact             = TRUE
          ,elementId           = NULL
          ,fullWidth           = TRUE
          ,highlight           = TRUE
          ,pagination          = FALSE
          ,onClick             = NULL
          ,rownames            = FALSE
          ,selection           = NULL
          ,showPageInfo        = FALSE
          ,sortable            = FALSE
          ,striped             = TRUE
       )
      ,col_defs = list(
           balance   = list(name="balance",   type="price")
          ,available = list(name="available", type="price")
          ,profit    = list(name="profit",    type="price")
          ,buy_high  = list(name="buy_high",  type="price")
          ,buy_low   = list(name="buy_low",   type="price")
          ,buy_last  = list(name="buy_last",  type="price")
          ,buy_net   = list(name="buy_net",   type="price")
          ,sell_high = list(name="sell_high", type="price")
          ,sell_low  = list(name="sell_low",  type="price")
          ,sell_last = list(name="sell_last", type="price")
          ,sell_net  = list(name="sell_net",  type="price")
          ,buy       = list(name="buy",       type="price")
          ,sell      = list(name="sell",      type="price")
          ,value     = list(name="value",     type="price")
          ,profit    = list(name="profit",    type="price")
          ,since     = list(name="since",     type="date" )
          ,tms       = list(name="tms",       type="tms"  )
          ,last      = list(name="last",      type="date" )
          ,day       = list(name="day",       type="prc" )
          ,week      = list(name="week",      type="prc" )
          ,month     = list(name="month",     type="prc" )
       )
      ,createDefaultValues = function (factory) {
          objPos = factory$getObject(factory$codes$object$position)
          create_names(factory)
          private$dfEmpty = objPos$empty_data()
          private$table_attr$data = dfEmpty
          private$table_attr$columns = col_defs
      }
      ,create_names = function(factory) {
          labels = factory$parms$getLabelsTable(factory$codes$tables$position)
          lbls   = lapply(names(col_defs), function(name) {
                          list( title=jgg_to_title(name)
                               ,lower = stringr::str_to_lower(name)
                               ,upper = stringr::str_to_upper(name)
                               ,label  = labels[[name]]
                               ,asis  = name
                              )})
          names(lbls) = names(col_defs)
          private$col_names = lbls
      }
      ,attrTable = list( striped = TRUE, compact=TRUE
                        ,pagination=FALSE, selection = "multiple"
                        ,wrap = FALSE
                                  # , onClick = reactable::JS(click)
                                  # , columns = cols
      )
  )
)
