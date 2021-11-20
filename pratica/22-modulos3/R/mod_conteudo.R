

# Ui ----------------------------------------------------------------------
conteudoUI <- function(id) {
    
    ns <- NS(id)
    tagList(
        # linha 1
        fluidRow(
            column(
                width = 12,
                # uiOutput para o título porque ele vai ser reativo segundo o tipo,
                # além de alterar a cor.
                uiOutput(outputId = ns("titulo"))
            )
        ),
        # espaço em branco
        br(),
        # linha 2
        fluidRow(
            column(
                width = 4,
                selectInput(
                    inputId = ns("pokemon"),
                    label = "Selecione um pokémon",
                    choices = c("Carregando" = "")
                ),
                # uiOutput para a imagem porque ela vai alterar também
                uiOutput(outputId = ns("img_pokemon"))
            ),
            column(
                width = 8,
                plotOutput(outputId = ns("grafico_habilidades"))
            )
        ),
        # espaço em branco
        br(),
        # linha 3
        fluidRow(
            column(
                width = 12,
                plotOutput(outputId = ns("grafico_freq"))
            )
        )
    )
    
}


# Server ------------------------------------------------------------------
conteudoServer <- function(id, tipo, pokemon){
    moduleServer(id, function(input, output, session){
        
        # gerando a tabela filtrando pelo tipo escolhido
        tb_pokemon <- pokemon |> 
            dplyr::filter(tipo_1 == tipo)
        
        # definindo a cor do tipo de pokemon escolhido
        cor <- tb_pokemon |> 
            dplyr::pull(cor_1) |> 
            unique()
        
        # pintando o título de acordo com o tipo de pokemon
        output$titulo <- shiny::renderUI({
            shiny::h2(
                paste("Pokémon do tipo ", tipo),
                style = paste("color: ", cor, ";")
            )
        })
        
        # criando observe
        shiny::observe({
            # lista de pokemons
            pkmns <- tb_pokemon |> 
                dplyr::pull(pokemon) |> 
                unique()
            
            # definindo qual input será atualizado e o que, nesse caso apenas as escolhas
            shiny::updateSelectInput(
                session = session,
                inputId = "pokemon",
                choices = pkmns
            )
        })
        
        
        # definindo imagem do pokemon
        output$img_pokemon <- shiny::renderUI({
            
            # esse código só roda se houver um pokemon
            shiny::req(input$pokemon)
            
            # obter url da imagem do pokemom
            url <- pokemon |> 
                dplyr::filter(pokemon == input$pokemon) |> 
                dplyr::pull(url_imagem)
            
            # plotando imagem
            img(src = url, width = "300px")
            
        })
        
        
        # gerar gráfico de habilidades
        output$grafico_habilidades <- shiny::renderPlot({
            
            # esse código só roda se houver um pokemon
            shiny::req(input$pokemon)
            
            # pivotar tabela de pokemon
            tb_pokemon_escolhido <- tb_pokemon |> 
                dplyr::filter(pokemon == input$pokemon) |> 
                tidyr::pivot_longer(
                    names_to = "habilidade",
                    values_to = "valor",
                    cols = ataque:velocidade
                )
            
            # plotar gráfico
            tb_pokemon |>
                tidyr::pivot_longer(
                    names_to = "habilidade",
                    values_to = "valor",
                    cols = ataque:velocidade
                ) |> 
                ggplot2::ggplot(
                    ggplot2::aes(
                        x = valor,
                        y = habilidade,
                        fill = habilidade
                    )
                ) +
                ggridges::geom_density_ridges(
                    show.legend = FALSE,
                    alpha = 0.8
                ) +
                ggplot2::geom_point(
                    data = tb_pokemon_escolhido,
                    mapping =  ggplot2::aes(
                        x = valor,
                        y = habilidade,
                    ),
                    show.legend = FALSE,
                    shape = 4,
                    alpha = 0.9,
                    size = 5
                ) +
                ggplot2::labs(
                    x = "Valor",
                    y= "Habilidade"
                ) +
                ggplot2::theme_minimal()
            
        })
        
        
        # gerar gráfico de frequências
        output$grafico_freq <- shiny::renderPlot({
            
            tb_pokemon |> 
                dplyr::count(id_geracao) |> 
                ggplot2::ggplot(
                    ggplot2::aes(
                        x = id_geracao,
                        y = n
                    )
                ) +
                ggplot2::geom_col(fill = cor) +
                ggplot2::labs(
                    x = "Geração",
                    y = "Número de pokémons"
                ) +
                ggplot2::theme_minimal()
            
        })
        
    })
}
    
    
    
    
    
    
    
    
    
    
    










