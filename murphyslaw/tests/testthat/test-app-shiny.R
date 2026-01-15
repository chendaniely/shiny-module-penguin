library(shinytest2)

test_that("{shinytest2} recording: shiny-demo", {
  local_app_support(test_path("../../inst/shiny"))
  app <- AppDriver$new(test_path("../../inst/shiny"), name = "shiny-demo", height = 1362, 
      width = 979)
  app$set_inputs(species = c("Adelie", "Chinstrap"))
  app$expect_values(output = "bill_depth_mm-range")
})
