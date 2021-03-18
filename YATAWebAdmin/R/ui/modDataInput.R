modDataInput = function(id, title) {
  ns = NS(id)
  tagList(  
     yataRow(align="center", h2("Abrir Posicion"))  
    ,fluidRow(column(1)
      ,column(3,
             h2("Base")
            ,yataFormTable(
                 list("Auto abrir",   yataSwitch(ns("swAutoOpen")))
           )
        )
    )
    ,fluidRow(column(1), tags$div(id=ns("msg")))
    ,fluidRow(column(1)
       ,column(4, yataBtnOK(ns("btnOK"), "Guardar"), yataBtnKO(ns("btnKO"), "Cancelar"))
    )
  
  
)}
