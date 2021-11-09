

# Carregar pacotes --------------------------------------------------------
library(shiny)
library(shinydashboard)
#remotes::install_github("abjur/abjData")


# Carregando dados --------------------------------------------------------
pnud <- abjData::pnud_muni |> 
    dplyr::filter(ano == "2010")



# Criar app ---------------------------------------------------------------
ui <- shinydashboard::dashboardPage(
    
    skin = "purple",
    
    shinydashboard::dashboardHeader(title = "PNUD"),
    
    shinydashboard::dashboardSidebar(
        shinydashboard::menuItem("Informações gerais", tabName = "info")
    ),
    
    shinydashboard::dashboardBody(
        shinydashboard::tabItems(
            shinydashboard::tabItem(
                
            )
        )
    )
    
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)