# ============================================================
# EXACT precision-oncology trial
# Exact binomial test
# ============================================================

# Total number of treated patients
n <- 55

# Number of patients with PFS1 / PFS0 > 1
x_obs <- 34

# Probability specified by the null hypothesis
p0 <- 0.40

# One-sided significance level used in the study
alpha <- 0.025


# ------------------------------------------------------------
# Observed proportion
# ------------------------------------------------------------

p_hat <- x_obs / n

print(p_hat)


# ------------------------------------------------------------
# Expected number of successes under H0
# ------------------------------------------------------------

expected <- n * p0

print(expected)


# ------------------------------------------------------------
# Hypotheses
# ------------------------------------------------------------

# H0: p = 0.40
# HA: p > 0.40
#
# We want to test whether the probability of benefit is
# greater than 0.40.
#
# Therefore this is a right-tailed test.


# ------------------------------------------------------------
# Exact binomial test
# ------------------------------------------------------------

result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "greater"
)

print(result)


# ------------------------------------------------------------
# Extract p-value
# ------------------------------------------------------------

p_value <- result$p.value

print(p_value)


# ------------------------------------------------------------
# Statistical decision
# ------------------------------------------------------------

if (p_value < alpha) {

  print("Reject H0")

} else {

  print("Do not reject H0")

}


# ============================================================
# Critical region
# ============================================================

# The proposed rejection region is:
#
# X >= 30
#
# Calculate:
#
# P(X >= 30)
#
# Since pbinom(29) gives P(X <= 29),
#
# P(X >= 30) = 1 - P(X <= 29)

p_30_or_more <- 1 - pbinom(
  29,
  size = n,
  prob = p0
)

print(p_30_or_more)


# ------------------------------------------------------------
# Check one count lower
# ------------------------------------------------------------

# Calculate:
#
# P(X >= 29)

p_29_or_more <- 1 - pbinom(
  28,
  size = n,
  prob = p0
)

print(p_29_or_more)


# ------------------------------------------------------------
# Compare with alpha
# ------------------------------------------------------------

print(alpha)

# P(X >= 30) < 0.025
#
# but
#
# P(X >= 29) > 0.025
#
# Therefore the rejection region begins at:
#
# X >= 30


# ============================================================
# Tail probability for the observed value
# ============================================================

# Observed:
#
# X = 34
#
# Calculate:
#
# P(X >= 34)

p_obs <- 1 - pbinom(
  33,
  size = n,
  prob = p0
)

print(p_obs)


# This is the same one-sided p-value returned by binom.test()

print(result$p.value)
