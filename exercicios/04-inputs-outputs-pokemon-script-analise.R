# Explorando inputs
# 
# Utilizando a base de pokemon, faça um Shiny app que permite escolher
# um tipo (tipo_1) e uma geração e faça um gráfico de dispersão do ataque 
# vs defesa para os pokemon com essas características.

# Script de análise da base de pokemons, posteriomente o código é transformado
# em um app shiny no script do exercício


# Carregar base -----------------------------------------------------------
bd_pokemon <- readr::read_rds("exercicios/dados/pkmn.rds")


# Explorar base -----------------------------------------------------------

bd_pokemon |> dplyr::glimpse()


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
        tipo_1 == "grama",
        id_geracao == "2"
    ) |> 

    ggplot2::ggplot()+
    ggplot2::geom_point(
        ggplot2::aes(
            x = ataque,
            y = defesa
        ),
        color="black",
        fill="#69b3a2",
        shape=23,
        alpha=0.5,
        size=3,
        stroke = 1

    ) +
    ggrepel::geom_text_repel(
            ggplot2::aes(
                x = ataque,
                y = defesa,
                label = pokemon
                )
    ) +
    ggplot2::theme_minimal()

    
    