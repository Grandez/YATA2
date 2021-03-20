
.yataPageHeader <- function(..., tabnav, title = NULL, titleWidth = NULL,
                            disable = FALSE, .list = NULL, leftUi = NULL,
                            controlbarIcon = shiny::icon("chevron-left"), fixed = FALSE) {
  items = NULL
  # handle left menu items

  if (!is.null(leftUi)) {
    left_menu_items <- lapply(seq_along(leftUi), FUN = function(i) {
      left_menu_item <- leftUi[[i]]
      name <- left_menu_item$name
      class <- left_menu_item$attribs$class

      # if the left menu item is not a li tag and does not have
      # the dropdown class, create a wrapper to make it work
      if (name != "li" || !is.null(class) || class != "dropdown") {
        dropdownTag <- shiny::tags$li(class = "dropdown")
        left_menu_item <- shiny::tagAppendChild(dropdownTag, left_menu_item)
        # add some custom css to make it nicer
        left_menu_item <- shiny::tagAppendAttributes(
          left_menu_item,
          style = "margin-top: 7.5px; margin-left: 5px; margin-right: 5px;"
        )
      } else {
        left_menu_item
      }
    })
    # when left_menu is null, left_menu_items are also NULL
  } else {
    left_menu_items <- leftUi
  }

    custom_css <- NULL
#    shiny::tags$header(
           tags$div(class="yata_header",
#    tags$div(s
#      class = "main-header",
      # custom_css,
      # style = if (disable) "display: none;",
             tags$div(style="float: left;",


      shiny::tags$span(class="navbar-brand yata-brand", textOutput("appTitle", inline=TRUE)),
            # Embed hidden icon so that we get the font-awesome dependency
      shiny::tags$span(shiny::icon("bars"), style = "display:none;"),
      # Sidebar toggle button
      shiny::tags$a(
        href = "#",
        class = "sidebar-toggle",
        # esto es para detectarlo en javascript
        `data-toggle` = "yataoffcanvas",
        role = "button",
#        shiny::tags$span(class = "sr-only"), "Toggle navigation")
        shiny::tags$span(shiny::icon("bars", style="padding-top: 18px;")) #, "Toggle navigation")
      )),

      # shiny::tags$a(
      #    href = "#",
      #   class = "sidebar-toggle",
      #   `data-toggle` = "yataoffcanvas",
      #   role = "button",
      #   shiny::tags$span(class = "sr-only", "Toggle navigation")
      # ),
      shiny::div(class="navbar yata-nav-left", tabnav),
      # right menu
      shiny::tags$div(id="yata-right-menu-btn",
        class = "navbar-custom-menu yata-nav-right",
        shiny::tags$ul(class = "nav navbar-nav", items,
                       shiny::tags$li(shiny::tags$a(href = "#",`data-toggle` = "control-sidebar",controlbarIcon))
        )
      )
    )
}
.yataPageHeader2 <- function(..., title = NULL, titleWidth = NULL,
                            disable = FALSE, .list = NULL, leftUi = NULL,
                            controlbarIcon = shiny::icon("gears"), fixed = FALSE) {
  # handle right menu items
  items <- c(list(...), .list)
  lapply(items, tagAssert, type = "li", class = "dropdown")

  # handle left menu items
  if (!is.null(leftUi)) {
    left_menu_items <- lapply(seq_along(leftUi), FUN = function(i) {
      left_menu_item <- leftUi[[i]]
      name <- left_menu_item$name
      class <- left_menu_item$attribs$class

      # if the left menu item is not a li tag and does not have
      # the dropdown class, create a wrapper to make it work
      if (name != "li" || !is.null(class) || class != "dropdown") {
        dropdownTag <- shiny::tags$li(class = "dropdown")
        left_menu_item <- shiny::tagAppendChild(dropdownTag, left_menu_item)
        # add some custom css to make it nicer
        left_menu_item <- shiny::tagAppendAttributes(
          left_menu_item,
          style = "margin-top: 7.5px; margin-left: 5px; margin-right: 5px;"
        )
      } else {
        left_menu_item
      }
    })
    # when left_menu is null, left_menu_items are also NULL
  } else {
    left_menu_items <- leftUi
  }

  titleWidth <- shiny::validateCssUnit(titleWidth)

  # Set up custom CSS for custom width.
  custom_css <- NULL
  if (!is.null(titleWidth)) {
    # This CSS is derived from the header-related instances of '230px' (the
    # default sidebar width) from inst/AdminLTE/AdminLTE.css. One change is that
    # instead making changes to the global settings, we've put them in a media
    # query (min-width: 768px), so that it won't override other media queries
    # (like max-width: 767px) that work for narrower screens.
    custom_css <- shiny::tags$head(
      shiny::tags$style(
        shiny::HTML(
          gsub(
            "_WIDTH_",
            titleWidth,
            fixed = TRUE,
            '@media (min-width: 768px) {
              .main-header > .navbar {
                margin-left: _WIDTH_;
              }
              .main-header .logo {
                width: _WIDTH_;
              }
             }
              '
          )
        )
      )
    )
  }

  shiny::tags$header(
    class = "main-header",
    custom_css,
    style = if (disable) "display: none;",
    # only hide on small screen devices when title is NULL
    shiny::tags$span(class = if (is.null(title)) "logo hidden-xs" else "logo", title),
    shiny::tags$nav(
      class = paste0("navbar navbar-", if (fixed) "fixed" else "static", "-top"),
      role = "navigation",
      # Embed hidden icon so that we get the font-awesome dependency
#JGG      shiny::tags$span(shiny::icon("chevronleft"), style = "display:none;"),
      # Sidebar toggle button
      shiny::tags$a(
        href = "#",
        class = "sidebar-toggle",
        `data-toggle` = "offcanvas",
        role = "button",
        shiny::tags$span(class = "sr-only", "Toggle navigation")
      ),
      ...,
      #JGG # left menu
      #JGG shiny::tags$div(
      #JGG   class = "navbar-custom-menu",
      #JGG   style = "float: left; margin-left: 10px;",
      #JGG   shiny::tags$ul(
      #JGG     class = "nav navbar-nav",
      #JGG     left_menu_items
      #JGG   )
      #JGG ),
      div(class="navbar-collapse collapse yata-brand", id=navId, nav),
      # right menu
      shiny::tags$div(
        class = "navbar-custom-menu",
        shiny::tags$ul(
          class = "nav navbar-nav",
          items,
          # right sidebar
          shiny::tags$li(
            shiny::tags$a(
              href = "#",
              `data-toggle` = "control-sidebar",
              controlbarIcon
            )
          )
        )
      )
    )
  )
}

