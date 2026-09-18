# ============================================================
# HIV mutation problem
# ============================================================
#
# The HIV genome contains approximately 10,000 nucleotides.
# Suppose that during one replication cycle, each nucleotide
# has a probability of 5 x 10^(-4) of undergoing a mutation,
# independently of the others.
#
# What is the probability of observing exactly 3 mutations?
#
# ============================================================

# HIV genome size: about 10,000 nucleotides
n <- 10000

# Probability of mutation at each nucleotide
p <- 5e-4

# Expected number of mutations
lambda <- n * p

lambda
# 5

x=3
# Exact binomial probabilities
binom_prob <- dbinom(
  x,
  size = n,
  prob = p
)
print(binom_prob)

# Poisson approximation
poisson_prob <- dpois(
  x,
  lambda = lambda
)
print(poisson_prob)

# ------------------------------------------------------------
# Probability of different numbers of mutations
# ------------------------------------------------------------

# Consider 0 to 12 mutations
x <- 0:12

# Exact binomial probabilities
binom_prob <- dbinom(
  x,
  size = n,
  prob = p
)

# Poisson approximation
poisson_prob <- dpois(
  x,
  lambda = lambda
)


# ------------------------------------------------------------
# Plot
# ------------------------------------------------------------

plot(
  x,
  binom_prob,
  type = "h",          # Vertical lines
  lwd = 4,             # Line width
  col = "blue",
  xaxt = "n",          # Do not draw automatic x-axis
  xlab = "Number of mutations",
  ylab = "Probability",
  main = "HIV Mutations: Binomial vs Poisson"
)

# Show every integer on the x-axis
axis(
  1,
  at = x
)

# Add Poisson probabilities
points(
  x,
  poisson_prob,
  pch = 16,            # Solid circles
  cex = 1.2,           # Point size
  col = "red"
)

# Add legend
legend(
  "topright",
  legend = c("Binomial", "Poisson"),
  lty = c(1, NA),
  lwd = c(4, NA),
  pch = c(NA, 16),
  col = c("blue", "red")
)