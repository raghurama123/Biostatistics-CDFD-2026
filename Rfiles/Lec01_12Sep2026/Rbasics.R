# ============================================================
# Basic syntax, vectors, data frames, statistics, and plots
# ============================================================

# In RStudio:
#   Run the current line or selected lines:
#       Mac:     Cmd + Enter
#       Windows: Ctrl + Enter
#
# Lines beginning with # are comments and are ignored by R.
#
# Useful commands:
#   ls()        -> list objects currently stored in memory
#   rm(x)       -> remove object x
#   rm(list = ls()) -> remove all objects from the workspace
#   ?mean       -> open help for the mean() function
#
# IMPORTANT:
# An object must be created before it can be used.
# For example:
#     x <- 10
# must be executed before R can evaluate:
#     x + 2


# ============================================================
# 1. BASIC MATHEMATICS
# ============================================================

2 + 3
10 / 4
5^2
sqrt(25)

# Other useful mathematical functions
abs(-5)       # absolute value
log(10)       # natural logarithm
exp(1)        # e^1
pi            # value of pi


# ============================================================
# 2. VARIABLES / OBJECTS
# ============================================================

# <- is the usual assignment operator in R.
# It means "store the value on the right in the object on the left."

x <- 10
y <- 4

x
y

x + y
x * y
x / y
x - y

# Check which objects currently exist
ls()

# Check the type/class of an object
class(x)


# ============================================================
# 3. VECTORS
# ============================================================

# c() means "combine".
# It creates a vector containing several values.

x <- c(2, 4, 6, 8, 10)

x

# NOTE:
# x previously contained the single value 10.
# The command above replaces that value with the new vector.

length(x)     # number of elements

# Operations on vectors are usually performed element by element.

x * 2
x + 1
x^2
sqrt(x)


# ============================================================
# 4. BASIC DESCRIPTIVE STATISTICS
# ============================================================

mean(x)
median(x)
sum(x)
sd(x)
min(x)
max(x)

# A convenient overall summary
summary(x)

# Variance
var(x)

# Quantiles
quantile(x)


# ============================================================
# 5. SELECTING ELEMENTS FROM A VECTOR
# ============================================================

x <- c(5, 8, 12, 3, 15, 7)

# R indexing starts at 1, not 0.

# First element
x[1]

# Third element
x[3]

# First three elements
x[1:3]

# Elements 2 and 5
x[c(2, 5)]

# Logical comparison:
x > 7

# Select only values greater than 7
x[x > 7]

# Select values between 5 and 12, inclusive
x[x >= 5 & x <= 12]


# ============================================================
# 6. DATA FRAMES
# ============================================================

# A data frame is similar to a table or spreadsheet.
# Rows usually represent observations.
# Columns usually represent variables.

students <- data.frame(
  name  = c("Anita", "Rahul", "Meera", "Arjun", "Nisha"),
  age   = c(20, 21, 19, 22, 20),
  score = c(78, 85, 92, 67, 88)
)

# Display the complete data frame
students

# Examine its structure
str(students)

# Summary statistics
summary(students)

# Number of rows and columns
nrow(students)
ncol(students)

# Dimensions: rows followed by columns
dim(students)

# Column names
names(students)


# ============================================================
# 7. ACCESSING DATA-FRAME COLUMNS
# ============================================================

# $ selects a named column.

students$score
students$age

mean(students$score)
sd(students$score)


# ============================================================
# 8. SELECTING ROWS AND COLUMNS
# ============================================================

# For a data frame:
#
#       data[row, column]
#
# The comma separates the row specification from the
# column specification.


# First row, all columns
students[1, ]

# All rows, second column
students[, 2]

# First row, second column
students[1, 2]

# Students with scores greater than 80
#
# The part before the comma selects rows.
# Nothing after the comma means "all columns".

students[students$score > 80, ]

# Select only the name and score columns
students[, c("name", "score")]

# Students older than 20
students[students$age > 20, ]


# ============================================================
# 9. SIMPLE PLOT
# ============================================================

x <- c(1, 2, 3, 4, 5)
y <- c(2, 4, 5, 8, 9)

# Basic scatter plot
plot(x, y)

# A more informative plot
plot(
  x,
  y,
  pch = 19,           # plotting symbol
  xlab = "X",         # x-axis label
  ylab = "Y",         # y-axis label
  main = "Plot of x vs. y"
)

# Connect the points with a line
lines(x, y)


# ============================================================
# 10. HISTOGRAM
# ============================================================

