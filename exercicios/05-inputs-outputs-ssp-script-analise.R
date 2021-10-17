# Explorando inputs
# 
# Utilizando a base de criminalidade, faça um Shiny app que, dado um 
# mês/ano escolhido pelo usuário, mostre uma tabela com o número de ocorrências 
# de cada tipo que aconteceram naquele mês. 
# O nível territorial (Estado, região, município ou delegacia) também pode 
# ser um filtro.

# Script de análise da base de criminalidade, posteriomente o código é transformado
# em um app shiny no script do exercício


# Carregar base -----------------------------------------------------------
bd_criminalidade <- readr::read_rds("exercicios/dados/ssp.rds")


# Explorar base -----------------------------------------------------------

bd_criminalidade |> dplyr::glimpse()


# agrupar todos os crimes em apenas uma coluna
bd_criminalidade_pivot <- bd_criminalidade |> 

    tidyr::pivot_longer(cols = 6:ncol(bd_criminalidade),
                        names_to = "crime_cometido",
                        values_to = "ocorrencias") |> 
    
    # retirando vítimas dos crimes
    dplyr::filter(!stringr::str_detect(crime_cometido, "vit"))


bd_criminalidade_pivot |> dplyr::glimpse()

# visualizar quantos itens tem NA em cada coluna
bd_criminalidade_pivot |> 
    dplyr::summarise(
        dplyr::across(
            .cols = dplyr::everything(),
            .fns = ~sum(is.na(.x))
        )
    ) |> 
    dplyr::select(
        where(~.x > 0)
    )


# retirar itens com NA
bd_criminalidade_pivot <- bd_criminalidade_pivot |> 
    dplyr::filter(!is.na(delegacia_nome))


# gerar base para a tabela


if (escolha_muni == TRUE) {
    base_filtro <- bd_criminalidade_pivot |>
        dplyr::filter(
            mes == 1,
            ano == 2002,
            municipio_nome == "",
            # delegacia_nome == "",
            # regiao_nome == ""
        ) 
}



base_filtro <- bd_criminalidade_pivot |>
    dplyr::filter(
        mes == 1,
        ano == 2002,
        # municipio_nome == "",
        # delegacia_nome == "",
        # regiao_nome == ""
    ) 
    

base_table <- base_filtro |> 
    dplyr::group_by(crime_cometido) |> 
    dplyr::summarise(total_ocorrencias = sum(ocorrencias)) |> 
    dplyr::arrange(desc(total_ocorrencias)) |> 
    dplyr::rename(
        "Tipo" = "crime_cometido",
        "Total de ocorrências" = "total_ocorrencias"
    )


# plotar tabela




