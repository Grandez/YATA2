modHistInput = function(id, title) {
   ns = NS(id)
   titCTC   = WEB$getMsg("TITLE.CURRENCIES")
   titPlots= WEB$getMsg("TITLE.PLOTS")
   choices  = c("None" = "", "Session" = "session", "Value" = "price", "Volume"="volume", "Capitalization"="cap")

   left = tagList(
       h3(titCTC)
      ,yuiListBox(ns("lstCurrencies"))
      ,tags$br()
      # ,h3(titPlots)
      # , tags$table(class="yata_layout_table",
      #       tags$tr(class="yata_layout_row"
      #             ,tags$td(class="yata_layout_left",  yuiLayout(ns("cboPlot_1_1"), choices=choices, selected="session"))
      #             ,tags$td(class="yata_layout_right", yuiLayout(ns("cboPlot_1_2"), choices=choices, selected=""))
      #       )
      #      ,tags$tr(class="yata_layout_row"
      #             ,tags$td(class="yata_layout_left",  yuiLayout(ns("cboPlot_2_1"), choices=choices, selected="volume"))
      #             ,tags$td(class="yata_layout_right", yuiLayout(ns("cboPlot_2_2"), choices=choices, selected=""))
      #       )
      #
      #      )

    )
   main = tagList(
      shiny::tabsetPanel( id=ns("mnuHist")
                  ,shiny::tabPanel("Summary",   value=ns("summ"),  JGGModule(ns("summ")))
                  ,shiny::tabPanel("",   value=ns("detail"),       JGGSubModule(ns("detail")))
                  ,shiny::tabPanel("",   value=ns("dummy"),     "")
      )
    )

    # pnl1 = tabsetPanel( id=ns("tabHist")
    #                   ,tabPanel("Summary",   value=ns("summ"),  YATAModule(ns("summ")))
    #                   # ,tabPanel("",   value=ns("detail"),       YATASubModule(ns("detail")))
    #                   # ,tabPanel("",   value=ns("dummy"),     "")
    #       )
    # pnl2 = tabPanel(ns("tabDetail"))
# pnl$children[[1]] = tagAppendChild(pnl$children[[1]], pnl2)

    #main = tagList(YATATabsetPanel(pnl1, pnl2))
    list(left=NULL, main=main, right=NULL)
}
