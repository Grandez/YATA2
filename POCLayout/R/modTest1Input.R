modTest1Input = function(id, title) {
    ns = shiny::NS(id)
    left = tagList(h3("Panel Izquierdo"))
    main = tagList(h1("Pagina principal"))
    list(left=left, main=main, right=NULL)
}
