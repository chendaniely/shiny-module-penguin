library(shinytest2)

test_that("{shinytest2} recording: app", {
  local_app_support(test_path("../../inst/app"))
  app <- AppDriver$new(
    test_path("../../inst/app"),
    name = "app",
    height = 1362,
    width = 1353
  )
  app$expect_values()
  app$expect_values(output = "bill_depth-range")
})


test_that("{shinytest2} recording: app", {
  shiny_app <- shinyApp(
    bslib::page_fluid(
      histUI("hist1", "bill_depth_mm")
    ),
    function(input, output, session) {
      filtered_data <- reactive({
        palmerpenguins::penguins
      })

      histServer("hist1", "bill_depth_mm", filtered_data)
    }
  )
  app <- AppDriver$new(shiny_app, name = "inline")
  app$expect_values(output = "hist1-range")
})
