
# dispersão
dispersao_ui <- function(id){
    ns <-NS(id)
    opcoes <- names(mtcars)
    tagList(
        fluidRow(
            column(
                width = 6,
                selectInput(
                    inputId = ns("variavel_x"),
                    label = "Selecione a variável do eixo x",
                    choices = opcoes
                )
            ),
            column(
                width = 6,
                selectInput(
                    inputId = ns("variavel_y"),
                    label = "Selecione a variável do eixo y",
                    choices = opcoes,
                    selected = opcoes[2]
                )
            )
        ),
        br(),
        fluidRow(
            column(
                width = 12,
                plotOutput(outputId = ns("grafico"))
            )
        )
    )
}

dispersao_server <- function(id){
    moduleServer(id, function(input, output, session){
        output$grafico <- renderPlot({
            plot(
                x = mtcars[[input$variavel_x]],
                y = mtcars[[input$variavel_y]]
            )
        })
    })
}