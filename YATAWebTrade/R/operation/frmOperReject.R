frmOperRejectInput = function(base, data) {
   ns = function(id) { paste0(base,id)}
   amount = ifelse(is.null(data$amount), 0, data$amount)
   price  = ifelse(is.null(data$price),  0, data$price)
    tagList(
        h2("Operacion rechazada")
       ,fluidRow(column(1)
           ,column(3,
               h2("Base")
              ,yataFormTable(
                 list("Camara",   yataTextLabel(ns("LblCamera")))
                ,list("Base",     yataTextLabel(ns("LblBase")))
                ,list("Counter",  yataTextLabel(ns("LblCounter")))
                ,list("Cantidad", numericInput(ns("ImpAmount"), NULL, value = amount))
                ,list("Precio",   numericInput(ns("ImpPrice"),  NULL, value = 0))
            )
           )   
        )
       ,fluidRow( column(1)
                 ,column(3, yataArea(ns("txtComment"), label = "Motivo"))
        ) 
   ,fluidRow(column(1)
       ,column(4, yataBtnOK(ns("BtnOK"), "Procesar"), yataBtnKO(ns("BtnKO"), "Cancelar"))
    )

)}
