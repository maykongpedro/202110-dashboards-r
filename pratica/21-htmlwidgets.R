
# Carregar pacotes --------------------------------------------------------
library(shiny)
library(shinydashboard)
#remotes::install_github("abjur/abjData")


# Carregando dados --------------------------------------------------------
pnud <- abjData::pnud_min |> 
    dplyr::filter(ano == "2010")


# Criar app ---------------------------------------------------------------
ui <- dashboardPage(
    
    skin = "purple",

    dashboardHeader(title = "PNUD"),

    dashboardSidebar(
      sidebarMenu(
        menuItem("Informações gerais", tabName = "info")
      )
    ),
 
    dashboardBody(
        tabItems(
            tabItem(
                tabName = "info",
                h2("Informações gerais dos municípios"),
                br(),

                # linha 1 - cards ----
                fluidRow(
                  infoBoxOutput(outputId = "num_muni", width = 4),
                  infoBoxOutput(outputId = "maior_idhm", width = 4),
                  infoBoxOutput(outputId = "menor_idhm", width = 4)
                ),
                
                # linha 2 - outputs: gráfico e mapa----
                fluidRow(
                  box(
                    width = 6,
                    title = "Gráfico",
                    plotly::plotlyOutput(outputId = "grafico")
                  ),
                  box(
                    width = 6,
                    title = "Mapa",
                    leaflet::leafletOutput(outputId = "mapa")
                  )
                ),
                
                # linha 3 - tabela ----
                fluidRow(
                  box(
                    width = 12,
                    title = "Dados",
                    reactable::reactableOutput(outputId = "tabela")),
                    downloadButton(outputId = "baixar", label = "Baixar!")
                )
            )
        )
    )
    
)

server <- function(input, output, session) {
  
  # teste download com base reativa ----
  dados <- reactive({
    pnud
  })
  
  # output1 - gráfico ----
  output$grafico <- plotly::renderPlotly({
    
    # browser()
  
    p <- pnud |>
      ggplot2::ggplot(
        ggplot2::aes(
          x = rdpc,
          y = espvida,
          colour = regiao_nm,
          size = pop/1e6
        )
      ) +
      ggplot2::geom_point() +
      ggplot2::scale_colour_viridis_d(begin = .2, end = .8) +
      ggplot2::labs(
        x = "Renda per capita",
        y = "Expectativa de vida",
        colour = "Região",
        size = "População"
      ) +
      cowplot::theme_minimal_grid(12)

    # capturando a linha selecionada
    if (!is.null(selected())) {
      linha_selecionada <- pnud |> 
        dplyr::slice(selected())
      # add linha selecionada no gráfico
      p <- p +
        ggplot2::geom_point(colour = "red", data = linha_selecionada)
    }
  
    # plotando com plotly
    plotly::ggplotly(p)

  })
  
  # output2 - mapa com leaflet ----
  output$mapa <- leaflet::renderLeaflet({
    
    pnud |> 
      leaflet::leaflet() |> 
      leaflet::addTiles() |> 
      leaflet::addMarkers(
        lng = ~lon,
        lat = ~lat,
        popup = ~muni_nm,
        clusterOptions = leaflet::markerClusterOptions()
      )
    
  })

  # teste seleção de linhas com reactive ----
  selected <- reactive({
    reactable::getReactableState(outputId = "tabela", name = "selected")
  })
  
  # output3 - tabela com reactable ----
  output$tabela <- reactable::renderReactable({
    
    pnud |> 
      dplyr::select(muni_id,
                    muni_nm,
                    uf_sigla,
                    regiao_nm,
                    idhm,
                    espvida,
                    rdpc,
                    gini,
                    pop) |> 
      reactable::reactable(
        striped = TRUE,
        compact = TRUE,
        highlight = TRUE,
        selection = "multiple", # add seleção de linhas
        columns = list(
          muni_id = reactable::colDef("ID"),
          muni_nm = reactable::colDef(
            "Município", 
            minWidth = 200,
            # add links aos nomes dos municípios
            cell = function(value, index){
              url <- sprintf("https://wikipedia.org/wiki/%s", value)
              htmltools::tags$a(href = url,
                                taget = "_blank",
                                as.character(value))
            }
            ),
          uf_sigla = reactable::colDef("UF"),
          regiao_nm = reactable::colDef("Região"),
          idhm = reactable::colDef(
            "IDH-M", 
            format = reactable::colFormat(digits = 3)
            ),
          espvida = reactable::colDef("Exp. Vida"),
          rdpc = reactable::colDef(
            "Renda",
            format = reactable::colFormat(currency = "BRL")
            ),
          gini = reactable::colDef(
            name = "Gini",
            format = reactable::colFormat(digits = 2)
        ),
          pop = reactable::colDef(
            name = "População",
            format = reactable::colFormat(
              digits = 0,
              separators = TRUE,
              locales = "pt-BR"
            )
          )
        )
      )
    
  })
  
  # output4 - botão de download ----
  output$baixar <- downloadHandler(
    
    filename = function(){
      "arquivo.csv"
    },
    
    content = function(file){
      readr::write_csv(dados(), file)
    }
    
  )
  
}

shinyApp(ui, server)
