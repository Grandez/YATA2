modOperHistInput = function(id, title="") {
    ns = NS(id)
    blocks = c("Plot" = "plotOpen", "Data"="data", "None"="none")
    left = tagList(
         fluidRow(column(4, "Up"),   column(8, yuiCombo(ns("cboUp"), choices=blocks, selected="plot")))
        ,fluidRow(column(4, "Down"), column(8, yuiCombo(ns("cboDown"), choices=blocks, selected="data")))
        ,fluidRow(column(4, yuiTitle(6, "Show cancelled"))
                 ,column(8, style="text-align: right;", yuiCheck(ns("chkCancelled")))
          )
        ,fluidRow(column(4, yuiTitle(6, "Show Derivatives"))
                 ,column(8, style="text-align: right;", yuiCheck(ns("chkSon")))
          )
        
    )

    main = tagList(h2("Historia de operaciones")
        ,fluidRow(yuiBox(ns("opClosed"), "Operaciones Cerradas",   yuiDataTable(ns("tblDetClosed"))))
        ,fluidRow(yuiBox(ns("opExec"),   "Operaciones ejecutadas", yuiDataTable(ns("tblDetExec"))))          
    )
    list(left=left, main=main, right=NULL)
}