heights <- c(
  165, 170, 172, 168, 175,
  180, 169, 173, 171, 176,
  167, 174, 178, 166, 172
)

hist(
  heights,
  main = "Distribution of Heights",
  xlab = "Height (cm)"
)

# Descriptive statistics
mean(heights)
median(heights)
sd(heights)
summary(heights)


# ============================================================
# 11. BOXPLOT
# ============================================================

# A boxplot gives a compact visual summary of a distribution.
#
# It shows:
#
#   - Median: the line inside the box
#   - Q1: lower edge of the box (25th percentile)
#   - Q3: upper edge of the box (75th percentile)
#   - IQR: interquartile range = Q3 - Q1
#   - Whiskers: extend to the most extreme values within
#               1.5 * IQR from Q1 and Q3
#   - Outliers: values beyond the whiskers, shown as separate points
#
# The box therefore contains the middle 50% of the observations.
#
# Boxplots are useful for comparing:
#   - central tendency (median)
#   - spread or variability
#   - skewness/asymmetry
#   - possible outliers
#   - distributions between different groups

control <- c(120, 125, 119, 130, 128, 123)
treated <- c(110, 115, 108, 118, 112, 114)

boxplot(
  control,
  treated,
  names = c("Control", "Treated"),
  ylab = "Blood pressure"
)

mean(control)
mean(treated)

summary(control)
summary(treated)


# ============================================================
# 12. INDEPENDENT TWO-SAMPLE t-TEST
# ============================================================

# Compare the mean of the control group with the mean of
# the treated group.
#
# By default, t.test() performs Welch's two-sample t-test,
# which does not assume equal population variances.

t.test(control, treated)


# ============================================================
# 13. PAIRED t-TEST
# ============================================================

# Paired data arise when the SAME subjects are measured twice,
# for example before and after treatment.

before <- c(140, 135, 150, 142, 138, 145)
after  <- c(132, 130, 142, 137, 131, 139)

t.test(before, after, paired = TRUE)

# Examine the change directly
difference <- after - before

difference
mean(difference)


# ============================================================
# 14. CORRELATION
# ============================================================

height <- c(160, 165, 170, 175, 180, 185)
weight <- c(55, 60, 67, 72, 80, 86)

# Pearson correlation coefficient
cor(height, weight)

plot(
  height,
  weight,
  pch = 19,
  xlab = "Height (cm)",
  ylab = "Weight (kg)"
)


# ============================================================
# 15. LINEAR REGRESSION
# ============================================================

# lm() means "linear model".
#
# The formula
#
#       weight ~ height
#
# means:
#
#       model weight as a function of height
#
# R fits a model of the form:
#
#       weight = intercept + slope * height

model <- lm(weight ~ height)

# Basic fitted coefficients
model

# Detailed statistical information about the model
summary(model)

# Extract the coefficients directly
coef(model)

# Plot the observations
plot(
  height,
  weight,
  pch = 19,
  xlab = "Height (cm)",
  ylab = "Weight (kg)",
  main = "Linear Regression"
)

# Add the fitted regression line
abline(model)


# ============================================================
# 16. PREDICTION FROM A LINEAR MODEL
# ============================================================

# Predict the weight for a person with height = 172 cm.

predict(
  model,
  newdata = data.frame(height = 172)
)


# ============================================================
# 17. RANDOM NUMBERS
# ============================================================

# set.seed() makes random-number generation reproducible.
# Running this script again will therefore generate the
# same random numbers.

set.seed(123)

# Generate 100 observations from a normal distribution
# with mean = 50 and standard deviation = 10.

x <- rnorm(
  100,
  mean = 50,
  sd = 10
)

# Look at the first few values
head(x)

mean(x)
sd(x)

hist(
  x,
  main = "Random Normal Data",
  xlab = "x"
)

boxplot(
  x,
  ylab = "x",
  main = "Boxplot of Random Data"
)

summary(x)
quantile(x)


# ============================================================
# 18. MISSING VALUES: NA
# ============================================================

# Real datasets often contain missing observations.
# R represents a missing value using NA.

values <- c(10, 12, 15, NA, 18)

values

# This gives NA because one observation is missing:
mean(values)

# Tell R to ignore missing observations:
mean(values, na.rm = TRUE)

# Identify missing values
is.na(values)


# ============================================================
# 19. GETTING HELP
# ============================================================

# Put ? before a function name to open its help page.

?mean
?t.test
?lm
?plot

# Another way:
help(mean)


# ============================================================
# END OF SCRIPT
# ============================================================

