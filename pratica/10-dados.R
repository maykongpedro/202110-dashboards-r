library(shiny)
library(dplyr)

imdb <- readr::read_rds("../dados/imdb.rds")

ui <- fluidPage(
  sliderInput(
    inputId = "anos",
    label = "Selecione o intervalo de anos",
    min = min(imdb$ano, na.rm = TRUE),
    max = max(imdb$ano, na.rm = TRUE),
    value = c(2000, 2010),
    step = 1,
    sep = ""
  ),
  tableOutput(outputId = "table")
)

server <- function(input, output, session) {
  
  # Caso os dados estivessem em um banco de dados, o ideal seria colocar
  # a base dentro de um 'reactive', assim toda vez que o usuário mudar o
  # ano, a query é realizada para trazer o banco de dados filtrado.
  # dados <- reactive({
  #   query(banco_de_dados, imdb, input$anos[1]:input$anos[2])
  # })
  
  # Carregando dentro do server a base não temos como usar ela antes
  # Nesse caso não é a melhor opção
  # imdb <- readr::read_rds("../dados/imdb.rds")
  
  output$table <- renderTable({
    
    # Caso a base venha do 'reactive'
    #dados() %>%
    
    imdb |> 
      filter(ano %in% input$anos[1]:input$anos[2]) %>% 
      select(titulo, ano, diretor, receita, orcamento) %>% 
      mutate(lucro = receita - orcamento) %>%
      top_n(20, lucro) %>% 
      arrange(desc(lucro)) %>% 
      mutate_at(vars(lucro, receita, orcamento), ~ scales::dollar(.x))
  })
  
}

shinyApp(ui, server)