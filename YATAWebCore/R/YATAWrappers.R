

yataNumericInput = function(id, label=NULL, value=0, step, min, max) {
  st = NA ; if (!missing(step)) st=step
  mn = NA ; if (!missing(min))  mn=min
  ma = NA ; if (!missing(max))  ma=max
  numericInput(id, label = label, value = value, mn, ma,st)
}
yataIntegerInput = function(id, label=NULL, value=0, step, min, max) {
  st = NA ; if (!missing(step)) st=step
  mn = NA ; if (!missing(min))  mn=min
  ma = NA ; if (!missing(max))  ma=max
  numericInput(id, label = label, value = value, mn, ma,st)
}

yataUpload = function(id, label=NULL, btnLabel="Browse...", imgLabel="no file", accept = NULL) {
  fileInput(id, label = label, buttonLabel=btnLabel, placeholder=imgLabel)
}
yataUploadImg = function(id, label=NULL, btnLabel="Browse...", imgLabel="Browse icon file") {
  yataUpload(id, label=label, btnLabel=btnLabel, imgLabel=imgLabel, accept="image/*")
}

# Copiadode TextArea
yataArea = function (inputId, label=NULL, value = "", width = NULL, height = NULL,
    cols = NULL, rows = NULL, placeholder = NULL, resize = NULL) {
    value <- restoreInput(id = inputId, default = value)
    if (!is.null(resize)) {
        resize <- match.arg(resize, c("both", "none", "vertical",
            "horizontal"))
    }
    style <- paste("max-width: 100%;", if (!is.null(width))
        paste0("width: ", validateCssUnit(width), ";"), if (!is.null(height))
        paste0("height: ", validateCssUnit(height), ";"), if (!is.null(resize))
        paste0("resize: ", resize, ";"))
    if (length(style) == 0)
        style <- NULL
    div(class = "form-group",
        tags$label(label, `for` = inputId), tags$textarea(id = inputId,
        class = "form-control", placeholder = placeholder, style = style,
        rows = rows, cols = cols, value))
}

# column
yataCol = function (width, ..., offset = 0) {
    if (!is.numeric(width) || (width < 1) || (width > 12))
        stop("column width must be between 1 and 12")
    colClass <- paste0("col-lg-", width)
    if (offset > 0) {
        colClass <- paste0(colClass, " offset-lg-", offset,
            " col-lg-offset-", offset)
    }
    div(class = colClass, ...)
}

yataTable = function(id) {
  data = DT::dataTableOutput(id)
data
}
############################
#### ShinyWidgets
###########################

yataRow = function(align = NULL, ...) {
    cls = paste("row")
    if (!is.null(align)) cls = paste(cls, paste0("yata_", align))
    div(class = cls, ...)
}

yataBoxClosable = function(id, title, style="primary", ...) {
  boxPlus(..., title=title, status=style, solidHeader=TRUE)
}
yataBox = function(id, title, ...) {

res =        boxPlus( ..., title = title
                   ,closable = FALSE
                   ,width = 12
                   ,status = "primary"
                   ,solidHeader = TRUE
                   ,collapsible = TRUE
             )
res
}
yataBox2 = function(text) {
    boxPlus(
  title = text,
  closable = TRUE,
  width = NULL,
  status = "warning",
  solidHeader = TRUE,
  collapsible = TRUE,
  enable_dropdown = TRUE,
  dropdown_icon = "wrench",
  dropdown_menu = dropdownItemList(
    dropdownItem(url = "http://www.google.com", name = "Link to google"),
    dropdownItem(url = "#", name = "item 2"),
    dropdownDivider(),
    dropdownItem(url = "#", name = "item 3")
  ),
  p("Box Content")
)
}
yataToggleClass = function(id, old, new) {
    shinyjs::toggleCssClass(id, old)
    shinyjs::toggleCssClass(id, new)
}

yataAlertDependencies <- function() {

  shiny::addResourcePath("shinyalert-assets",
                         system.file("www", package = "shinyalert"))

  runtime <- knitr::opts_knit$get("rmarkdown.runtime")
  if (!is.null(runtime) && runtime == "shiny") {
    # we're inside an Rmd document
    insert_into_doc <- shiny::tagList
  } else {
    # we're in a shiny app
    insert_into_doc <- shiny::tags$head
  }

  shiny::singleton(
    insert_into_doc(
      shiny::tags$script(
        src = file.path("shinyalert-assets", "shared", "sweetalert-1.0.1",
                        "js", "sweetalert.min.js")
      ),
      shiny::tags$link(
        rel = "stylesheet",
        href = file.path("shinyalert-assets", "shared", "sweetalert-1.0.1",
                         "css", "sweetalert.min.css")
      ),
      shiny::tags$script(
        src = file.path("shinyalert-assets", "shared", "swalservice",
                        "swalservice.min.js")
      ),
      shiny::tags$script(
        src = file.path("shinyalert-assets", "srcjs", "shinyalert.js")
      ),
      shiny::tags$link(
        rel = "stylesheet",
        href = file.path("shinyalert-assets", "css", "shinyalert.css")
      )
    )
  )
}
