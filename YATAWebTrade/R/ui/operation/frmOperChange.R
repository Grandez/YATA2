frmOperChangeInput = function(base, data) {
   ns = function(id) { paste0(base,id)}
   amount = ifelse(is.null(data$amount), 0, data$amount)
   price  = ifelse(is.null(data$price),  0, data$price)
    tagList(
        fluidRow(column(2), column(6, h2(yuiLabelText(ns("LblOper")))))
       ,fluidRow(column(1)
           ,column(4,
               h2("Base")
              ,yuiFormTable(
                 yuiFormRow("Camara2",   yuiLabelText(ns("LblCamera")))
                ,yuiFormRow("Base",     yuiLabelText(ns("LblBase")))
                ,yuiFormRow("Counter",  yuiLabelText(ns("LblCounter")))
                ,yuiFormRow("Cantidad", yuiNumericInput(ns("ImpAmount"), NULL, value = amount))
                ,yuiFormRow("Precio",   yuiNumericInput(ns("ImpPrice"),  NULL, value = price))
                ,yuiFormRow("Motivo",   yuiCombo(ns("cboReason"), choices=data$reasons), selected="0")                
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
      ,column(4,
             h2("Resumen")
            ,yuiFormTable(
                 yuiFormRow("Disponible",    uiOutput(ns("LblAvailable")), uiOutput(ns("lblNew")))
                ,yuiFormRow("Importe",       ""                          , uiOutput(ns("lblImp")))
                ,yuiFormRow("Comision",      yuiNumericInput(ns("LblFee"))    , uiOutput(ns("lblFeeImp")))
                ,yuiFormRow("Gas",           textOutput(ns("LblGas"))    , uiOutput(ns("lblGasImp")))
                ,yuiFormRow("Total Base",    ""                          , uiOutput(ns("lblTotBase")))
                ,yuiFormRow("Total Counter", ""                          , uiOutput(ns("lblTotCounter")))   
           )
        )
       )
      ,yuiYesNo(ns("tag"))

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