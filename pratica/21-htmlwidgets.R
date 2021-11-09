

# Carregar pacotes --------------------------------------------------------
library(shiny)
library(shinydashboard)#remotes::install_github("abjur/abjData")


# Carregando dados --------------------------------------------------------
pnud <- abjData::pnud_muni |> 
    dplyr::filter(ano == "2010")



# Criar app ---------------------------------------------------------------
ui <- dashboardPage(
    
    skin = "purple",
    
    dashboardHeader(title = "PNUD"),
    
    dashboardSidebar(
        menuItem("Informações gerais", tabName = "info")
    ),
    
    dashboardBody(
        tabItems(
            tabItem(
                tabName = "info",
                h2("Informações gerais dos municípios"),
                br(),
                # linha 1 - cards ----
                fluidRow(
                  infoBoxOutput(
                    outputId = "num_muni",
                    width = 4
                  ),
                  infoBoxOutput(
                    outputId = "maior_idhm",
                    width = 4
                  ),
                  infoBoxOutput(
                    outputId = "maior_idhm",
                    width = 4
                  )
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
                    reactable::reactableOutput(outputId = "tabela")
                  )
                )
            )
        )
    )
    
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)