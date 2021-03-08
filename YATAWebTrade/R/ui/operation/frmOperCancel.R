frmOperCancelInput = function(base, data) {
   ns = function(id) { paste0(base,id)}
   amount = ifelse(is.null(data$amount), 0, data$amount)
   price  = ifelse(is.null(data$price),  0, data$price)
    tagList(
        h2("Cancelar la operacion")
       ,fluidRow(column(1)
           ,column(3,
               h2("Base")
              ,yataFormTable(
                 list("Camara",   yuiLabelText(ns("LblCamera")))
                ,list("Base",     yuiLabelText(ns("LblBase")))
                ,list("Counter",  yuiLabelText(ns("LblCounter")))
                ,list("Cantidad", yuiLabelNumber(ns("LblAmount")))
                ,list("Precio",   yuiLabelNumber(ns("LblPrice")))
            )
           )   
        )
       ,fluidRow( column(1)
                 ,column(3, yuiSwitch(ns("SwDelete"), value = TRUE))
        ) 
   ,fluidRow(column(1),yuiYesNo(ns("tag"), "Anular", "Cancelar"))
)}
