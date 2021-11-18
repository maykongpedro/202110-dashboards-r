
histograma_ui <- function(id){
    ns <- NS(id) # necessário para criar módulos
    tagList(
        selectInput(
            # todos os ids precisam ir dentro da função 'ns'
            inputId = ns("variavel_x"),
            label = "Selecione uma variável",
            choices = names(mtcars)
        ),
        br(),
        plotOutput(outputId = ns("grafico"))
    )
}

histograma_server <- function(id){
    # chamar a função moduleServer para construir um módulo pro server
    moduleServer(id, function(input, output, session){
        # construir normalmente o output
        output$grafico <- renderPlot({
            hist(mtcars[[input$variavel_x]]) # plotando histograma
        })
    })
}