.yataPageHeader <- function(..., tabnav, title = NULL, titleWidth = NULL,
                            disable = FALSE, .list = NULL, leftUi = NULL,
                            controlbarIcon = shiny::icon("chevron-left"), fixed = FALSE) {
    items = NULL
    # handle left menu items

    if (!is.null(leftUi)) {
        left_menu_items = lapply(seq_along(leftUi), FUN = function(i) {
           left_menu_item = leftUi[[i]]
            name = left_menu_item$name
            class = left_menu_item$attribs$class

            # if the left menu item is not a li tag and does not have
            # the dropdown class, create a wrapper to make it work
            if (name != "li" || !is.null(class) || class != "dropdown") {
                dropdownTag <- shiny::tags$li(class = "dropdown")
                left_menu_item <- shiny::tagAppendChild(dropdownTag, left_menu_item)
                # add some custom css to make it nicer
                left_menu_item = tagAppendAttributes(left_menu_item,
                                         style = "margin-top: 7.5px; margin-left: 5px; margin-right: 5px;")
            } else {
               left_menu_item
            }
         })
    } else {
        left_menu_items <- leftUi
    }

    custom_css <- NULL
    tags$div(class="yata_header",
         tags$div(style="float: left;",

         shiny::tags$span(class="navbar-brand yata_brand", textOutput("appTitle", inline=TRUE)),
         # Embed hidden icon so that we get the font-awesome dependency
         shiny::tags$span(shiny::icon("bars"), style = "display:none;"),
         shiny::tags$a(href = "#",  id="leftButton", # Sidebar toggle button
                class = "sidebar-toggle",
                `data-toggle` = "yataoffcanvas", # esto es para detectarlo en javascript
                 role = "button"
                ,shiny::tags$span( id="left_side_closed"
                                  ,class="yata_side_open"
                                  ,shiny::icon("chevron-right fa-lg", style="padding-top: 12px"))
                ,shiny::tags$span( id="left_side_open"
                                  ,class="yata_side_closed"
                                  ,shiny::icon("chevron-left fa-lg", style= "padding-top: 12px"))
         )),
         shiny::div(class="navbar yata_nav_left", tabnav),
         shiny::tags$div(id="yata_right_menu_btn", # right menu
                         class = "navbar-custom-menu yata_nav_right",
                         shiny::tags$ul(class = "nav navbar-nav", items,
                                        shiny::tags$li(shiny::tags$a(href = "#",
                                                      `data-toggle` = "control-sidebar",controlbarIcon))
                        )
         )
     )
}

