
library(shiny)

opcoes <- names(mtcars)

ui <- fluidPage(
  
    selectInput(
        inputId = "variavel_a",
        label = "variavel_a",
        choices = opcoes
    ),
    
    plotOutput(outputId = "histograma_a"),
    
    
    selectInput(
        inputId = "variavel_b",
        label = "variavel_b",
        choices = opcoes,
        # começa a seleção em outro item
        selected = opcoes[2]
    ),
    
    plotOutput(outputId = "histograma_b"),
    
)

server <- function(input, output, session) {
    
    output$histograma_a <- renderPlot({
        
        # print para soltar no console para confirmar as modificaçÕes
        print("Rodei o código do A")
        hist(
            mtcars[[input$variavel_a]],
            main = paste0("Histograma da ", input$variavel_a)
            )
    }
    )
    
    output$histograma_b <- renderPlot({
        
        # print para soltar no console para confirmar as modificaçÕes
        print("Rodei o código do B")
        hist(
            mtcars[[input$variavel_b]],
            main = paste0("Histograma da ", input$variavel_b)
        )
    }
        
    )
    
  
}

shinyApp(ui, server)