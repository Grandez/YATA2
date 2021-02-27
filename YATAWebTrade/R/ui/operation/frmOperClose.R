frmOperCloseInput = function(base, data) {
   ns = function(id) { paste0(base,id)}
   amount = ifelse(is.null(data$amount), 0, data$amount)
   price  = ifelse(is.null(data$price),  0, data$price)
    tagList(
        fluidRow(column(2), column(6, h2(yuiLabelText(ns("LblOper")))))
       ,fluidRow(column(1), column(6,
              yuiFormTable(
                 yuiFormRow("Camara",   yuiLabelText(ns("LblCamera")))
                ,yuiFormRow("Base",     yuiLabelText(ns("LblBase")))
                ,yuiFormRow("Counter",  yuiLabelText(ns("LblCounter")))
                ,yuiFormRow("Cantidad", yuiNumericInput(ns("ImpAmount"), NULL, value = amount, min=0,max=amount))
                ,yuiFormRow("Precio",   yuiNumericInput(ns("ImpPrice"),  NULL, value = price))
#                ,yuiFormRow("Comision", yuiNumericInput(ns("LblFee")))
                ,yuiFormRow("Motivo",   selectInput(ns("cboReasons"), label=NULL, choices=data$reasons, selected="0"))
            )
        )
       )
    ,fluidRow(column(1), column(6, h2("Notas")))
    ,fluidRow(column(1), column(6, yuiTextArea(ns("comment"), label=NULL, cols="100", rows="10")))
    ,yuiYesNo(ns("tag"))
)}

# frmOperCloseServer = function(id, input, output, session, base, pnl) {
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