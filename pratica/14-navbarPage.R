
library(shiny)

ui <- navbarPage(
  
    title = "Shiny com navbarPage",
    
    # dentro do navbarPage é necessário colocar as coisas dentro de tabPanels
    tabPanel(
        title = "Tela 1",
        h2("Conteúdo da tela 1"),
        # input
        sliderInput(
            inputId = "tamanho",
            label = "Tamanho da amostra",
            min = 1,
            max = 1000,
            value = 100
        )
    ),
    
    tabPanel(
        title = "Tela 2",
        h2("Conteúdo da tela 2"),
        # output
        plotOutput(outputId = "grafico")
    ),
    
    navbarMenu(
        
        title = "Várias telas",
        
        tabPanel(
            title = "Tela 3",
            h2("Conteúdo da tela 3")
        ),
        
        tabPanel(
            title = "Tela 4",
            h2("Conteúdo da tela 4")
        ),
        
    )
    
)

server <- function(input, output, session) {
  
    output$grafico <- renderPlot({
        
        # colocar uma pausa para ver a mudança
        Sys.sleep(1)
        
        # plotar histograma
        rnorm(input$tamanho) |> 
            hist()
        
    })
    
}

shinyApp(ui, server)