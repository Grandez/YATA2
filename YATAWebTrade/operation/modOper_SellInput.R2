modOperSellInput2 = function(id, title) {
    ns = NS(id)
    
    main = tagList( yuiFormTable(6
                   ,yuiFormRow( "Camara", yuiCombo(ns("cboCamera"), choices=list(" "))
                               ,"" 
                               ,"Moneda", yuiCombo(ns("cboCounter"),   choices=list(" ")))
                      )
                  )
   list(left=NULL, main=main,right=NULL)  
}