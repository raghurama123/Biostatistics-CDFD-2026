# ============================================================
# Exact binomial test: general template
# ============================================================

# Number of trials
n <- 100

# Observed number of successes
x_obs <- 50

# Probability specified by the null hypothesis
p0 <- 0.5

# Significance level
alpha <- 0.05


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
# Exact binomial test
# ------------------------------------------------------------

result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "two.sided"
  # use:
  # "less"      for HA: p < p0
  # "greater"   for HA: p > p0
  # "two.sided" for HA: p != p0
)

print(result)

print( result$p.value )

print( result$estimate )

print( result$conf.int )

print( result$null.value )

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
