bslib_page_navbar <- function(..., title = NULL, id = NULL, selected = NULL,
                        position = c("static-top", "fixed-top", "fixed-bottom"),
                        header = NULL, footer = NULL,
                        bg = NULL, inverse = "auto",
                        collapsible = TRUE, fluid = TRUE,
                        theme =  bs_theme(),
                        window_title = NA,
                        lang = NULL) {

  #JGG BEG
  # bslib quiere window_title
  if (is.null(title)) stop("Falta el titulo")
  window_title = title
  # # https://github.com/rstudio/shiny/issues/2310
  # if (!is.null(title) && isTRUE(is.na(window_title))) {
  #   window_title <- unlist(find_characters(title))
  #   if (is.null(window_title)) {
  #     warning("Unable to infer a `window_title` default from `title`. Consider providing a character string to `window_title`.")
  #   } else {
  #     window_title <- paste(window_title, collapse = " ")
  #   }
  # }

#JGG END
    mpage = bslib_navs_bar(
      ..., title = title, id = id, selected = selected,
      position = match.arg(position), header = header,
      footer = footer, bg = bg, inverse = inverse,
      collapsible = collapsible, fluid = fluid
    )

  bslib_page(
    title = window_title,
    theme = theme,
    lang = lang,
      mpage
    # navs_bar(
    #   ..., title = title, id = id, selected = selected,
    #   position = match.arg(position), header = header,
    #   footer = footer, bg = bg, inverse = inverse,
    #   collapsible = collapsible, fluid = fluid
    # )
  )
}

bslib_navs_bar = function (..., title = NULL, id = NULL, selected = NULL, position = c("static-top",
    "fixed-top", "fixed-bottom"), header = NULL, footer = NULL,
    bg = NULL, inverse = "auto", collapsible = TRUE, fluid = TRUE) {

    if (identical(inverse, "auto")) {
        inverse <- TRUE
        if (!is.null(bg)) {
            bg <- htmltools::parseCssColors(bg)
            bg_contrast <- bs_get_contrast(bs_theme(`navbar-bg` = bg),
                "navbar-bg")
            inverse <- col2rgb(bg_contrast)[1, ] > 127.5
        }
    }
    navbar <- bslib_navbarPage_(title = title, ..., id = id, selected = selected,
        position = match.arg(position), header = header, footer = footer,
        collapsible = collapsible, inverse = inverse, fluid = fluid)
    if (!is.null(bg)) {
        navbar[[1]] <- tagAppendAttributes(navbar[[1]], style = css(background_color = paste(bg,
            "!important")))
    }

    bslib_as_fragment(navbar, page = page)
}

# -----------------------------------------------------------------------
# 'Internal' tabset logic that was pulled directly from shiny/R/bootstrap.R
#  (with minor modifications)
# -----------------------------------------------------------------------

