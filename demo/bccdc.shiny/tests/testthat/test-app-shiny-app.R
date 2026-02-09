library(shinytest2)

test_that("{shinytest2} recording: shiny-app", {
  local_app_support(test_path("../../inst/shiny-app"))
  app <- AppDriver$new(test_path("../../inst/shiny-app"), name = "shiny-app", height = 1202, 
      width = 1415)
  app$set_inputs(species = c("Adelie", "Chinstrap"))
  app$set_inputs(species = "Chinstrap")
  app$expect_values(output = "bill_depth_mm-range")
})
