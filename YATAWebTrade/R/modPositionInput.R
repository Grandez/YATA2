modPosInput = function(id, title) {
    ns = NS(id)
    blocks = c( "Plot Position"  = "plotHist", "Plot Session" = "plotSession"
               ,"Plot Best"      = "plotBest", "Plot Top"     = "plotTop"
               ,"Plot Favorites" = "plotFav"
               ,"Position"       = "Position", "Best"              = "blkBest"
               ,"Best of Top"    = "blkTop"  , "Best of favorites" = "blkFav"
    )
    vals = c("plotHist", "plotSession", "blkBest", "Position")
    mon = fluidRow(column(4,"Monitors"), column(8, style="text-align: right;", yuiCheck(ns("chkMonitors"))))

   objLayout = OBJLayout$new(ns, c(2,2), blocks, values=vals, top = mon)
#   left = tagList( objLayout$getConfig())
    
    left = tagList(
         fluidRow(column(4, "Updated:"),column(8, yuiLabelDate(ns("dtLast"))))
        ,objLayout$getConfig()
        ,fluidRow(column(4, "Interval"),column(8, yuiNumericInput(ns("numInterval"))))
        ,fluidRow(column(4, "History") ,column(8, yuiNumericInput(ns("numHistory"), value=15,step=1,min=7,max=90)))
        ,hr() 
        
        ,yuiTitle(5, "Show")
        ,fluidRow(column(4, "Operations"),column(8, style="text-align: right;", yuiCheck(ns("chkOper"))))
        ,fluidRow(column(4, "Position"),  column(8, style="text-align: right;", yuiRadio(ns("radPosition")
                                                      , choices=c("All", "Global", "Cameras")
                                                      , selected="All"))
          )
        ,hr()
        ,yuiTitle(5, "Best")
        ,fluidRow(column(4, "Top"),    column(8, yuiIntegerInput(ns("numBestTop"),value=15,step=1,min=5,max=30)))
        ,fluidRow(column(4, "Period"), column(8, yuiCombo(ns("cboBestFrom"), 
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
            ,tags$div(id=ns("blkBest"),style="width: 100%", yuiBox(ns("Best"), yuiLabelText(ns("lblBest")), yuiDataTable(ns("tblBest"))))
            ,tags$div(id=ns("blkTop") ,style="width: 100%", yuiBox(ns("Top"),  yuiLabelText(ns("lblTop")),  yuiDataTable(ns("tblTop"))))
            ,tags$div(id=ns("blkFav") ,style="width: 100%", yuiBox(ns("Fav"),  yuiLabelText(ns("lblFav")),  yuiDataTable(ns("tblFav"))))
            ,tags$div(id=ns("Position"), style="width: 100%;"
                    ,hidden(tags$div(id=ns("posGlobal"), 
                                     yuiBox(ns("PosGlobal"), "Posicion Global", yuiDataTable(ns("tblPosGlobal")))))
                    ,hidden(tags$div(id=ns("PosCameras")))
            )
    )
    main = tagList( fluidRow(id=ns("monitor")) # fluidRow(tags$div(id=ns("monitor"), class="yata_monitors"))
                   ,objLayout$getBody(blocks)
    )
    list(left=left, main=main, right=NULL)           
}
