frmOperChangeInput = function(base, data) {
   ns = function(id) { paste0(base,id)}
   amount = ifelse(is.null(data$amount), 0, data$amount)
   price  = ifelse(is.null(data$price),  0, data$price)
    tagList(
        tags$div(h2(yuiLabelText(ns("LblOper"))))
       ,fluidRow(
            column(6,
               h2("Base")
              ,yuiFormTable(
                 yuiFormRow("Camara",   yuiLabelBold(ns("LblCamera")))
                ,yuiFormRow("Base",     yuiLabelBold(ns("LblBase")))
                ,yuiFormRow("Counter",  yuiLabelBold(ns("LblCounter")))
                ,yuiFormRow("Cantidad", yuiNumericInput(ns("ImpAmount"), NULL, value = amount))
                ,yuiFormRow("Precio",   yuiNumericInput(ns("ImpPrice"),  NULL, value = price))
#                ,yuiFormRow("Motivo",   yuiCombo(ns("cboReason"), choices=data$reasons), selected="0")                
            )
        )
      ,column(6,
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

# frmOperChangeServer = function(id, input, output, session, base, pnl) {
#   browser()
#     moduleServer(id, function(input, output, session) {
#   initForm = function() {
#       browser()
#      title = "XXX"
#       if (pnl$vars$nextAction == YATACodes$status$accepted) title = "Aceptar Operacion"
#       if (pnl$vars$nextAction == YATACodes$status$executed) title  = "Ejecutar Operacion"
#       if (pnl$vars$nextAction == YATACodes$status$rejected) title  = "Rechazar Operacion"
#       if (pnl$vars$nextAction == YATACodes$status$closed)   title   = "Cerrar Operacion"
#       output$changeLblOper = renderText({ title })
#   }
#   initForm()
#   browser()
#     })
# }