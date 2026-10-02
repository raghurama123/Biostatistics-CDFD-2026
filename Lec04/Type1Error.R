# ============================================================
# Type I error and alpha
# Right-tailed binomial test
# ============================================================

# Null hypothesis:
# H0: p = 0.50

n <- 20
p0 <- 0.50

# Rejection region:
# X >= 15

critical <- 15

# ------------------------------------------------------------
# Exact Type I error probability
# ------------------------------------------------------------

# P(X >= 15 | H0 true)
alpha_actual <- pbinom(
  critical - 1,
  size = n,
  prob = p0,
  lower.tail = FALSE
)

alpha_actual

# ------------------------------------------------------------
# Simulation under H0
# ------------------------------------------------------------

set.seed(123)

x <- rbinom(
  100000,
  size = n,
  prob = p0
)

# Proportion of experiments in rejection region
alpha_sim <- mean(x >= critical)

alpha_sim
alpha_actual

# ------------------------------------------------------------
# Plot the null distribution and rejection region
# ------------------------------------------------------------

values <- 0:n

prob <- dbinom(
  values,
  size = n,
  prob = p0
)

bar_col <- ifelse(
  values >= critical,
  "tomato",
  "skyblue"
)

barplot(
  prob,
  names.arg = values,
  col = bar_col,
  xlab = "Number of successes",
  ylab = "Probability",
  main = "Type I Error Under H0"
)
