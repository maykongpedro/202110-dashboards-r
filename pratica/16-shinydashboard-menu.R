
library(shiny)
library(shinydashboard)


ui <- dashboardPage(
    
    # sempre nessa ordem: header -> siderbar -> body
    dashboardHeader(),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem(text = "Página 1", tabName = "pag1"),
            menuItem(text = "Página 2", tabName = "pag2"),
            menuItem(text = "Página 3", tabName = "pag3"),
            menuItem(
                text = "Várias páginas",
                
                # para fazer subpáginas é necessário usar a menuSubItem
                menuSubItem(
                    text = "Página 4",
                    tabName = "pag4"
                ),
                menuSubItem(
                    text = "Página 5",
                    tabName = "pag5"
                ),
                menuSubItem(
                    text = "Página 6",
                    tabName = "pag6"
                )
            )
        )
    ),
    
    dashboardBody(
        tabItems(
            
            # o tabItem vai receber o mesmo nome do tabName
            tabItem(
                tabName = "pag1",
                h2("Conteúdo da página 1")
            ),
            tabItem(
                tabName = "pag2",
                h2("Conteúdo da página 2")
            ),
            tabItem(
                tabName = "pag3",
                h2("Conteúdo da página 3")
            ),
            tabItem(
                tabName = "pag4",
                h2("Conteúdo da página 4")
            ),
            tabItem(
                tabName = "pag5",
                h2("Conteúdo da página 5")
            ),
            tabItem(
                tabName = "pag6",
                h2("Conteúdo da página 6")
            )
        )
    )
    
)

server <- function(input, output, session) {
    
}

shinyApp(ui, server)