bslib_navbarPage_ <- function(title,
                       ...,
                       id = NULL,
                       selected = NULL,
                       position = c("static-top", "fixed-top", "fixed-bottom"),
                       header = NULL,
                       footer = NULL,
                       inverse = FALSE,
                       collapsible = FALSE,
                       fluid = TRUE,
                       theme = NULL,
                       windowTitle = title,
                       lang = NULL) {

  # alias title so we can avoid conflicts w/ title in withTags
  pageTitle <- title

  # navbar class based on options
  navbarClass <- "navbar navbar-default"
  position <- match.arg(position)
  if (!is.null(position)) navbarClass <- paste0(navbarClass, " navbar-", position)
  if (inverse)            navbarClass <- paste(navbarClass, "navbar-inverse")
  if (!is.null(id))       selected <- shiny::restoreInput(id = id, default = selected)

  # build the tabset
  tabset <- bslib_buildTabset(..., ulClass = "nav navbar-nav", id = id, selected = selected)

  containerClass <- paste0("container", if (fluid) "-fluid")

  # built the container div dynamically to support optional collapsibility
  if (collapsible) {
    navId <- paste0("navbar-collapse-", bslib_p_randomInt(1000, 10000))
    containerDiv <- div(
      class = containerClass,
      div(
        class = "navbar-header",
        tags$button(
          type = "button",
          class = "navbar-toggle collapsed",
          `data-toggle` = "collapse",
          `data-target` = paste0("#", navId),
          # data-bs-* is for BS5+
          `data-bs-toggle` = "collapse",
          `data-bs-target` = paste0("#", navId),
          span(class="sr-only", "Toggle navigation"),
          span(class = "icon-bar"),
          span(class = "icon-bar"),
          span(class = "icon-bar")
        ),
        span(class = "navbar-brand", pageTitle)
      ),
      div(
        class = "navbar-collapse collapse",
        id = navId, tabset$navList
      )
    )
  } else {
    containerDiv <- div(
      class = containerClass,
      div(
        class = "navbar-header",
        span(class = "navbar-brand", pageTitle)
      ),
      tabset$navList
    )
  }

  # Bootstrap 3 explicitly supported "dropup menus" via .navbar-fixed-bottom,
  # but BS4+ requires .dropup on menus with .navbar.fixed-bottom
  if (position == "fixed-bottom") {
    containerDiv <- tagQuery(containerDiv)$
      find(".dropdown-menu")$
      parent()$
      addClass("dropup")$
      allTags()
  }

  # build the main tab content div
  contentDiv <- div(class = containerClass)
  if (!is.null(header)) contentDiv <- tagAppendChild(contentDiv, div(class = "row", header))
  contentDiv <- tagAppendChild(contentDiv, tabset$content)
  if (!is.null(footer)) contentDiv <- tagAppendChild(contentDiv, div(class = "row", footer))

  # *Don't* wrap in bootstrapPage() (shiny::navbarPage()) does that part
  tagList(
    tags$nav(class = navbarClass, role = "navigation", containerDiv),
    contentDiv
  )
}

bslib_navbarMenuTextFilter <- function(text) {
  if (grepl("^\\-+$", text)) tags$li(class = "divider")
  else tags$li(class = "dropdown-header", text)
}
bslib_findAndMarkSelectedTab <- function(tabs, selected, foundSelected) {
  tabs <- lapply(tabs, function(x) {
    if (foundSelected || is.character(x)) {
      # Strings are not selectable items

    } else if (bslib_isNavbarMenu(x)) {
      # Recur for navbarMenus
      res <- bslib_findAndMarkSelectedTab(x$tabs, selected, foundSelected)
      x$tabs <- res$tabs
      foundSelected <<- res$foundSelected

    } else if (bslib_isTabPanel(x)) {
      # Base case: regular tab item. If the `selected` argument is
      # provided, check for a match in the existing tabs; else,
      # mark first available item as selected
      if (is.null(selected)) {
        foundSelected <<- TRUE
        x <- bslib_markTabAsSelected(x)
      } else {
        tabValue <- x$attribs$`data-value` %||% x$attribs$title
        if (identical(selected, tabValue)) {
          foundSelected <<- TRUE
          x <- bslib_markTabAsSelected(x)
        }
      }
    }
    return(x)
  })
  return(list(tabs = tabs, foundSelected = foundSelected))
}

bslib_isTabPanel <- function(x) {
  if (!inherits(x, "shiny.tag")) return(FALSE)
  class <- tagGetAttribute(x, "class") %||% ""
  "tab-pane" %in% strsplit(class, "\\s+")[[1]]
}

# Helpers to build tabsetPanels (& Co.) and their elements
bslib_markTabAsSelected <- function(x) {
  attr(x, "selected") <- TRUE
  x
}

# Copy of shiny:::anyNamed()
bslib_anyNamed <- function(x) {
  if (length(x) == 0)
    return(FALSE)
  nms <- names(x)
  if (is.null(nms))
    return(FALSE)
  any(nzchar(nms))
}

bslib_p_randomInt <- function(...) {
  getFromNamespace("p_randomInt", "shiny")(...)
}

