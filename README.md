# shiny-module-penguin
Small shiny app example with modules + package

Topics:

- Github Actions
- Shiny Modules
- Testing Shiny Applications

## Schedule

#### 00 - 10: Initial application introduction

- Basic shiny applicaton. Has inputs on the left sidebar, outputs on the right body
- Examine the code: this application aims to automate part of the process: loop and programically create histograms of numeric columns
  - We drop year since it bahaves more like a categorical variable, even though it's coded as numeric
- There's a lot of logic encapsulated into this plot setup:
  - get the species values selected
    - if none selected, return a meaningful UI
  - filter the data based on selected species
  - drop missing values
  - find the numeric columns
  - for each numeric column
    - create a unique shiny output ID
    - create a figure and associate with corresponding output ID
    - figure title/card should show which column is being plotted
    - wrap the figure into a card element
  - return all the figure cards as a set

#### 11 - 15: What are shiny modules, why would we use them?

- Shiny modules help us in a few ways:
  - encapsulate the logic for ui, server, component interactions
  - be able to re-use the encapsulations in the same app (modules!)
  - modules are reactivity-aware functions, so we can create an R package for a module
 
#### 16 - 30: Shiny module example

- Refactor the current application into a shiny module
- show how the base application has much fewer lines of code because of the module encapsulation
  - the app developer no longer needs to worry about this part of the code when building the rest of the applicaiton
- modules are regular R functions, so we can follow a more R package folder structure if we want to share them with others

#### 30 - 35: Modules and testing

- We have an R package, and a shiny application
- we should write tests for the application
- Why unit testing is good?
- We can use shinytest2 to test shiny applications, and our shiny module
- Whenever possible, if you write functions for your application, try to separate the reactive logic from a regular function call of inputs and outputs.
  - this allows you to also leverage your normal R packageing `testthat` unittesting framework

 #### 36 - 45: shinytest2

 - We have our shiny application ready for testing
 - shinytest2 > record your application > see saved app state > test the values

#### 46 - 50: Github Actions

- Now we want to automate all this testing
- Github Actions to the rescue!
- Details about line-by-line workflow file is out of scope
- specifically talk about the action steps in the workflow that correspond to running the test from the terminal/console

#### 51 - 55: Github Actions

- Watch the spinning wheel go ✔️

#### 56 - 60: Buffer / Q+A

🎉
