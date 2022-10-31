YATAItem = function(id, name, icon=NULL,...) {
  ns = NS(id)

  args = list(...)
  html = NULL
  container = div(class = "tab-pane", title = name, `data-value` = id,
        `data-icon-class` = shiny:::iconClass(icon))
  if (length(args) == 0) {
      ui = paste0("mod", paste0(toupper(substring(name, 1,1)), substring(name, 2)), "Input")
      html = eval(parse(text=paste0(ui, "('", id, "')")))
  } else if (length(args) == 1 && is.character(args[[1]])) {
      module = args[[1]]
      html = eval(parse(text=paste0(module, "('", id, "')")))
  } else {
    html = args
  }
#  tagAppendChildren(container, html)
#panel1 = function(id) {
    tabPanel(name, value=id, html)

}


# Cada Item tiene:
# id
# nombre
# Devuelve:
# 1 - el item para el menu
# 2 - la parte izda
# 3 - la parte derecha
# 4 - el contenido

# panelNav = function(id, name, icon) {
#     # nav  = tags$li(class="nav-item")
#     # href = tags$a(id=id, class="nav-link", href=paste0("#", name), name)
#     # tagAppendChild(nav, href)
#     tags$li(name, id=id)
# }
# panelLeft = function(id) {
#   ns <- NS(id)
#   NULL
# }
# panelRight = function(id) {
#   ns <- NS(id)
#   NULL
# }
#
# panelMain = function(id, name) {
#   ns <- NS(id)
#   tagList(tags$p(paste("Pagina", name)))
# }
#
# # panel es un conjunto de cosas
# # o una clase
# # si es una clase llama a construct
# # si es otra cosa ....
# # por ejemplo lista o cosas .... pues ya veremos
# # O llama al cosntructor atuomatico
# YATAItem = function(id, name, panel=null, icon=NULL) {
#
#    # Llama al modulo indicado o a panel_id()
#    # Generamos siempre los 3 divs, asi ahorramos chequear si existen o no
#    # Siempre existen aunque esten vacios
#     ns <- NS(id)
#
#     divLeft  = tags$div(id=paste(id, "left", sep="-"),  style="display: none")
#     divRight = tags$div(id=paste(id, "right", sep="-"), style="display: none")
#     divMain  = tags$div(id=paste(id, "main", sep="-"),  style="display: none")
#
#     datNav   = panelNav(id, name, icon)
#     # datLeft  = panelLeft(id)
#     # datRight = panelRight(id)
#     # datMain  = panelMain(id, name)
#
#     if (!is.null(panel$left))  divLeft  = tagAppendChildren(divLeft, panel$left)
#     if (!is.null(panel$main))  divMain  = tagAppendChildren(divMain, panel$main)
#     if (!is.null(panel$right)) divRight = tagAppendChildren(divRight, panel$right)
#
#     list(id=id, nav = datNav, left=divLeft, main = divMain, right = divRight)
#
# }
