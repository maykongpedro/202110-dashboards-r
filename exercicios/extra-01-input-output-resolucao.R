# Gráfico de dispersão da base mtcars
#
# Faça um Shiny app para mostrar um gráfico de dispersão (pontos)
# das variáveis da base mtcars.
#
# O seu app deve:
#
#   - Ter dois inputs: a variável a ser colocada no eixo e a variável
#     a ser colocada no eixo y
#
#   - Um output: um gráfico de dispersão

# Aluno: Maykon Gabriel
# Exercício resolvido no dia 06/10/2021


library(shiny)

ui <- fluidPage(
  
    "Exercício extra 1",
    
    selectInput(
        inputId = "eixo_x",
        label = "Escolha a variável que será alocada no eixo x",
        choices = names(mtcars) 
    ),
    
    selectInput(
        inputId = "eixo_y",
        label = "Escolha a variável que será alocada no eixo y",
        choices = names(mtcars) 
    ),
    
    plotOutput(
        outputId = "plot_dispersao"
    )
)

server <- function(input, output, session) {
  
    output$plot_dispersao <- renderPlot({
        
        mtcars |> 
            ggplot2::ggplot() +
            ggplot2::geom_point(
                ggplot2::aes(
                    x = .data[[input$eixo_x]],
                    y = .data[[input$eixo_y]]
                )
            ) +
            ggplot2::labs(
                x = input$eixo_x,
                y = input$eixo_y,
                title = "Gráfico de dispersão - Database mtcars"
            )+
            ggplot2::theme_minimal()
        
    }
    )
    
}


shinyApp(ui, server)
