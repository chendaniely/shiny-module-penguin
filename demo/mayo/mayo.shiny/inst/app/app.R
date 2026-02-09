library(shiny)
library(bslib)
library(palmerpenguins)
library(dplyr)
library(ggplot2)
library(mayo.shiny)

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
