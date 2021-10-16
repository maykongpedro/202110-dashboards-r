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


# gerar base para o plot



# plotar gráfico