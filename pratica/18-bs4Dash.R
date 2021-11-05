

# Carregar pacotes --------------------------------------------------------
library(shiny)
library(bs4Dash)

# instalar pacote para acessar bases do curso
# remotes::install_github("curso-r/basesCursoR")

# carregar base
# imdb <- basesCursoR::pegar_base("imdb")


# Criar função que será usada ao longo do app -----------------------------

# a melhor prática para uso dessas funções seria ter uma pasta R dentro do diretório
# do app, assim quando o shiny roda, ele carrega automaticamente os scrips dentro
# da pasta R

fn_separar <- function(base, coluna){
    
    base |> 
        dplyr::pull({{coluna}}) |> 
        stringr::str_split(", ") |> 
        purrr::flatten_chr() |> 
        unique()
    
}


fn_separar_e_contar_distintos <- function(base, coluna){
    
    base |> 
        fn_separar({{coluna}}) |> 
        length()
    
}




ui <- dashboardPage(
    
    # cabeçalho
    dashboardHeader(),
    
    # barra lateral
    dashboardSidebar(
        sidebarMenu(
            menuItem(text = "Informações gerais", tabName = "info"),
            menuItem(text = "Financeiro", tabName = "financeiro"),
            menuItem(text = "Elenco", tabName = "elenco")
        )
    ),
    
    # corpo principal
    dashboardBody(
        tabItems(
            # tabitem 1
            tabItem(
                tabName = "info",
                
                # fluid row 1
                fluidRow( # add linha
                    column( # add coluna
                        width = 12,
                        h2("Informações gerais dos filmes") # add título
                    )
                ),
                
                br(), # pular linha,
                
                # fluidrow2
                fluidRow(
                    
                    # info box é um elemento que ja gera uma coluna, ou seja,
                    # nao posso colocar outra coluna aqui dentro usando column
                    # se possui o argumento 'width' é quase certo que é uma coluna
                    infoBoxOutput(outputId = "num_filmes", width = 4),
                    infoBoxOutput(outputId = "num_diretores", width = 4),
                    infoBoxOutput(outputId = "num_atores", width = 4)
                ),
                
                # fluidorow3
                fluidRow(
                    column(
                        width = 12,
                        plotOutput(outputId = "plot_filmes_ano", height = "400px")
                    )
                )
                
            ),
            
            
            # tabitem 2
            tabItem(
                tabName = "financeiro",
                # fluid row 1
                fluidRow( # add linha
                    column( # add coluna
                        width = 12,
                        h2("Financeiro") # add título
                    )
                ),
                fluidRow(
                    
                    # o box cria uma caixa pra receber algum item, diferente do
                    # column que só organiza, sem gerear uma caixa
                    box(
                        width = 4,
                        title = "Filtros",
                        status = "info",
                        solidHeader = TRUE,
                        # usando essa função para poder criar um input dentro do server
                        # porque nesse caso as escolhas dos gêneros estão na base
                        uiOutput(outputId = "ui_financeiro_genero")
                    ),
                    box(
                        width = 8,
                        plotOutput(outputId = "plot_orc_vs_receita")
                    )
                )
                
                
            ),
            
            # tabitem 3
            tabItem(
                tabName = "elenco",
                
                # Lição de casa: dado um ator/atriz (ou diretor (a)), mostrar um
                # gráfico com os filmes feitos por essa pessoa e a nota desses filmes
                # filtrar um ano antes de gerar as opções, porque senão a quantidade 
                # será muito grande e irá ficar lento)
                
            )
        )
    )
    
)

server <- function(input, output, session) {
    
    # carregar base
    imdb <- basesCursoR::pegar_base("imdb")
    
    # output 1 - número de filmes
    output$num_filmes <- renderInfoBox({
        
        # quantidade de filmes na base
        numero_filmes <- nrow(imdb)
        
        # formatar para exibir melhor no dashboard
        numero_filmes <- scales::number(numero_filmes, big.mark = ".", decimal.mark = ",")
        numero_filmes <- prettyNum(numero_filmes, big.mark = ".", decimal.mark = ",")
        
        # essa info box pode ser carregada na UI se a base for carregada antes,
        # porque ela é basicamente um HMTL, caso seja estático
        infoBox(
            title = "Número de filmes",
            value = numero_filmes,
            color = "orange",
            
            # para usar ícones pode ser utilizado os nomes dos ícones disponíveis
            # no site "https://fontawesome.com/", o que não está em cinza é gratuito
            icon = icon("film")
        )
    })
    
    # output 2 - número de diretores
    output$num_diretores <- renderInfoBox({
        
        # calcular quantidade de diretores únicos na base
        numero_diretores <- fn_separar_e_contar_distintos(imdb, direcao)
        
        # formatar para exibir melhor no dashboard
        numero_diretores <- prettyNum(numero_diretores, big.mark = ".", decimal.mark = ",")
        
        
        infoBox(
            title = "Número de diretores e diretoras",
            value = numero_diretores,
            color = "olive",
            icon = icon("film")
        )
        
    })
    
    # output 3 - número de atores e atrizes
    output$num_atores <- renderInfoBox({
        
        # calcular quantidade de atores distintos na base
        numeros_atores <- fn_separar_e_contar_distintos(imdb, elenco)
        
        # formatar para exibir melhor no dashboard
        numeros_atores <- prettyNum(numeros_atores, big.mark = ".", decimal.mark = ",")
        
        formatar_numero <- function(x){
            
            scales::number_format()
            
        }
        
        infoBox(
            title = "Número de atrizes e atores",
            value = numeros_atores,
            color = "purple",
            icon = icon("film")
        )
        
    })
    
    # output 4 - gráfico de filmes por ano
    output$plot_filmes_ano <- renderPlot({
        
        # fazer gráfico da quantidade de filmes por ano
        imdb |>
            dplyr::count(ano, sort = TRUE) |> 
            ggplot2::ggplot(
                ggplot2::aes(
                    x = ano,
                    y = n
                )
            )+
            ggplot2::geom_col(color = "black", fill = "pink")+
            ggplot2::ggtitle("Número de filmes por ano") +
            cowplot::theme_minimal_grid()
        
        
    })
    
    # output 5 - seletor de gêneros (uiOutput)
    output$ui_financeiro_genero <- renderUI({
        
        # obtendo os gêneros da base
        generos <- fn_separar(imdb, genero) |> sort()
        
        # criando um input dentro do server usando uiOutput
        selectInput(
            inputId = "financeiro_genero",
            label = "Selecione um ou mais gêneros",
            multiple = TRUE,
            choices = generos 
        )
        
    })
    
    # output 6 - gráfico de orçamento x receita
    output$plot_orc_vs_receita <- renderPlot({
        
        imdb |> 
            dplyr::mutate(
                genero = stringr::str_split(genero, ", ")
            ) |> 
            tidyr::unnest(genero) |> 
            dplyr::filter(genero %in% input$financeiro_genero) |> 
            dplyr::distinct(titulo, .keep_all = TRUE) |> 
            
            ggplot2::ggplot(
                ggplot2::aes(
                    x = orcamento,
                    y = receita
                )
            ) +
            ggplot2::geom_point() +
            cowplot::theme_minimal_grid()
        
    })
    
}

shinyApp(ui, server)