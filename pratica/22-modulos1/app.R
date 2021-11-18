library(shiny)

# Se a pasta dos módulos não se chamar R
# source("nome_pasta/histograma.R")
# source("nome_pasta/dispersao.R")


# Módulos -----------------------------------------------------------------

# Dedois de construir eles aqui a parte do histograma e da dispersão foram
# divididas em outros dois scripts que serão oficialmente os módulos separados
# em outros arquivos.

# histograma
# histograma_ui <- function(id){
#     ns <- NS(id) # necessário para criar módulos
#     tagList(
#         selectInput(
#             # todos os ids precisam ir dentro da função 'ns'
#             inputId = ns("variavel_x"),
#             label = "Selecione uma variável",
#             choices = names(mtcars)
#         ),
#         br(),
#         plotOutput(outputId = ns("grafico"))
#     )
# }
# 
# histograma_server <- function(id){
#     # chamar a função moduleServer para construir um módulo pro server
#     moduleServer(id, function(input, output, session){
#         # construir normalmente o output
#         output$grafico <- renderPlot({
#             hist(mtcars[[input$variavel_x]]) # plotando histograma
#         })
#     })
# }

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
# dispersao_ui <- function(id){
#     ns <-NS(id)
#     opcoes <- names(mtcars)
#     tagList(
#         fluidRow(
#             column(
#                 width = 6,
#                 selectInput(
#                     inputId = ns("variavel_x"),
#                     label = "Selecione a variável do eixo x",
#                     choices = opcoes
#                 )
#             ),
#             column(
#                 width = 6,
#                 selectInput(
#                     inputId = ns("variavel_y"),
#                     label = "Selecione a variável do eixo y",
#                     choices = opcoes,
#                     selected = opcoes[2]
#                 )
#             )
#         ),
#         br(),
#         fluidRow(
#             column(
#                 width = 12,
#                 plotOutput(outputId = ns("grafico"))
#             )
#         )
#     )
# }
# 
# dispersao_server <- function(id){
#   moduleServer(id, function(input, output, session){
#     output$grafico <- renderPlot({
#       plot(
#         x = mtcars[[input$variavel_x]],
#         y = mtcars[[input$variavel_y]]
#       )
#     })
#   })
# }


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
          # histograma_ui("histograma_2")
          
          # situaçao de uso com a base como argumento
          # histograma_ui("histograma", mtcars),
          # histograma_ui("histograma_2", ggplot2::diamonds)
      ),
      column(
          width = 6,
          dispersao_ui("dispersao")
      )
  )
)


# Server ------------------------------------------------------------------

server <- function(input, output, session) {

  # chamando o módulo de server com o mesmo id que defini para a ui
  histograma_server("histograma")
  
  # teste com histograma 2
  # histograma_server("histograma_2")
  
  # # situaçao de uso com a base como argumento
  # histograma_server("histograma", mtcars)
  # histograma_server("histograma_2", ggplot2::diamonds)
  
  # chamando o módulo de server do gráfico de dispersão
  dispersao_server("dispersao")
  
  
}

shinyApp(ui, server)
