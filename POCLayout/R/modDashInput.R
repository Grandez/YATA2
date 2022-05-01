
modDashInput = function(id, title) {
   ns = NS(id)
lay = JGGLayout$new(ns("layout"), blocks=list(items=list( block01 = list(label = "Bloque 1")
                           ,block02 = list(label = "Bloque 2")
                           ,block03 = list(label = "Bloque 3")
                           ,block04 = list(label = "Bloque 4")
                          )
                ,selected = c("lbl_block01","lbl_block02","lbl_block03","lbl_block04")
                ,widgets = list( tbl    = list(lblSuffix="Data", widget="reactableOutput" )
                                ,plot   = list(lblPreffix="Plot", widget="plotlyOutput" )
                                ,lbl    = list(lblPreffix="Label")
                               )
               )
)
   left = tagList(lay$config())
   main = tagList(lay$body())
   list(left=left, main=main, right=NULL, header=NULL)
}
