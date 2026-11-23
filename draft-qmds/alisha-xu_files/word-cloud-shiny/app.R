# ==============================================================================
#       This is a Shiny App that creates an interactive Word Cloud UI
# template: https://github.com/rstudio/shiny-examples/tree/main/082-word-cloud
# ==============================================================================

library(shiny)
library(bslib)        # for functions controlling the user interface layout 
library(shinythemes)  # to change overall appearance of shiny app using different themes
library(tidyverse)
library(RColorBrewer)
library(wordcloud)

# ------------------- import data
ta <- read_csv("data/text_analysis_all.csv")

# specify choices object 
company_choices <- c("Meta", "Apple", "Google", "Nvidia", "Tesla", "Microsoft")
frequency_choices <- c("tf", "idf", "tf_idf")

# specify color palette
num_colors <- 5
pal <- brewer.pal(num_colors, "Dark2")

# =============================================================================
# User interface 
# =============================================================================

ui <- fluidPage(
  # Application title
  titlePanel("Word Cloud for Quarterly Reports of the Magnificent 6"),
  
  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      selectInput("selection", "Company",
                  choices = company_choices),
      hr(),
      sliderInput("max",
                  "Maximum Number of Words:",
                  min = 1,  max = 300,  value = 100)
    ),
    
    # Show Word Cloud
    mainPanel(
      plotOutput("plot")
    )
  )
)

# =============================================================================
# Server
# =============================================================================

server <- function(input,output){
  
  
  output$plot <- renderPlot({
    ta |>
      filter(COMP == input$selection) |>
      with(wordcloud(words = word
                     , freq = tf_idf
                     , max.words = input$max
                     , colors = pal
                     , random.order = TRUE))
  })
}

shinyApp(ui = ui, server = server)
