library(shiny)

# Carregar dados ----------------------------------------------------------
dados <- readr::read_rds("../dados/pkmn.rds")


ui <- fluidPage(
  
    # título
    titlePanel("Shiny com sidebarLayout"),
    
    # layout
    sidebarLayout(
        
        sidebarPanel = sidebarPanel(
            
            # input1
            selectInput(
                inputId = "pokemon",
                label = "Selecione um pokemon",
                choices = unique(dados$pokemon)
            )
        ),
        
        mainPanel = mainPanel(
            
            # centralizar output
            fluidRow(
                column(
                    offset = 3,
                    width = 6,
                    # output
                    imageOutput(outputId = "img_pokemon")
                    
                )
            )
                        
        )
        
    )
    
)

server <- function(input, output, session) {
  
    output$img_pokemon <- renderImage({
        
        # capturar url da imagem respectiva ao pokemon (imagem pequena)
        # url <- dados |> 
        #     dplyr::filter(pokemon == input$pokemon) |> 
        #     dplyr::pull(url_imagem)
        
        id <- dados |> 
            
            # filtrar pokemon
            dplyr::filter(pokemon == input$pokemon) |>
            
            # obtém o id
            dplyr::pull(id) |> 
            
            # adiciona "zero" na esquerda do id caso seja necessário
            stringr::str_pad(width = 3, side = "left", pad = 0)
        
        
        # imagem grande
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
            width = 300
        )
        
    },
    
    # argumento necessário para o shiny nao gerar um warning
    deleteFile = TRUE
    )
    
}

shinyApp(ui, server)
