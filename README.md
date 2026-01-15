# shiny-module-penguin

Small shiny app example with modules + package

Topics:

- Shiny Modules
- Testing Shiny Applications
- Github Actions

Data: Palmer Penguins dataset from the [`{palmerpenguins}` R package](https://allisonhorst.github.io/palmerpenguins/)

## Schedule

#### 00 - 10: Initial application introduction

- Basic shiny applicaton. Has an input on the left sidebar, outputs on the right body
- Examine the code
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

#### 11 - 15: Consolidate repeated code

- Move repeated code to functions

#### 16 - 20: What are shiny modules, why would we use them?
- Shiny modules are R functions that encapsulate Shiny UI and server logic
- They help in:
  - Code organization: Break down complex apps into smaller, manageable pieces
  - Reusability: Use the same module in multiple places within an app or across different apps
  - Namespace management: Avoid ID conflicts by providing unique namespaces for module instances
- Basic structure of a shiny module:
  - UI function: Defines the user interface for the module
  - Server function: Contains the server-side logic for the module


#### 16 - 30: Shiny module example

- Refactor the helper functions into shiny modules
  - The app developer no longer needs to worry about this part of the code when building the rest of the applicaiton
- Modules are regular R functions, so we can follow a more R package folder structure if we want to share them with others

#### 30 - 35: Modules and testing

- We have an R package, and a shiny application
- We should write tests for the application
- Why unit testing is good?
- We can use shinytest2 to test shiny applications, and our shiny module
- Whenever possible, if you write functions for your application, try to separate the reactive logic from a regular function call of inputs and outputs.
  - This allows you to also leverage your normal R packageing `testthat` unittesting framework

 #### 36 - 45: shinytest2

 - We have our shiny application ready for testing
 - `{shinytest2}` > record your application > see saved app state > test the values

#### 46 - 50: Github Actions

- Now we want to automate all this testing
- Github Actions to the rescue!
- Details about line-by-line workflow file is out of scope
- Specifically talk about the action steps in the workflow that correspond to running the test from the terminal/console

#### 51 - 55: Github Actions

- Watch the spinning wheel go ✔️

#### 56 - 60: Buffer / Q+A

🎉
