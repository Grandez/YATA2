frmOperChangeInput = function(base, data) {
   ns = function(id) { paste0(base,id)}
   amount = ifelse(is.null(data$amount), 0, data$amount)
   price  = ifelse(is.null(data$price),  0, data$price)
    tagList(
        h2(yataTextLabel(ns("LblOper")))
       ,fluidRow(column(1)
           ,column(3,
               h2("Base")
              ,yataFormTable(
                 list("Camara",   yataTextLabel(ns("LblCamera")))
                ,list("Base",     yataTextLabel(ns("LblBase")))
                ,list("Counter",  yataTextLabel(ns("LblCounter")))
                ,list("Cantidad", yataNumericInput(ns("ImpAmount"), NULL, value = amount))
                ,list("Precio",   yataNumericInput(ns("ImpPrice"),  NULL, value = price))
            )
        )
      # ,column(3,
      #        h2("Control")
      #       ,yataFormTable(
      #           list("Objetivo", numericInput(ns("target"),  NULL, value = 0))
      #          ,list("Plazo",    numericInput(ns("deadline"),  NULL, value = 0))
      #          ,list("Stop",    numericInput(ns("stop"),   NULL, value = 0))
      #          ,list("Limit",   numericInput(ns("limit"),  NULL, value = 0))
      #          ,list("Revisar",  numericInput(ns("alert"),  NULL, value = 0))
      #      )
      #   )
      ,column(3,
             h2("Resumen")
            ,yataFormTable(
                 list("Disponible",    uiOutput(ns("LblAvailable")), uiOutput(ns("lblNew")))
                ,list("Importe",       ""                          , uiOutput(ns("lblImp")))
                ,list("Comision",      yataNumericInput(ns("LblFee"))    , uiOutput(ns("lblFeeImp")))
                ,list("Gas",           textOutput(ns("LblGas"))    , uiOutput(ns("lblGasImp")))
                ,list("Total Base",    ""                          , uiOutput(ns("lblTotBase")))
                ,list("Total Counter", ""                          , uiOutput(ns("lblTotCounter")))   
           )
        )
       )
   ,fluidRow(column(1)
       ,column(4, yataBtnOK(ns("BtnOK"), "Transferir"), yataBtnKO(ns("BtnKO"), "Cancelar"))
    )

)}

frmOperChangeServer = function(id, input, output, session, base, pnl) {
  browser()
    moduleServer(id, function(input, output, session) {
  initForm = function() {
      browser()
     title = "XXX"
      if (pnl$vars$nextAction == YATACodes$status$accepted) title = "Aceptar Operacion"
      if (pnl$vars$nextAction == YATACodes$status$executed) title  = "Ejecutar Operacion"
      if (pnl$vars$nextAction == YATACodes$status$rejected) title  = "Rechazar Operacion"
      if (pnl$vars$nextAction == YATACodes$status$closed)   title   = "Cerrar Operacion"
      output$changeLblOper = renderText({ title })
  }
  initForm()
  browser()
    })
}