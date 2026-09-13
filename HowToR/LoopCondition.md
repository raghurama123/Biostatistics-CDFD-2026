# Loops and Conditional Statements in R

Conditional statements and loops allow an R program to make decisions and repeat operations.

The most commonly used control structures are:

* `if`
* `if ... else`
* `ifelse()`
* `for`
* `while`
* `repeat`
* `break`
* `next`

---

# 1. The `if` Statement

The `if` statement executes a block of code only when a condition is `TRUE`.

```r
x <- 10

if (x > 5) {
  print("x is greater than 5")
}
```

Output:

```text
[1] "x is greater than 5"
```

The general form is:

```r
if (condition) {
  # code to execute
}
```

---

# 2. `if ... else`

Use `else` when different code should be executed depending on whether a condition is `TRUE` or `FALSE`.

```r
x <- 3

if (x > 5) {
  print("x is greater than 5")
} else {
  print("x is not greater than 5")
}
```

Output:

```text
[1] "x is not greater than 5"
```

---

# 3. Multiple Conditions with `else if`

Several conditions can be tested in sequence.

```r
score <- 72

if (score >= 80) {
  print("Grade A")
} else if (score >= 60) {
  print("Grade B")
} else if (score >= 40) {
  print("Grade C")
} else {
  print("Fail")
}
```

Output:

```text
[1] "Grade B"
```

Only the first condition that evaluates to `TRUE` is executed.

---

# 4. Comparison Operators

Conditions often use comparison operators.

| Operator | Meaning                  |
| -------- | ------------------------ |
| `==`     | equal to                 |
| `!=`     | not equal to             |
| `>`      | greater than             |
| `<`      | less than                |
| `>=`     | greater than or equal to |
| `<=`     | less than or equal to    |

Example:

```r
x <- 10

x == 10
x != 5
x > 7
x <= 20
```

---

# 5. Logical Operators

More than one condition can be combined.

| Operator | Meaning                           |    |                                  |
| -------- | --------------------------------- | -- | -------------------------------- |
| `&`      | AND                               |    |                                  |
| `        | `                                 | OR |                                  |
| `!`      | NOT                               |    |                                  |
| `&&`     | AND for single logical conditions |    |                                  |
| `        |                                   | `  | OR for single logical conditions |

Example:

```r
age <- 25

if (age >= 18 && age <= 60) {
  print("Age is between 18 and 60")
}
```

Another example:

```r
temperature <- 35

if (temperature < 10 || temperature > 30) {
  print("Temperature is outside the normal range")
}
```

---

# 6. The `ifelse()` Function

For operations on vectors, `ifelse()` is often more convenient than `if`.

The syntax is:

```r
ifelse(condition, value_if_true, value_if_false)
```

Example:

```r
x <- c(2, 7, 4, 10, 3)

result <- ifelse(x > 5, "High", "Low")

print(result)
```

Output:

```text
[1] "Low"  "High" "Low"  "High" "Low"
```

Another useful example is classifying exam scores:

```r
scores <- c(45, 72, 88, 32, 65)

result <- ifelse(scores >= 40, "Pass", "Fail")

print(result)
```

---

# 7. The `for` Loop

A `for` loop repeats an operation for each value in a sequence.

Example:

```r
for (i in 1:5) {
  print(i)
}
```

Output:

```text
[1] 1
[1] 2
[1] 3
[1] 4
[1] 5
```

The general form is:

```r
for (variable in sequence) {
  # commands
}
```

---

# 8. Performing a Calculation in a `for` Loop

For example, calculate the square of the numbers from 1 to 5:

```r
for (i in 1:5) {

  square <- i^2

  print(square)
}
```

Output:

```text
[1] 1
[1] 4
[1] 9
[1] 16
[1] 25
```

---

# 9. Looping Over a Vector

A loop can directly iterate over the values of a vector.

```r
temperatures <- c(20, 25, 30, 35)

for (temperature in temperatures) {

  fahrenheit <- temperature * 9 / 5 + 32

  print(fahrenheit)
}
```

---

# 10. Saving Results from a Loop

Usually, we want to save the results instead of only printing them.

For example:

```r
x <- c(2, 4, 6, 8, 10)

squares <- numeric(length(x))

for (i in 1:length(x)) {

  squares[i] <- x[i]^2
}

print(squares)
```

Output:

```text
[1]   4  16  36  64 100
```

A safer way to generate the indices is:

```r
for (i in seq_along(x)) {

  squares[i] <- x[i]^2
}
```

`seq_along(x)` automatically produces the correct index sequence for `x`.

---

# 11. Combining `for` and `if`

Loops and conditional statements can be combined.

```r
scores <- c(45, 72, 33, 88, 61)

for (score in scores) {

  if (score >= 40) {
    print("Pass")
  } else {
    print("Fail")
  }
}
```

---

# 12. Example: Classifying Numbers

