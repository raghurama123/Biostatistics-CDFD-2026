# Organizing R Code Across Multiple Files

As an R project becomes larger, it is useful to separate functions into different files rather than keeping everything in a single script.

For a small project, store related functions in separate `.R` files and load them into a main script using `source()`.

---

## Example Project Structure

Consider the following directory:

```text
project/
├── functions_statistics.R
├── functions_conversion.R
├── functions_plotting.R
└── main.R
```

Each file contains functions related to a particular task.

For example:

* `functions_statistics.R` contains statistical functions.
* `functions_conversion.R` contains unit-conversion functions.
* `functions_plotting.R` contains plotting functions.
* `main.R` contains the main analysis and calls functions from the other files.

---

## 1. Statistical Functions

Create a file called:

```text
functions_statistics.R
```

Add the following function:

```r
# Calculate basic statistics for a numeric vector

basic_stats <- function(x) {

  result <- c(
    mean   = mean(x),
    median = median(x),
    sd     = sd(x)
  )

  return(result)
}
```

The function `basic_stats()` calculates the mean, median, and standard deviation of a numeric vector.

For example:

```r
x <- c(10, 12, 15, 11, 18)

basic_stats(x)
```

---

## 2. Conversion Functions

Create another file called:

```text
functions_conversion.R
```

Add:

```r
# Convert temperature from Celsius to Fahrenheit

celsius_to_fahrenheit <- function(temperature) {

  fahrenheit <- temperature * 9 / 5 + 32

  return(fahrenheit)
}
```

For example:

```r
celsius_to_fahrenheit(30)
```

gives:

```text
86
```

because

$$
F = \frac{9}{5}C + 32.
$$

---

## 3. Plotting Functions

Create:

```text
functions_plotting.R
```

Add:

```r
# Plot a numeric vector

plot_data <- function(x) {

  plot(
    x,
    type = "b",
    pch = 16,
    xlab = "Observation",
    ylab = "Value",
    main = "Data"
  )
}
```

The option

```r
type = "b"
```

plots both the points and the lines connecting them.

---

# Main Program

Now create:

```text
main.R
```

The complete `main.R` file could be:

```r
# ============================================================
# Load functions
# ============================================================

source("functions_statistics.R")
source("functions_conversion.R")
source("functions_plotting.R")


# ============================================================
# Example data
# ============================================================

x <- c(10, 12, 15, 11, 18)


# ============================================================
# Calculate statistics
# ============================================================

stats <- basic_stats(x)

print(stats)


# ============================================================
# Convert temperature
# ============================================================

temperature <- 30

fahrenheit <- celsius_to_fahrenheit(temperature)

print(fahrenheit)


# ============================================================
# Plot the data
# ============================================================

plot_data(x)
```

