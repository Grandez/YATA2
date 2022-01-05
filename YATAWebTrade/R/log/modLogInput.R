modLogInput = function(id, title="") {
    ns = NS(id)
    targets = c("General"="gral", "Moneda"="currency", "Operacion"="oper", "Notas"="note")
    targets2 = c("Todo"="all",targets)
    lblFilter = YATAWEB$MSG$get("LABEL.BTN.APPLY")
    lblTitle = YATAWEB$MSG$get("TITLE.TITLE")
    lblDetail  = YATAWEB$MSG$get("TITLE.DETAIL")
    lblApply   = YATAWEB$MSG$get("SUBT.APPLY")
    
    left = tagList(
         yuiTitle(5, "Filter")
        ,fluidRow(column(4, "Select")
                  ,column(8, yuiCombo( ns("cboFilter"),choices=targets2,selected="currency")))
        ,fluidRow( column(4, "Desde")
                  ,column(8, style="text-align: right;"
                            , dateInput(ns("dfFrom"), NULL, format = "yyyy-mm-dd", startview = "month",language = "es"))
          )
      ,fluidRow(column(4, "Orden"),column(8, yuiSwitch(ns("swOrder"),onLbl="Asc", offLbl="Desc")))      
      ,yuiBtnOK(ns("btnFilter"),lblFilter)
    )
    main = tagList(
        yuiBox(ns("item"),"", tags$br()
              ,fluidRow( yuiColumn(2, h4(lblApply))
                        ,yuiColumn(2, yuiCombo( ns("cboApply"),choices=targets,selected="oper"))
                        ,yuiColumn(1)
                        ,yuiColumn(1,h4("Item"))
                        ,yuiColumn(3,yuiComboSelect(ns("cboTarget"),text="Counter"))
              )
        ,fluidRow(yuiColumn(2, h4(lblTitle)), column(7, yuiTextInput(ns("title"))))
        ,fluidRow(yuiColumn(2),               column(7, yuiTextArea(ns("data"), label=NULL, cols="200", rows="10")))
        ,fluidRow(yuiColumn(2), yuiColumn(6, yuiBtnOK(ns("btnOK"), "Procesar")
                                           , yuiBtnInfo(ns("btnView"), "Visualizar")
                                           , yuiBtnDanger(ns("btnKO"), "Cancelar"))
                            )
        )
,yuiBox(id=ns("posts0"), "Box with user comment",
  tags$div(id=ns("posts")),
  userPost(
    id = 1,
      image=NULL,
#    src = "https://adminlte.io/themes/AdminLTE/dist/img/user1-128x128.jpg",
    author = "Jonathan Burke Jr.",
    description = "Shared publicly - 7:30 PM today",
    "Lorem ipsum represents a long-held tradition for designers, 
              typographers and the like. Some people hate it and argue for 
              its demise, but others ignore the hate as they create awesome 
              tools to help create filler text for everyone from bacon 
              lovers to Charlie Sheen fans.",
    # userPostToolItemList(
    #   userPostToolItem(dashboardLabel("item 1")),
    #   userPostToolItem(dashboardLabel("item 2", status = "danger"), side = "right")
    # )
  ),
  userPost(
    id = 2, image=NULL,
#    src = "https://adminlte.io/themes/AdminLTE/dist/img/user6-128x128.jpg",
    author = "Adam Jones",
    description = "Shared publicly - 5 days ago",
    # userPostMedia(src = "https://adminlte.io/themes/AdminLTE/dist/img/photo2.png"),
    userPostTagItems(
      userPostTagItem(dashboardLabel("item 1", status = "danger")),
      userPostTagItem(dashboardLabel("item 2", status = "danger"), side = "right")
    )
  )

)        
    )
    list(left=left, main=main, right=NULL)
}
