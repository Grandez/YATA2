jgg_make_container = function (nav, content, titleActive) {
   contentDiv = shiny::tags$div(id="jgg_page")
   divHeader  = shiny::tags$div(id="jgg_page_header", class="row bg-dark jgg_header" )
   divBody    = shiny::tags$div(id="jgg_page_body",   class="jgg_body"   )
   divFooter  = shiny::tags$div(id="jgg_page_footer", class="jgg_footer" )

   divHeader = jgg_make_page_header(divHeader, nav, titleActive)
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
                            ,class = "jgg_sidebar_toggle", role = "button"
                            ,`data-toggle` = "jgg_left_button" # javascript
                            ,shiny::tags$span( id="left_side_open", class="jgg_side_open"
                                              ,shiny::icon( "chevron-right" ,"fa-lg"
                                              ,style="padding-top: 12px"))
                            ,shiny::tags$span( id="left_side_close", class="jgg_side_closed"
                                              ,shiny::icon( "chevron-left" ,"fa-lg"
                                                           ,style= "padding-top: 12px"))
                      )
    button_right = shiny::tags$a( href = "#", id="jgg_right_side"
                            ,class = "jgg_sidebar_toggle", role = "button"
                            ,`data-toggle` = "jgg_right_button" # javascript
                            ,shiny::tags$span( id="right_side_open", class="jgg_side_open"
                                              ,shiny::icon( "cog" ,"fa-lg"
                                              ,style="padding-top: 12px"))
                            ,shiny::tags$span( id="right_side_close", class="jgg_side_closed"
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
