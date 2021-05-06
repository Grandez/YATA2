modHistSummInput = function(id, title="") {
    ns = NS(id)
    main = tagList(h2("Historia de operaciones")
        ,fluidRow(column(6, yuiPlot(ns("plotRevenue"))))
        ,fluidRow(column(6, yuiTable(ns("tblRevenue"))))
        # ,fluidRow(yuiBox(ns("opClosed"), "Operaciones Cerradas",   yuiDataTable(ns("tblDetClosed"))))
        # ,fluidRow(yuiBox(ns("opExec"),   "Operaciones ejecutadas", yuiDataTable(ns("tblDetExec"))))          
    )
    list(left=NULL, main=main, right=NULL)
}