modAdminPortfolioInput = function(id, title) {
    ns = NS(id)
    main = tagList(
        br()
       ,fluidRow(column(1)
            ,column(2, guiListbox(ns("lstPortfolios")), actionBttn(ns("btn_new"), "Nuevo", color="primary")
                )
            ,column(1)
            ,column(4, tags$table(style="width: 100%"
                 ,tags$tr( tags$td("Nombre")
                         ,tags$td(colspan="2", guiLabel(ns("lbl_name")), hidden(guiText(ns("txt_name"))))
                         ,tags$td(guiButtonIcon(ns("btn_name"), "pencil-alt")))
                ,tags$tr( tags$td("Titulo")
                         ,tags$td(colspan="2", guiLabel(ns("lbl_title")), hidden(guiText(ns("txt_title"))))
                         ,tags$td(guiButtonIcon(ns("btn_title"), "pencil-alt")))
                ,tags$tr( tags$td("Scope")
                         ,tags$td(colspan="2", guiLabel(ns("lbl_scope")),
                                  hidden(guiCombo(ns("cbo_scope"), choices=WEB$combo$scopes())))
                         ,tags$td(guiButtonIcon(ns("btn_scope"), "pencil-alt")))
                ,tags$tr( tags$td("target")
                         ,tags$td(colspan="2", guiLabel(ns("lbl_target")),
                                  hidden(guiCombo(ns("cbo_target"), choices=WEB$combo$targets())))
                         ,tags$td(guiButtonIcon(ns("btn_target"), "pencil-alt")))
                ,tags$tr( tags$td("selective CTC")
                         ,tags$td(colspan="2", guiLabel(ns("lbl_ctc")),
                                  hidden(guiNumericInput(ns("txt_ctc"), step = 50, min = 0)))
                         ,tags$td(guiButtonIcon(ns("btn_ctc"), "pencil-alt")))
                ,tags$tr( tags$td("Selective token")
                         ,tags$td(colspan="2", guiLabel(ns("lbl_tok")),
                                  hidden(guiNumericInput(ns("txt_tok"), step = 50, min = 0)))
                         ,tags$td(guiButtonIcon(ns("btn_tok"), "pencil-alt")))

                ,tags$tr( tags$td("Comment")
                         ,tags$td(colspan="2", guiLabel(ns("lbl_comment")), hidden(guiText(ns("txt_comment"))))
                         ,tags$td(guiButtonIcon(ns("btn_comment"), "pencil-alt")))
                ,tags$tr( tags$td("Database")
                         ,tags$td(colspan="2", guiLabel(ns("lbl_db")), hidden(guiText(ns("txt_db"))))
                         ,tags$td(guiButtonIcon(ns("btn_db"), "pencil-alt")))

                ,tags$tr( tags$td("Activo")
                         ,tags$td(colspan="2", guiSwitch(ns("swActive"),onLbl="On", offLbl="Off")))
                ,tags$tr( tags$td("Desde")
                         ,tags$td(colspan="2", guiLabel(ns("lbl_since"))))

             )
            ,guiYesNo(ns("new_buttons"))
                ))
    )
    list(left=NULL, main=main, right=NULL)
}
