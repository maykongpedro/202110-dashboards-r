# Explorando inputs
# 
# Utilizando a base de pokemon, faça um Shiny app que permite escolher
# um tipo (tipo_1) e uma geração e faça um gráfico de dispersão do ataque 
# vs defesa para os pokemon com essas características.

library(shiny)

# Carregar base -----------------------------------------------------------
bd_pokemon <- readr::read_rds("dados/pkmn.rds")


# Criar base de escolhas --------------------------------------------------
tipo <- bd_pokemon |> 
    dplyr::distinct(tipo_1)

geracao <- bd_pokemon |> 
    dplyr::distinct(id_geracao) |> 
    dplyr::filter(!is.na(id_geracao))


# Criar app ---------------------------------------------------------------

ui <- fluidPage(
  
    titlePanel("Dispersão de ataque e defesa de pokemons"),
    
    # layout
    sidebarLayout(
        
        sidebarPanel(
            
            # input 1
            selectInput(
                inputId = "tipo",
                label = "Selecione o tipo do pokemon",
                choices = tipo$tipo_1
            ),
            
            # input 2
            selectInput(
                inputId = "geracao",
                label = "Selecione a geração do pokemon",
                choices = geracao$id_geracao
            ),
            
            "Aluno: Maykon G. Pedro",
            br(),
            "Exercício 4 - Inputs-Outputs-Pokemon",
            br(),
            "Script: 021-inputs-outputs-pokemon.R",
            br(),
            "Os nomes exibidos no gráfico são os nomes dos Pokemons."
            
        ),
        
        mainPanel(
            
            # output
            plotOutput(outputId = "plot_dispersao")
            
        )
        
    )
    
)

server <- function(input, output, session) {
    
    output$plot_dispersao <- renderPlot({
        
        # gerar base para o plot
        base_plot <- bd_pokemon |> 
            dplyr::filter(
                !is.na(tipo_1),
                !is.na(id_geracao)
            ) |> 
            dplyr::select(
                tipo_1, 
                id_geracao,
                ataque,
                defesa,
                pokemon
            ) 
        
        
        # plotar gráfico
        base_plot |> 
            dplyr::filter(
                tipo_1 == input$tipo,
                id_geracao == input$geracao
            ) |> 
            
            ggplot2::ggplot()+
            ggplot2::geom_point(
                ggplot2::aes(
                    x = ataque,
                    y = defesa
                ),
                color="black",
                fill="red",
                shape=21,
                alpha=0.5,
                size=7,
                stroke = 1
            ) +
            ggrepel::geom_text_repel(
                ggplot2::aes(
                    x = ataque,
                    y = defesa,
                    label = pokemon
                ),
                size = 6
                
            ) +
            ggplot2::theme_bw()
        
    })
  
}

shinyApp(ui, server)
