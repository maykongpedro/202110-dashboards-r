library(shiny)

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
  
    # Teste de reatividade
    # O shiny não consegue acessar valores de input fora das funções
    # 'render'.
    # amostra <- sample(
    #   1:10,
    #   input$tamanho,
    #   replace = TRUE
    # )
  
    # output 1
    output$grafico <- renderPlot({
        
        # cria a base de sorteio usando o tamanho definido no input
        amostra <- sample(
            1:10,
            input$tamanho,
            replace = TRUE
        )
        
        # gerar o gráfico de barras
        amostra |> 
          # calcula a frequência pra cada número
          table() |> 
          # plota o gráfico
          barplot()
        
    })
    
    # output 2 - Teste 1
    # Não funciona, porque o objeto amostra foi criado no renderPlot 1,
    # ou seja, não existe dentro desse renderText
    # output$resultado <- renderText({
    #  
    #   print(amostra)
    #   "O maior valor sorteado foi XXXXX"
    #    
    # }
    # )
    
    
    # output 2 - Teste 2
    # Nesse caso a base amostra é criada novamente, porém em um contexto
    # diferente, não está recebendo o mesmo resultado do output 1, gerando
    # valores distintos
    output$resultado <- renderText({

      # cria a base de sorteio usando o tamanho definido no input
      amostra <- sample(
        1:10,
        input$tamanho,
        replace = TRUE
      )
      
      # gera a tabela de frequência
      contagem <- table(amostra)
      
      # obtém o valor mais frequente da base
      mais_freq <- names(contagem[which.max(contagem)])
      
      # gera a frase final
      glue::glue("O valor mais sorteado foi {mais_freq}")

    }
    )
    
}

shinyApp(ui, server)


