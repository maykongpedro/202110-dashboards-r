
# Carregar pacotes --------------------------------------------------------
library(shiny)


# Carregar base -----------------------------------------------------------
# pokemon <- readr::read_rds("dados/pkmn.rds")
pokemon <- readr::read_rds("../../dados/pkmn.rds")

# Ui ----------------------------------------------------------------------

ui <- shiny::navbarPage(
  title = "Pokémon",
  id = "menu"
)


# Server ------------------------------------------------------------------

server <- function(input, output, session) {
  
    # obter cada tipo de pokemon existente na base
    tipos <- unique(pokemon$tipo_1)
    
    # fazer loop para gerar uma página por tipo de pkm
    purrr::walk(
        .x = tipos,
        ~ shiny::appendTab(
            inputId = "menu",
            tab = shiny::tabPanel(
                title = stringr::str_to_title(.x),
                # para fazer rondar no Windows é necessário reditar os acentos de cada id
                conteudoUI(abjutils::rm_accent(.x))
            ),
            select = ifelse(
                test = .x == "grama",
                yes = TRUE,
                no = FALSE
            )
        )
    )
    
    # fazer loop para gerar o conteúdo do server para cada tipo
    purrr::walk(
        .x = tipos,
        ~ conteudoServer(abjutils::rm_accent(.x), .x, pokemon)
    )
    
}

shinyApp(ui, server)