# Builds tabPanel/navbarMenu items (this function used to be
# declared inside the bslib_buildTabset() function and it's been
# refactored for clarity and reusability). Called internally
# by bslib_buildTabset.
bslib_buildTabItem <- function(index, tabsetId, foundSelected, tabs = NULL,
                         divTag = NULL, textFilter = NULL) {

  divTag <- divTag %||% tabs[[index]]

  # Handles navlistPanel() headers and dropdown dividers
  if (is.character(divTag) && !is.null(textFilter)) {
    return(list(liTag = textFilter(divTag), divTag = NULL))
  }

  if (bslib_isNavbarMenu(divTag)) {
    # tabPanelMenu item: build the child tabset
    ulClass <- "dropdown-menu"
    if (identical(divTag$align, "right")) {
      ulClass <- paste(ulClass, "dropdown-menu-right dropdown-menu-end")
    }
    tabset <- bslib_buildTabset(
      !!!divTag$tabs, ulClass = ulClass,
      textFilter = bslib_navbarMenuTextFilter,
      foundSelected = foundSelected
    )
    return(bslib_buildDropdown(divTag, tabset))
  }

  if (bslib_isTabPanel(divTag)) {
    return(bslib_buildNavItem(divTag, tabsetId, index))
  }

  if (is_nav_item(divTag) || is_nav_spacer(divTag)) {
    return(
      list(liTag = divTag, divTag = NULL)
    )
  }

  # The behavior is undefined at this point, so construct a condition message
  msg <- paste0(
    "Navigation containers expect a collection of `bslib::nav()`/`shiny::tabPanel()`s ",
    "and/or `bslib::nav_menu()`/`shiny::navbarMenu()`s. ",
    "Consider using `header` or `footer` if you wish to place content above ",
    "(or below) every panel's contents."
  )

  # Luckily this case has never worked, so it's safe to throw here
  # https://github.com/rstudio/shiny/issues/3313
  if (!inherits(divTag, "shiny.tag"))  {
    stop(msg, call. = FALSE)
  }

  # Unfortunately, this 'off-label' use case creates an 'empty' nav and includes
  # the divTag content on every tab. There shouldn't be any reason to be relying on
  # this behavior since we now have pre/post arguments, so throw a warning, but still
  # support the use case since we don't make breaking changes
  warning(msg, call. = FALSE)

  return(bslib_buildNavItem(divTag, tabsetId, index))
}

bslib_buildNavItem <- function(divTag, tabsetId, index) {
  id <- paste("tab", tabsetId, index, sep = "-")
  # Get title attribute directory (not via tagGetAttribute()) so that contents
  # don't get passed to as.character().
  # https://github.com/rstudio/shiny/issues/3352
  title <- divTag$attribs[["title"]]
  value <- divTag$attribs[["data-value"]]
  active <- bslib:::isTabSelected(divTag)
  divTag <- tagAppendAttributes(divTag, class = if (active) "active")
  divTag$attribs$id <- id
  divTag$attribs$title <- NULL
  list(
    divTag = divTag,
    liTag = htmltools::tagAddRenderHook(
      bslib:::liTag(id, title, value, attr(divTag, "_shiny_icon")),
      function(x) {
        if (isTRUE(bslib_getCurrentThemeVersion() >= 4)) {
          tagQuery(x)$
            addClass("nav-item")$
            find("a")$
            addClass(c("nav-link", if (active) "active"))$
            allTags()
        } else {
          tagAppendAttributes(x, class = if (active) "active")
        }
      }
    )
  )
}

bslib_isNavbarMenu <- function(x) {
  inherits(x, "shiny.navbarmenu")
}
# Helpers to build tabsetPanels (& Co.) and their elements
bslib_markTabAsSelected <- function(x) {
  attr(x, "selected") <- TRUE
  x
}

#JGG ESTA
# This function is called internally by navbarPage, tabsetPanel
# and navlistPanel
bslib_buildTabset = function(..., ulClass, textFilter = NULL, id = NULL,
                        selected = NULL, foundSelected = FALSE) {
  tabs = bslib_dropNulls(rlang::list2(...))
  res = bslib:::findAndMarkSelectedTab(tabs, selected, foundSelected)
  tabs = res$tabs
  foundSelected <- res$foundSelected

  # add input class if we have an id
  if (!is.null(id)) ulClass <- paste(ulClass, "shiny-tab-input")

  if (bslib_anyNamed(tabs)) {
    nms <- names(tabs)
    nms <- nms[nzchar(nms)]
    stop("Tabs should all be unnamed arguments, but some are named: ",
         paste(nms, collapse = ", "))
  }

  tabsetId <- bslib_p_randomInt(1000, 10000)
  tabs <- lapply(seq_len(length(tabs)), bslib_buildTabItem,
                 tabsetId = tabsetId, foundSelected = foundSelected,
                 tabs = tabs, textFilter = textFilter)

  tabNavList = tags$ul(class = ulClass, id = id,
                        `data-tabsetid` = tabsetId, !!!lapply(tabs, "[[", "liTag"))

  tabContent = tags$div(class = "tab-content",
                         `data-tabsetid` = tabsetId, !!!lapply(tabs, "[[", "divTag"))

  list(navList = tabNavList, content = tabContent)
}

