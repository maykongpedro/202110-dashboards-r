library(shiny)


# Módulos -----------------------------------------------------------------



# Ui ----------------------------------------------------------------------

ui <- fluidPage(
  h1("Treinando a construção de módulos")
)


# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  
}

shinyApp(ui, server)