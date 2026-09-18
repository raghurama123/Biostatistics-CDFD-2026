# ============================================================
# Binomial distribution:
# significance level for a LEFT-TAILED test
# ============================================================
#
# HIV example
#
# H0: p = 5 x 10^(-4)
# HA: p < 5 x 10^(-4)
#
# For a left-tailed test, unusually SMALL numbers of
# mutations provide evidence against H0.
#
# ============================================================


# Number of nucleotides
n <- 10000

# Mutation probability under H0
p0 <- 5e-4

# Significance level
alpha <- 0.05

# Corresponding probability outside the rejection region
confidence_level <- 1 - alpha

confidence_level
# 0.95


# ------------------------------------------------------------
# Binomial probability distribution under H0
# ------------------------------------------------------------

# Number of mutations to display
x <- 0:15

# Probabilities under H0
prob <- dbinom(
  x,
  size = n,
  prob = p0
)


# ------------------------------------------------------------
# Find the critical value for a left-tailed test
# ------------------------------------------------------------

# For a left-tailed test, all of alpha = 0.05
# is placed in the LEFT tail.
#
# We want the largest value of X for which:
#
#     P(X <= critical value | H0) <= 0.05
#
# Because the binomial distribution is discrete,
# the tail probability will usually not be exactly 0.05.

q <- qbinom(
  alpha,
  size = n,
  prob = p0
)


# qbinom() finds the first value where the cumulative
# probability reaches or exceeds alpha.
#
# Therefore, check whether q itself keeps the
# cumulative probability <= alpha.

if (pbinom(q, size = n, prob = p0) <= alpha) {
  
  critical <- q
  
} else {
  
  critical <- q - 1
  
}

critical


# Probability actually contained in the rejection region

pbinom(
  critical,
  size = n,
  prob = p0
)


# ------------------------------------------------------------
# Choose colors for the plot
# ------------------------------------------------------------

# Red = rejection region
# Blue = do-not-reject region

bar_col <- ifelse(
  x <= critical,
  "tomato",
  "skyblue"
)


# ------------------------------------------------------------
# Plot the probability distribution
# ------------------------------------------------------------

barplot(
  prob,
  names.arg = x,
  col = bar_col,
  
  xlab = "Number of mutations",
  ylab = "Probability",
  
  main = "Left-Tailed Binomial Test for HIV Mutations"
)


# ------------------------------------------------------------
# Add legend
# ------------------------------------------------------------

legend(
  "topright",
  
  legend = c(
    "Do not reject H0",
    "Rejection region"
  ),
  
  fill = c(
    "skyblue",
    "tomato"
  ),
  
  cex = 0.9
)


# ------------------------------------------------------------
# Interpretation
# ------------------------------------------------------------
#
# H0: p = 5 x 10^(-4)
# HA: p < 5 x 10^(-4)
#
# alpha = 0.05
#
# For a LEFT-TAILED test, small numbers of mutations
# are evidence against H0.
#
# If the observed number of mutations falls in the
# red rejection region:
#
#     Reject H0.
#
# There is evidence that the mutation probability
# is smaller than the value specified by H0.
#
#
# If the observed number of mutations falls in the
# blue region:
#
#     Do not reject H0.
#
# There is not sufficient evidence to conclude
# that the mutation probability is smaller than p0.
#
#
# Important:
#
# Because the binomial distribution is discrete,
# the probability of the rejection region may be
# smaller than, rather than exactly equal to, alpha = 0.05.
#
# "Do not reject H0" does NOT mean that H0 is true.