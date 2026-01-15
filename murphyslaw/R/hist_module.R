#' Histogram Module UI
#'
#' Creates a UI component for displaying a histogram with range information.
#' This module provides a reusable card component that shows a histogram plot
#' along with the data range in the header.
#'
#' @param column_name Name of the column to create histogram for. Used as module ID.
#' @param height Height of the plot output. Default is "300px".
#' @return A bslib card containing histogram output and range display
#' @export
#' @importFrom shiny NS textOutput plotOutput
#' @importFrom bslib card card_header
#' @examples
#' \dontrun{
#'   # In your UI
#'   hist_ui("bill_length_mm")
#'   hist_ui("body_mass_g", height = "400px")
#' }
hist_ui <- function(column_name, height = "300px") {
  ns <- NS(column_name)

  card(
    card_header(
      paste("Histogram:", column_name),
      textOutput(ns("range"))
    ),
    plotOutput(ns("hist"), height = height)
  )
}

#' Histogram Module Server
#'
#' Server logic for rendering histogram and range information from reactive data.
#' Displays a histogram with configurable bins and styling, along with the data range.
#'
#' @param column_name Name of the column to create histogram for. Must match UI module ID.
#' @param data_reactive Reactive expression returning a data frame with the column.
#' @param bins Number of histogram bins. Default is 20.
#' @param fill Fill color for histogram bars. Default is "steelblue".
#' @param no_data_message Message to display when no data is available. Default is "No data available".
#' @return Server module (no return value)
#' @export
#' @importFrom shiny moduleServer renderText renderPlot validate need
#' @importFrom ggplot2 ggplot aes geom_histogram labs theme_minimal theme element_text
#' @importFrom rlang .data
#' @examples
#' \dontrun{
#'   # In your server
#'   filtered_data <- reactive({
#'     penguins %>% filter(species == "Adelie")
#'   })
#'
#'   hist_server("bill_length_mm", filtered_data)
#'   hist_server("body_mass_g", filtered_data, bins = 30, fill = "darkgreen")
#' }
hist_server <- function(column_name, data_reactive, bins = 20, fill = "steelblue",
                        no_data_message = "No data available") {
  moduleServer(column_name, function(input, output, session) {
    output$range <- renderText({
      if (nrow(data_reactive()) == 0) {
        return("")
      }

      range_vals <- range(data_reactive()[[column_name]], na.rm = TRUE)
      paste0("[", round(range_vals[1], 1), ", ", round(range_vals[2], 1), "]")
    })

    output$hist <- renderPlot({
      validate(
        need(
          nrow(data_reactive()) > 0,
          no_data_message
        )
      )

      ggplot(data_reactive(), aes(x = .data[[column_name]])) +
        geom_histogram(
          bins = bins,
          fill = fill,
          alpha = 0.7,
          color = "white"
        ) +
        labs(
          x = column_name,
          y = "Count"
        ) +
        theme_minimal() +
        theme(plot.title = element_text(size = 14, hjust = 0.5))
    })
  })
}
