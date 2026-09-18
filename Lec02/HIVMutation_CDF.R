# ============================================================
# HIV mutation problem: probability distribution under H0
# ============================================================

# Null hypothesis:
# mutation probability per nucleotide = 5 x 10^(-4)

n <- 10000
p0 <- 5e-4

# Observed number of mutations
x_obs <- 3

# Possible values to plot
x <- 0:15

# Binomial probabilities under H0
prob <- dbinom(
  x,
  size = n,
  prob = p0
)

# Colors:
# highlight x <= 3 for a left-tailed view
bar_col <- ifelse(x <= x_obs, "tomato", "skyblue")

# Bar plot
bp <- barplot(
  prob,
  names.arg = x,
  col = bar_col,
  xlab = "Number of mutations",
  ylab = "Probability",
  main = "Null distribution for HIV mutations"
)

# Add a label for the observed value
text(
  x = bp[x_obs + 1],
  y = prob[x_obs + 1],
  labels = "observed = 3",
  pos = 3
)




# ------------------------------------------------------------
# Probability of observing 3 or fewer mutations
# ------------------------------------------------------------

# Individual probabilities:
# P(X = 0), P(X = 1), P(X = 2), P(X = 3)

pvals <- dbinom(
  0:x_obs,
  size = n,
  prob = p0
)

print(pvals)


# Add the probabilities:
#
# P(X <= 3)
# = P(X = 0) + P(X = 1) + P(X = 2) + P(X = 3)

sum(pvals)

# ------------------------------------------------------------
# The same calculation using the cumulative distribution
# ------------------------------------------------------------
pbinom(
  x_obs,
  size = n,
  prob = p0
)
