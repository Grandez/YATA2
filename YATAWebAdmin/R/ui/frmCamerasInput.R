frmCamerasInput = function(base) {
  ns = function(id) { paste0(base,id)}
    tagList(
       fluidRow(column(1)
      ,column(2
         ,yataFormTable(
             list("Simbolo",  yataTextInput    (ns("TxtSymbol")))
            ,list("Nombre",   yataTextInput    (ns("TxtName")))
            ,list("Activa",   yataSwitch       (ns("SwActive"), TRUE))
            ,list("Maker",    yataNumericInput (ns("NumMaker")))
            ,list("Taker",    yataNumericInput (ns("NumTaker")))
            ,list("Token",    yataTextInput    (ns("TxtToken")))
            ,list("User",     yataTextInput    (ns("TxtUser")))
            ,list("Password", yataTextInput    (ns("TxtPwd")))                            
         )
       )
    )
   ,fluidRow(column(1)
       ,column(4, yataBtnOK(ns("BtnOK"), "Guardar"), yataBtnKO(ns("BtnKO"), "Cancelar"))
    )

)}
