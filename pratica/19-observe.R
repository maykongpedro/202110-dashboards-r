
# Carregar pacotes --------------------------------------------------------
library(shiny)

# Carregar dados ----------------------------------------------------------
dados <- readr::read_rds("../dados/pkmn.rds")
# dados <- readr::read_rds("dados/pkmn.rds")

ui <- fluidPage(
    
    # título
    titlePanel("Shiny com sidebarLayout"),
    
    # layout
    sidebarLayout(
        
        sidebarPanel = sidebarPanel(
            
            # input1 - geração
            selectInput(
                inputId = "geracao",
                label = "Selecione a geração de pokemons",
                choices = unique(dados$id_geracao)
            ),
            
            
            # input2 - pokemon - opção 1 (com input dentro do session)
            # uiOutput(outputId = "ui_pokemon")
            
            # input2 - pokemon - opção 2 (usando observe() para atualizar a lista)            
            selectInput(
                inputId = "pokemon",
                label = "Selecione um pokemon",
                choices = c("Carregando..." = ""),
                selectize = TRUE
            )

        ),
        
        mainPanel = mainPanel(
            
            # centralizar output
            fluidRow(
                column(
                    offset = 3,
                    width = 6,
                    # output
                    imageOutput(outputId = "img_pokemon", height = "205px")
                    
                )
            )
            
        )
    ),
    
    fluidRow(
        column(
            width = 12,
            
            # output 2 - gráfico
            plotOutput(outputId = "plot_principal")
            )
        )
)

server <- function(input, output, session) {
    
    # input2 - pokemon - opção 1 (com input dentro do session)
    # output$ui_pokemon <- renderUI({
    #     
    #     escolhas <- dados |> 
    #         dplyr::filter(id_geracao == input$geracao) |> 
    #         dplyr::pull(pokemon)
    #     # input2 - pokemon
    #     selectInput(
    #         inputId = "pokemon",
    #         label = "Selecione um pokemon",
    #         choices = escolhas
    #     )
    #     
    # })
    
    
    # input2 - pokemon - opção 2 (usando observe() para atualizar a lista)            
    # é uma maneira mais prática porque o elemento selectInput é criado apenas
    # uma vez, diferente da opção 1, onde o selectInput é recriado toda vez
    # que a geração muda
    observe({
        
        # Sys.sleep(2)
        escolhas <- dados |>
            dplyr::filter(id_geracao == input$geracao) |>
            dplyr::pull(pokemon)

        # atualizar o select input definido na ui
        updateSelectInput(
            session = session,
            inputId = "pokemon",
            # atualizar o 'choices' do input com a lista de escolhas criada anteriomente
            choices = escolhas
        )        
        
    })
    
    # output 1 - imagem do pokemon
    output$img_pokemon <- renderImage({
        
        # Existe algumas opções para rodar essa reatividade corretamente, ou seja,
        # quando um pokemon é escolhido
        
        # opção 1 - req(), tem como requisito o input para rodar a reatividade
        req(input$pokemon)

        # opção 2 - validade + need, testa se o valor do input é válido
        # Sys.sleep(2) # um tempo apenas para ver a mensagem
        # validate(
        #     need(
        #         expr = isTruthy(input$pokemon),
        #         message = "Carregando as opções"
        #     )
        # )
        
        # capturar id do pokemon
        id <- dados |> 
            
            # filtrar pokemon
            dplyr::filter(pokemon == input$pokemon) |>
            
            # obtém o id
            dplyr::pull(id) |> 
            
            # adiciona "zero" na esquerda do id caso seja necessário
            stringr::str_pad(width = 3, side = "left", pad = 0)
        
        
        # capturar ul da imagem respectiva ao pokemon
        url <- stringr::str_glue(
            
            # concatenar url com o ID do pokemon
            "https://raw.githubusercontent.com/HybridShivam/Pokemon/master/assets/images/{id}.png"
        )
        
        
        # fazer download do arquivo
        arquivo <- tempfile(fileext = ".png")
        httr::GET(url, httr::write_disk(arquivo))
        
        # lista de argumentos necessários para o renderImage
        list(
            
            # esse argumento precisa ser o caminho da imagem
            src = arquivo,
            
            # comprimento da imagem (px)
            width = 205
        )
        
    },
    
    # argumento necessário para o shiny nao gerar um warning
    deleteFile = TRUE
    )
    
    # output 2 - gráfico
    output$plot_principal <- renderPlot({
        
        req(input$pokemon)
        print("Passei por aqui")
        
        dados |>
            # tabela
            # usando isolate() para garantir que o gráfico não seja
            # gerado novamente quando houver mudança da geração. Ele
            # só muda quando altera o pokemon. Nesse caso isso é realizado
            # porque a mudança de geração obrigatoriamente muda a geração,
            # então o input pokemon mudando não há necessidade da geração
            # ativar a reatividade também
            dplyr::filter(id_geracao == isolate(input$geracao)) |>

            # criar uma coluna que permita a separação entre o pokemon escolhido
            # e todos os outros, pra poder calcular a média
            dplyr::mutate(
                flag = ifelse(
                    test = pokemon == input$pokemon,
                    yes = input$pokemon,
                    no = "Média da geração"
                )
            ) |>

            tidyr::pivot_longer(
                cols = hp:velocidade,
                names_to = "status",
                values_to = "valor"
            ) |>
            dplyr::group_by(status, flag) |>
            dplyr::summarise(valor = mean(valor)) |>

            # gráfico
            ggplot2::ggplot(
                ggplot2::aes(
                    x = status,
                    y = valor,
                    fill = flag
                )
            ) +
            ggplot2::geom_col(position = "dodge")



    })

}

shinyApp(ui, server)
