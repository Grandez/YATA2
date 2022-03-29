runExample <- function() {
  appDir <- system.file("examples", "demo", package = "YATAWidgets")
  shiny::runApp(appDir, display.mode = "normal")
}
