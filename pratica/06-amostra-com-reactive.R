library(shiny)

# ver gráfico de reatividade (CTRL + F3 no navegador)
options(shiny.reactlog = TRUE)

ui <- fluidPage(
    
    # texto
    "Resultado do sorteio",
    
    # input
    sliderInput(
        
        inputId = "tamanho",
        label = "Selecione o tamanho da amostra",
        min = 1,
        max = 1000,
        value = 100
        
    ),
    
    # output
    plotOutput(outputId = "grafico"),
    
    # output2
    textOutput(outputId = "resultado")
    
)
    
server <- function(input, output, session) {

    # colocando o objeto amostra em uma expressão reativa
    amostra <- reactive({
        sample(
            1:10,
            input$tamanho,
            replace = TRUE
        )
    })
    
    # output 1
    output$grafico <- renderPlot({
        
        # gerar o gráfico de barras
        # amostra usando parenteses porque é um objeto reativo
        amostra() |> 
            # calcula a frequência pra cada número
            table() |> 
            # plota o gráfico
            barplot()
        
    })
    
    output$resultado <- renderText({

        # gera a tabela de frequência
        # amostra usando parenteses porque é um objeto reativo
        contagem <- table(amostra())
        
        # obtém o valor mais frequente da base
        mais_freq <- names(contagem[which.max(contagem)])
        
        # gera a frase final
        glue::glue("O valor mais sorteado foi {mais_freq}")
        
    }
    )
    
}

shinyApp(ui, server)
