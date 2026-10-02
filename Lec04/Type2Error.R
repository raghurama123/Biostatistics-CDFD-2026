# ============================================================
# Type II error
# ============================================================

# Test:
# H0: p = 0.50
# HA: p > 0.50
#
# Rejection region:
# X >= 15

n <- 20
critical <- 15

# Suppose the true probability is actually 0.70
p_true <- 0.70

# A Type II error occurs if we do NOT reject H0:
# X <= 14

beta <- pbinom(
  critical - 1,
  size = n,
  prob = p_true
)

beta

# ------------------------------------------------------------
# Beta depends on the true alternative
# ------------------------------------------------------------

pbinom(
  critical - 1,
  size = n,
  prob = 0.55
)

pbinom(
  critical - 1,
  size = n,
  prob = 0.70
)

pbinom(
  critical - 1,
  size = n,
  prob = 0.90
)

# ------------------------------------------------------------
# Simulation of Type II error
# ------------------------------------------------------------

set.seed(123)

x <- rbinom(
  100000,
  size = n,
  prob = p_true
)

beta_sim <- mean(x < critical)

beta_sim
beta
