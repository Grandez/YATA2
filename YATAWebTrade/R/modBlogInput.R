modBlogInput = function(id, title="") {
    ns = NS(id)
    main = tagList(h2("Panel de BLOG"))
#     targets = c("General"="gral", "Moneda"="currency", "Operacion"="oper", "Notas"="note")
#     targets2 = c("Todo"="all",targets)
#     lblFilter = WEB$msg$get("LABEL.BTN.APPLY")
#     lblTitle = WEB$msg$get("TITLE.TITLE")
#     lblDetail  = WEB$msg$get("TITLE.DETAIL")
#     lblApply   = WEB$msg$get("SUBT.APPLY")
#
#     left = tagList(
#          guiTitle(5, "Filter")
#         ,fluidRow(column(4, "Select")
#                   ,column(8, guiCombo( ns("cboFilter"),choices=targets2,selected="currency")))
#         ,fluidRow( column(4, "Desde")
#                   ,column(8, style="text-align: right;"
#                             , dateInput(ns("dfFrom"), NULL, format = "yyyy-mm-dd", startview = "month",language = "es"))
#           )
#       ,fluidRow(column(4, "Orden"),column(8, guiSwitch(ns("swOrder"),onLbl="Asc", offLbl="Desc")))
#       ,yuiBtnOK(ns("btnFilter"),lblFilter)
#     )
#     main = tagList(
#         guiBox(ns("item"),"Crear nota", tags$br()
#               ,fluidRow( guiColumn(2, h4(lblApply))
#                         ,guiColumn(2, guiCombo( ns("cboApply"),choices=targets,selected="oper"))
#                         ,guiColumn(1)
#                         ,guiColumn(1,h4("Item"))
#                         ,guiColumn(3,guiComboSelect(ns("cboTarget"),text="Counter"))
#               )
#         ,fluidRow(guiColumn(2, h4(lblTitle)), column(7, yuiTextInput(ns("title"))))
#         ,fluidRow(guiColumn(2),               column(7, guiTextArea(ns("data"), label=NULL, cols="200", rows="10")))
#         ,fluidRow(guiColumn(2), guiColumn(6, yuiBtnOK(ns("btnOK"), "Procesar")
#                                            , yuiBtnInfo(ns("btnView"), "Visualizar")
#                                            , yuiBtnDanger(ns("btnKO"), "Cancelar"))
#                             )
#         )
# ,guiBox(id=ns("posts0"), "Box with user comment",
#   tags$div(id=ns("posts"))
# #     ,userPost(
# #     id = 1,
# #       image=NULL,
# # #    src = "https://adminlte.io/themes/AdminLTE/dist/img/user1-128x128.jpg",
# #     author = "Jonathan Burke Jr.",
# #     description = "Shared publicly - 7:30 PM today",
# #     "Lorem ipsum represents a long-held tradition for designers,
# #               typographers and the like. Some people hate it and argue for
# #               its demise, but others ignore the hate as they create awesome
# #               tools to help create filler text for everyone from bacon
# #               lovers to Charlie Sheen fans.",
# #     # userPostToolItemList(
# #     #   userPostToolItem(dashboardLabel("item 1")),
# #     #   userPostToolItem(dashboardLabel("item 2", status = "danger"), side = "right")
# #     # )
# #   ),
# #   userPost(
# #     id = 2, image=NULL,
# # #    src = "https://adminlte.io/themes/AdminLTE/dist/img/user6-128x128.jpg",
# #     author = "Adam Jones",
# #     description = "Shared publicly - 5 days ago",
# #     # userPostMedia(src = "https://adminlte.io/themes/AdminLTE/dist/img/photo2.png"),
# #     userPostTagItems(
# #       userPostTagItem(dashboardLabel("item 1", status = "danger")),
# #       userPostTagItem(dashboardLabel("item 2", status = "danger"), side = "right")
# #     )
# #   )
#
# )
#     )
    list(left=NULL, main=main, right=NULL)
}
