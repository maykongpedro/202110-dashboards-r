library(shiny)

ui <- fluidPage(
  
  # texto que aparece antes da exibição do output
  "Um histograma",
  
  # defini o nome do output para ser chamado no server
  plotOutput(outputId = "histograma")
)

server <- function(input, output, session) {
  
  output$histograma <- renderPlot({
    
    # aquié onde fica o código R que gera o output
    hist(mtcars$mpg)
    
  })
  
}

shinyApp(ui, server)