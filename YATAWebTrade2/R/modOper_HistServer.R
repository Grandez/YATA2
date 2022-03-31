modOperHistServer = function(id, full, pnlParent, parent) {
ns = NS(id)
ns2 = NS(full)
PNLOperHist = R6::R6Class("PNL.OPER.HIST"
   ,inherit    = YATAPanel
   ,cloneable  = FALSE
   ,lock_class = TRUE
   ,public = list(
       available  = 0
      ,balance    = 0
      ,initialize = function(id, pnlParent, session) {
          super$initialize(id, pnlParent, session)
          private$oper      = self$factory$getObject(self$codes$object$operation)
          self$vars = list(oper = 0, currency = " ",camera   = " ", date=NULL)
      }
      ,reload = function() {
          self$data$dfOpers = private$oper$getActive()
      }
      ,filterByOper     = function (df) {
          if (self$vars$oper != 0) df = df[df$type == self$vars$oper,]
          df
      }
      ,filterByCurrency = function (df) {
          if (nchar(trimws(self$vars$currency)) == 0) return (df)
          if (is.null(self$vars$buy)) {
              df = df %>% dplyr::filter(base == self$vars$currency | counter == self$vars$currency)
              return (df[df$counter == self$vars$currency || df$base == self$vars$currency,])
          } else {
              if (self$vars$buy) df = df[df$counter == self$vars$currency,]
              else               df = df[df$base == self$vars$currency,]
          }
          df
      }
      ,filterByCamera   = function (df) {
          if (nchar(trimws(self$vars$camera)) == 0) return (df)
          df[df$camera == self$vars$camera,]
      }
      ,filterByDate   = function (df) {
          if (is.null(self$vars$date)) return (df)
          df[df$tms >= self$vars$date,]
      }

      ,prepareTable = function(df) {
          if (nrow(df) == 0) return()
          include = c("tms", "camera", "base", "counter", "amount", "value", "price", "fee", "gas")
          exclude =  c("id", "parent", "priceIn", "priceOut", "alive", "rank")
          exclude = c(exclude, "acive", "status")
          exclude = c(exclude, "acive", "status")
          #df[exclude] = list(NULL)
          df = df[,include]
          types = list( imp = c("amount", "value","price")
                        )
          data = list(df = df, cols=NULL, info=NULL)
          data$info=list( types=types) #event=ns("tablePos"), target=table,types=types)
          data
       }
  )
  ,private = list(
       oper      = NULL
    )
)
moduleServer(id, function(input, output, session) {
   pnl = WEB$getPanel(id)
   if (is.null(pnl)) pnl = WEB$addPanel(PNLOperHist$new(id, pnlParent, session))
   flags = reactiveValues(
      refresh  = FALSE
   )
   observeEvent(flags$refresh, {
      if (nrow(pnl$data$dfOpers) == 0) return()
       df   = pnl$filterByOper     (pnl$data$dfOpers)
       df   = pnl$filterByCurrency (df)
       df   = pnl$filterByCamera   (df)
       df   = pnl$filterByDate     (df)
       data = pnl$prepareTable (df)

       output$tblHistory = updTable(data)
   })
   observeEvent(input$cboOper, {
      df = pnl$data$dfOpers
      pnl$vars$oper = as.integer(input$cboOper)
      pnl$vars$buy  = (pnl$vars$oper %% 2) == 0

      if (input$cboOper == 0) {
          pnl$vars$buy = NULL
          choices=WEB$combo$operations(all=TRUE)
          updCombo("cboCurrency", choices=choices)
      } else {
          currency = ifelse(pnl$vars$buy, "counter", "base")
          currencies = unique(df[,currency])
          choices=WEB$combo$currencies(all=TRUE, set=currencies)
          updCombo("cboCurrency", choices=choices)
      }
      flags$refresh = isolate(!flags$refresh)
   }, ignoreInit = TRUE, ignoreNULL = TRUE)
   observeEvent(input$cboCurrency, {
      pnl$vars$currency = input$cboCurrency
      flags$refresh = isolate(!flags$refresh)
   }, ignoreInit = TRUE, ignoreNULL = TRUE)
   observeEvent(input$cboCamera, {
      pnl$vars$camera = input$cboCamera
      flags$refresh = isolate(!flags$refresh)
   }, ignoreInit = TRUE, ignoreNULL = TRUE)
   observeEvent(input$dtDate, {
      pnl$vars$date = input$dtDate
      flags$refresh = isolate(!flags$refresh)
   }, ignoreInit = TRUE, ignoreNULL = TRUE)

   if (!pnl$loaded) {
       pnl$loaded = TRUE
       pnl$reload()
       flags$refresh = isolate(!flags$refresh)
   }
})
}
