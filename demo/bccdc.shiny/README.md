# bccdc.shiny

BCCDC Shiny Modules - Provides reusable Shiny modules for data visualization and analysis.

## Installation

You can install the package from this local directory:

```r
devtools::install("/Users/barret/Documents/git/rstudio/shiny-module-penguin/shiny-module-penguin.nosync/bccdc.shiny")
```

Or install with dependencies:

```r
devtools::install("/Users/barret/Documents/git/rstudio/shiny-module-penguin/shiny-module-penguin.nosync/bccdc.shiny", dependencies = TRUE)
```

## Exported Functions

The package exports three main functions:

- `hist_ui()` - UI component for histogram module
- `hist_server()` - Server logic for histogram module
- `run_app()` - Launches the example Shiny application

## Usage

```r
library(shiny)
library(bccdc.shiny)
library(palmerpenguins)
library(dplyr)

ui <- fluidPage(
  hist_ui("bill_length_mm", "Bill Length (mm)")
)

server <- function(input, output, session) {
  data <- reactive({
    palmerpenguins::penguins %>%
      filter(!is.na(bill_length_mm))
  })

  hist_server("bill_length_mm", data)
}

shinyApp(ui, server)
```

## Example App

A complete example application is included in the package. You can find it at:

```
inst/shiny-app/app.R
```

To run the example app after installing the package:

```r
library(bccdc.shiny)
run_app()
```

Or alternatively:

```r
shiny::runApp(system.file("shiny-app", package = "bccdc.shiny"))
```

## Documentation

View function documentation:

```r
?hist_ui
?hist_server
?run_app
```

## Package Structure

```
bccdc.shiny/
├── DESCRIPTION          # Package metadata and dependencies
├── NAMESPACE           # Package namespace (auto-generated)
├── LICENSE             # MIT License
├── R/
│   └── hist_module.R   # Histogram module functions
├── man/                # Documentation (auto-generated)
│   ├── hist_ui.Rd
│   ├── hist_server.Rd
│   └── run_app.Rd
└── inst/
    └── shiny-app/
        └── app.R       # Example Shiny application
```

## Development

To modify the package:

1. Edit the R files in the `R/` directory
2. Update roxygen comments if needed
3. Regenerate documentation:
   ```r
   devtools::document("bccdc.shiny")
   ```
4. Run checks:
   ```r
   devtools::check("bccdc.shiny")
   ```
