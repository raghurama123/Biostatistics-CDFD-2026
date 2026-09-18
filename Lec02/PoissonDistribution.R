# ============================================================
# Binomial distribution approaching the Poisson distribution
# ============================================================

# A Poisson distribution can approximate a binomial distribution
# when:
#
#   n is large
#   p is small
#   lambda = n * p remains constant
#
# Here we keep lambda = 2.

lambda <- 2


# ------------------------------------------------------------
# Choose the number of trials
# ------------------------------------------------------------

# Try:
# n <- 10
# n <- 100
# n <- 1000

n <- 10


# Choose p so that:
#
# n * p = lambda
#
# Therefore:
#
# p = lambda / n

p <- lambda / n

# Show p
p


# ------------------------------------------------------------
# Compare one probability
# ------------------------------------------------------------

# Probability of exactly 1 success using
# the exact binomial distribution

dbinom(
  1,
  size = n,
  prob = p
)


# Probability of exactly 1 event using
# the Poisson approximation

dpois(
  1,
  lambda = lambda
)


# ------------------------------------------------------------
# Calculate the distributions
# ------------------------------------------------------------

# We plot probabilities for 0 to 10 successes.
#
# Keeping this range fixed makes it easy to compare
# n = 10, 100, and 1000.

x <- 0:10


# Exact binomial probabilities

binom_prob <- dbinom(
  x,
  size = n,
  prob = p
)


# Poisson probabilities using R's built-in function
poisson_prob <- dpois(
  x,
  lambda = lambda
)
print(poisson_prob)

# The same probabilities calculated directly
# from the Poisson probability formula:
#
# P(X = x) = exp(-lambda) * lambda^x / x!

poisson_prob_formula <- exp(-lambda) * lambda^x / factorial(x)

print(poisson_prob_formula)

# ------------------------------------------------------------
# Plot
# ------------------------------------------------------------

# Plot the exact binomial distribution

plot(
  x,
  binom_prob,
  
  # type = "h" draws vertical lines
  # from the x-axis to each probability
  type = "h",
  
  # Width of the vertical lines
  lwd = 4,
  
  # Keep the same y-axis for all values of n
  ylim = c(0, 0.3),
  
  # Do not draw the x-axis automatically.
  xaxt = "n", 
  
  # Axis labels
  xlab = "Number of successes",
  ylab = "Probability",
  
  # Display n and p in the title
  main = paste(
    "Binomial vs Poisson",
    "\nn =", n,
    "   p =", p
  ),
  
  # Binomial distribution in blue
  col = "blue"
)


# Add x-axis labels at every integer

axis(
  1, # means bottom axis
  at = x # tick marks at every value in x
)


# ------------------------------------------------------------
# Add Poisson probabilities
# ------------------------------------------------------------

points(
  x,
  poisson_prob,
  
  # pch = 16 gives solid circles
  pch = 16,
  
  # Size of points
  cex = 1.2,
  
  # Poisson distribution in red
  col = "red"
)


# ------------------------------------------------------------
# Add legend
# ------------------------------------------------------------

legend(
  "topright",
  
  # Labels
  legend = c(
    "Binomial",
    "Poisson"
  ),
  
  # Binomial shown as a line
  # Poisson has no line
  lty = c(1, NA),
  
  # Width of the binomial line
  lwd = c(4, NA),
  
  # Poisson shown as a solid circle
  pch = c(NA, 16),
  
  # Match colors in the plot
  col = c(
    "blue",
    "red"
  ),
  
  # Size of legend
  cex = 0.9
)