# Selecionando várias opções
# 
# (a) Reproduza o seguinte Shiny app: 
# https://cursodashboards.shinyapps.io/select-multiple/
#   
# (b) Troque o selectInput pelo checkboxGroupInput().
# 
# Para acessar a base utilizada, rode o código abaixo:

# install.packages(nycflights13)
# nycflights13::flights


library(shiny)


# Carregar base -----------------------------------------------------------

bd_voos <- nycflights13::flights


# Transformar base --------------------------------------------------------

dplyr::glimpse(bd_voos)


# criando a coluna de data
bd_voos <- bd_voos |> 
    dplyr::mutate(
        date = lubridate::ymd_hms(time_hour),
        date = lubridate::date(date)
    )

# dicas sobre como agrupar datas:
#https://ro-che.info/articles/2017-02-22-group_by_month_r

# Criar app ---------------------------------------------------------------

ui <- fluidPage(
    
    # input
    checkboxGroupInput(
        inputId = "empresa",
        label = "Selecione uma ou mais empresas",
        choices = unique(bd_voos$carrier) 
    ),

    # output
    plotOutput(outputId = "plot_empresa")
    
)

server <- function(input, output, session) {
    
    
    # output
    output$plot_empresa <- renderPlot({
        
        # quantidade de voos por empresa
        base_plot <- bd_voos |> 
        #dplyr::filter(carrier %in% c("9E", "AS")) |>
            dplyr::filter(carrier %in% input$empresa) |>
            dplyr::group_by(
                month = lubridate::floor_date(date, "month"),
                carrier
                ) |> 
            dplyr::summarise(qtd_voos = dplyr::n()) |> 
            dplyr::arrange(month)
        
        
        # plotar gráfico
        base_plot |> 
            ggplot2::ggplot(
                ggplot2::aes(
                    x = month,
                    y = qtd_voos,
                    group = carrier,
                    color = carrier
                )
            )+
            ggplot2::geom_line(size = 1)+
            ggplot2::scale_color_discrete(guide = "none")+
            ggplot2::scale_x_date(
                date_breaks = "1 month",
                date_labels = "%b/%Y"
                
            ) +
            directlabels::geom_dl(
                ggplot2::aes(label = carrier),
                method = list(directlabels::dl.combine("first.points", "last.points")), 
                #method = "last.points",
                #method = "smart.grid",
                cex = 0.8 
            ) +
            
            ggplot2::labs(
                x = "Data",
                y = "Quantidade de voos",
                title = "Número de voos por empresa ao longo de 2013"
            )+
            ggplot2::theme_minimal() 
        
        })
    
}

shinyApp(ui, server)