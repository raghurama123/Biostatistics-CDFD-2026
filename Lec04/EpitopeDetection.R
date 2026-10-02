# ============================================================
# Epitope detection:
# Binomial model and Poisson approximation
# ============================================================

# Number of candidate peptide positions
n <- 500

# Probability that one position produces a detectable epitope
p <- 0.004

# Expected number of detected epitopes
lambda <- n * p

lambda

# ------------------------------------------------------------
# Probability of exactly 3 detected epitopes
# ------------------------------------------------------------

# Exact binomial probability
binom_prob <- dbinom(
  3,
  size = n,
  prob = p
)

# Poisson approximation
poisson_prob <- dpois(
  3,
  lambda = lambda
)

binom_prob
poisson_prob

# ------------------------------------------------------------
# Probability of at least one detected epitope
# ------------------------------------------------------------

# P(X >= 1) = 1 - P(X = 0)
1 - dpois(
  0,
  lambda = lambda
)

# Equivalent calculation
ppois(
  0,
  lambda = lambda,
  lower.tail = FALSE
)

# ------------------------------------------------------------
# Compare complete distributions
# ------------------------------------------------------------

x <- 0:10

binom_prob <- dbinom(
  x,
  size = n,
  prob = p
)

poisson_prob <- dpois(
  x,
  lambda = lambda
)

plot(
  x,
  binom_prob,
  type = "h",
  lwd = 4,
  xaxt = "n",
  xlab = "Number of detected epitopes",
  ylab = "Probability",
  main = "Epitope Detection: Binomial vs Poisson"
)

axis(
  1,
  at = x
)

points(
  x,
  poisson_prob,
  pch = 16,
  cex = 1.2
)
