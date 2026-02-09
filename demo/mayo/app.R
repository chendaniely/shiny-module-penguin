library(shiny)
library(bslib)
library(palmerpenguins)
library(dplyr)
library(ggplot2)


histUI <- function(id, col_name) {
  ns <- NS(id)
  card(
    card_header(
      paste("Histogram:", col_name),
      textOutput(ns("range"))
    ),
    plotOutput(ns("hist"), height = "300px")
  )
}

histServer <- function(id, col_name, filtered_data) {
  moduleServer(id, function(input, output, session) {
    output$range <- renderText({
      if (nrow(filtered_data()) == 0) {
        return("")
      }

      range_vals <- range(filtered_data()[[col_name]], na.rm = TRUE)
      paste0("[", round(range_vals[1], 1), " - ", round(range_vals[2], 1), "]")
    })

    output$hist <- renderPlot({
      validate(
        need(
          nrow(filtered_data()) > 0,
          "No data available for selected species"
        )
      )

      ggplot(filtered_data(), aes(.data[[col_name]])) +
        geom_histogram(
          bins = 20,
          fill = "steelblue",
          alpha = 0.7,
          color = "white"
        ) +
        labs(
          x = col_name,
          y = "Count"
        ) +
        theme_minimal() +
        theme(plot.title = element_text(size = 14, hjust = 0.5))
    })
  })
}

ui <- page_sidebar(
  title = "Palmer Penguins Data Explorer",
  sidebar = sidebar(
    checkboxGroupInput(
      "species",
      "Select Species:",
      choices = c("Adelie", "Chinstrap", "Gentoo"),
      selected = c("Adelie", "Chinstrap", "Gentoo")
    ),
    width = 175
  ),
  # Return cards in a flowing layout
  layout_columns(
    col_widths = c(6, 6), # Two columns that will wrap as needed
    histUI("bill_length", "bill_length_mm"),
    histUI("bill_depth", "bill_depth_mm"),
    histUI("flipper_length", "flipper_length_mm"),
    histUI("body_mass", "body_mass_g")
  )
)

server <- function(input, output, session) {
  # Filter data based on selected species
  filtered_data <- reactive({
    penguins %>%
      filter(species %in% input$species) %>%
      filter(
        !is.na(bill_length_mm),
        !is.na(bill_depth_mm),
        !is.na(flipper_length_mm),
        !is.na(body_mass_g)
      )
  })

  histServer("bill_length", "bill_length_mm", filtered_data)
  histServer("bill_depth", "bill_depth_mm", filtered_data)
  histServer("flipper_length", "flipper_length_mm", filtered_data)
  histServer("body_mass", "body_mass_g", filtered_data)
}

shinyApp(ui = ui, server = server)
