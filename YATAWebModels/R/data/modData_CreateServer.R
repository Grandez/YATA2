modDatCreateServer = function(id, full, pnlParent, parent) {
   ns = NS(id)
   ns2 = NS(full)
   PNLData = R6::R6Class("PNL.DATA"
        ,inherit    = YATAPanel
        ,cloneable  = FALSE
        ,lock_class = TRUE
        ,public = list(
            plot       = NULL
           ,initialize = function(id, pnlParent, session) {
               super$initialize(id, pnlParent, session)
               self$plot = YATAPlot$new("plot", type="Marker")
           }
         ,addRecord = function(row, value) {
            df = self$data$df
            if (is.null(df)) {
                df = data.frame(id=as.integer(), value=as.numeric(),var1=as.numeric(), var2=as.numeric())
            }
            if (nrow(df) < row) row = nrow(df) + 1
            if (nrow(df) >= row) {
               df[df$id > row,]$id = df$id + 1
            }
            df = rbind(df,list(id=row, value=value,var1=0.0,var2=0.0))
            self$data$df = df[order(df$id),]
            self$data$df
         }
         ,updateRecord = function(row, value) {
            self$data$df[row, "value"] = value
            self$updateData()
            invisible(self)
         }
         ,updateData = function(df) {
             if (missing(df)) df = self$data$df
             df = df[order(df$id),]
             df$id = seq(1, nrow(df))
             df$var1 = rollapply(df$value, 2, function(x) round(((x[2]/x[1]) - 1) * 100,3), fill=0, align="right")
             org = df[1,"value"]
             df$var2 = rollapply(df$value, 2, function(x) round(((x[2]/org) - 1) * 100,3), fill=0, align="right")
             self$data$df = df
             self$data$df
         }
         ,getData = function() { self$data$df }

     )
      ,private = list(
          selected = NULL
         ,definition = list(id = "", left=0, right=0, son=NULL, submodule=TRUE)
         ,prepareData = function(df) {
         }
      )
   )

   moduleServer(id, function(input, output, session) {
      pnl = YATAWEB$getPanel(full)
      if (is.null(pnl)) pnl = YATAWEB$addPanel(PNLData$new(id, pnlParent, session))

      flags = reactiveValues(
            data   = FALSE
           ,opView    = FALSE
           ,change = FALSE
      )

      changeEntry = function(df, row) {
          pnl$vars$edit = TRUE
          updIntegerInput("row",   df[row, "id"])
          updNumericInput("value", df[row, "value"])
          updBtn(ns2("btnValue"), label="Update")
          updBtn(ns2("btnPrc"),   label="Cancel")
      }
      resetEntry = function() {
         updBtn(ns2("btnValue"), label="Value")
         updBtn(ns2("btnPrc"),   label="Percentage")
         updIntegerInput("row",   0)
         updNumericInput("value", 0)
         pnl$vars$edit = NULL
      }
      ###########################################################
      ### Reactives
      ###########################################################

       observeEvent(flags$change, ignoreInit = TRUE, {
          df   = pnl$getData()
          data = pnl$vars$table
          action = substr(data$colName,4, nchar(data$colName))
          if (action == "Edit")   {
              changeEntry(df, data$row)
              return()
          } else {
              if (!is.null(pnl$vars$edit)) {
                  resetEntry()
              }
          }


          if (action == "Up")   {
              df[data$row - 1, 1] = data$row
              df[data$row    , 1] = data$row - 1
          }
          if (action == "Down")   {
              df[data$row + 1, 1] = data$row
              df[data$row    , 1] = data$row + 1
          }
          if (action == "Del")   {
              df = df[-c(data$row),]
              df$id = seq(1, nrow(df))
          }
          pnl$updateData(df)
          flags$data = isolate((!flags$data))
       })


      observeEvent(flags$data, ignoreInit = TRUE, {
         df = pnl$getData()
         btns = list(btnUp=yuiBtnIconUp(),btnDown=yuiBtnIconDown(), btnEdit=yuiBtnIconEdit(), btnDel=yuiBtnIconDel())
         info = list(buttons=btns, event=ns2("tableData"), target="Data", height=300)
         tblDef = list(info=info,df=df)
         updNumericInput("row", nrow(df) + 1)
         output$tblData = updTable(tblDef)
         pnl$plot$setData(df[,1:2], "data")
         output$plot = updPlot(pnl$plot, ns("plot"))
      })

      ###########################################################
      ### Observers
      ###########################################################

       observeEvent(input$btnValue, ignoreInit = TRUE, {
           if (!is.null(pnl$vars$edit)) {
               pnl$updateRecord(pnl$vars$table$row, input$value)
               resetEntry()
           } else {
               row = input$row
               for (idx in 1:input$times) {
                    pnl$addRecord(row, input$value)
                   row = row + 1
               }
           }
           flags$data = isolate((!flags$data))
       })

       observeEvent(input$btnPrc, ignoreInit = TRUE, {
           if (!is.null(pnl$vars$edit)) {
               resetEntry()
               return()
           }
           df = pnl$getData()
           value = df[nrow(df), "value"]
           row   = df[nrow(df), "id"]
           var   = input$value / 100
           for (idx in 1:input$times) {
              row   = row + 1
              value = value * (1 + var)
              pnl$addRecord(row, value)
           }
           pnl$updateData()
           flags$data = isolate((!flags$data))
       })
       observeEvent(input$btnDone1 | input$btnDone2, ignoreInit = TRUE, {
           pnl$getRoot()$setData(pnl$getData())
           updateTabsetPanel(session=parent, inputId="mainMenu", selected="analysis")
       })

       observeEvent(input$tableData, {
           pnl$vars$table = input$tableData
           if (startsWith(input$tableData$colName, "btn")) {
               flags$change = isolate(!flags$change)
           } else {
               flags$tab = isolate(!flags$tab)
           }

       })

  })
}

