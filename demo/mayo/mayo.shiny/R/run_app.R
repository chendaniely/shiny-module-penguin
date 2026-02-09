#' Run the Palmer Penguins Shiny App
#'
#' @param ... Additional arguments to pass to shiny::runApp
#'
#' @return Runs the Shiny application
#' @export
run_app <- function(...) {
  app_dir <- system.file("app", package = "mayo.shiny")
  if (app_dir == "") {
    stop("Could not find app directory. Try re-installing `mayo.shiny`.")
  }
  shiny::runApp(app_dir, ...)
}
