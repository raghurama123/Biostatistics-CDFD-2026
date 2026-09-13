# How to Maintain a Small R Package

A small R package is a convenient way to organize and maintain reusable functions.

For a teaching or research project, related functions can be stored in separate files inside the package's `R/` directory and then used from another script such as `main.R`.

---

## Example Package Structure

A minimal package may look like this:

```text
myRpackage/
│
├── DESCRIPTION
├── NAMESPACE
│
└── R/
    ├── statistics.R
    ├── conversion.R
    └── plotting.R

analysis/
└── main.R
```

The important idea is that **all `.R` files inside the package's `R/` directory belong to the same package namespace**.

Therefore, functions defined in one file can call functions defined in another file.

---

# 1. Create the Package

One convenient way to create an R package is using the `usethis` package.

Install it once:

```r
install.packages("usethis")
```

Then load it:

```r
library(usethis)
```

Create a new package:

```r
create_package("~/repos/myRpackage")
```

This creates a directory similar to:

```text
myRpackage/
├── DESCRIPTION
├── NAMESPACE
└── R/
```

The package functions will be stored inside the `R/` directory.

---

# 2. Add a Statistics Function

Create:

```text
R/statistics.R
```

and add:

```r
#' Calculate basic statistics
#'
#' @param x Numeric vector
#' @return A named vector containing mean, median, and standard deviation
#' @export
basic_stats <- function(x) {

  result <- c(
    mean   = mean(x),
    median = median(x),
    sd     = sd(x)
  )

  return(result)
}
```

The comments beginning with

```r
#'
```

are **roxygen2 documentation comments**.

The line

```r
#' @export
```

indicates that the function should be available to users of the package.

---

# 3. Add a Conversion Function

Create:

```text
R/conversion.R
```

and add:

```r
#' Convert Celsius to Fahrenheit
#'
#' @param temperature Temperature in Celsius
#' @return Temperature in Fahrenheit
#' @export
celsius_to_fahrenheit <- function(temperature) {

  fahrenheit <- temperature * 9 / 5 + 32

  return(fahrenheit)
}
```

More than one function can be stored in the same file if the functions are logically related.

---

# 4. Add a Plotting Function

Create:

```text
R/plotting.R
```

and add:

```r
#' Plot numerical data
#'
#' @param x Numeric vector
#' @return No return value; produces a plot
#' @export
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

The `R/` directory now contains:

```text
R/
├── statistics.R
├── conversion.R
└── plotting.R
```

---

# 5. Generate the Documentation and `NAMESPACE`

The `@export` statements tell R which functions should be made available to package users.

Install `roxygen2`:

```r
install.packages("roxygen2")
```

Then, from the package directory, run:

```r
roxygen2::roxygenise()
```

This generates or updates the file:

```text
NAMESPACE
```

For this example, it will contain entries similar to:

```text
export(basic_stats)
export(celsius_to_fahrenheit)
export(plot_data)
```

`roxygen2` also generates help files inside:

```text
man/
```

For example:

```text
man/
├── basic_stats.Rd
├── celsius_to_fahrenheit.Rd
└── plot_data.Rd
```

These files normally should **not** be edited manually.

Instead, modify the `#'` documentation above the functions and run:

```r
roxygen2::roxygenise()
```

again.

---

# 6. The `DESCRIPTION` File

The `DESCRIPTION` file contains information about the package.

A simple example is:

```text
Package: myRpackage
Title: Simple Example R Package
Version: 0.1.0
Authors@R: person("Your", "Name", role = c("aut", "cre"),
    email = "your@email.com")
Description: A small package containing example statistical,
    conversion, and plotting functions.
License: MIT
Encoding: UTF-8
Roxygen: list(markdown = TRUE)
RoxygenNote: 7.3.3
```

The exact value of:

```text
RoxygenNote
```

is not important to set manually.

`roxygen2` will update it when the documentation is generated.

---

# 7. Install the Package

From a Terminal, move into the package directory:

```bash
cd ~/repos/myRpackage
```

Then install it:

```bash
R CMD INSTALL .
```

A successful installation should end with something similar to:

```text
* DONE (myRpackage)
```

The package can now be loaded in R like any other package:

```r
library(myRpackage)
```

---

# 8. Use the Package From a Main Script

The main analysis script does not have to be inside the package.

