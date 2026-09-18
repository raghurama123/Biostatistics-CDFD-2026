# ============================================================
# Binomial distribution: 3 tosses of a fair coin
# ============================================================

# Number of tosses
n <- 3

# Probability of getting a head in one toss
p <- 0.5

# ------------------------------------------------------------
# Example: probability of getting exactly 3 heads
# ------------------------------------------------------------

# dbinom() gives the probability of getting exactly x successes
#
# x    = number of successes we are interested in
# size = total number of trials
# prob = probability of success in each trial

dbinom(
  3,
  size = 3,
  prob = 0.5
)


# ------------------------------------------------------------
# Complete binomial distribution
# ------------------------------------------------------------

# Possible number of heads in 3 tosses:
# 0, 1, 2, or 3

x <- 0:n


# Calculate the probability of each possible number of heads
#
# Because x is a vector (0, 1, 2, 3), dbinom() calculates
# all four probabilities at once.

prob <- dbinom(
  x,
  size = n,
  prob = p
)


# Show the probabilities
prob


# ------------------------------------------------------------
# Make a table
# ------------------------------------------------------------

results <- data.frame(
  Heads = x,
  Probability = prob
)

results


# ------------------------------------------------------------
# Plot the binomial distribution
# ------------------------------------------------------------

plot(
  x,
  prob,
  
  # type = "h" draws vertical lines from the x-axis to each probability value.
  # "h" can be thought of as histogram-like vertical lines.
  type = "h",
  
  # lwd = line width.
  # Larger values make the vertical lines thicker.
  lwd = 5,
  
  # Labels for the x- and y-axes
  xlab = "Number of Heads",
  ylab = "Probability",
  
  # Title shown above the plot
  main = "Binomial Distribution: 3 Coin Tosses"
)


# ------------------------------------------------------------
# Add points at the top of the vertical lines
# ------------------------------------------------------------

points(
  x,
  prob,
  
  # pch = plotting character, 16 means a solid filled circle.
  pch = 16,
  
  # cex = character expansion factor, 1 is the default size.
  cex = 1.3
)