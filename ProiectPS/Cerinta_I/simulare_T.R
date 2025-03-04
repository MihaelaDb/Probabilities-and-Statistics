#1
library(ggplot2)
library(dplyr)

num_sim <- 10^6 # nr de simulari


n <- 5  # numarul de etape
lambda <- c(1, 1.2, 0.8, 1.5, 1)  # Rratele distributiilor exponentiale pentru fiecare etapa
alpha <- c(0.9, 0.8, 0.85, 0.7, 0.6)  # probabilitatile de a continua la pasul urmator

#functia pentru a obtine timpul total si ultima activitate inainte ca activitatea sa se opreasca
simulate_T <- function() {
  T_total <- 0  # se initializeaza cu 0, adica activitatea nu a inceput inca
  last_stage <- 0
  for (i in 1:n) {  #iteram prin toate etapele
    T_total <- T_total + rexp(1, lambda[i])  # se genereaza un timp exponential care se adauga la T_total
    last_stage <- i # ultima activitate devine i
    if (runif(1) > alpha[i]) break  # verificam daca activitatea se opreste
  }
  return(c(T_total, last_stage)) 
}

# simulam acest proces de 10^6 ori
sim_results <- replicate(num_sim, simulate_T())
T_values <- sim_results[1, ]
last_stages <- sim_results[2, ]

# 1) estimam valoarea medie a timpului total si il afisam
E_T_simulated <- mean(T_values)
cat("Estimarea lui E(T):", E_T_simulated, "\n")

# reprezentarea grafica a distributiei lui T
ggplot(data.frame(T_values), aes(x = T_values)) +
  geom_histogram(bins = 100, fill = "blue", alpha = 0.6) +
  labs(title = "Distributia valorilor lui T",
       x = "T",
       y = "Frecventa") +
  theme_minimal()

# 2) E(t) exact
E_T_exact <- sum(sapply(1:n, function(i) {
  (1 / lambda[i]) * ifelse(i == 1, 1, prod(alpha[1:(i-1)]))
}))

cat("Valoarea exactă a E(T):", E_T_exact, "\n")


# 3)

p_finalizare_simulat <- sum(last_stages == n) / num_sim
cat("Probabilitatea estimată prin simulare:", p_finalizare_simulat, "\n")


# 4) Probabilitatea ca T ≤ σ
# 4) Probabilitatea ca T <= σ
sigma <- 5  
p_T_sigma <- sum(T_values <= sigma) / num_sim #T_values este vectorul care contine timpii simulati ai activitalitor finalizate
cat("Probabilitatea ca T ≤", sigma, ":", p_T_sigma, "\n")

# 5) Timpul minim și maxim de finalizare
T_min <- min(T_values)
T_max <- max(T_values)
cat("Timpul minim de finalizare:", T_min, "\n")
cat("Timpul maxim de finalizare:", T_max, "\n")
ggplot(data.frame(T_values), aes(x = T_values)) +
  geom_histogram(bins = 100, fill = "blue", alpha = 0.6) +
  labs(title = "Distribuția timpilor de finalizare",
       x = "Timp de finalizare",
       y = "Frecvență") +
  theme_minimal()


# 6)probabilitatea de oprire inainte de etapa k
k_values <- 1:n
prob_k <- sapply(k_values, function(k) {
  sum(last_stages < k) / num_sim
})


df_prob <- data.frame(k = k_values, Probabilitate = prob_stop_before_k)


ggplot(df_prob, aes(x = k, y = Probabilitate)) +
  geom_point(color = "red", size = 3) +
  geom_line(color = "blue") +
  labs(title = "Probabilitatea de oprire inainte de etapa k",
       x = "k",
       y = "P(Etapa finală < k)") +
  theme_minimal()