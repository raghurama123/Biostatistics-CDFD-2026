# ============================================================
# Multinomial distribution
# DNA nucleotide example
# ============================================================

# Category probabilities
prob <- c(
  A = 0.30,
  C = 0.20,
  G = 0.20,
  T = 0.30
)

# Check that probabilities add to 1
sum(prob)

# Sequence length
n <- 100

# Expected counts
n * prob

# ------------------------------------------------------------
# Simulate one DNA sequence
# ------------------------------------------------------------

set.seed(123)

one_sequence <- rmultinom(
  1,
  size = n,
  prob = prob
)

one_sequence

# Check that counts add to n
sum(one_sequence)

# ------------------------------------------------------------
# Simulate many DNA sequences
# ------------------------------------------------------------

set.seed(123)

sim <- rmultinom(
  10000,
  size = n,
  prob = prob
)

# First simulated sequence
sim[, 1]

# Mean nucleotide count across simulations
rowMeans(sim)

# Compare with theoretical expected counts
n * prob

# ------------------------------------------------------------
# Visualize one simulated sequence
# ------------------------------------------------------------

barplot(
  one_sequence[, 1],
  names.arg = names(prob),
  xlab = "Nucleotide",
  ylab = "Count",
  main = "Simulated Nucleotide Counts"
)
