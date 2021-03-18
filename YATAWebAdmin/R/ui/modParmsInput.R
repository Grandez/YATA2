modParmsInput = function(id, title) {
    ns = NS(id)
    tagList(
       tabsetPanel(id=ns("pnlType")
         ,tabPanel("General",        value=ns("gral"), YATAModule("ParmsGral", ns("gral"), ""))
         ,tabPanel("Bases de datos", value=ns("db"),   YATAModule("ParmsDB",   ns("db")  , ""))
         ,tabPanel("Proveedores",    value=ns("prov"), YATAModule("ParmsProv", ns("prov"), ""))
         )
)}
# modGeneralInput = function(id) {
#    ns = NS(id)
#    tagList(
#       yataBox(ns("gralGral"),  "General"
#             ,yataFormTable(
#                 list("External data", yataTextInput (ns("txtPlugins")))
#                ,list("Base de datos", yataCombo(ns("cboDB")))
#                ,list("Auto abrir",    yataSwitch(ns("swAutoOpen")))
#                ,list("Alertas",       yataIntegerInput(ns("intAlert")))
#            )
#       )
#      ,yataBox(ns("gralDB"),  "Databases"
#         ,fluidRow( column(2, yataListBox(ns("lstDB")))
#                  ,column(1)
#                  ,column(3,
#                     yataFormTable(
#                        list("Nombre",   yataTextInput(ns("txtDBName")))
#                       ,list("Motor",    yataTextInput(ns("txtDBEngine")))
#                       ,list("Database", yataTextInput(ns("txtDBDB")))
#                       ,list("Usuario",  yataTextInput(ns("txtDBUser"))) 
#                       ,list("Password", yataTextInput(ns("txtDBPwd")))
#                       ,list("Host",     yataTextInput(ns("txtDBHost"))) 
#                    ))
#            )
#         )
#      ,fluidRow(column(1), tags$div(id=ns("msg")))
#      ,fluidRow(column(1)
#        ,column(4, yataBtnOK(ns("btnOK"), "Guardar"), yataBtnKO(ns("btnKO"), "Cancelar"))
#      )
# )}
