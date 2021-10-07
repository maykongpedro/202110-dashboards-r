# Meu primeiro shiny app
# 
# Faça um shiny app para visualizar histogramas da base diamonds 
# e o coloque no shinyapps.io.
# 
# Seu shiny deve ter um input e um output.
# 
# - Input: variáveis numéricas da base diamonds.
# - Output: histograma da variável selecionada.
# 
# Para acessar a base diamonds, carrrege o pacote ggplot2
# 
# library(ggplot2)
# 
# ou rode 
# 
# ggplot2::diamonds

# Aluno: Maykon Gabriel
# Exercício resolvido no dia 06/10/2021

library(shiny)

# defindo base
db_diamonds <- ggplot2::diamonds

# apenas colunas númericas
base_sem_cols_texto <-
    db_diamonds |>
    dplyr::select(
        -cut,
        -color,
        -clarity
    )


ui <- fluidPage(
 
    "Exercício 1 - Histograma das colunas númericas da base diamonds (pacote ggplot2)",
    
    selectInput(
        
        inputId = "variavel_selecionada",
        label = "Escolha a variável",
        choices = names(base_sem_cols_texto)
        
    ),
    
    plotOutput(outputId = "histograma")
    
)


server <- function(input, output, session) {
  
    output$histograma <- renderPlot(
        
        hist(
            db_diamonds[[input$variavel_selecionada]],
            main = "Histograma",
            xlab = input$variavel_selecionada,
            col = "#5ec962"
            )
        
    )
    
}

shinyApp(ui, server)

