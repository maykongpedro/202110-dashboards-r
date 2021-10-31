
library(shiny)
library(shinydashboard)


ui <- dashboardPage(
  
    # sempre nessa ordem: header -> siderbar -> body
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody()
    
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)