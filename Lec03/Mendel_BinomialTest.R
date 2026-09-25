# ============================================================
# Mendel's pea experiment
# Exact binomial test
# ============================================================

# Total number of seeds
n <- 7324

# Observed number of round seeds
x_obs <- 5474

# Probability of a round seed under the Mendelian 3:1 model
p0 <- 0.75

# Significance level
alpha <- 0.05


# ------------------------------------------------------------
# Observed proportion
# ------------------------------------------------------------

p_hat <- x_obs / n

print(p_hat)


# ------------------------------------------------------------
# Expected number of round seeds under H0
# ------------------------------------------------------------

expected <- n * p0

print(expected)


# ------------------------------------------------------------
# Hypotheses
# ------------------------------------------------------------

# H0: p = 0.75
# HA: p != 0.75
#
# The question asks whether the observed proportion differs
# from the Mendelian expectation.
#
# Therefore this is a two-sided test.


# ------------------------------------------------------------
# Exact binomial test
# ------------------------------------------------------------

result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "two.sided"
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
