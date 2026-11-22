# ==============================================================================
#       This is a Shiny App that creates an interactive Word Cloud UI
# template: https://github.com/rstudio/shiny-examples/tree/main/082-word-cloud
# ==============================================================================

library(shiny)
library(bslib)        # for functions controlling the user interface layout 
library(shinythemes)  # to change overall appearance of shiny app using different themes
library(tidyverse)

# ------------------- import data
companies <- c("Meta", "Apple", "Google", "Nvidia", "Tesla", "Microsoft")

# for loop for exporting all companies
for (i in companies) {
  df <- read_csv(paste0("data/text_analysis_", i, ".csv"))
  
  assign(paste0("ta_", i), df)
}

# =============================================================================
# User interface 
# =============================================================================

fluidPage(
  # Application title
  titlePanel("Word Cloud"),
  
  sidebarLayout(
    # Sidebar with a slider and selection inputs
    sidebarPanel(
      selectInput("selection", "Company:",
                  choices = books),
      actionButton("update", "Change"),
      hr(),
      sliderInput("freq",
                  "Minimum Frequency:",
                  min = 1,  max = 50, value = 15),
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

function(input, output, session) {
  # Define a reactive expression for the document term matrix
  terms <- reactive({
    # Change when the "update" button is pressed...
    input$update
    # ...but not for anything else
    isolate({
      withProgress({
        setProgress(message = "Processing corpus...")
        getTermMatrix(input$selection)
      })
    })
  })
  
  # Make the wordcloud drawing predictable during a session
  wordcloud_rep <- repeatable(wordcloud)
  
  output$plot <- renderPlot({
    v <- terms()
    wordcloud_rep(names(v), v, scale=c(4,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
}
