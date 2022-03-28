# -----------------------------------------------------------------------
# 'Internal' tabset logic that was pulled directly from shiny/R/bootstrap.R
#  (with minor modifications)
# -----------------------------------------------------------------------

jgg_bslib_navbarPage_ <- function(id, ...) {

  navbarClass <- "navbar navbar-default navbar-static-top"
  tabset = bslib_buildTabset( ...
                             ,ulClass = "nav navbar-nav", textFilter=NULL, id = id
                             ,selected = NULL, foundSelected = FALSE)
  # Aqui tenemos las dos partes

  contentDiv = div(id="jgg_tab_content", class = c("container-fluid"))
  contentDiv = tagAppendChild(contentDiv, tabset$content)

  tagList( navList=tags$nav(class = navbarClass, role = "navigation", tabset$navList)
          ,content=contentDiv
  )

}
jgg_bslib_navs_bar_full = function (webtitle, titleActive, id, ...) {
    # Tiene Panel derecho y panel izquiero
    webtitle=NULL
    tabset = jgg_bslib_navbarPage_(id, ...)

    containerDiv = div(class = "container-fluid"
                       ,div(class = "navbar-header"
                            ,span(class = "navbar-brand", webtitle)
                        )
                       , tabset$navList)

    containerClass = "navbar navbar-default"
    nav = tags$nav(class = containerClass, role = "navigation", containerDiv)

    # content = div(class = containerClass)
    # content = tagAppendChild(content, tabset$content)

    jgg_make_container_full(nav, tabset$content, titleActive)
}
jgg_make_container_full = function (nav, content, titleActive) {
   contentDiv = shiny::tags$div(id="jgg_page")
   divHeader  = shiny::tags$div(id="jgg_page_header", class="jgg_header row" )
   divBody    = shiny::tags$div(id="jgg_page_body",   class="jgg_body container-fluid"   )
   divFooter  = shiny::tags$div(id="jgg_page_footer", class="jgg_footer" )

   divHeader = jgg_make_page_header(divHeader, nav, titleActive)

   divMain  = shiny::tags$div(id="jgg_page_main",  class="jgg_page_main"  )
   divLeft  = shiny::tags$div( id="jgg_page_left"
                              ,class="w-25 h-100 jgg_page_left jgg_side_hide"  )

   divRight = shiny::tags$div( id="jgg_page_right"
                              ,class="w-25 h-100 jgg_page_right jgg_side_hide" )

   divFooter = tagAppendChild(divFooter, tags$span("YATA - Grandez"))

  #  children = content$children
  #  children = children[[1]]$children
  #  pages = content$children
  #  for (idx in 1:length(pages)) {
  #      page = pages[[idx]]$children[[1]] # Aqui son 5
  #      if (!is.null(page$left))  divLeft  = tagAppendChild(divLeft,  page$left)
  #      if (!is.null(page$right)) divRight = tagAppendChild(divRight, page$right)
  #      page$left  = NULL
  #      page$right = NULL
  #      divMain    = tagAppendChild(divMain, page)
  #  }

  # contentDiv <- div(class = containerClass)
  # if (!is.null(header))
  #   contentDiv <- tagAppendChild(contentDiv, div(class = "row", header))
  # contentDiv <- tagAppendChild(contentDiv, tabset$content)
  # if (!is.null(footer))
  #   contentDiv <- tagAppendChild(contentDiv, div(class = "row", footer))

   divBody   = tagAppendChildren(divBody, content) # divLeft, divMain, divRight)
   page = tags$div(class="jgg_page", divHeader, divBody, divFooter)
   tags$div(id="jgg_container", class="jgg_container", page, .mainFormError())
}

