# Explorando inputs
# 
# Utilizando a base de criminalidade, faça um Shiny app que, dado um 
# mês/ano escolhido pelo usuário, mostre uma tabela com o número de ocorrências 
# de cada tipo que aconteceram naquele mês. 
# O nível territorial (Estado, região, município ou delegacia) também pode 
# ser um filtro.
# 

library(shiny)
library(shinyWidgets)

# Carregar base -----------------------------------------------------------
bd_criminalidade <- readr::read_rds("dados/ssp.rds")

# add uma coluna de data
# bd_criminalidade <- bd_criminalidade |> 
#   dplyr::mutate(
#     data = glue::glue("01/{mes}/{ano}"),
#     data = lubridate::dmy(data)
#   ) |> 
#   dplyr::relocate(data, .before = dplyr::everything()) 



# Criar base de escolhas -------------------------------------------------
meses <- bd_criminalidade |> 
    dplyr::distinct(mes)

ano <- bd_criminalidade |> 
    dplyr::distinct(ano)

# data <- bd_criminalidade |> 
#   dplyr::distinct(data)

municipios <- bd_criminalidade |> 
    dplyr::distinct(municipio_nome) |> 
    dplyr::arrange(municipio_nome)

regioes <- bd_criminalidade |> 
    dplyr::distinct(regiao_nome) |> 
    dplyr::arrange(regiao_nome) |> 
    tidyr::drop_na()

delegacias <- bd_criminalidade |> 
    dplyr::distinct(delegacia_nome) |> 
    dplyr::arrange(delegacia_nome) |> 
    tidyr::drop_na()


# Criar app ---------------------------------------------------------------


ui <- fluidPage(
    
  titlePanel("Ocorrências de crimes em SP"),
  sidebarLayout(
    
    sidebarPanel(
      
      #input1
      pickerInput( # input que permite selecionar tudo ou não
        inputId = "mes",
        label = "Selecione o mês desejado",
        choices = meses$mes,
        options = list(`actions-box` = TRUE),
        multiple = T,
        selected = meses$mes[1]
      ),
      
      #input2
      pickerInput( # input que permite selecionar tudo ou não
        inputId = "ano",
        label = "Selecione o ano desejado",
        choices = ano$ano,
        options = list(`actions-box` = TRUE),
        multiple = T,
        selected = ano$ano[1]
      ),
      
      
      #input3
      pickerInput( # input que permite selecionar tudo ou não
        inputId = "regiao",
        label = "Selecione a região de interesse",
        choices = regioes$regiao_nome,
        options = list(`actions-box` = TRUE),
        multiple = T,
        selected = regioes$regiao_nome
      ),
      
      #input4
      pickerInput( # input que permite selecionar tudo ou não
        inputId = "nome_muni",
        label = "Selecione o munícipio",
        choices = municipios$municipio_nome,
        options = list(`actions-box` = TRUE),
        multiple = T,
        selected = municipios$municipio_nome
      ),
      
      #input5
      pickerInput( # input que permite selecionar tudo ou não
        inputId = "delegacia",
        label = "Selecione a delegacia",
        choices = delegacias$delegacia_nome,
        options = list(`actions-box` = TRUE),
        multiple = T,
        selected = delegacias$delegacia_nome
      ),
      
      
      "Aluno: Maykon G. Pedro",
      br(),
      "Exercício 5 - Inputs-Outputs-SSP",
      br(),
      "Script: 022-inputs-outputs-ssp.R",
      br(),
      "A tabela exibe a quantidade de ocorrências por crime cometido."
      
    ),
    
    mainPanel(
      
      # output
      tableOutput(outputId = "tabela")
      
    )
    
  )

)


server <- function(input, output, session) {
  
    
    output$tabela <- renderTable({
        
        # faz o filtro primeiro e depois a pivotagem para ficar mais rápido
        base_filtrada <- bd_criminalidade |> 
            dplyr::filter(
                mes == input$mes,
                ano == input$ano,
                regiao_nome %in% input$regiao,
                municipio_nome %in% input$nome_muni,
                delegacia_nome %in% input$delegacia
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
        dplyr::mutate(total_ocorrencias = round(total_ocorrencias, 0)) |> 
        dplyr::arrange(desc(total_ocorrencias)) |> 
        dplyr::rename(
            "Tipo" = "crime_cometido",
            "Total de ocorrências" = "total_ocorrencias"
        )
        
    })
        
    
}

shinyApp(ui, server)
