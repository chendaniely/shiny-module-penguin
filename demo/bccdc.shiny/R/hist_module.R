#' Histogram Module UI
#'
#' Creates a card with a histogram plot and range display for a given column.
#'
#' @param id Character string. The module ID.
#' @param col_name Character string. The column name to display in the header.
#'
#' @return A bslib card UI element.
#' @export
#'
#' @examples
#' \dontrun{
#' hist_ui("bill_length_mm", "Bill Length (mm)")
#' }
hist_ui <- function(id, col_name) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header(
      paste("Hist:", col_name),
      shiny::textOutput(ns("range"), inline = TRUE)
    ),
    shiny::plotOutput(ns("hist"), height = "300px")
  )
}

#' Histogram Module Server
#'
#' Server logic for the histogram module. Renders a histogram and displays the
#' range of values for the specified column.
#'
#' @param id Character string. The module ID (must match the ID used in hist_ui).
#' @param filtered_data Reactive expression returning a data frame.
#'
#' @return Server logic for the histogram module.
#' @export
#'
#' @examples
#' \dontrun{
#' server <- function(input, output, session) {
#'   data <- reactive({ mtcars })
#'   hist_server("mpg", data)
#' }
#' }
hist_server <- function(id, filtered_data) {
  shiny::moduleServer(id, function(input, output, session) {
    output$range <- shiny::renderText({
      if (nrow(filtered_data()) == 0) {
        return("")
      }

      range_vals <- range(filtered_data()[[id]], na.rm = TRUE)
      paste0("[", round(range_vals[1], 1), ", ", round(range_vals[2], 1), "]")
    })

    output$hist <- shiny::renderPlot({
      shiny::validate(
        shiny::need(nrow(filtered_data()) > 0, "No data available for selected species")
      )

      ggplot2::ggplot(filtered_data(), ggplot2::aes_string(id)) +
        ggplot2::geom_histogram(
          bins = 20,
          fill = "darkgreen",
          alpha = 0.7,
          color = "white"
        ) +
        ggplot2::labs(
          x = id,
          y = "Count"
        ) +
        ggplot2::theme_minimal() +
        ggplot2::theme(plot.title = ggplot2::element_text(size = 14, hjust = 0.5))
    })
  })
}

#' Run the Example Shiny App
#'
#' Launches the example Shiny application included with the package that
#' demonstrates the histogram modules using the Palmer Penguins dataset.
#'
#' @param ... Additional arguments passed to \code{\link[shiny]{runApp}}.
#'
#' @return Runs the Shiny application.
#' @export
#'
#' @examples
#' \dontrun{
#' run_app()
#' }
run_app <- function(...) {
  app_dir <- system.file("shiny-app", package = "bccdc.shiny")

  if (app_dir == "") {
    stop("Could not find example app. Try re-installing `bccdc.shiny`.", call. = FALSE)
  }

  shiny::runApp(app_dir, ...)
}
