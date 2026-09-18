# ============================================================
# Binomial distribution:
# significance level and central 95% probability region
# ============================================================

# HIV example:
# Number of nucleotides
n <- 10000

# Probability of mutation at each nucleotide
p <- 5e-4

# Significance level
alpha <- 0.05

# Corresponding central probability
confidence_level <- 1 - alpha

confidence_level
# 0.95


# ------------------------------------------------------------
# Binomial probability distribution
# ------------------------------------------------------------

# Number of mutations to display
x <- 0:15

# Probability of each possible number of mutations
prob <- dbinom(
  x,
  size = n,
  prob = p
)


# ------------------------------------------------------------
# Find the central 95% region
# ------------------------------------------------------------

# For alpha = 0.05, divide the probability
# between the two tails:
#
# alpha / 2 = 0.025 in each tail

lower <- qbinom(
  alpha / 2,
  size = n,
  prob = p
)

upper <- qbinom(
  1 - alpha / 2,
  size = n,
  prob = p
)

lower
upper


# ------------------------------------------------------------
# Choose colors for the plot
# ------------------------------------------------------------

# Values inside the central region are blue.
# Values in the two tails are red.

bar_col <- ifelse(
  x < lower | x > upper,
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
  
  main = "Binomial Distribution of HIV Mutations"
)


# ------------------------------------------------------------
# Add legend
# ------------------------------------------------------------

legend(
  "topright",
  
  legend = c(
    "Central 95% region, Do not reject H0",
    "Tail regions, Rejection region"
  ),
  
  fill = c(
    "skyblue",
    "tomato"
  ),
  
  cex = 0.9
)

# ------------------------------------------------------------
# Interpretation of the confidence interval
# ------------------------------------------------------------
#
# For a two-sided test at significance level alpha = 0.05:
#
# If the value of p specified by H0 lies INSIDE the 95%
# confidence interval:
#
#     Do not reject H0.
#
# The observed data are compatible with the value specified by H0.
#
#
# If the value of p specified by H0 lies OUTSIDE the 95%
# confidence interval:
#
#     Reject H0 at the 5% significance level.
#
# The observed data provide evidence that p differs from
# the value specified by H0.
#
# Important:
# "Do not reject H0" does NOT mean that H0 has been proven true.
#
# alpha = 0.05 corresponds to a 95% confidence interval because:
#
#     confidence level = 1 - alpha = 0.95