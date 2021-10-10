library(shiny)

ui <- fluidPage(
  
    # input
    textInput(
        inputId = "entrada",
        label = "Escreva um texto"
    ),
    
    # output
    textOutput(outputId = "saida")
    
)

server <- function(input, output, session) {
  
    # expressão reativa
    a <- reactive({
        
        print(input$entrada)
        toupper(input$entrada) 
        
    })
    
    # output
    output$saida <- renderText({
        
        # objeto reativo: se ele não aparecer dentro de um contexto
        # de Observers, não será rodado, pois o R não verá necessidade
        a()
        
        #input$entrada
    })
    
}

shinyApp(ui, server)