For example:

```text
analysis/
└── main.R
```

The script can simply load the package:

```r
library(myRpackage)
```

A complete `main.R` could be:

```r
library(myRpackage)

# ============================================================
# Example data
# ============================================================

x <- c(10, 12, 15, 11, 18, 20, 16)


# ============================================================
# Function from statistics.R
# ============================================================

stats <- basic_stats(x)

print(stats)


# ============================================================
# Function from conversion.R
# ============================================================

temperature <- 30

fahrenheit <- celsius_to_fahrenheit(temperature)

print(fahrenheit)


# ============================================================
# Function from plotting.R
# ============================================================

plot_data(x)
```

The script can then be run using:

```r
source("main.R")
```

The output will be similar to:

```text
     mean    median        sd
14.571429 15.000000  3.823486

[1] 86
```

and the plotting function will produce a figure.

---

# 9. Developing the Package Without Reinstalling Every Time

During development, repeatedly running

```bash
R CMD INSTALL .
```

after every small modification is inconvenient.

The `devtools` package provides a simpler workflow.

Install it once:

```r
install.packages("devtools")
```

Then, from inside the package directory, run:

```r
devtools::load_all()
```

This loads the package directly from the source directory.

For example:

```r
devtools::load_all()

x <- c(1, 2, 3, 4, 5)

basic_stats(x)

celsius_to_fahrenheit(25)

plot_data(x)
```

After modifying any of the files under `R/`, simply run:

```r
devtools::load_all()
```

again.

There is no need to reinstall the package after every change.

---

# 10. Typical Development Workflow

A useful development workflow is:

```text
Edit statistics.R
        |
        v
Edit conversion.R
        |
        v
Edit plotting.R
        |
        v
devtools::load_all()
        |
        v
Run main.R
        |
        v
Check the results
```

Once everything works correctly, install the package:

```r
devtools::install()
```

---

# 11. Checking the Package

Before distributing or uploading the package, it is useful to check for common problems.

Run:

```r
devtools::check()
```

This performs many of the same checks used for standard R packages.

It can detect problems such as:

* missing documentation,
* incorrect imports,
* syntax errors,
* undocumented functions,
* problems in the `DESCRIPTION` file.

A good development cycle is therefore:

```text
Modify code
    |
    v
devtools::load_all()
    |
    v
Test functions
    |
    v
roxygen2::roxygenise()
    |
    v
devtools::check()
    |
    v
devtools::install()
```

---

# 12. Adding New Functions

Suppose a new mathematical function is required.

You could create:

```text
R/mathematics.R
```

containing:

```r
#' Calculate the square of a number
#'
#' @param x Numeric value or vector
#' @return The square of x
#' @export
square <- function(x) {

  return(x^2)
}
```

Then regenerate the documentation:

```r
roxygen2::roxygenise()
```

and reload the package:

```r
devtools::load_all()
```

The new function can now be used:

```r
square(5)
```

which gives:

```text
[1] 25
```

---

# 13. Recommended Package Layout

As the package grows, a structure such as the following is useful:

```text
myRpackage/
│
├── DESCRIPTION
├── NAMESPACE
├── README.md
│
├── R/
│   ├── statistics.R
│   ├── conversion.R
│   ├── plotting.R
│   └── mathematics.R
│
├── man/
│   ├── basic_stats.Rd
│   ├── celsius_to_fahrenheit.Rd
│   ├── plot_data.Rd
│   └── square.Rd
│
└── tests/
```

In general:

* `R/` contains the source code.
* `man/` contains automatically generated documentation.
* `DESCRIPTION` contains package information.
* `NAMESPACE` controls which functions are exported and which external functions are imported.
* `README.md` describes the package for users.
* `tests/` can contain automated tests.

---

# Summary

For a small R package, the basic workflow is:

```r
# Create the package
usethis::create_package("~/repos/myRpackage")
```

Add functions under:

```text
R/
```

Document exported functions using:

```r
#' @export
```

Generate the documentation:

```r
roxygen2::roxygenise()
```

During development, load the current source code using:

```r
devtools::load_all()
```

Check the package using:

```r
devtools::check()
```

Finally, install it using:

```r
devtools::install()
```

or from the Terminal:

```bash
R CMD INSTALL .
```

This allows functions to be maintained in separate files while still being used together as part of a single R package.

