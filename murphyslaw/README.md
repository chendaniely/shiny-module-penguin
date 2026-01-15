# murphyslaw

A Shiny application package for exploring Palmer Penguins data with reusable modular histogram components.

## Installation

You can install the package from the local source:

```r
# Install devtools if you haven't already
install.packages("devtools")

# Install murphyslaw
devtools::install("path/to/murphyslaw")
```

## Quick Start

Launch the Palmer Penguins Data Explorer app:

```r
library(murphyslaw)
run_app()
```

## Features

### Histogram Module

The package provides reusable histogram module functions that can be used in any Shiny application:

- **`hist_ui()`** - Creates a bslib card with histogram plot and range display
- **`hist_server()`** - Server logic for rendering histogram and data range

### Usage in Your Own Apps

```r
library(shiny)
library(murphyslaw)
library(palmerpenguins)
library(dplyr)

ui <- fluidPage(
  titlePanel("Custom Penguin App"),
  sidebarLayout(
    sidebarPanel(
      selectInput("species", "Species:",
                  choices = c("Adelie", "Chinstrap", "Gentoo"))
    ),
    mainPanel(
      hist_ui("bill_length_mm", height = "400px"),
      hist_ui("body_mass_g")
    )
  )
)

server <- function(input, output, session) {
  filtered_data <- reactive({
    penguins %>%
      filter(species == input$species, !is.na(bill_length_mm))
  })

  # Use default styling
  hist_server("bill_length_mm", filtered_data)

  # Customize bins and color
  hist_server("body_mass_g", filtered_data,
              bins = 30,
              fill = "darkgreen",
              no_data_message = "Select a species")
}

shinyApp(ui, server)
```

## Module Parameters

### `hist_ui(column_name, height = "300px")`

- **column_name**: Name of the column (also used as module ID)
- **height**: Height of the plot (default: "300px")

### `hist_server(column_name, data_reactive, bins = 20, fill = "steelblue", no_data_message = "No data available")`

- **column_name**: Name of the column (must match UI module ID)
- **data_reactive**: Reactive expression returning a data frame
- **bins**: Number of histogram bins (default: 20)
- **fill**: Fill color for bars (default: "steelblue")
- **no_data_message**: Message shown when data is empty (default: "No data available")

## Package Structure

```
murphyslaw/
├── R/
│   ├── hist_module.R     # Histogram module functions
│   └── run_app.R         # App launcher function
├── inst/
│   └── shiny/
│       └── app.R         # Palmer Penguins demo app
├── DESCRIPTION
├── NAMESPACE
└── README.md
```

## About the Demo App

The included demo application showcases the histogram modules by visualizing four measurements from the Palmer Penguins dataset:

- Bill Length (mm)
- Bill Depth (mm)
- Flipper Length (mm)
- Body Mass (g)

Users can filter the data by penguin species (Adelie, Chinstrap, Gentoo) to explore distributions across different populations.
