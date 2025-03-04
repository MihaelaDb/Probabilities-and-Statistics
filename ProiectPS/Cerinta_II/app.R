library(shiny)
library(ggplot2)
library(gganimate)
library(gifski)
library(dplyr)

ui <- fluidPage(
  titlePanel("Distribuția Negativ Binomială"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("size", "Parametrul size (numărul de succese):", min = 1, max = 20, value = 5),
      sliderInput("prob", "Probabilitatea succesului per încercare:", min = 0.1, max = 1, value = 0.5, step = 0.05),
      sliderInput("x_max", "Limita superioară pentru X:", min = 10, max = 100, value = 50),
      selectInput("distType", "Formulare a distribuției:", 
                  choices = c("Număr eșecuri înainte de r succese" = "failures_before_r",
                              "Număr total încercări pentru r succese" = "total_trials",
                              "Sumă de variabile geometrice" = "sum_geom",
                              "Model Poisson-Gamma" = "poisson_gamma",
                              "Recompense Bernoulli" = "bernoulli_rewards")),
      selectInput("plotType", "Tip de reprezentare:", 
                  choices = c("Funcția de Masă a Probabilității (PMF)" = "pmf",
                              "Funcția de Repartiție Cumulativă (CDF)" = "cdf")),
      actionButton("animate", "Generează animație")
    ),
    mainPanel(
      plotOutput("distPlot"),
      imageOutput("animation")
    )
  )
)

server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    x_vals <- 0:input$x_max  
    df <- data.frame(x = x_vals)
    
    if (input$distType == "failures_before_r") {
      df$pmf <- dnbinom(x_vals, size = input$size, prob = input$prob)
      df$cdf <- pnbinom(x_vals, size = input$size, prob = input$prob)
      title <- "Număr de eșecuri înainte de r succese"
      
    } else if (input$distType == "total_trials") {
      df$pmf <- dnbinom(x_vals - input$size, size = input$size, prob = input$prob)
      df$cdf <- pnbinom(x_vals - input$size, size = input$size, prob = input$prob)
      title <- "Număr total de încercări pentru r succese"
      
    } else if (input$distType == "sum_geom") {
      simulated <- replicate(10000, sum(rgeom(input$size, input$prob)))
      df <- data.frame(x = simulated)
      title <- "Sumă de variabile geometrice"
      
    } else if (input$distType == "poisson_gamma") {
      lambda_vals <- rgamma(10000, shape = input$size, scale = (1 - input$prob) / input$prob)
      poisson_samples <- rpois(10000, lambda = lambda_vals)
      df <- data.frame(x = poisson_samples)
      title <- "Model Poisson-Gamma"
      
    } else if (input$distType == "bernoulli_rewards") {
      rewards <- rbinom(10000, size = input$size, prob = input$prob)
      df <- data.frame(x = rewards)
      title <- "Recompense în proces Bernoulli"
    }
    
    # Afișare PMF și CDF doar pentru distribuțiile care le au
    if (input$plotType == "pmf" && "pmf" %in% names(df)) {
      ggplot(df, aes(x, pmf)) + 
        geom_col(fill = "skyblue") + 
        labs(title = paste(title, "- PMF"), x = "X", y = "Probabilitate")
      
    } else if (input$plotType == "cdf" && "cdf" %in% names(df)) {
      ggplot(df, aes(x, cdf)) + 
        geom_line(color = "blue") +
        geom_point(color = "red") +
        labs(title = paste(title, "- CDF"), x = "X", y = "Probabilitate cumulativă")
    } else {
      # Pentru distribuțiile generate prin simulare, folosim histograme
      ggplot(df, aes(x)) + 
        geom_histogram(bins = 50, fill = "skyblue", color = "black", alpha = 0.7) + 
        labs(title = paste(title, "- Histogramă"), x = "X", y = "Frecvență")
    }
  })
  
  
  output$animation <- renderImage({
    req(input$animate)  
    
    # Definirea valorilor probabilității
    probs <- seq(0.1, 0.9, by = 0.1)  
    
    # Crearea datelor pentru animație
    animation_data <- expand.grid(x = 0:input$x_max, prob = probs)
    
    # Calcularea pmf pentru fiecare combinație de x și prob
    animation_data$pmf <- mapply(function(x, prob) dnbinom(x, size = input$size, prob = prob), 
                                 animation_data$x, animation_data$prob)
    
    # Verificarea că pmf nu conține valori NA sau NULL
    animation_data <- animation_data[!is.na(animation_data$pmf), ]
    
    # Crearea animației folosind ggplot
    frames <- ggplot(animation_data, aes(x = x, y = pmf, frame = prob)) + 
      geom_col(fill = "skyblue") + 
      transition_states(prob, transition_length = 2, state_length = 1) + 
      labs(title = "Evoluția distribuției când probabilitatea crește",
           x = "X", y = "Probabilitate")
    
    # Salvarea animației ca GIF
    gif_path <- tempfile(fileext = ".gif")
    anim_save(gif_path, frames, renderer = gifski_renderer())
    
    # Returnarea GIF-ului generat
    list(src = gif_path, contentType = 'image/gif')
  }, deleteFile = TRUE)
}
shinyApp(ui, server = server)
  