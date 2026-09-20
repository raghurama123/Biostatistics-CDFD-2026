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
# We observed 3 mutations among 10,000 nucleotides.
#
# Under H0:
#
# X ~ Binomial(n = 10000, p = 5 x 10^(-4))
#
# Because HA: p < p0, this is a LEFT-TAILED test.
#
# The p-value is:
#
# P(X <= 3 | H0)
#
# That is, the probability of observing 3 or fewer mutations
# if the mutation probability really is 5 x 10^(-4).
#
# ============================================================


# ------------------------------------------------------------
# Define the problem
# ------------------------------------------------------------

# Number of nucleotides examined
n <- 10000

# Mutation probability under the null hypothesis
p0 <- 5e-4

# Observed number of mutations
x_obs <- 3

# Significance level
alpha <- 0.05


# ------------------------------------------------------------
# Perform the exact binomial test
# ------------------------------------------------------------

result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "less"
)

# Display the test results

# Note:
#
# In the output, R may print:
#
# "alternative hypothesis: true probability of success is less than 5e-04"
#
# Here, the word "true" refers to the true, but unknown,
# probability of success, p.
#
# It does NOT mean that the alternative hypothesis is true.
#
# The statement means:
#
# HA: p < 5e-04
#
# Whether there is sufficient evidence for HA is decided
# from the p-value and the chosen significance level alpha.

result


# ------------------------------------------------------------
# Extract the p-value
# ------------------------------------------------------------

p_value <- result$p.value

print(p_value)


# ------------------------------------------------------------
# Compare the p-value with alpha
# ------------------------------------------------------------

# The decision rule is:
#
# p-value < alpha
#
#     Reject H0
#
# p-value >= alpha
#
#     Do not reject H0

p_value < alpha


# ------------------------------------------------------------
# Make the statistical decision
# ------------------------------------------------------------

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}


# ------------------------------------------------------------
# Interpretation
# ------------------------------------------------------------

# Here the p-value is approximately 0.265.
#
# Since:
#
# 0.265 > 0.05
#
# we do not reject H0.
#
# The observed mutation count (3) is smaller than the expected
# count under H0:
#
# E[X] = n * p0 = 5
#
# but 3 mutations is not sufficiently unusual under H0
# to provide evidence that the true mutation probability
# is smaller than 5 x 10^(-4).