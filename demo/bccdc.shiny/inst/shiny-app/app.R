library(shiny)
library(bslib)
library(bccdc.shiny)
library(palmerpenguins)
library(dplyr)

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
