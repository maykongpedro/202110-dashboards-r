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
bd_criminalidade_pivot |> dplyr::glimpse()


# Criar base de escolhas -------------------------------------------------
meses <- bd_criminalidade |> 
    dplyr::distinct(mes)

ano <- bd_criminalidade |> 
    dplyr::distinct(ano)


# Criar app ---------------------------------------------------------------


ui <- fluidPage(
    
    # input 1
    selectInput(
        inputId = "mes",
        label = "Selecione o mês desejado",
        choices = meses$mes,
    ),
    
    # input 2
    selectInput(
        inputId = "ano",
        label = "Selecione o ano desejado",
        choices = ano$ano
    ),
    
    "Aluno: Maykon G. Pedro",
    br(),
    "Exercício 5 - Inputs-Outputs-SSP",
    br(),
    "Script: 022-inputs-outputs-ssp.R",
    br(),
    "A tabela exibe a quantidade de ocorrências por crime cometido.",
    
    # output
    tableOutput(outputId = "tabela")
  
)

server <- function(input, output, session) {
  
    
    output$tabela <- renderTable({
        
        # faz o filtro primeiro e depois a pivotagem para ficar mais rápido
        base_filtrada <- bd_criminalidade |> 
            dplyr::filter(
                mes == input$mes,
                ano == input$ano
                # municipio_nome == "",
                # delegacia_nome == "",
                # regiao_nome == ""
            ) 
        
        # agrupar todos os crimes em apenas uma coluna
        base_tabela <- base_filtrada |> 
            
            tidyr::pivot_longer(cols = 6:ncol(bd_criminalidade),
                                names_to = "crime_cometido",
                                values_to = "ocorrencias") |> 
            
            # retirando vítimas dos crimes
            dplyr::filter(!stringr::str_detect(crime_cometido, "vit")) |> 
            dplyr::filter(!is.na(delegacia_nome))
        
        
        base_tabela |> 
        dplyr::group_by(crime_cometido) |> 
        dplyr::summarise(total_ocorrencias = sum(ocorrencias)) |> 
        dplyr::arrange(desc(total_ocorrencias)) |> 
        dplyr::rename(
            "Tipo" = "crime_cometido",
            "Total de ocorrências" = "total_ocorrencias"
        )
        
    })
        
    
}

shinyApp(ui, server)
