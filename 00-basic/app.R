library(shiny)
library(bslib)
library(palmerpenguins)
library(dplyr)
library(ggplot2)

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
    card(
      card_header(
        "Histogram: bill_length_mm",
        textOutput("range_bill_length_mm")
      ),
      plotOutput("hist_bill_length_mm", height = "300px")
    ),
    card(
      card_header(
        "Histogram: bill_depth_mm",
        textOutput("range_bill_depth_mm")
      ),
      plotOutput("hist_bill_depth_mm", height = "300px")
    ),
    card(
      card_header(
        "Histogram: flipper_length_mm",
        textOutput("range_flipper_length_mm")
      ),
      plotOutput("hist_flipper_length_mm", height = "300px")
    ),
    card(
      card_header("Histogram: body_mass_g", textOutput("range_body_mass_g")),
      plotOutput("hist_body_mass_g", height = "300px")
    )
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

  output$range_bill_length_mm <- renderText({
    if (nrow(filtered_data()) == 0) {
      return("")
    }

    range_vals <- range(filtered_data()$bill_length_mm, na.rm = TRUE)
    paste0("[", round(range_vals[1], 1), " - ", round(range_vals[2], 1), "]")
  })
  output$hist_bill_length_mm <- renderPlot({
    validate(
      need(nrow(filtered_data()) > 0, "No data available for selected species")
    )

    ggplot(filtered_data(), aes(bill_length_mm)) +
      geom_histogram(
        bins = 20,
        fill = "steelblue",
        alpha = 0.7,
        color = "white"
      ) +
      labs(
        x = "bill_length_mm",
        y = "Count"
      ) +
      theme_minimal() +
      theme(plot.title = element_text(size = 14, hjust = 0.5))
  })

  output$range_bill_depth_mm <- renderText({
    if (nrow(filtered_data()) == 0) {
      return("")
    }

    range_vals <- range(filtered_data()$bill_depth_mm, na.rm = TRUE)
    paste0("[", round(range_vals[1], 1), " - ", round(range_vals[2], 1), "]")
  })
  output$hist_bill_depth_mm <- renderPlot({
    validate(
      need(nrow(filtered_data()) > 0, "No data available for selected species")
    )

    ggplot(filtered_data(), aes(bill_depth_mm)) +
      geom_histogram(
        bins = 20,
        fill = "steelblue",
        alpha = 0.7,
        color = "white"
      ) +
      labs(
        x = "bill_depth_mm",
        y = "Count"
      ) +
      theme_minimal() +
      theme(plot.title = element_text(size = 14, hjust = 0.5))
  })

  output$range_flipper_length_mm <- renderText({
    if (nrow(filtered_data()) == 0) {
      return("")
    }

    range_vals <- range(filtered_data()$flipper_length_mm, na.rm = TRUE)
    paste0("[", round(range_vals[1], 1), " - ", round(range_vals[2], 1), "]")
  })
  output$hist_flipper_length_mm <- renderPlot({
    validate(
      need(nrow(filtered_data()) > 0, "No data available for selected species")
    )

    ggplot(filtered_data(), aes(flipper_length_mm)) +
      geom_histogram(
        bins = 20,
        fill = "steelblue",
        alpha = 0.7,
        color = "white"
      ) +
      labs(
        x = "flipper_length_mm",
        y = "Count"
      ) +
      theme_minimal() +
      theme(plot.title = element_text(size = 14, hjust = 0.5))
  })

  output$range_body_mass_g <- renderText({
    if (nrow(filtered_data()) == 0) {
      return("")
    }

    range_vals <- range(filtered_data()$body_mass_g, na.rm = TRUE)
    paste0("[", round(range_vals[1], 1), " - ", round(range_vals[2], 1), "]")
  })
  output$hist_body_mass_g <- renderPlot({
    if (nrow(filtered_data()) == 0) {
      return("")
    }
    ggplot(filtered_data(), aes(body_mass_g)) +
      geom_histogram(
        bins = 20,
        fill = "steelblue",
        alpha = 0.7,
        color = "white"
      ) +
      labs(
        x = "body_mass_g",
        y = "Count"
      ) +
      theme_minimal() +
      theme(plot.title = element_text(size = 14, hjust = 0.5))
  })
}

shinyApp(ui = ui, server = server)