jgg_make_container = function (nav, content, titleActive) {
    browser()
   contentDiv = shiny::tags$div(id="jgg_page")
   divHeader  = shiny::tags$div(id="jgg_page_header", class="jgg_header row" )
   divBody    = shiny::tags$div(id="jgg_page_body",   class="jgg_body"   )
   divFooter  = shiny::tags$div(id="jgg_page_footer", class="jgg_footer" )

   divHeader = jgg_make_page_header(divHeader, nav, titleActive)

   divLeft  = shiny::tags$div(id="jgg_page_left",  class="jgg_page_left"  )
   divMain  = shiny::tags$div(id="jgg_page_main",  class="jgg_page_main"  )
   divRight = shiny::tags$div(id="jgg_page_right", class="jgg_page_right" )

   divBody   = tagAppendChild(divBody, content)
   divFooter = tagAppendChild(divFooter, tags$span("YATA - Grandez"))

   page = tags$div(class="jgg_page", divHeader, divBody, divFooter)
   tags$div(id="jgg_container", class="jgg_container", page, .mainFormError())
}

.mainFormError = function() {
    divInner = tags$div(
         class="jgg_clearfix"
        ,fluidRow( imageOutput("jgg_main_img_err", inline=TRUE)
                  ,tags$span(class="jgg_text_err", textOutput("jgg_main_text_err")))
        )
    pnlErr =  tags$div( id="jgg_main_err"
                       ,class="jgg_panel_err"
                       ,tags$div( class="jgg_panel_err_container"
                                 ,divInner))
    shinyjs::hidden(pnlErr)
}


jgg_make_page_header <- function(parent, nav, titleActive = FALSE, titleWidth = NULL,
                            disable = FALSE, .list = NULL,
                            controlbarIcon = shiny::icon("chevron-left"), fixed = FALSE) {
    # Hacemos 3 columnas
    # Titulo y iconos de abrr cerrar
    # Menu principal
    # Iconos de la barra derecha

    button_left = shiny::tags$a( href = "#", id="jgg_left_side"
        ,class = "jgg_sidebar_toggle"
        ,role  = "button"
        ,`data-toggle` = "jgg_left_button" # javascript
        ,shiny::tags$span( id="jgg_left_side_open"
               ,shiny::icon( "chevron-right" ,"fa-lg"
                            ,style="padding-top: 12px")
              )
              ,shiny::tags$span( id="jgg_left_side_close"
                                ,class="jgg_button_side_hide"
                                ,shiny::icon( "chevron-left" ,"fa-lg"
                                ,style= "padding-top: 12px")
               )
    )
    button_right = shiny::tags$a( href = "#", id="jgg_right_side"
        ,class = "jgg_sidebar_toggle"
        ,role  = "button"
        ,`data-toggle` = "jgg_right_button" # javascript
        ,shiny::tags$span( id="jgg_right_side_open"
                          ,shiny::icon( "cog" ,"fa-lg"
                          ,style="padding-top: 12px"))
        ,shiny::tags$span( id="jgg_right_side_close"
                          ,class="jgg_button_side_hide"
                          ,shiny::icon( "chevron-right" ,"fa-lg"
                          ,style= "padding-top: 12px"))
    )

    divBrand = tags$div(id="jgg_brand", class="col-lg-1")
    if (titleActive) {
        span = shiny::tags$span( class="navbar-brand jgg_brand jgg_clickable"
                                ,onclick="Shiny.setInputValue('app_title', 'click');")
    } else {
        span = shiny::tags$span( class="navbar-brand jgg_brand")
    }
    span = tagAppendChild(span, textOutput("app_title", inline=TRUE))
    divBrand = tagAppendChildren(divBrand
        ,span
        ,shiny::tags$span(shiny::icon("bars"), style = "display:none;")   # para la dependencia
        ,button_left
    )

    divNav = tags$div(id="jgg_nav_bar", class="navbar jgg_nav_left col-lg-10", nav)

    #JGG Aqui falta poner el menu
    divRight = tags$div(class="col-lg-1", style="float: 'right';")
    divRight = tagAppendChildren(divRight, button_right)

    tagAppendChildren(parent, divBrand, divNav, divRight)
}
