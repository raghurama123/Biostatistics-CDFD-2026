# ============================================
# Simple ggplot2 example
# ============================================

# Install ggplot2 once, if needed:
#install.packages("ggplot2")

# Load the package
library(ggplot2)

# Create a small data frame
students <- data.frame(
  name = c("Asha", "Ravi", "Meera", "Arun", "Neha"),
  hours_studied = c(2, 4, 5, 6, 8),
  score = c(55, 65, 72, 78, 90)
)

# View the data
students

# --------------------------------------------
# Scatter plot
# --------------------------------------------

# Default R-plot
plot(
  students$hours_studied,
  students$score,
  xlab = "Hours Studied",
  ylab = "Exam Score",
  main = "Study Time vs Exam Score"
)

# Plot with ggplot2
ggplot(students, aes(x = hours_studied, y = score)) +
  geom_point(size = 3) +
  labs(
    title = "Study Time vs Exam Score",
    x = "Hours Studied",
    y = "Exam Score"
  ) +
theme_minimal()

#theme_gray()      # default ggplot2 theme
#theme_minimal()   # clean, simple with grid
#theme_classic()   # white background, no grid
#theme_bw()        # black-and-white style

# Plot with ggplot2 and add a fitted line
ggplot(students, aes(x = hours_studied, y = score)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE) +  # add fitted line
  labs(
    title = "Study Time vs Exam Score",
    x = "Hours Studied",
    y = "Exam Score"
  ) +
theme_minimal()
