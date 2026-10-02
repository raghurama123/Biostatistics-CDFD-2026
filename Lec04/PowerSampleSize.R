# ============================================================
# Effect of sample size on power
# ============================================================

# We test:
# H0: p = 0.50
# HA: p > 0.50
#
# For each n, choose the smallest critical value for which
# the right-tail probability under H0 is <= alpha.

p0 <- 0.50
p_true <- 0.65
alpha <- 0.05

sample_sizes <- c(
  20,
  50,
  100,
  200
)

power_values <- numeric(
  length(sample_sizes)
)

critical_values <- numeric(
  length(sample_sizes)
)

for (i in seq_along(sample_sizes)) {

  n <- sample_sizes[i]

  # Find possible critical values
  candidates <- 0:n

  tail_prob <- pbinom(
    candidates - 1,
    size = n,
    prob = p0,
    lower.tail = FALSE
  )

  # Smallest count whose null tail probability is <= alpha
  critical <- min(
    candidates[tail_prob <= alpha]
  )

  critical_values[i] <- critical

  # Power under the specified alternative
  power_values[i] <- pbinom(
    critical - 1,
    size = n,
    prob = p_true,
    lower.tail = FALSE
  )
}

results <- data.frame(
  n = sample_sizes,
  critical_value = critical_values,
  power = power_values
)

results

plot(
  sample_sizes,
  power_values,
  type = "b",
  pch = 16,
  xlab = "Sample size n",
  ylab = "Power",
  ylim = c(0, 1),
  main = "Effect of Sample Size on Power"
)
