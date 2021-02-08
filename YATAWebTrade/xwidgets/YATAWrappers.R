showLeftBar   = function() { .toggleSideBar(TRUE,  TRUE)  }
HideLeftBar   = function() { .toggleSideBar(FALSE, TRUE)  }
showRighttBar = function() { .toggleSideBar(TRUE,  FALSE) }
HideRightBar  = function() { .toggleSideBar(FALSE, FALSE) } 

iconBarShow  = function(side) { shinyjs::showElement(selector=paste0("#YATAIconNav-", side)) }
iconBarHide  = function(side) { shinyjs::hideElement(selector=paste0("#YATAIconNav-", side)) }

toggleLeftBar      = function()          { toggleSideBar(T) }
toggleRightBar     = function()          { toggleSideBar(F) }
toggleSideBar      = function(left) { 
    selector = ifelse(left, "#YATALeftSide", "#YATARightSide")
    shinyjs::toggle(selector=selector, anim=T)
    shinyjs::runjs(paste0("YATAToggleSideBar(", left, ")")) 
}

updateIconsRightBar = function() { }
updateIconsLefttBar = function() { }

makePage = function(id, left=NULL, main=NULL, right=NULL, modal=NULL) {
  ns <- NS(id)
  useShinyjs()
  
  divLeft  = NULL
  divMain  = NULL
  divRight = NULL
  divModal = NULL
  
  if (!is.null(left))  divLeft  = div(id = ns("left"),  left)
  if (!is.null(main))  divMain  = div(id = ns("main"),  class="YATAMainPanel", main)
  if (!is.null(right)) divRight = div(id = ns("right"), right)
  
  if (!is.null(modal)) {
    divContainer = div(id=ns("container"), class="YATAContainer")
    #divModal     = div(id=ns("modal-back"),class="YATAModalBack")
    divModal     = div(id=ns("modal-panel"), class="YATAModalPanel", wellPanel(modal))
    divContainer = tagAppendChild(divContainer, hidden(divModal)) 
    # divContainer = tagAppendChild(divContainer, hidden(div(id=ns("modal-panel"), class="YATAModalPanel", wellPanel(modal))))
    divContainer = tagAppendChild(divContainer, divMain)
    divMain = divContainer
  }
  tagList(divLeft, divMain, divRight)
}

#################################################################
### PAGE MENU 
#################################################################

menuTab = function(idMenu, choices=NULL, selected=NULL, names=NULL, values=NULL) {
    sel = selected
    mnu = NULL
    if (!is.null(choices)) {
      if (class(choices) == "list") choices = unlist(choices)
      if (is.null(sel)) sel = choices[1]
      mnu = radioGroupButtons(idMenu, choices = choices, label = NULL,  
                                selected = sel, direction="horizontal", size="lg",
                                justified = FALSE, status = "menu")
      
              
    }
    else {
      mnu = radioGroupButtons(idMenu, choiceNames = names, choiceValues = values, label = NULL,  
                              selected = selected, direction="horizontal", size="lg",
                              justified = FALSE, status = "menu")
    }
    tagList(mnu, hr(class="hr-menu"))
}
updateMenuTab = function(session, idMenu, label=NULL, choices=NULL, selected=NULL,
                         status="menu", size="normal",choiceNames=NULL, choiceValues=NULL) {
  updateRadioGroupButtons(session, idMenu, label=label, choices=choices, selected= selected
                                 , choiceNames = choiceNames, choiceValues = choiceValues
                                 , status = status, size = size)
}

#################################################################
### Iconos de las barras
#################################################################

YATAIconNav = function (left=TRUE, icons) 
{
    lib = "font-awesome"
    suffix = ifelse(left, "left", "right")
    class = paste0("nav navbar-icon-", suffix)
    
    icons = .getIcons(icons)
    
    jscall = paste0("YATAToggleSideBar((0 == ", ifelse(left, 0, 1), "), ")
    iconTagOn <- tags$span(id=paste0("YATAIconNav-", suffix, "-on")
                           , class="navbar-icon"
                           , style="display: inline-block;",
                           tags$i(class = icons[[1]], onclick=htmlwidgets::JS(paste0(jscall, "(0 == 0))"))))
    iconTagOff <- tags$span(id=paste0("YATAIconNav-", suffix, "-off")
                            , class="navbar-icon"
                            , style="display: none;", 
                            tags$i(class = icons[[2]], onclick=htmlwidgets::JS(paste0(jscall, "(0 == 1))"))))
    
    container = tags$div(id=paste0("YATANav-", suffix), style=paste0("float: ", suffix, ";"), class="navbar-nav shinyjs-show")
    container = tagAppendChild(container, iconTagOn)
    container = tagAppendChild(container, iconTagOff)
    container
}

.getIcons = function(icons) {
    #lib = "font-awesome"
    lib = "glyphicon"
    # Poner como lista de caracteres
    names = icons
    if (is.null(names)) names ="menu-hamburger"
    if (class(icons) == "list") names = unlist(icons)
    
    # Obtener la libreria si hay
    pos = which(names(names) == "lib")
    if (length(pos) > 0) {
        lib = names[pos]
        names = names[-pos]
    }
    # Crear dos items (1 = On, 2 = Off)
    if (length(names) == 1) names = c(names, names)
    
    iconOn  = .mountIcon(names[1], lib)
    iconOff = .mountIcon(names[2], lib)
    
    list(iconOn, iconOff)
}
.mountIcon <- function(name, lib) {
    prefixes <- list(`font-awesome` = "fa", glyphicon = "glyphicon")
    prefix <- prefixes[[lib]]
    
    iconClass = ""
    prefix_class <- prefix
    if (prefix_class == "fa" && name %in% font_awesome_brands) {
        prefix_class <- "fab"
    }
    paste0(prefix_class, " ", prefix, "-", name)
}
