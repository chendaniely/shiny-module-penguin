library(shiny)
library(bslib)
library(palmerpenguins)
library(dplyr)
library(ggplot2)

# Shiny module UI
hist_ui <- function(id, col_name) {
  ns <- NS(id)
  card(
    card_header(
      paste("Hist:", col_name),
      textOutput(ns("range"), inline = TRUE)
    ),
    plotOutput(ns("hist"), height = "300px")
  )
}

# Shiny module server
hist_server <- function(id, filtered_data) {
  moduleServer(id, function(input, output, session) {
    output$range <- renderText({
      if (nrow(filtered_data()) == 0) {
        return("")
      }

      range_vals <- range(filtered_data()[[id]], na.rm = TRUE)
      paste0("[", round(range_vals[1], 1), " - ", round(range_vals[2], 1), "]")
    })

    output$hist <- renderPlot({
      validate(
        need(nrow(filtered_data()) > 0, "No data available for selected species")
      )

      ggplot(filtered_data(), aes_string(id)) +
        geom_histogram(
          bins = 20,
          fill = "darkgreen",
          alpha = 0.7,
          color = "white"
        ) +
        labs(
          x = id,
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
    hist_ui("bill_length_mm", "bill_length_mm"),
    hist_ui("bill_depth_mm", "bill_depth_mm"),
    hist_ui("flipper_length_mm", "flipper_length_mm"),
    hist_ui("body_mass_g", "body_mass_g")
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

  hist_server("bill_length_mm", filtered_data)
  hist_server("bill_depth_mm", filtered_data)
  hist_server("flipper_length_mm", filtered_data)
  hist_server("body_mass_g", filtered_data)
}

shinyApp(ui = ui, server = server)
