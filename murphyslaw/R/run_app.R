#' Run the Palmer Penguins Shiny Application
#'
#' Launch the Palmer Penguins Data Explorer Shiny application.
#'
#' @param ... Additional arguments passed to \code{\link[shiny]{shinyApp}}
#' @return Runs the Shiny application
#' @export
#' @importFrom shiny shinyApp
#' @examples
#' \dontrun{
#'   run_app()
#' }
run_app <- function(...) {
  app_dir <- system.file("shiny", package = "murphyslaw")

  if (app_dir == "") {
    stop("Could not find app directory. Try re-installing `murphyslaw`.", call. = FALSE)
  }

  shiny::runApp(app_dir, ...)
}
