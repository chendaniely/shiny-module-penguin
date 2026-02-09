#' Histogram Module UI
#'
#' @param id Module ID
#' @param col_name Column name to display in the histogram
#'
#' @return A bslib card containing histogram UI elements
#' @export
histUI <- function(id, col_name) {
  ns <- shiny::NS(id)
  bslib::card(
    bslib::card_header(
      paste("Histogram:", col_name),
      shiny::textOutput(ns("range"))
    ),
    shiny::plotOutput(ns("hist"), height = "300px")
  )
}

#' Histogram Module Server
#'
#' @param id Module ID
#' @param col_name Column name to plot
#' @param filtered_data Reactive expression containing filtered data
#'
#' @return Module server function
#' @export
histServer <- function(id, col_name, filtered_data) {
  shiny::moduleServer(id, function(input, output, session) {
    output$range <- shiny::renderText({
      if (nrow(filtered_data()) == 0) {
        return("")
      }

      range_vals <- range(filtered_data()[[col_name]], na.rm = TRUE)
      paste0("[", round(range_vals[1], 1), ", ", round(range_vals[2], 1), "]")
    })

    output$hist <- shiny::renderPlot({
      shiny::validate(
        shiny::need(
          nrow(filtered_data()) > 0,
          "No data available for selected species"
        )
      )

      ggplot2::ggplot(filtered_data(), ggplot2::aes(.data[[col_name]])) +
        ggplot2::geom_histogram(
          bins = 20,
          fill = "steelblue",
          alpha = 0.7,
          color = "white"
        ) +
        ggplot2::labs(
          x = col_name,
          y = "Count"
        ) +
        ggplot2::theme_minimal() +
        ggplot2::theme(plot.title = ggplot2::element_text(size = 14, hjust = 0.5))
    })
  })
}
