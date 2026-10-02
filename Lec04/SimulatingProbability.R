# ============================================================
# Simulating probability distributions in R
# ============================================================

# ------------------------------------------------------------
# One binomial experiment
# ------------------------------------------------------------

rbinom(
  1,
  size = 10,
  prob = 0.5
)

# ------------------------------------------------------------
# Many binomial experiments
# ------------------------------------------------------------

set.seed(123)

sim <- rbinom(
  10000,
  size = 10,
  prob = 0.5
)

head(sim)

# Theoretical probability of exactly 6 successes
theoretical <- dbinom(
  6,
  size = 10,
  prob = 0.5
)

# Simulated proportion with exactly 6 successes
simulated <- mean(sim == 6)

theoretical
simulated

# ------------------------------------------------------------
# Effect of number of simulations
# ------------------------------------------------------------

set.seed(123)

N <- 100
sim <- rbinom(N, size = 10, prob = 0.5)
mean(sim == 6)

N <- 1000
sim <- rbinom(N, size = 10, prob = 0.5)
mean(sim == 6)

N <- 10000
sim <- rbinom(N, size = 10, prob = 0.5)
mean(sim == 6)

N <- 100000
sim <- rbinom(N, size = 10, prob = 0.5)
mean(sim == 6)

# ------------------------------------------------------------
# Simulating a Poisson distribution
# ------------------------------------------------------------

set.seed(123)

sim <- rpois(
  10000,
  lambda = 2
)

# Simulated probability of exactly 3 events
mean(sim == 3)

# Theoretical probability
dpois(
  3,
  lambda = 2
)

# ------------------------------------------------------------
# Compare simulated and theoretical distributions
# ------------------------------------------------------------

x <- 0:10

sim_prob <- sapply(
  x,
  function(k) mean(sim == k)
)

theory_prob <- dpois(
  x,
  lambda = 2
)

plot(
  x,
  theory_prob,
  type = "h",
  lwd = 4,
  xaxt = "n",
  xlab = "Number of events",
  ylab = "Probability",
  main = "Poisson Simulation vs Theory"
)

axis(
  1,
  at = x
)

points(
  x,
  sim_prob,
  pch = 16,
  cex = 1.2
)
