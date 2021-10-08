# Boxplots da base diamonds
# 
# Faça um shiny app para visualizarmos boxplots da base diamonds.
# 
# O seu app deve ter dois inputs e um output:
#   
#   1. o primeiro input deve ser uma caixa de seleção das variáveis 
#     numéricas da base (será o eixo y do gráfico).
# 
#   2. o segundo input deve ser uma caixa de seleção das variáveis 
#    categóricas da base (será o eixo x do gráfico).
# 
#   3. o output deve ser um gráfico com os boxplots da variável 
#    escolhida em (1) para cada categoria da variável escolhida em (2).
# 
# Para acessar a base diamonds, carrrege o pacote ggplot2
# 

#library(ggplot2)

# 
# ou rode 
# 
#ggplot2::diamonds

library(shiny)

# defindo base
db_diamonds <- ggplot2::diamonds

# apenas colunas númericas
base_cols_numericas <-
    db_diamonds |>
    dplyr::select(
        -cut,
        -color,
        -clarity
    )


# apenas colunas categóricas
base_cols_categoricas <-
    db_diamonds |>
    dplyr::select(
        cut,
        color,
        clarity
    )


ui <- fluidPage(
    
    # texto
    "Exercício extra 2 - Boxplots da base diamonds (pacote ggplot2)",
    
    
    # input
    selectInput(
        
        inputId = "variavel_numerica",
        label = "Selecione a variável númerica (eixo y) para exibir no boxplot",
        choices = names(base_cols_numericas)
        
    ),
    
    selectInput(
        
        inputId = "variavel_categorica",
        label = "Selecione a variável categórica (eixo x) para exibir on boxplot",
        choices = names(base_cols_categoricas) 
        
    ),
    
    
    # output
    plotOutput(
        outputId = "boxplot"
    )
    
)

server <- function(input, output, session) {
    
    output$boxplot <- renderPlot({
        
        db_diamonds |> 
            ggplot2::ggplot()+
            ggplot2::geom_boxplot(
                ggplot2::aes(
                    x = .data[[input$variavel_categorica]],
                    y = .data[[input$variavel_numerica]],
                ),
                fill = "#21918c",
                alpha = 0.7
            ) +
            ggplot2::labs(
                x = input$variavel_categorica,
                y = input$variavel_numerica,
                title = "Boxplot - base diamonds (ggplot2)"
            ) +
            ggplot2::theme_minimal()+
            ggplot2::theme(legend.position="none")
        
    }
        
    )
  
}

shinyApp(ui, server)
