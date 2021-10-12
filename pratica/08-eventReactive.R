library(shiny)

ui <- fluidPage(
    
    # texto
    "Formulário",
    
    # input 1
    textInput(
        inputId = "nome",
        label = "Digite o seu nome"
    ),
    
    # input 2
    numericInput(
        inputId = "idade",
        label = "Idade",
        value = 30,
        min = 18,
        max = NA,
        step = 1
        
    ),

    # input 3
    textInput(
        inputId = "estado",
        label = "Estado onde mora"
    ),
    
    # input 4
    actionButton(
        inputId = "botao",
        label = "Enviar"
    ),
    
    # texto 2
    # função usada para quebrar linhas (dar espaço)
    br(),
    "Resposta",
    
    # output
    textOutput(outputId = "resposta")
    
)

server <- function(input, output, session) {
  
    # frase <- eventReactive(
    #     
    #     # primeiro argumento é o que vai gera a mudança pra ativar a reatividade
    #     input$botao, {
    #         
    #         glue::glue(
    #             "Olá! Eu sou {input$nome}, tenho {input$idade} e moro em/no {input$estado}"
    #         )
    #         
    #     }
    # )
    
    
    # Para casos onde queremos que a mudança só ocorra por conta de um output,
    # ignorando os outros, devemos usar a função 'isolate'
    frase <- reactive({
        
        nome <- isolate(input$nome)
        idade <- isolate(input$idade)
        
        glue::glue(
        "Olá! Eu sou {nome}, tenho {idade} e moro em/no {input$estado}"
    )
    })
    
    
    
    output$resposta <- renderText(
        
        frase()
        
    )
    
}

shinyApp(ui, server)