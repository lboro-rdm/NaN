library(shiny)
library(shinycssloaders)
library(shinythemes)

# Define UI for the app
shinyUI(fluidPage(theme = shinytheme("united"),
                  
                  # Application title
                  titlePanel("Named After Nelson: Lboro Repository Items"),
                  p("The Named After Nelson project is a collaboration between the ", 
                    a("Nelson Mandela Foundation", href = "https://www.nelsonmandela.org/exhibitions/entry/named-after-nelson-nan"), 
                    " and ", 
                    a("Loughborough University", href = "https://repository.lboro.ac.uk/projects/Named_after_Nelson/199324"), 
                    ". The digital exhibition is housed in the Loughborough Research Repository and this app shows the geographical spread of the engagement of that material."),
                  p("Our servers are slow - please be patient :)"),
                  
                  # Sidebar layout with a sidebar and main panel
                  sidebarLayout(
                    
                    # Sidebar panel for inputs
                    sidebarPanel(
                      # Dropdown menu for selecting metric (views or downloads)
                      selectInput("metric", 
                                  label = "Select Metric:",
                                  choices = list("Downloads" = "downloads", "Views" = "views"),
                                  selected = "downloads"),
                      
                      # Date input for start date
                      dateInput("start_date", 
                                label = "Start Date:",
                                value = "2024-04-24",  # Default to earliest date
                                min = "2024-04-24",  # Earliest selectable date
                                max = Sys.Date()),  # Latest selectable date
                      
                      # Date input for end date
                      dateInput("end_date", 
                                label = "End Date:",
                                value = Sys.Date(),  # Default to today
                                min = "2024-04-24",  # Earliest selectable date
                                max = Sys.Date()),  # Latest selectable date
                      
                      # Download button for the CSV file
                      downloadButton("downloadData", "Download data as CSV"),
                      
                      p(),
                      
                      # Download button for the JPEG map
                      downloadButton("downloadMap", "Download map as JPEG")
                    ),
                    
                    # Main panel for displaying outputs
                    mainPanel(
                      # Output: Plot with a spinner
                      withSpinner(plotOutput("heatMapPlot"))
                    )
                  )
))