```r
numbers <- c(-3, 0, 5, -1, 8)

for (x in numbers) {

  if (x > 0) {

    print("Positive")

  } else if (x < 0) {

    print("Negative")

  } else {

    print("Zero")
  }
}
```

---

# 13. The `while` Loop

A `while` loop repeats as long as a condition remains `TRUE`.

Example:

```r
i <- 1

while (i <= 5) {

  print(i)

  i <- i + 1
}
```

Output:

```text
[1] 1
[1] 2
[1] 3
[1] 4
[1] 5
```

The general form is:

```r
while (condition) {

  # commands

}
```

The condition should eventually become `FALSE`; otherwise, the loop will continue indefinitely.

---

# 14. Example: Repeated Multiplication

Suppose we want to repeatedly double a number until it becomes greater than 100.

```r
x <- 1

while (x <= 100) {

  print(x)

  x <- x * 2
}
```

Output:

```text
[1] 1
[1] 2
[1] 4
[1] 8
[1] 16
[1] 32
[1] 64
```

---

# 15. The `repeat` Loop

A `repeat` loop continues indefinitely unless it is explicitly stopped using `break`.

Example:

```r
i <- 1

repeat {

  print(i)

  i <- i + 1

  if (i > 5) {
    break
  }
}
```

This produces:

```text
[1] 1
[1] 2
[1] 3
[1] 4
[1] 5
```

---

# 16. The `break` Statement

`break` immediately stops a loop.

Example:

```r
for (i in 1:10) {

  if (i == 6) {
    break
  }

  print(i)
}
```

Output:

```text
[1] 1
[1] 2
[1] 3
[1] 4
[1] 5
```

The loop stops when `i` reaches 6.

---

# 17. The `next` Statement

`next` skips the current iteration and continues with the next one.

Example:

```r
for (i in 1:5) {

  if (i == 3) {
    next
  }

  print(i)
}
```

Output:

```text
[1] 1
[1] 2
[1] 4
[1] 5
```

The value `3` is skipped.

---

# 18. Example: Print Only Even Numbers

The modulo operator `%%` gives the remainder after division.

```r
for (i in 1:10) {

  if (i %% 2 == 0) {
    print(i)
  }
}
```

Output:

```text
[1] 2
[1] 4
[1] 6
[1] 8
[1] 10
```

For an even number:

```r
i %% 2 == 0
```

is `TRUE`.

---

# 19. Example: Skip Missing Values

Loops can also be used when working with missing data.

```r
x <- c(10, 15, NA, 20, NA, 25)

for (value in x) {

  if (is.na(value)) {
    next
  }

  print(value)
}
```

Output:

```text
[1] 10
[1] 15
[1] 20
[1] 25
```

---

# 20. Nested Loops

A loop can be placed inside another loop.

For example, a small multiplication table:

```r
for (i in 1:3) {

  for (j in 1:3) {

    result <- i * j

    print(result)
  }
}
```

A more informative version is:

```r
for (i in 1:3) {

  for (j in 1:3) {

    cat(i, "x", j, "=", i * j, "\n")
  }
}
```

Output:

```text
1 x 1 = 1
1 x 2 = 2
1 x 3 = 3
2 x 1 = 2
2 x 2 = 4
2 x 3 = 6
3 x 1 = 3
3 x 2 = 6
3 x 3 = 9
```

---

# 21. Example: Monte Carlo Coin Tosses

Loops can be used for simulations.

The following program repeats an experiment in which 10 fair coins are tossed.

```r
n_simulations <- 1000

count <- 0

for (i in 1:n_simulations) {

  heads <- sum(
    rbinom(
      10,
      size = 1,
      prob = 0.5
    )
  )

  if (heads >= 6) {
    count <- count + 1
  }
}

probability <- count / n_simulations

print(probability)
```

The result should be close to the theoretical probability of obtaining six or more heads.

In R, the same simulation can often be performed more efficiently using vectorized functions:

```r
heads <- rbinom(
  100000,
  size = 10,
  prob = 0.5
)

mean(heads >= 6)
```

This illustrates an important feature of R: **loops are useful, but vectorized operations are often simpler and faster**.

---

# 22. Vectorized Operations Instead of Loops

Suppose we want the squares of:

```r
x <- c(1, 2, 3, 4, 5)
```

Using a loop:

```r
result <- numeric(length(x))

for (i in seq_along(x)) {

  result[i] <- x[i]^2
}

print(result)
```

But R can perform the operation directly:

```r
result <- x^2
```

Similarly, instead of:

```r
for (i in seq_along(x)) {

  if (x[i] > 3) {
    x[i] <- 100
  }
}
```

we can use vector indexing:

```r
x[x > 3] <- 100
```

Vectorized operations are an important part of R programming.

---

# 23. `for` Versus `while`

Use a `for` loop when the number of repetitions is known.

For example:

```r
for (i in 1:10) {
  print(i)
}
```

Use a `while` loop when the number of repetitions depends on a condition.

For example:

```r
x <- 1

while (x < 100) {

  x <- x * 2

  print(x)
}
```


