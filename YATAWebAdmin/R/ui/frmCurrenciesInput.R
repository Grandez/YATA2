frmCurrenciesInput = function(base, ...) {
  ns = function(id) { paste0(base,id)}
  parms = list(...)
  data = parms$data
  lblUpload = ifelse (is.null(data$icon), "browse ...", basename(data$icon))
    tagList(
      yataFormHeader("Titulo del form")
      ,fluidRow(yataCol(1)
      ,yataCol(8
         ,yataFormTable(
             list("Simbolo", yataTextInput (ns("TxtSymbol"), value=data$id))
            ,list("Nombre",  yataTextInput (ns("TxtName"), value=data$name))
            ,list("Activa",  yataSwitch    (ns("SwActive"), TRUE))
            ,list("Icono",   yataUploadImg (ns("FileIco"),imgLabel=lblUpload))
         )
       )
     ,yataCol(3, img(src = data$icon, alt=data$name, class="yataLogo"))
    )
   ,fluidRow(yataCol(1), column(2, h2("Camaras")))
   ,fluidRow( yataCol(1)
             ,yataCol(5, fluidRow(yataListBox( ns("LstCamerasOK"), "Cotiza"
                                             ,choices=data$camerasIn
                                             ,multiple=TRUE, size=20))
                        ,yataRowButtons(yataBtnKO(ns("BtnKO"), "Quitar")))
             ,yataCol(5, fluidRow(yataListBox( ns("LstCamerasKO"), "No Cotiza"
                                             ,choices=data$camerasOut
                                             ,multiple=TRUE, size=10))
                        ,yataRowButtons(yataBtnOK(ns("BtnOK"), "Agregar")))
     )    
   ,yataRowButtons(if (data$action == 0) yataBtnOK(ns("BtnAdd"), "Procesar"), yataBtnKO(ns("BtnEsc"), "Cancelar")
    )

)}
