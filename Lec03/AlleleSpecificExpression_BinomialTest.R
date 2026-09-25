# ============================================================
# Allele-specific expression
# Exact binomial test
# ============================================================

# Total number of allele-specific reads
n <- 100

# Number of reads from allele A
x_obs <- 68

# Under equal expression:
# probability that a read comes from allele A
p0 <- 0.5

# Significance level
alpha <- 0.05


# ------------------------------------------------------------
# Observed proportion
# ------------------------------------------------------------

p_hat <- x_obs / n

print(p_hat)


# ------------------------------------------------------------
# Expected number of allele-A reads under H0
# ------------------------------------------------------------

expected <- n * p0

print(expected)


# ------------------------------------------------------------
# Hypotheses
# ------------------------------------------------------------

# H0: p = 0.5
# HA: p != 0.5
#
# We want to detect expression imbalance in either direction.
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
