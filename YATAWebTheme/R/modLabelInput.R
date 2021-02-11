modLabelInput = function(id) {
   ns = NS(id)   
   main = tagList(
          yataTitle("Tablas de datos")
         ,yataRow(markdown("Conjunto de funciones que generan etiquetas que pueden o no tener un valor inicial: `yuiLabelXXX`
            Se actualizan en el servidor mediante la familia de funciones: ```updLabelXXX```
         "))
         ,yataCols(column(3, h3("Etiqueta de texto simple")))
         ,yataCols(column(3,column(2, yuiLabelText(ns("lbl01"))), yuiBtnOK(ns("btnLbl01"), "actualiza")))
         ,yataCols(
            column(2, yuiLabelDate(ns("dt01"))), yuiBtnOK(ns("btnDt01"), "actualiza")
         )

      )   
   list(left=NULL, main=main, right=NULL)   
}
