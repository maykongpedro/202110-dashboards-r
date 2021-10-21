# Date input
# 
# Reproduza o seguinte Shiny app: 
# https://cursodashboards.shinyapps.io/select-date/
#   
# Para acessar a base utilizada, rode o código abaixo:
# install.packages("nycflights13")
# nycflights13::flights

# dateRangeInput(
#   
#   inputId = "data",
#   label = "Selecione a data desejada",
#   start = min(data$data),
#   end = max(data$data),
#   min = min(data$data),
#   max = max(data$data),
#   format = "mm/yyyy",
#   separator = "até"
#   
# ),

library(shiny)


# Carregar base -----------------------------------------------------------

bd_voos <- nycflights13::flights


# Transformar base --------------------------------------------------------

dplyr::glimpse(bd_voos)

# criando a coluna apenas com a data
bd_voos <- bd_voos |> 
    dplyr::mutate(
        date = lubridate::ymd_hms(time_hour),
        date = lubridate::date(date)
    )



# Criar app ---------------------------------------------------------------


ui <- fluidPage(
  
    # input
    dateInput(
        inputId = "data",
        label = "Escolha o dia",
        value = min(bd_voos$date),
        max = max(bd_voos$date),
        format = "dd-mm-yyyy"
    ),
    
    # output1
    tableOutput(outputId = "tb_descritiva"),
    
    # output2
    plotOutput(outputId = "plot_empresa")
    
)

server <- function(input, output, session) {
  
    # output1
    output$tb_descritiva <- renderTable({
        
        
    })
    
    # output2
    output$plot_empresa <- renderPlot({
        
        # quantidade de voos por empresa
        base_plot <- bd_voos |> 
            #dplyr::filter(date == "2013-01-31") |> 
            dplyr::filter(date == input$data) |>
            dplyr::group_by(carrier) |> 
            dplyr::summarise(qtd_voos = dplyr::n()) |> 
            dplyr::arrange(desc(qtd_voos))
        
        # plotar gráfico
        base_plot |> 
            dplyr::mutate(
                carrier = forcats::fct_inorder(carrier)
            ) |> 
            ggplot2::ggplot()+
            ggplot2::geom_col(
                ggplot2::aes(
                    x = carrier,
                    y = qtd_voos
                )
            )+
            ggplot2::labs(
                x = "Empresa",
                y = "Quantidade de voos",
                title = "Número de voos por empresa"
            )+
            ggplot2::theme_minimal()
        
    })
    
}

shinyApp(ui, server)