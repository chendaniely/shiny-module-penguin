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
    )
  ),
  uiOutput("histogram_cards")
)

server <- function(input, output, session) {

  # Filter data based on selected species
  filtered_data <- reactive({
    penguins %>%
      filter(species %in% input$species) %>%
      filter(!is.na(bill_length_mm), !is.na(bill_depth_mm),
             !is.na(flipper_length_mm), !is.na(body_mass_g))
  })

  # Generate histogram cards for numeric columns
  output$histogram_cards <- renderUI({
    if(nrow(filtered_data()) == 0) {
      return(card(card_header("Histograms"), "No data available for selected species"))
    }

    data <- filtered_data()
    numeric_cols <- c()

    # Find numeric columns using for loop and check if they are continuous
    for(col in names(data)) {
      if(is.numeric(data[[col]])) {
        # Skip if column has too few unique values (likely categorical)
        unique_values <- length(unique(data[[col]]))
        if(unique_values > 5) {  # Only include if more than 5 unique values
          numeric_cols <- c(numeric_cols, col)
        }
      }
    }

    # Create histogram cards in a flowing layout
    histogram_cards <- list()
    for(i in seq_along(numeric_cols)) {
      col_name <- numeric_cols[i]
      output_id <- paste0("hist_", col_name)  # Use column name in ID for uniqueness

      # Create plot output
      local({
        current_col <- col_name
        output[[output_id]] <- renderPlot({
          ggplot(data, aes(.data[[current_col]])) +
            geom_histogram(bins = 20, fill = "steelblue", alpha = 0.7, color = "white") +
            labs(
              x = current_col,
              y = "Count"
            ) +
            theme_minimal() +
            theme(plot.title = element_text(size = 14, hjust = 0.5))
        })
      })

      # Create card
      histogram_cards[[i]] <- card(
        card_header(paste("Histogram:", col_name)),
        plotOutput(output_id, height = "300px")
      )
    }

    # Return cards in a flowing layout
    layout_columns(
      col_widths = c(6, 6),  # Two columns that will wrap as needed
      !!!histogram_cards
    )
  })

}

shinyApp(ui = ui, server = server)
