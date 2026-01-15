library(shiny)
library(bslib)
library(palmerpenguins)
library(dplyr)
library(ggplot2)


hist_ui <- function(column_name) {
  card(
    card_header(
      paste("Histogram:", column_name),
      textOutput(paste0("range_", column_name))
    ),
    plotOutput(paste0("hist_", column_name), height = "300px")
  )
}

hist_output <- function(output, column_name, data_reactive) {
  output[[paste0("range_", column_name)]] <- renderText({
    if (nrow(data_reactive()) == 0) {
      return("")
    }

    range_vals <- range(data_reactive()[[column_name]], na.rm = TRUE)
    paste0("[", round(range_vals[1], 1), " - ", round(range_vals[2], 1), "]")
  })

  output[[paste0("hist_", column_name)]] <- renderPlot({
    validate(
      need(nrow(data_reactive()) > 0, "No data available for selected species")
    )

    ggplot(data_reactive(), aes_string(column_name)) +
      geom_histogram(
        bins = 20,
        fill = "steelblue",
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
    hist_ui("bill_length_mm"),
    hist_ui("bill_depth_mm"),
    hist_ui("flipper_length_mm"),
    hist_ui("body_mass_g")
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

  # Generate histogram cards for numeric columns
  hist_output(output, "bill_length_mm", filtered_data)
  hist_output(output, "bill_depth_mm", filtered_data)
  hist_output(output, "flipper_length_mm", filtered_data)
  hist_output(output, "body_mass_g", filtered_data)
}

shinyApp(ui = ui, server = server)
