# Explorando inputs
# 
# Utilizando a base de criminalidade, faça um Shiny app que, dado um 
# mês/ano escolhido pelo usuário, mostre uma tabela com o número de ocorrências 
# de cada tipo que aconteceram naquele mês. 
# O nível territorial (Estado, região, município ou delegacia) também pode 
# ser um filtro.
# 

library(shiny)


# Carregar base -----------------------------------------------------------
bd_criminalidade <- readr::read_rds("dados/ssp.rds")


# Criar base de escolhas -------------------------------------------------



# Criar app ---------------------------------------------------------------


ui <- fluidPage(
  
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)
