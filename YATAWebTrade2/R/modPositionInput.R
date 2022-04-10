modPosInput = function(id, title) {
   ns = NS(id)
   WORD  = WEB$MSG$getWords()
   items = list(
        Pos     = list(label = WORD$POS,   plot=TRUE, table=TRUE)
       ,Session = list(label = WORD$SESS,  plot=TRUE, table=TRUE)
       ,Top     = list(label = WORD$TOP,   plot=TRUE, table=TRUE)
       ,Trend   = list(label = WORD$TREND, plot=TRUE, table=TRUE)
       ,Fav     = list(label = WORD$FAV,   plot=TRUE, table=TRUE)
       ,Full = list(label = paste(WORD$POS, WORD$FULL),  plot=TRUE, table=TRUE)
   )
   pairs        = c("Pos", "Session", "Top", "Best", "Trend", "Fav", "Full")
   names(pairs) = c( WORD$POS,   WORD$SESS, WORD$TOP, WORD$BEST
                    ,WORD$TREND, WORD$FAV,  paste(WORD$POS, WORD$FULL))
   vals = c("plotPos", "plotSession", "blkBest", "blkPos")
   wdgLayout = WDGLayout$new(ns, layout=c(2,2), pairs=pairs, values=vals)

   mon = fluidRow(column(4,"Monitors"), column(8, style="text-align: right;", guiCheck(ns("chkMonitors"))))

   left = tagList(
         fluidRow(column(4, "Updated:"),column(8, guiLabelDate(ns("dtLast"))))
        ,wdgLayout$getConfig()
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
            column(8, guiCombo(ns("cboBestPeriod"), choices=WEB$combo$reasons(),selected=2)))
        ,tags$br()
        ,yuiFlex(yuiBtnOK(ns("btnSave"), WORD$SAVE), yuiBtnKO(ns("btnClose"),WORD$CLOSE))
    )
    # pattern = "tags$div( id=ns('__NAME__'),style='width: 100%', guiBox(ns('__VALUE__')"
    # pattern = paste0(pattern, ", guiLabelText(ns('paste0('")
    # pattern = paste0(pattern, "'lbl',__VALUE__)), yuiTable(ns("tblBest"))))
    # pp = "tags$div( id=ns('__NAME__'),style='width: 100%', guiBox(ns('__VALUE__'), guiLabelText(ns('paste0(lblBest")), yuiTable(ns("tblBest"))))


    # blocks = tagList(
    #          yuiPlot(ns("plotPos"))
    #         ,yuiPlot(ns("plotSession"))
    #         ,yuiPlot(ns("plotTop"))
    #         ,yuiPlot(ns("plotBest"))
    #         ,yuiPlot(ns("plotFav"))
    #         ,tags$div( id=ns("blkBest"),style="width: 100%", guiBox(ns("Best")
    #                   ,guiLabelText(ns("lblBest")), yuiTable(ns("tblBest"))))
    #         ,tags$div( id=ns("blkTop") ,style="width: 100%", guiBox(ns("Top")
    #                   ,guiLabelText(ns("lblTop")),  yuiTable(ns("tblTop"))))
    #         ,tags$div( id=ns("blkFav") ,style="width: 100%", guiBox(ns("Fav")
    #                   ,guiLabelText(ns("lblFav")),  yuiTable(ns("tblFav"))))
    #         ,tags$div( id=ns("blkTrend") ,style="width: 100%", guiBox(ns("Trend")
    #                   ,guiLabelText(ns("lblTrend")),  yuiTable(ns("tblTrend"))))
    #         ,tags$div(id=ns("Position"), style="width: 100%;"
    #                  ,hidden(tags$div( id=ns("posGlobal")
    #                                   , guiBox( ns("PosGlobal")
    #                                            ,"Posicion Global", yuiTable(ns("tblPosGlobal")))))
    #                  ,hidden(tags$div(id=ns("PosCameras")))
    #         )
    #         ,tags$div(id=ns("PositionFull"), style="width: 100%;"
    #                  ,hidden(tags$div( id=ns("posGlobalFull")
    #                                   , guiBox( ns("PosGlobalFull")
    #                                            ,"Posicion Global Completa", yuiTable(ns("tblPosGlobalFull")))))
    #                  ,hidden(tags$div(id=ns("PosCamerasFull")))
    #         )
    #
    # )
    main = tagList( guiRow(id=ns("monitor"), class="yata_monitors"), wdgLayout$getLayout()) # wdgLayout$getBody(blocks))

    #header = tagList(btnIcon(id=ns("btnRefresh"), shiny::icon("sync")))

    list(left=left, main=main, right=NULL, header=NULL)
}
