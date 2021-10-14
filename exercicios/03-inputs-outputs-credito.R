# Explorando inputs
# 
# Utilizando a base de crédito, faça um Shiny app que permite escolher
# o estado civil, tipo de moradia e/ou trabalho e mostra uma visualização
# representando a proporção de clientes "bons" e "ruins" da base.


# Carregar base -----------------------------------------------------------
#bd_credito <- readr::read_rds("./exercicios/dados/credito.rds")


# Criar base de escolhas --------------------------------------------------
estado_civil <- bd_credito |> 
    dplyr::distinct(estado_civil)

tipo_moradia <- bd_credito |> 
    dplyr::distinct(moradia)

trabalho <- bd_credito |> 
    dplyr::distinct(trabalho)


# Criar app ---------------------------------------------------------------

ui <- shiny::fluidPage(
  
)

server <- function(input, output, session) {
  
}

shiny::shinyApp(ui, server)