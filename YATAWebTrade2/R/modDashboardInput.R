WORD  = WEB$msg$getWords()
wdgTable = 'guiBox(ns(box),guiLabelText(ns(lbl)), yuiTable(ns(tbl)))'
layoutDashboard = JGGLayout$new("layout"
      ,items=list( Pos     = list(label = WORD$POS)
                  ,Session = list(label = WORD$SESS)
                  ,Top     = list(label = WORD$TOP)
                  ,Best    = list(label = WORD$BEST)
                  ,Trend   = list(label = WORD$TREND)
                  ,Fav     = list(label = WORD$FAV)
                  ,Full    = list(label = WORD$FULL)
             )
        ,selected = c("tbl_Best", "tbl_Top", "tbl_Full", "tbl_Pos")
        ,widgets = list( tbl  = list(lblSuffix="Data", widget=wdgTable )
                        ,plot = list(lblPreffix="Plot") #, widget="plotlyOutput" )
#                                ,lbl    = list(lblPreffix="Label")
)
)

modDashInput = function(id, title) {
   ns = NS(id)

   mon = fluidRow(column(4,"Monitors"), column(8, style="text-align: right;", guiCheck(ns("chkMonitors"))))

   left = tagList(
         fluidRow(column(4, "Updated:"),column(8, guiLabelDate(ns("dtLast"))))
        #,wdgLayout$getConfig()
        ,layoutDashboard$config(ns)
        ,fluidRow(column(4, "Selective"),column(8, guiNumericInput(ns("numSelective"))))
        ,fluidRow(column(4, "Interval"), column(8, guiNumericInput(ns("numInterval"))))
        ,fluidRow(column(4, "History") , column(8, guiNumericInput(ns("numHistory"), value=15,step=1,min=7,max=90)))
        ,hr()

        ,yuiTitle(5, "Show")
        ,fluidRow(column(4, "Operations"),column(8, style="text-align: right;", guiCheck(ns("chkOper"))))
        ,fluidRow(column(4, "Position"),  column(8, style="text-align: right;", guiRadio(ns("radPosition")
                                                      , choices=c("All", "Global", "Cameras")
                                                      , selected="All"))
          )
        ,hr()
        ,yuiTitle(5, "Best")
        ,fluidRow(column(4, "Top"),
            column(8, guiIntegerInput(ns("numBestTop"),value=15,step=1,min=5,max=30)))
        ,fluidRow(column(4, "Period"),
            column(8, guiCombo(ns("cboBestPeriod"), choices=WEB$combo$periods(),selected=2)))
        ,tags$br()
        ,yuiFlex(yuiBtnOK(ns("btnSave"), WORD$SAVE), yuiBtnKO(ns("btnClose"),WORD$CLOSE))

    )
    main = tagList( guiRow(id=ns("monitor"), class="yata_monitors")
            # ,tags$div(id=ns("Position"), style="width: 100%;"
            #          ,hidden(tags$div( id=ns("posGlobal")
            #                           , guiBox( ns("PosGlobal")
            #                                    ,"Posicion Global", yuiTable(ns("tblPosGlobal")))))
            #          ,hidden(tags$div(id=ns("PosCameras")))
            # )
            # ,tags$div(id=ns("PositionFull"), style="width: 100%;"
            #          ,hidden(tags$div( id=ns("posGlobalFull")
            #                           , guiBox( ns("PosGlobalFull")
            #                                    ,"Posicion Global Completa", yuiTable(ns("tblPosGlobalFull")))))
            #          ,hidden(tags$div(id=ns("PosCamerasFull")))
            # )
            # ,tags$div( id=ns("blkBest"),style="width: 100%", guiBox(ns("Best")
            #           ,guiLabelText(ns("lblBest")), yuiTable(ns("tblBest"))))
            # ,tags$div( id=ns("blkTop") ,style="width: 100%", guiBox(ns("Top")
            #           ,guiLabelText(ns("lblTop")),  yuiTable(ns("tblTop"))))
            # ,tags$div( id=ns("blkFav") ,style="width: 100%", guiBox(ns("Fav")
            #           ,guiLabelText(ns("lblFav")),  yuiTable(ns("tblFav"))))
            # ,tags$div( id=ns("blkTrend") ,style="width: 100%", guiBox(ns("Trend")
            #           ,guiLabelText(ns("lblTrend")),  yuiTable(ns("tblTrend"))))
            #
        , layoutDashboard$body(ns))
        #wdgLayout$getLayout()) # wdgLayout$getBody(blocks))

    #header = tagList(btnIcon(id=ns("btnRefresh"), shiny::icon("sync")))

    list(left=left, main=main, right=NULL, header=NULL)
}
