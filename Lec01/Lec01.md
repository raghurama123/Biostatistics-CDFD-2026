# Lecture 01 — Introduction to R for Biostatistics

This lecture introduces the basic R workflow used in the course: working with R objects, reading data from files, visualizing data with `ggplot2`, and using a simple Bioconductor package for biological sequence analysis.

[1. R Basics](#1-r-basics)  
[2. Reading and Writing Data](#2-reading-and-writing-data)  
[3. Plotting with `ggplot2`](#3-plotting-with-ggplot2)   
[4. Monte Carlo Simulation](#4-monte-carlo-simulation)    
[5. Introduction to Bioconductor](#5-introduction-to-bioconductor)   

---

## Learning objectives

By the end of this lecture, you should be able to:

- use R as a calculator;
- create variables, vectors, and data frames;
- calculate simple descriptive statistics;
- select rows, columns, and elements from R objects;
- make basic plots in R;
- perform simple statistical tests and linear regression;
- read data from CSV and other common file formats;
- modify and save data;
- create plots using `ggplot2`;
- use random numbers in a simple Monte Carlo simulation;
- estimate $\pi$ using random sampling and visualize the simulation;
- install and load an R package;
- understand the role of Bioconductor in biological data analysis;
- perform simple operations on a DNA sequence using `Biostrings`.

---

# 1. R Basics

File: [`Rbasics.R`](Rbasics.R)

We begin with the basic syntax of R and the objects used throughout the rest of the course.

## Running commands in RStudio

Run the current line or selected lines using:

- **macOS:** `Cmd + Enter`
- **Windows/Linux:** `Ctrl + Enter`

Lines beginning with `#` are comments and are ignored by R.

For example:

```r
# Store a value
x <- 10

# Use the stored value
x + 2
```

The assignment operator

```r
<-
```

means *store the value on the right in the object on the left*.

---

## Main topics in `Rbasics.R`

### Basic mathematics

```r
2 + 3
10 / 4
5^2
sqrt(25)

abs(-5)
log(10)
exp(1)
pi
```

### Variables

```r
x <- 10
y <- 4

x + y
x * y
```

### Vectors

The function `c()` combines values into a vector.

```r
x <- c(2, 4, 6, 8, 10)

x
x * 2
x^2
```

### Descriptive statistics

```r
mean(x)
median(x)
sd(x)
var(x)
min(x)
max(x)
summary(x)
quantile(x)
```

### Selecting elements

R indexing begins at **1**.

```r
x <- c(5, 8, 12, 3, 15, 7)

x[1]
x[1:3]
x[c(2, 5)]
x[x > 7]
```

### Data frames

A data frame is similar to a spreadsheet:

- rows usually represent observations;
- columns usually represent variables.

```r
students <- data.frame(
  name  = c("Anita", "Rahul", "Meera", "Arjun", "Nisha"),
  age   = c(20, 21, 19, 22, 20),
  score = c(78, 85, 92, 67, 88)
)
```

Useful commands include:

```r
students
str(students)
summary(students)
nrow(students)
ncol(students)
names(students)
```

Columns can be accessed using `$`:

```r
students$score
mean(students$score)
```

Rows and columns can be selected using:

```r
students[row, column]
```

For example:

```r
students[1, ]
students[, 2]
students[students$score > 80, ]
```

---

## Basic visualization

`Rbasics.R` introduces the base-R plotting system.

### Scatter plot

```r
plot(x, y)
```

### Histogram

```r
hist(heights)
```

A histogram shows the distribution of a numerical variable by grouping observations into intervals or **bins**.

### Boxplot

```r
boxplot(control, treated)
```

A boxplot gives a compact summary of a distribution, including:

- median;
- first quartile (`Q1`);
- third quartile (`Q3`);
- interquartile range (`IQR = Q3 - Q1`);
- whiskers;
- possible outliers.

---

## Introductory statistical methods

The script also gives a first look at several statistical methods that will be discussed in more detail later.

### Independent two-sample t-test

```r
t.test(control, treated)
```

By default, R uses Welch's two-sample t-test.

### Paired t-test

```r
t.test(before, after, paired = TRUE)
```

This is appropriate when the same subjects are measured twice.

### Correlation

```r
cor(height, weight)
```

### Linear regression

```r
model <- lm(weight ~ height)

summary(model)
```

Add the fitted line to a plot:

```r
abline(model)
```

Make a prediction:

```r
predict(
  model,
  newdata = data.frame(height = 172)
)
```

---

## Random numbers and missing values

R can generate random data:

```r
set.seed(123)

x <- rnorm(
  100,
  mean = 50,
  sd = 10
)
```

`set.seed()` makes the simulation reproducible.

Missing observations are represented by `NA`.

```r
values <- c(10, 12, 15, NA, 18)

mean(values)
mean(values, na.rm = TRUE)
is.na(values)
```

---

# 2. Reading and Writing Data

File: [`ReadCSV.R`](ReadCSV.R)

Most real analyses begin with data stored in a file rather than data entered directly into an R script.

The second part of the lecture therefore introduces file input/output and simple data manipulation.

---

## Working directory

Check the current working directory:

```r
getwd()
```

List the files in it:

```r
list.files()
```

When possible, use **relative paths** rather than computer-specific absolute paths. This makes scripts easier to share through GitHub and run on another computer.

For example, if `students.csv` is in the current folder:

```r
students <- read.csv("students.csv")
```

R can also open a file-selection window:

```r
students <- read.csv(file.choose())
```

---

## Examining imported data

After reading a dataset, first inspect it.

```r
head(students)
tail(students)
str(students)
names(students)
dim(students)
summary(students)
```

These commands help answer basic questions such as:

- How many observations are present?
- What are the variable names?
- What data type does each variable have?
- Are there unusual or missing values?

---

## Selecting data

Select rows using a logical condition:

```r
students[students$score > 80, ]
```

Select columns:

```r
students[, c("name", "score")]
```

---

## Creating a new variable

A new column can be created directly.

```r
students$result <- ifelse(
  students$score >= 75,
  "Pass",
  "Fail"
)
```

---

## Sorting data

Sort by score:

```r
students[order(students$score), ]
```

Sort from highest to lowest:

```r
students[order(students$score, decreasing = TRUE), ]
```

---

## Missing values

Check for missing observations:

```r
is.na(students)
```

Count missing values in each column:

```r
colSums(is.na(students))
```

Count all missing values:

```r
sum(is.na(students))
```

---

## Modifying data

Modify an existing row:

```r
students[2, ] <- data.frame(
  name = "Rahul",
  age = 22,
  score = 90
)
```

Add a new row:

```r
new_student <- data.frame(
  name = "Kiran",
  age = 21,
  score = 81
)

students <- rbind(students, new_student)
```

---

## Writing a CSV file

```r
write.csv(
  students,
  "students_modified.csv",
  row.names = FALSE
)
```

Using

```r
row.names = FALSE
```

prevents R from writing an unwanted extra column containing row numbers.

---

## Other file formats

### Tab-separated files

```r
data_tsv <- read.delim("students.tsv")
```

or:

```r
data_tsv <- read.table(
  "students.tsv",
  header = TRUE,
  sep = "\t"
)
```

### RDS

RDS is useful for storing an individual R object while preserving its R-specific structure.

```r
saveRDS(students, "students.rds")

students2 <- readRDS("students.rds")
```

### RData

Several R objects can be saved together:

```r
save(
  x,
  y,
  students,
  file = "my_data.RData"
)
```

They can later be restored using:

```r
load("my_data.RData")
```

---

# 3. Plotting with `ggplot2`

File: [`Plotggplot2.R`](Plotggplot2.R)

Base R provides functions such as `plot()`, `hist()`, and `boxplot()`. A widely used alternative is **ggplot2**, which provides a flexible layered system for constructing graphics.

---

## Installing and loading `ggplot2`

A package only needs to be installed once:

```r
install.packages("ggplot2")
```

It must be loaded in each new R session in which it is used:

```r
library(ggplot2)
```

A useful distinction is therefore:

```text
install.packages()   -> install once
library()            -> load for the current R session
```

---

## Example dataset

```r
students <- data.frame(
  name = c("Asha", "Ravi", "Meera", "Arun", "Neha"),
  hours_studied = c(2, 4, 5, 6, 8),
  score = c(55, 65, 72, 78, 90)
)
```

---

## Base R version

```r
plot(
  students$hours_studied,
  students$score,
  xlab = "Hours Studied",
  ylab = "Exam Score",
  main = "Study Time vs Exam Score"
)
```

---

## The same plot with `ggplot2`

```r
ggplot(
  students,
  aes(x = hours_studied, y = score)
) +
  geom_point(size = 3) +
  labs(
    title = "Study Time vs Exam Score",
    x = "Hours Studied",
    y = "Exam Score"
  ) +
  theme_minimal()
```

A useful way to read this code is:

```text
data
  +
mapping of variables
  +
geometric objects
  +
labels
  +
theme
```

The main components are:

- `ggplot()` — initializes the plot;
- `aes()` — maps variables to visual properties;
- `geom_point()` — adds points;
- `labs()` — adds labels;
- `theme_minimal()` — controls the overall appearance.

---

## Adding a fitted line

A linear-model fit can be added using `geom_smooth()`:

```r
ggplot(
  students,
  aes(x = hours_studied, y = score)
) +
  geom_point(size = 3) +
  geom_smooth(
    method = "lm",
    se = FALSE
  ) +
  labs(
    title = "Study Time vs Exam Score",
    x = "Hours Studied",
    y = "Exam Score"
  ) +
  theme_minimal()
```

Here:

```r
method = "lm"
```

requests a linear model, while

```r
se = FALSE
```

suppresses the confidence band around the fitted line.

---

## Common themes

```r
theme_gray()
theme_minimal()
theme_classic()
theme_bw()
```

The important idea is that `ggplot2` builds plots by adding layers with the `+` operator.

---

# 4. Monte Carlo Simulation

File: [`MonteCarlo.R`](MonteCarlo.R)

Monte Carlo methods use **random sampling** to estimate numerical quantities.  
They are widely used in statistics, physics, biology, finance, and many other
fields when an exact calculation is difficult or when we want to study the
behavior of a random process.

In this introductory example, random points are used to estimate the value of
$\pi$.

---

## Geometrical idea

Consider a square covering the region

$$
0 \le x \le 1,
\qquad
0 \le y \le 1.
$$

Inside this square is a quarter-circle of radius 1.

A point $(x,y)$ lies inside the quarter-circle when

$$
x^2 + y^2 \le 1.
$$

The area of the square is

$$
A_{\mathrm{square}} = 1,
$$

while the area of the quarter-circle is

$$
A_{\mathrm{quarter\ circle}}
=
\frac{\pi r^2}{4}
=
\frac{\pi}{4}.
$$

Therefore,

$$
\frac{
A_{\mathrm{quarter\ circle}}
}{
A_{\mathrm{square}}
}
=
\frac{\pi}{4}.
$$

If points are generated uniformly inside the square, the fraction that fall
inside the quarter-circle should approach $\pi/4$ as the number of points
becomes large.

Thus,

$$
\pi
\approx
4 \times
\frac{
\text{number of points inside the quarter-circle}
}{
\text{total number of points}
}.
$$

---

## Reproducible random numbers

The script begins with

```r
set.seed(123)
```

Computer-generated random numbers are actually **pseudorandom**.  
Using `set.seed()` fixes the starting point of the random-number generator so
that the same script produces the same sequence of random values every time.

This is important for **reproducible scientific analysis**.

---

## Generating random points

Choose the number of simulated points:

```r
N <- 100000
```

Generate random $x$ and $y$ coordinates between 0 and 1:

```r
x <- runif(N, 0, 1)
y <- runif(N, 0, 1)
```

The function

```r
runif(N, min, max)
```

generates `N` random numbers from a **uniform distribution** between `min` and
`max`.

Here, every location between 0 and 1 has equal probability of being sampled.

---

## Testing whether points are inside the circle

The condition

```r
inside <- x^2 + y^2 <= 1
```

creates a logical vector containing values such as

```text
TRUE
FALSE
TRUE
TRUE
FALSE
...
```

`TRUE` means that the corresponding point lies inside the quarter-circle.

Because R treats

```text
TRUE  -> 1
FALSE -> 0
```

when calculating a mean, the command

```r
mean(inside)
```

directly gives the fraction of points inside the quarter-circle.

For example,

```r
fraction_inside <- mean(inside)
```

estimates

$$
\frac{\pi}{4}.
$$

---

## Estimating pi

The estimate is therefore

```r
pi_estimate <- 4 * fraction_inside
```

and can be compared with R's built-in value:

```r
pi_estimate
pi
```

With a sufficiently large value of `N`, the Monte Carlo estimate should be
close to the true value of $\pi$.

The result will not usually be exactly equal to $\pi$ because the estimate is
based on a finite random sample.

---

## Complete numerical calculation

```r
set.seed(123)

# Number of random points
N <- 100000

# Generate uniformly distributed coordinates
x <- runif(N, 0, 1)
y <- runif(N, 0, 1)

# TRUE if the point lies inside the quarter-circle
inside <- x^2 + y^2 <= 1

# Fraction of simulated points inside
fraction_inside <- mean(inside)

# Monte Carlo estimate of pi
pi_estimate <- 4 * fraction_inside

pi_estimate
pi
```

---

## Visualizing the simulation

For visualization, a smaller number of points is convenient:

```r
set.seed(123)

N <- 5000

x <- runif(N)
y <- runif(N)

inside <- x^2 + y^2 <= 1
```

Plot the simulated points:

```r
plot(
  x, y,
  pch = 16,
  cex = 0.5,
  xlab = "x",
  ylab = "y",
  asp = 1,
  main = "Monte Carlo Estimation of Pi"
)
```

Important plotting arguments are:

- `pch = 16` — draws each point as a filled circle;
- `cex = 0.5` — reduces the point size;
- `asp = 1` — forces equal scaling of the $x$ and $y$ axes.

The argument

```r
asp = 1
```

is particularly important here. Without equal axis scaling, a geometrically
circular curve may appear stretched or compressed on the screen.

---

## Drawing the quarter-circle

The upper boundary of the quarter-circle follows from

$$
x^2 + y^2 = 1.
$$

Solving for $y$ gives

$$
y = \sqrt{1-x^2}.
$$

It can be added to the existing plot using

```r
curve(
  sqrt(1 - x^2),
  from = 0,
  to = 1,
  add = TRUE,
  lwd = 2
)
```

Here:

- `from = 0` and `to = 1` specify the range of $x$;
- `add = TRUE` means **draw the curve on the existing plot** rather than
  opening a new plot;
- `lwd = 2` increases the line width.

---

## Final estimate from the plotted sample

The Monte Carlo estimate can again be calculated directly:

```r
4 * mean(inside)
```

Since this visualization uses only 5000 points rather than 100000, its estimate
may differ slightly more from the exact value of $\pi$.

---

## Effect of sample size

An important idea in Monte Carlo simulation is that estimates usually become
more stable as the number of random samples increases.

For example, try:

```r
N <- 100
N <- 1000
N <- 10000
N <- 100000
```

and compare the corresponding estimates of $\pi$.

The exact sequence of estimates will depend on the random sample, but larger
values of `N` generally give estimates closer to the true value.

This example therefore introduces several useful R ideas at once:

- random-number generation with `runif()`;
- reproducibility with `set.seed()`;
- logical vectors;
- using `mean()` with `TRUE` and `FALSE`;
- simulation-based numerical estimation;
- geometric visualization with `plot()` and `curve()`.

---

# 5. Introduction to Bioconductor

File: [`BioConductor.R`](BioConductor.R)

The final part of the lecture gives a short introduction to **Bioconductor**, an ecosystem of R packages designed for biological and genomic data analysis.

This example uses the `Biostrings` package to work with a DNA sequence.

---

## Installing Bioconductor packages

Install `BiocManager` once:

```r
install.packages("BiocManager")
```

Use it to install Bioconductor packages:

```r
BiocManager::install("Biostrings")
```

Load the package:

```r
library(Biostrings)
```

---

## Creating a DNA sequence

```r
dna <- DNAString(
  "ATGGCCATTGTAATGGGCCGCTGAAAGGGTGCCCGATAG"
)

dna
```

`DNAString` stores a DNA sequence as a biological sequence object rather than as ordinary text.

---

## Sequence length

```r
length(dna)
```

---

## Nucleotide composition

Count each nucleotide:

```r
letterFrequency(
  dna,
  letters = c("A", "C", "G", "T")
)
```

---

## GC content

```r
gc_count <- letterFrequency(
  dna,
  letters = c("G", "C")
)

gc_percent <- sum(gc_count) / length(dna) * 100

gc_percent
```

The GC percentage is

$$
\mathrm{GC\%} =
\frac{G + C}{A + T + G + C}
\times 100
$$

---

## Reverse complement

```r
reverseComplement(dna)
```

For double-stranded DNA, this gives the sequence of the complementary strand written in the standard `5' -> 3'` direction.

---

## Translation

Translate the DNA sequence into an amino-acid sequence:

```r
protein <- translate(dna)

protein
```

This provides a simple example of how specialized R packages can represent and manipulate biological data directly.



---