bslib_buildDropdown <- function(divTag, tabset) {

  navList <- htmltools::tagAddRenderHook(
    tabset$navList,
    function(x) {
      if (isTRUE(bslib_getCurrentThemeVersion() >= 4)) {
        tagQuery(x)$
          find(".nav-item")$
          removeClass("nav-item")$
          find(".nav-link")$
          removeClass("nav-link")$
          addClass("dropdown-item")$
          allTags()
      } else {
        x
      }
    }
  )

  active <- bslib_containsSelectedTab(divTag$tabs)

  dropdown <- tags$li(
    class = "dropdown",
    class = if (active) "active",
    tags$a(
      href = "#",
      class = "dropdown-toggle",
      `data-toggle` = "dropdown",
      # data-bs-* is for BS5+
      `data-bs-toggle` = "dropdown",
      `data-value` = divTag$menuName,
      divTag$icon,
      divTag$title,
      tags$b(class = "caret")
    ),
    navList,
    .renderHook = function(x) {
      if (isTRUE(bslib_getCurrentThemeVersion() >= 4)) {
        tagQuery(x)$
          addClass("nav-item")$
          find(".dropdown-toggle")$
          addClass("nav-link")$
          allTags()
      } else {
        x
      }
    }
  )

  list(
    divTag = tabset$content$children,
    liTag = dropdown
  )
}
bslib_tag_require <- function(tag, version = 4, caller = "") {
  htmltools::tagAddRenderHook(
    tag, replace = FALSE,
    func = function(x) {
      current_version <- theme_version(bs_current_theme()) %||% 3
      if (isTRUE(current_version >= version))
        return(x)

      stop(
        caller, " requires Bootstrap ", version, " or higher. ",
        "Please supply `bslib::bs_theme(version = ", version,
        ")` to the UI's page layout function.",
        call. = FALSE
      )
    }
  )
}

bslib_is_tag <- function(x) {
  inherits(x, "shiny.tag")
}

bslib_containsSelectedTab <- function(tabs) {
  any(vapply(tabs, bslib:::isTabSelected, logical(1)))
}
# Copy of shiny::bslib_getCurrentThemeVersion()
# (copied to avoid >1.6.0 dependency)
bslib_getCurrentThemeVersion <- function() {
  theme <- shiny::getCurrentTheme()
  if (is_bs_theme(theme)) theme_version(theme) else "3"
}

bslib_as_fragment <- function(x, page = page_fluid) {
  stopifnot(is.function(page) && "theme" %in% names(formals(page)))
  attr(x, "bslib_page") <- page
  class(x) <- c("bslib_fragment", class(x))
  x
}
#' Create a Bootstrap page
#'
#' These functions are small wrappers around shiny's page constructors (i.e., [shiny::fluidPage()], [shiny::navbarPage()], etc) that differ in two ways:
#'  * The `theme` parameter defaults bslib's recommended version of Bootstrap (for new projects).
#'  * The return value is rendered as an static HTML page when printed interactively at the console.
#'
#' @inheritParams shiny::bootstrapPage
#' @seealso [shiny::bootstrapPage()]
#' @export
bslib_page <- function(..., title = NULL, theme = bs_theme(), lang = NULL) {
#JGG Para debug

data = shiny::bootstrapPage(..., title = title, theme = theme, lang = lang)
  bslib_as_page(data)

  # bslib_as_page(
  #   shiny::bootstrapPage(..., title = title, theme = theme, lang = lang)
  # )
}
bslib_as_page <- function(x) {
  class(x) <- c("bslib_page", class(x))
  x
}

bslib_dropNulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE=logical(1))]
}
