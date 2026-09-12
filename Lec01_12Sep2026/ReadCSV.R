# ============================================================
# Reading data from files
# ============================================================


# ============================================================
# 1. CURRENT WORKING DIRECTORY
# ============================================================

# R normally looks for files in the current working directory.

getwd()

# List files in the current directory
list.files()

# In RStudio, you can also set the working directory using:
#
# Session -> Set Working Directory -> Choose Directory
#
# It is generally better to avoid repeatedly hard-coding
# setwd() commands in scripts when possible.


# ============================================================
# 2. READ A CSV FILE
# ============================================================

# Suppose we have a file called:
#
# students.csv
#
# containing:
#
# name,age,score
# Anita,20,78
# Rahul,21,85
# Meera,19,92
# Arjun,22,67
# Nisha,20,88


students <- read.csv("/Users/rr/repos/biostatistics_cdfd/2026_Huber_Holmes/Rfiles/students.csv")

# Display the data
students


# ============================================================
# 3. CHOOSE A FILE INTERACTIVELY
# ============================================================

# Instead of typing the filename, R can open a file-selection window.

students <- read.csv(file.choose())

# This is convenient when learning R or working interactively.

students
# ============================================================
# 4. EXAMINE THE IMPORTED DATA
# ============================================================

# First few rows
head(students)

# Last few rows
tail(students)

# Structure of the dataset
str(students)

# Column names
names(students)

# Number of rows
nrow(students)

# Number of columns
ncol(students)

# Dimensions: rows, columns
dim(students)

# Statistical summary
summary(students)


# ============================================================
# 5. ACCESS INDIVIDUAL COLUMNS
# ============================================================

students$name
students$age
students$score

mean(students$score)
median(students$score)
sd(students$score)


# ============================================================
# 6. SELECT ROWS
# ============================================================

# Students scoring more than 80

students[students$score > 80, ]

# Students aged 20

students[students$age == 20, ]

# Students aged at least 20

students[students$age >= 20, ]


# ============================================================
# 7. SELECT COLUMNS
# ============================================================

# Only name and score

students[, c("name", "score")]


# ============================================================
# 8. CREATE A NEW COLUMN
# ============================================================

# Add a pass/fail column

students$result <- ifelse(
  students$score >= 75,
  "Pass",
  "Fail"
)

students


# ============================================================
# 9. SORT DATA
# ============================================================

students[order(students$name), ]

# Sort by score from lowest to highest

students[order(students$score), ]

# Sort from highest to lowest

students[order(students$score, decreasing = TRUE), ]


# ============================================================
# 10. MISSING VALUES
# ============================================================

# Check for missing values in each column

is.na(students)

# Number of missing values in each column

colSums(is.na(students))

# Number of missing values in the entire dataset

sum(is.na(students))

# Calculate mean while ignoring missing values

mean(students$score, na.rm = TRUE)


# ============================================================
# 11. SIMPLE PLOTS FROM IMPORTED DATA
# ============================================================

hist(
  students$score,
  main = "Distribution of Student Scores",
  xlab = "Score"
)

boxplot(
  students$score,
  ylab = "Score",
  main = "Student Scores"
)

plot(
  students$age,
  students$score,
  pch = 19,
  xlab = "Age",
  ylab = "Score",
  main = "Score vs. Age"
)


# ============================================================
# 12. SAVE MODIFIED DATA AS CSV
# ============================================================
# modify a row
students[2, ] <- data.frame(
  name = "Rahul",
  age = 22,
  score = 90
)

# new entry
new_student <- data.frame(
  name = "Kiran",
  age = 21,
  score = 81
)

students <- rbind(students, new_student)

write.csv(
  students,
  "/Users/rr/repos/biostatistics_cdfd/2026_Huber_Holmes/Rfiles/students_modified.csv",
  row.names = FALSE
)

# row.names = FALSE prevents R from adding an extra
# numbered column to the output file.


# ============================================================
# 13. TAB-SEPARATED FILES
# ============================================================

# TSV files use tabs instead of commas.
#
# They are often useful when text fields themselves
# may contain commas.

data_tsv <- read.delim("/Users/rr/repos/biostatistics_cdfd/2026_Huber_Holmes/Rfiles/students.tsv")

# Alternatively:

data_tsv <- read.table(
  "students.tsv",
  header = TRUE,
  sep = "\t"
)


# ============================================================
# 14. RDS FILES
# ============================================================

# RDS is an R-specific file format.
#
# Unlike CSV, it preserves:
#   - data types
#   - factors
#   - dates
#   - lists
#   - complex R objects
#
# Save an R object:

saveRDS(
  students,
  "students.rds"
)

# Read it back:

students2 <- readRDS("/Users/rr/repos/biostatistics_cdfd/2026_Huber_Holmes/Rfiles/students.rds")

students2


# ============================================================
# 15. SAVE MULTIPLE R OBJECTS
# ============================================================

x <- c(1, 2, 3)
y <- c(10, 20, 30)

# Save several objects together

save(
  x,
  y,
  students,
  file = "/Users/rr/repos/biostatistics_cdfd/2026_Huber_Holmes/Rfiles/my_data.RData"
)

# Load them again

load("/Users/rr/repos/biostatistics_cdfd/2026_Huber_Holmes/Rfiles/my_data.RData")


# ============================================================
# 16. CHECK FILE EXISTENCE
# ============================================================

file.exists("/Users/rr/repos/biostatistics_cdfd/2026_Huber_Holmes/Rfiles/students.csv")

# Useful before attempting to read a file.


# ============================================================
# END OF SCRIPT
# ============================================================
