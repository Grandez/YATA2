modTableInput = function(id) {
   ns = NS(id)   
   main = tagList(
          yataTitle("Tablas de datos")
         ,yataRow(markdown("Cada tabla encapsula un tipo de datos para poder dar diferentes estilos
              Se basan en el paquete YATADT que es una copia de DT
              La interfaz es siempre yuiDataTable
         "))
         ,yuiTable(ns("tbl01"))
      )   
   list(left=NULL, main=main, right=NULL)   
}
