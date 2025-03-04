library(shiny)

ui <- fluidPage(
  titlePanel("Vizualizare Functii de Repartitie"),
  sidebarLayout(
    sidebarPanel(
      selectInput("distribution", "Alege distributia:",
                  choices = c("Normala (0,1)", "Normala (mu, sigma^2)", "Exponentiala", "Poisson", "Binomiala")),
      numericInput("param1", "Parametru 1:", value = 1, min = 0.1),
      numericInput("param2", "Parametru 2:", value = 1, min = 0.1),
      numericInput("n", "Numar de esantioane:", value = 1000, min = 100)
    ),
    mainPanel(
      plotOutput("distPlot")
    )
  )
)