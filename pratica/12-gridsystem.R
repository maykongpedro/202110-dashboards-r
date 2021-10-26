

# Criar quadrados em HTML para serem exibidos -----------------------------

quadrado <- function(text = "") {
  div(
    style = "background: purple; height: 100px; text-align: center; color: white; font-size: 24px;", 
    text
  )
}

quadrado2 <- function(text = "") {
  div(
    style = "background: green; height: 100px; text-align: center; color: white; font-size: 24px;", 
    text
  )
}


# Criar app ---------------------------------------------------------------


library(shiny)

ui <- fluidPage(
  
  # tudo dentro da fluidRow ficará na mesma linha
  # linha 1
  fluidRow(
    column(
      width = 3,
      quadrado(1)
    ),
    column(
      width = 3,
      quadrado(2)
    ),
    
    column(
      width = 3,
      quadrado(3)
    ),
    
    column(
      width = 3,
      quadrado(4)
    )
  ),
  
  # espaço entre linhas
  br(),
  
  # linha 2
  fluidRow(
    column(
      width = 1, 
      quadrado(5)
      ),
    
    column(
      width = 3, # largura de 3
      offset = 8, # pulando 8 espaços
      quadrado(6)
      )
  )

)

server <- function(input, output, session) {
  
    
    
}

shinyApp(ui, server)