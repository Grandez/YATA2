modPosInput = function(id, title) {
    ns = NS(id)
    blocks = c( "Plot Position"  = "plotHist", "Plot Session" = "plotSession"
               ,"Plot Best"      = "plotBest", "Plot Top"     = "plotTop"
               ,"Plot Favorites" = "plotFav"
               ,"Position"       = "Position", "Best"              = "blkBest"
               ,"Best of Top"    = "blkTop"  , "Best of favorites" = "blkFav"
    )
    vals = c("plotHist", "plotSession", "blkBest", "Position")
    mon = fluidRow(column(4,"Monitors"), column(8, style="text-align: right;", guiCheck(ns("chkMonitors"))))

#   wdgLayout = wdgLayout$new(ns, c(2,2), blocks, values=vals, top = mon)
       wdgLayout = WDGLayout$new(ns, c(2,2), blocks, values=vals)
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
        ,fluidRow(column(4, "Top"),    column(8, guiIntegerInput(ns("numBestTop"),value=15,step=1,min=5,max=30)))
        ,fluidRow(column(4, "Period"), column(8, guiCombo(ns("cboBestFrom"), 
                                                   choices=c("Hora"=1,"Dia"=2,"Semana"=3,"Mes"=4),selected=2)))
        ,tags$br()
        ,yuiFlex(yuiBtnOK(ns("btnLayoutOK"),"Guardar"), yuiBtnKO(ns("btnLayoutKO"),"Cerrar"))
    )

    blocks = tagList(
             yuiPlot(ns("plotHist"))
            ,yuiPlot(ns("plotSession"))
            ,yuiPlot(ns("plotTop"))
            ,yuiPlot(ns("plotBest"))
            ,yuiPlot(ns("plotFav"))
            ,tags$div(id=ns("blkBest"),style="width: 100%", guiBox(ns("Best"), guiLabelText(ns("lblBest")), yuiTable(ns("tblBest"))))
            ,tags$div(id=ns("blkTop") ,style="width: 100%", guiBox(ns("Top"),  guiLabelText(ns("lblTop")),  yuiTable(ns("tblTop"))))
            ,tags$div(id=ns("blkFav") ,style="width: 100%", guiBox(ns("Fav"),  guiLabelText(ns("lblFav")),  yuiTable(ns("tblFav"))))
            ,tags$div(id=ns("Position"), style="width: 100%;"
                     ,hidden(tags$div(id=ns("posGlobal"), guiBox(ns("PosGlobal"), "Posicion Global", yuiTable(ns("tblPosGlobal")))))
                     ,hidden(tags$div(id=ns("PosCameras")))
            )
    )
    main = tagList( guiRow(id=ns("monitor"), class="yata_monitors"), wdgLayout$getBody(blocks))
    
    list(left=left, main=main, right=NULL)           
}
