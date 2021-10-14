# Explorando inputs
# 
# Utilizando a base de crédito, faça um Shiny app que permite escolher
# o estado civil, tipo de moradia e/ou trabalho e mostra uma visualização
# representando a proporção de clientes "bons" e "ruins" da base.

library(shiny)
library(shinyWidgets)

# Carregar base -----------------------------------------------------------
bd_credito <- readr::read_rds("dados/credito.rds")


# Criar base de escolhas --------------------------------------------------
estado_civil <- bd_credito |> 
    dplyr::distinct(estado_civil)

tipo_moradia <- bd_credito |> 
    dplyr::distinct(moradia)

trabalho <- bd_credito |> 
    dplyr::distinct(trabalho)

# escolhas
escolhas_categoria <- bd_credito |> 
    dplyr::select(
        estado_civil,
        moradia,
        trabalho
    ) |> 
    names()

# Criar app ---------------------------------------------------------------

ui <- fluidPage(
  
    titlePanel("Proporção de clientes bons e ruins da base 'credito'"),

    # layout
    sidebarLayout( 
        
        sidebarPanel(
            
            # input
            radioGroupButtons(
                inputId = "categoria",
                label = "Escolha a categoria desejada:", 
                choices = escolhas_categoria,
                size = "lg"
            ),

            
            "A categoria será exibida no gráfico no eixo x, gerando uma visão",
             br(),
            "de proporção de status dos clientes existentes na categoria.",
            
        ),

        
        mainPanel(

            # output
            plotOutput(outputId = "plot_proporcao")  
            
            )
        )
    )

server <- function(input, output, session) {
    
    output$plot_proporcao <- renderPlot({
        
        # gerar base para o plot
        base_plot <- bd_credito |> 
            dplyr::filter(!is.na(.data[[input$categoria]])) |> 
            dplyr::group_by(status, .data[[input$categoria]]) |> 
            dplyr::summarise(qtd = dplyr::n()) 
        
        
        # quantidade de clientes
        qtd_clientes <- base_plot |> 
            dplyr::ungroup() |> 
            dplyr::summarise(clientes = sum(qtd)) |> 
            dplyr::pull()
        
        # criar função para o nome do eixo x
        nome_do_eixo_x <- function(eixo_x){
            
            # retira underscore, coloca espaço e transforma primeira letra em uppercase
            nome_do_eixo_x <- eixo_x |> 
                stringr::str_replace_all("_", " ") |> 
                stringr::str_to_title()
            
            nome_do_eixo_x
            
        }
        
        # definir itens básico do plot
        config_plot <-
            c(
                "bom" = "#35B779",
                "ruim" = "#F1605D",
                "background" = "#F5F5F2",
                "text" = "#22211D",
                "eixo_x_title" = nome_do_eixo_x(input$categoria),
                "eixo_y_title" = "Proporção de clientes (%)",
                "title_legend" = "Status",
                "title" = "Proporção de clientes bons e ruins na base de acordo com determinada categoria",
                "subtitle" = glue::glue("Proporção baseada no total de {qtd_clientes} clientes."),
                "caption" = "**@Dataviz:** @maykongpedro | **Fonte:** Base 'credito', disponibilizada pela CursoR"
            )
        # plotar gráfico de proporção
        base_plot |> 
            ggplot2::ggplot()+
            ggplot2::geom_col(
                ggplot2::aes(
                    x = .data[[input$categoria]],
                    y = qtd,
                    fill = status,
                ),
                position = "fill"
            ) +
            ggplot2::scale_fill_manual(
                breaks = c("bom", "ruim"),
                values = c(config_plot[["bom"]], config_plot[["ruim"]])
            )+
            ggplot2::scale_y_continuous(
                expand = c(0,0), 
                labels = scales::percent
            ) +
            ggplot2::labs(
                x = config_plot[["eixo_x_title"]],
                y = config_plot[["eixo_y_title"]],
                fill = config_plot[["title_legend"]],
                title = config_plot[["title"]],
                subtitle = config_plot[["subtitle"]],
                caption = config_plot[["caption"]]
            )+
            
            ggplot2::theme_minimal(base_size = 15)+
            ggplot2::theme(
                axis.text = ggplot2::element_text(face = "bold"),
                axis.title = ggplot2::element_text(face = "bold"),
                plot.title = ggplot2::element_text(face = "bold"),
                axis.line.x = ggplot2::element_line(size = 1),
                plot.caption = ggtext::element_markdown(),
                plot.background = ggplot2::element_rect(
                    fill = config_plot[["background"]], 
                    color = NA
                ),
                panel.background = ggplot2::element_rect(
                    fill = config_plot[["background"]], 
                    color = NA
                ),
                plot.margin = ggplot2::unit(c(1, 1, 1, 1), "cm") 
            )

    })
    
  
}

shiny::shinyApp(ui, server)
