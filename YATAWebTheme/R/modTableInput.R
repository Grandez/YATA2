modTableInput = function(id) {
   ns = NS(id)   
   main = tagList(
          yataTitle("Tablas de datos")
         ,yataRow(markdown("Cada tabla encpasula un tipo de datos para poder dar diferentes estilos
              Se basan en el paquete YATADT que es una copia de DT
              La interfaz es siempre yuiDataTable
         "))
         ,yuiDataTable(ns("tblPos01"))
      )   
   list(left=NULL, main=main, right=NULL)   
}
