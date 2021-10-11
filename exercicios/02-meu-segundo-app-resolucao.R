# Meu segundo shiny app (agora importando uma base de dados)
# 
# Escolha uma das bases da pasta dados ou use uma base própria.
# 
# - Crie um shiny app com pelo menos um input e um output 
# para visualizarmos alguma informação interessante da base.
# 
# - Suba o app para o shinyapps.io.
# 
# Observação: se você usar uma base própria, 
# não se esqueça de descrever as variáveis utilizadas na hora 
# de tirar dúvidas.

# -------------------------------------------------------------------------
# Aluno: Maykon Gabriel
# Exercício resolvido no dia 07/10/2021
# Objetivo: gerar um app simples que faça o plot da área plantada de determinado
# gênero de plantio florestal em um mapa do Brasil
# -------------------------------------------------------------------------


# Carregar base -----------------------------------------------------------
# if(!require("pacman")) install.packages("pacman")

# instalar pacote que possui a base de dados
pacman::p_load_gh("maykongpedro/plantiosflorestais")

# carregar base de mapeamentos de plantios florestais estaduais
db_mapeamentos_ufs <- plantiosflorestais::mapeamentos_estados
db_mapeamentos_ufs |> dplyr::glimpse()

# gerar resumo dos dados
iba_genero_por_uf <- db_mapeamentos_ufs |>
  dplyr::filter(
    mapeamento == "IBÁ - Relatório Anual 2020",
    ano_base == "2019"
    ) |> 
  dplyr::group_by(mapeamento, genero, uf) |> 
  dplyr::summarise(area_ha = sum(area_ha, na.rm = TRUE)/1000) |> 
  dplyr::ungroup()


# gerar base das escolhas
opcoes_genero <- unique(iba_genero_por_uf$genero)

# importar shape
# lendo shape dos municípios do PR
shp_ufs <- geobr::read_state()

# ajustar nome da coluna de estado
shp_ufs <- shp_ufs |> 
  dplyr::rename(uf = "abbrev_state")


# shiny app ---------------------------------------------------------------

library(shiny)

ui <- fluidPage(
  
    # texto
    "Plantios florestais por estado no Brasil em 2019 segundo a Indústria Brasileira de Árvores (IBÁ)",
    
    # input ano
    selectInput(
      
      inputId = "genero_plantio",
      label = "Selecione o gênero do plantio florestal" ,
      choices = opcoes_genero
      
    ),
    
    # output
    plotOutput(outputId = "plot_mapa")
    
)

server <- function(input, output, session) {
  
  output$plot_mapa <- renderPlot({
    
    base_filtrada <- iba_genero_por_uf |> 
    dplyr::filter(genero == input$genero_plantio)      
      
    # fazer join da base com o shape
    shp_completo <-
      shp_ufs %>% 
      dplyr::left_join(base_filtrada, by = "uf")
    
    # fazer plot
    shp_completo |> 
      ggplot2::ggplot()+
      ggplot2::geom_sf(alpha = .5,
                       color = "white",
                       size = 0.2) +
      ggplot2::geom_sf(ggplot2::aes(fill = area_ha)) +
      ggplot2::scale_fill_viridis_c(
        direction = -1,
        option = "viridis"
        )+
      ggplot2::labs(fill = "Área (Mil ha)",
                    title = paste0("Área plantada do gênero ", input$genero_plantio, " no Brasil"), 
                    subtitle = paste0("Mapeamento realizado pelo FGV para o relatório IBÁ - 2020 | ", "Ano base: 2019"),
                    caption = "**Fonte:** Relatório IBÁ - 2020 | Acesso aos dados pelo pacote: *maykongpedro/plantiosflorestais*") +
      ggspatial::annotation_north_arrow(
        location = "br",
        which_north = "true",
        height = ggplot2::unit(1, "cm"),
        width = ggplot2::unit(1, "cm"),
        pad_x = ggplot2::unit(0.1, "in"),
        pad_y = ggplot2::unit(0.1, "in"),
        style = ggspatial::north_arrow_fancy_orienteering
      ) +
      ggspatial::annotation_scale() +
      ggplot2::theme_minimal()+
      ggplot2::theme(
        plot.title = ggplot2::element_text(face = "bold"),
        plot.caption = ggtext::element_markdown()
      )
      
      
  }
  )
  
}

shinyApp(ui, server)