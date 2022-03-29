#' Custom Tabler action button
#'
#' @inheritParams shiny::actionButton
#' @param status Button color.
#' @return A Tabler action button tag.
#' @export
#'
#' @examples
#' if (interactive()) {
#'  library(shiny)
#'  ui <- tabler_page(
#'   tabler_body(
#'     tabler_button(
#'       "btn",
#'       HTML(paste("Value", textOutput("val"), sep = ":")),
#'       icon = icon("thumbs-up"),
#'       width = "25%"
#'     )
#'   )
#'  )
#'
#'  server <- function(input, output) {
#'    output$val <- renderText(input$btn)
#'  }
#'
#'  shinyApp(ui, server)
#' }
tabler_button <- function(inputId, label, status = NULL, icon = NULL, width = NULL, ...) {

  btn_cl <- paste0(
    "btn action-button",
    if (is.null(status)) {
      " btn-primary"
    } else {
      paste0(" btn-", status)
    }
  )

  value <- restoreInput(id = inputId, default = NULL)

  # custom right margin
  if (!is.null(icon)) icon$attribs$class <- paste0(
    icon$attribs$class, " mr-1"
  )

  tags$button(
    id = inputId,
    style = if (!is.null(width)) paste0("width: ", validateCssUnit(width), ";"),
    type = "button",
    class = btn_cl,
    `data-val` = value,
    list(icon, label), ...
  )
}
