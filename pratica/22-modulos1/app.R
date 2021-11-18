library(shiny)

# Módulos -----------------------------------------------------------------

# histograma
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

# módulos com bases
# histograma_ui <- function(id, base){
#     ns <- NS(id) # necessário para criar módulos
#     tagList(
#         selectInput(
#             # todos os ids precisam ir dentro da função 'ns'
#             inputId = ns("variavel_x"),
#             label = "Selecione uma variável",
#             choices = names(base)
#         ),
#         br(),
#         plotOutput(outputId = ns("grafico"))
#     )
# }
# 
# histograma_server <- function(id, base){
#     # chamar a função moduleServer para construir um módulo pro server
#     moduleServer(id, function(input, output, session){
#         # construir normalmente o output
#         output$grafico <- renderPlot({
#             hist(base[[input$variavel_x]]) # plotando histograma
#         })
#     })
# }

# dispersão
dispersao_ui <- function(id){
    ns <-NS(id)
    tagList(
        fluidRow(
            column(
                width = 6,
                selectInput(
                    
                )
            ),
            column(
                width = 6,
                selectInput(
                    
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


# Ui ----------------------------------------------------------------------

ui <- fluidPage(
  h1("Treinando a construção de módulos"),
  fluidRow(
      column(
          width = 6,
          # chamando o módulo e definindo um id
          histograma_ui("histograma"),

          # teste com a mesmo módulo porém com id diferente, pois o id precisa
          # ser único por módulo
          histograma_ui("histograma_2")
          
          # situaçao de uso com a base como argumento
          # histograma_ui("histograma", mtcars),
          # histograma_ui("histograma_2", ggplot2::diamonds)
      ),
      column(
          width = 6
      )
  )
)


# Server ------------------------------------------------------------------

server <- function(input, output, session) {

    # chamando o módulo de server com o mesmo id que defini para a ui
    histograma_server("histograma")

    # teste com histograma 2
    histograma_server("histograma_2")
    
    # # situaçao de uso com a base como argumento
    # histograma_server("histograma", mtcars)
    # histograma_server("histograma_2", ggplot2::diamonds) 
}

shinyApp(ui, server)
