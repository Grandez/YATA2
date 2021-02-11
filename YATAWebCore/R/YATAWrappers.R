


yataUpload = function(id, label=NULL, btnLabel="Browse...", imgLabel="no file", accept = NULL) {
  fileInput(id, label = label, buttonLabel=btnLabel, placeholder=imgLabel)
}
yataUploadImg = function(id, label=NULL, btnLabel="Browse...", imgLabel="Browse icon file") {
  yataUpload(id, label=label, btnLabel=btnLabel, imgLabel=imgLabel, accept="image/*")
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

# yataRow = function(align = NULL, ...) {
#     cls = paste("row")
#     if (!is.null(align)) cls = paste(cls, paste0("yata_", align))
#     div(class = cls, ...)
# }

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
