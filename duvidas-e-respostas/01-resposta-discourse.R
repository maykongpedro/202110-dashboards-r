
library(ggplot2)
library(tidyverse)
library(shiny)
 
 ui <- fluidPage(
   
     titlePanel("Dataset MTCARS"),
     
     selectInput(
         inputId = "variavel_x",
         label = "Escolha a variável X",
         choices = names(mtcars)
     ),
     
     selectInput(
         inputId = "variavel_y",
         label = "Escolha a variável Y",
         choices = names(mtcars)
     ),
     
     # coloquei o output depois para fazer sentido a escolha do usuário
     plotOutput(outputId = "dispersao_x"),
     
     # não há necessidade desse output
     # plotOutput(outputId = "dispersao_y")
     
 )
 
 server <- function(input, output, session) {
     
     output$dispersao_x <- renderPlot({
         
        ggplot(mtcars) +
        geom_point(
            aes(
                # a mudança necessária é aqui
                x = .data[[input$variavel_x]],
                y = .data[[input$variavel_y]]
                
                )
        )
     })
     
     # não há necessidade desse output, porque o gráfico vai usar os dois inputs
     # output$dispersao_y <- renderPlot({
     #     
     #     ggplot(mtcars) +
     #     geom_point(
     #         aes(x = input$variavel_x, 
     #             y = input$variavel_y)
     #         )
     # })
 }
 
 shinyApp(ui, server)


