
library(shiny)

ui <- fluidPage(
  
  # texto que aparece antes da exibição do output
  "Um histograma",
  
  selectInput(
    
    # nome do input
    inputId = "variavel",
    
    # informação adicional para o usuário
    label = "Escolha uma variavel",
    
    # itens para seleção do usuário
    choices = names(mtcars) 
    
    ),
  
  # definir o nome do output para ser chamado no server
  plotOutput(outputId = "histograma")
  
)

server <- function(input, output, session) {
  
  output$histograma <- renderPlot({
    
    # aqui onde fica o código R que gera o output
    # input$variavel é para puxar a variavel de escolha criada na UI
    # está dentro de [] pois o resultado é uma string, o nome da coluna, no caso
    hist(mtcars[[input$variavel]])
    
  })
  
}

shinyApp(ui, server)