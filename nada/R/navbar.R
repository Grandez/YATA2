navbarPage2 <- function(title,
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
                       windowTitle = NA,
                       lang = NULL) {
    res = page_navbar(
    ..., title = title, id = id, selected = selected,
    position = match.arg(position),
    header = header, footer = footer,
    inverse = inverse, collapsible = collapsible,
    fluid = fluid,
    theme = theme,
    window_title = windowTitle,
    lang = lang
  )
remove_first_class(res)
}

page_navbar <- function(..., title = NULL, id = NULL, selected = NULL,
                        position = c("static-top", "fixed-top", "fixed-bottom"),
                        header = NULL, footer = NULL,
                        bg = NULL, inverse = "auto",
                        collapsible = TRUE, fluid = TRUE,
                        theme =  bs_theme(),
                        window_title = NA,
                        lang = NULL) {

  # https://github.com/rstudio/shiny/issues/2310
  if (!is.null(title) && isTRUE(is.na(window_title))) {
    window_title <- unlist(find_characters(title))
    if (is.null(window_title)) {
      warning("Unable to infer a `window_title` default from `title`. Consider providing a character string to `window_title`.")
    } else {
      window_title <- paste(window_title, collapse = " ")
    }
  }

  page(
    title = window_title,
    theme = theme,
    lang = lang,
    navs_bar(
      ..., title = title, id = id, selected = selected,
      position = match.arg(position), header = header,
      footer = footer, bg = bg, inverse = inverse,
      collapsible = collapsible, fluid = fluid
    )
  )
}

as_page = function (x) {
    class(x) <- c("bslib_page", class(x))
    x
}
page <- function(..., title = NULL, theme = bs_theme(), lang = NULL) {
    browser()
    #res = shiny::bootstrapPage(..., title = title, theme = theme, lang = lang)
    res = bootstrapPage(..., title = title, theme = theme, lang = lang)
  as_page(res)
}
bootstrapPage <- function(..., title = NULL, theme = NULL, lang = NULL) {
    browser()
pp = list2(...)
browser()
  args <- list(
    jqueryDependency(),
    if (!is.null(title)) tags$head(tags$title(title)),
    if (is.character(theme)) {
      if (length(theme) > 1) stop("`theme` must point to a single CSS file, not multiple files.")
      tags$head(tags$link(rel="stylesheet", type="text/css", href=theme))
    },
    # remainder of tags passed to the function
    list2(...)
  )

  # If theme is a bslib::bs_theme() object, bootstrapLib() needs to come first
  # (so other tags, when rendered via tagFunction(), know about the relevant
  # theme). However, if theme is anything else, we intentionally avoid changing
  # the tagList() contents to avoid breaking user code that makes assumptions
  # about the return value https://github.com/rstudio/shiny/issues/3235
  if (is_bs_theme(theme)) {
    args <- c(bootstrapLib(theme), args)
    ui <- do.call(tagList, args)
  } else {
    ui <- do.call(tagList, args)
    ui <- attachDependencies(ui, bootstrapLib())
  }

  setLang(ui, lang)
}

setLang <- function(ui, lang) {
  # Add lang attribute to be passed to renderPage function
  attr(ui, "lang") <- lang
  ui
}