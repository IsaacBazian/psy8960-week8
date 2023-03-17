library(shiny)
library(tidyverse)

# Define UI for application
ui <- fluidPage(

    # App title. Thought it was descriptive enough for our purposes.
    titlePanel("PSY 8960 Week 8 Shiny App"),

    # App layout. I decided on sidebars because it felt natural to have the inputs partitioned off to the left and to see the plot update right next to them.
    sidebarLayout(
        # These lines define a sidepanel where users can click buttons to define inputs. I thought radio buttons would look nice, and they're a convenient way to let users see all options and pick
        sidebarPanel(
            radioButtons("gender", "Gender:", choices = c("Male", "Female", "All"), selected = "All"),
            radioButtons("error_band", "Error Band:", choices = c("Display Error Band", "Suppress Error Band"), selected = "Display Error Band"),
            radioButtons("date", "Completed Before August 1st, 2017:", choices = c("Include", "Exclude"), selected = "Include")
        ),
        # These lines simply display the plot next to the radio buttons panels, which updates in the server as users select different options
        mainPanel(
           plotOutput("plot")
        )
    )
)

# Define server for application
server <- function(input, output) {
  # This line reads in the data from where it was exported in the Rmd file. In this initial form, it is unfiltered, with all data points 
  shinydata_tbl <- readRDS(file = "./shinydata.rds")
  
  # This if statement determines if data is filtered by participant gender. If users select 'All', no filtering happens - if they select 'Male' or 'Female', that input is used to filter the gender column
  output$plot <- renderPlot({
    if (input$gender != "All") {
      shinydata_tbl <- shinydata_tbl %>% 
        filter(gender == input$gender)
    }
    
    # This if statement determines if data is filtered by participant completion before August 1st, 2017. If users select 'Include', no filtering happens - if they select 'Exclude,'the timeEnd column is filtered to be greater than or equal to that date
    if (input$date != "Include") {
      shinydata_tbl <- shinydata_tbl %>% 
        filter(timeEnd >= ymd_hms("2017-08-01 00:00:00"))
    }
    
    # This if else if statement determines if the plot has error bands or not. Now that all the data has been filtered as desired above, we draw one of two plots, with the only difference being whether they have the error bars set to FALSE or not
    if (input$error_band == "Display Error Band") {
      ggplot(shinydata_tbl, aes(x = meanq1q6, y = meanq8q10)) +
        geom_point() +
        geom_smooth(method = "lm", color = "purple") +
        labs(x = "Q1-Q6 Mean Scores", y = "Q8-Q10 Mean Scores")
    } else if (input$error_band == "Suppress Error Band"){
      ggplot(shinydata_tbl, aes(x = meanq1q6, y = meanq8q10)) +
        geom_point() +
        geom_smooth(method = "lm", color = "purple", se = FALSE) +
        labs(x = "Q1-Q6 Mean Scores", y = "Q8-Q10 Mean Scores")
    }
    
    })
}

# Run the app
shinyApp(ui = ui, server = server)
