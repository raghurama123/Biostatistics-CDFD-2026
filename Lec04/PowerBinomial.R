# ============================================================
# Statistical power for a binomial test
# ============================================================

# Test:
# H0: p = 0.50
# HA: p > 0.50
#
# Rejection region:
# X >= 15

n <- 20
p0 <- 0.50
critical <- 15

# ------------------------------------------------------------
# Power at p = 0.70
# ------------------------------------------------------------

p_true <- 0.70

beta <- pbinom(
  critical - 1,
  size = n,
  prob = p_true
)

power <- 1 - beta

beta
power

# Equivalent direct calculation
pbinom(
  critical - 1,
  size = n,
  prob = p_true,
  lower.tail = FALSE
)

# ------------------------------------------------------------
# Power curve
# ------------------------------------------------------------

p_true <- seq(
  0.50,
  0.90,
  by = 0.01
)

power <- pbinom(
  critical - 1,
  size = n,
  prob = p_true,
  lower.tail = FALSE
)

plot(
  p_true,
  power,
  type = "l",
  lwd = 2,
  xlab = "True probability p",
  ylab = "Power",
  ylim = c(0, 1),
  main = "Power Curve for a Right-Tailed Binomial Test"
)

abline(
  h = 0.8,
  lty = 2
)

# ------------------------------------------------------------
# Simulation estimate of power at p = 0.70
# ------------------------------------------------------------

set.seed(123)

x <- rbinom(
  100000,
  size = n,
  prob = 0.70
)

power_sim <- mean(x >= critical)

power_exact <- pbinom(
  critical - 1,
  size = n,
  prob = 0.70,
  lower.tail = FALSE
)

power_sim
power_exact
