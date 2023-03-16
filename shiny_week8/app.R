setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(shiny)
library(tidyverse)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("PSY 8960 Week 8 Shiny App"),

    sidebarLayout(
        sidebarPanel(
            radioButtons("gender", "Gender:", choices = c("Male", "Female", "All"), selected = "All"),
            radioButtons("error_band", "Error Band:", choices = c("Display Error Band", "Suppress Error Band"), selected = "Display Error Band"),
            radioButtons("date", "Completed Before August 1st, 2017:", choices = c("Include", "Exclude"), selected = "Include")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("plot")
        )
    )
)


server <- function(input, output) {
  shinydata_tbl <- readRDS(file = "shiny_week8/shinydata.rds")
}

# Run the application 
shinyApp(ui = ui, server = server)
