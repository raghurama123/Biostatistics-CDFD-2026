# ============================================================
# Hypothesis test for the HIV mutation probability
# ============================================================
#
# We want to test whether the true mutation probability
# is smaller than 5 x 10^(-4).
#
# Null hypothesis:
#
# H0: p = 5 x 10^(-4)
#
# Alternative hypothesis:
#
# HA: p < 5 x 10^(-4)
#
# We observed 3 mutations in a genome containing
# 10,000 nucleotides.
#
# The hypothesis test asks:
#
# If H0 is true, how likely is it to observe
# 3 mutations or fewer?
#
# ============================================================


# ------------------------------------------------------------
# Define the problem
# ------------------------------------------------------------

# Number of nucleotides examined
n <- 10000

# Mutation probability assumed under the null hypothesis
p0 <- 5e-4

# Observed number of mutations
x_obs <- 3


# ------------------------------------------------------------
# Calculate the p-value directly
# ------------------------------------------------------------

# Because the alternative hypothesis is:
#
# HA: p < p0
#
# this is a LEFT-TAILED hypothesis test.
#
# Therefore, the p-value is:
#
# P(X <= 3 | H0)
#
# That is, the probability of observing 3 or fewer mutations
# if the true mutation probability really is p0.

p_value <- pbinom(
  
  # Observed number of mutations
  x_obs,
  
  # Total number of trials (nucleotides)
  size = n,
  
  # Mutation probability under H0
  prob = p0
)

print(p_value)


# ------------------------------------------------------------
# Make the statistical decision
# ------------------------------------------------------------

# Choose a significance level
alpha <- 0.05

# Compare the p-value with alpha
#
# If p-value < alpha:
#     the observation is sufficiently unusual under H0,
#     so we reject H0.
#
# If p-value >= alpha:
#     the observation is not sufficiently unusual,
#     so we do not reject H0.

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}


# ------------------------------------------------------------
# Perform the exact binomial test using R
# ------------------------------------------------------------

# binom.test() performs the same hypothesis test directly.
#
# x = observed number of mutations
# n = total number of nucleotides
# p = mutation probability specified by H0
#
# alternative = "less" means:
#
# HA: p < p0
#
# Therefore, R performs a left-tailed test.

binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "less"
)

