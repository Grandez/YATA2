modCamerasInput = function(id, title) {
    ns = NS(id)
    tagList(
      fluidRow(column(1) # yataBtnOK(ns("btnOK"), "Agregar"), yataBox(ns("tblPosGlobal"), "Prueba")
        #,yataBox(ns("tblPosGlobal"), "Posicion Global", DT::dataTableOutput(ns("tblPosGlobal")))
        ,column(4, 
           yataBox(ns("camOK"), "Activas",
          #h2("Camaras activas"), 
             DT::dataTableOutput(ns("tblCamOK"))
#          , title = "Prueba"
#                   ,closable = TRUE
#                   ,width = NULL
#                   ,status = "primary"
#                   ,solidHeader = TRUE
                   #,collapsible = TRUE
                   # ,enable_dropdown = TRUE
                   # ,dropdown_icon = "wrench"
                   # ,dropdown_menu = dropdownItemList(
                   #     dropdownItem(url = "http://www.google.com", name = "Link to google"),
                   #     dropdownItem(url = "#", name = "item 2"),
                   #     dropdownDivider(),
                   #     dropdownItem(url = "#", name = "item 3")
                   #  )

             )
          
          )
          #h2("Camaras activas"), DT::dataTableOutput(ns("tblCamOK")))
        ,column(2)
        ,column(4, h2("Camaras inactivas"), DT::dataTableOutput(ns("tblCamKO")))
        ,column(1, yataBtnOK(ns("btnOK2"), "Agregar"))
      )
)}
