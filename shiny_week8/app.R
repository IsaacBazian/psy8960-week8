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
  shinydata_tbl <- readRDS(file = "./shinydata.rds") #Will come back and fix this later, for now I am manually loading the data into my environment for the sake of time
  
  output$plot <- renderPlot({
    if (input$gender == "All") {
      shinydata_tbl <- shinydata_tbl #Nothing happens
    } else if (input$gender == "Male"|"Female"){
      shinydata_tbl <- shinydata_tbl %>% 
        filter(gender == input$gender)
    }
    
    if (input$date == "Include") {
      shinydata_tbl <- shinydata_tbl #Nothing happens
    } else if (input$date == "Exclude") {
      shinydata_tbl <- shinydata_tbl %>% 
        filter(timeEnd >= ymd_hms("2017-08-01 00:00:00"))
    }
    
    if (input$error_band == "Display Error Band") {
      ggplot(shinydata_tbl, aes(x = meanq1q6, y = meanq8q10)) +
        geom_point() +
        geom_smooth(method = "lm", color = "purple")
    } else if (input$error_band == "Suppress Error Band"){
      ggplot(shinydata_tbl, aes(x = meanq1q6, y = meanq8q10)) +
        geom_point() +
        geom_smooth(method = "lm", color = "purple", se = FALSE)
    }
    
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
