yataExample <- function() {
  appDir <- system.file("examples", "myapp", package = "mypackage")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing `mypackage`.", call. = FALSE)
  }

  shiny::runApp(appDir, display.mode = "normal")
}
