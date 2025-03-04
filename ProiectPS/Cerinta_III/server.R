server <- function(input, output) {
  output$distPlot <- renderPlot({
    set.seed(123)
    n <- input$n
    
    
    base_data <- switch(input$distribution,
                        "Normala (0,1)" = rnorm(n, mean = 0, sd = 1),
                        "Normala (mu, sigma^2)" = rnorm(n, mean = input$param1, sd = sqrt(input$param2)),
                        "Exponentiala" = rexp(n, rate = input$param1),
                        "Poisson" = rpois(n, lambda = input$param1),
                        "Binomiala" = rbinom(n, size = as.integer(input$param1), prob = input$param2)
    )
    

    transform_data <- switch(input$distribution,
                             "Normala (0,1)" = list("X" = base_data, "3-2X" = 3 - 2 * base_data, "X^2" = base_data^2, "Suma X" = cumsum(base_data), "Suma X^2" = cumsum(base_data^2)),
                             "Normala (mu, sigma^2)" = list("X" = base_data, "3-2X" = 3 - 2 * base_data, "X^2" = base_data^2, "Suma X" = cumsum(base_data), "Suma X^2" = cumsum(base_data^2)),
                             "Exponentiala" = list("X" = base_data, "2+5X" = 2 + 5 * base_data, "X^2" = base_data^2, "Suma X" = cumsum(base_data)),
                             "Poisson" = list("X" = base_data, "3X-2" = 3 * base_data - 2, "X^2" = base_data^2, "Suma X" = cumsum(base_data)),
                             "Binomiala" = list("X" = base_data, "5X-4" = 5 * base_data - 4, "Suma X" = cumsum(base_data))
    )
    
   
    plot(ecdf(transform_data$X), main = paste("Functia de repartitie pentru", input$distribution),
         xlab = "Valori", ylab = "Functia de repartitie (CDF)", col = "blue", lwd = 2)
    
  
    if (!is.null(transform_data$`3-2X`)) lines(ecdf(transform_data$`3-2X`), col = "red", lwd = 2)
    if (!is.null(transform_data$`X^2`)) lines(ecdf(transform_data$`X^2`), col = "green", lwd = 2)
    if (!is.null(transform_data$`Suma X`)) lines(ecdf(transform_data$`Suma X`), col = "purple", lwd = 2)
    if (!is.null(transform_data$`Suma X^2`)) lines(ecdf(transform_data$`Suma X^2`), col = "orange", lwd = 2)
    
    legend("bottomright", legend = names(transform_data), col = c("blue", "red", "green", "purple", "orange"), lwd = 2)
  })
}