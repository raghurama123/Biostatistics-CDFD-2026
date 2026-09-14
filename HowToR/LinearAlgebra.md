# Linear Algebra in R

R provides built-in support for vectors, matrices, and common linear algebra operations.

This section gives simple examples of:

* vector operations,
* matrix-vector operations,
* matrix-matrix operations,
* solving linear equations,
* eigenvalues and eigenvectors.

---

# 1. Creating Vectors

A vector can be created using `c()`.

```r
x <- c(1, 2, 3)
y <- c(4, 5, 6)

x
y
```

---

# 2. Vector Addition and Subtraction

```r
x <- c(1, 2, 3)
y <- c(4, 5, 6)

x + y
x - y
```

Output:

```text
[1] 5 7 9

[1] -3 -3 -3
```

---

# 3. Multiplying a Vector by a Scalar

```r
x <- c(1, 2, 3)

2 * x
```

Output:

```text
[1] 2 4 6
```

Similarly:

```r
x / 2
```

gives:

```text
[1] 0.5 1.0 1.5
```

---

# 4. Element-by-Element Vector Multiplication

The `*` operator performs element-by-element multiplication.

```r
x <- c(1, 2, 3)
y <- c(4, 5, 6)

x * y
```

Output:

```text
[1] 4 10 18
```

This is different from a dot product.

---

# 5. Dot Product

The dot product of two vectors is

$$
\mathbf{x}\cdot\mathbf{y}=
\sum_i x_i y_i.
$$

In R:

```r
x <- c(1, 2, 3)
y <- c(4, 5, 6)

dot_product <- sum(x * y)

dot_product
```

Output:

```text
[1] 32
```

The same calculation can be performed using `%*%`:

```r
x %*% y
```

Output:

```text
     [,1]
[1,]   32
```

---

# 6. Vector Length and Norm

For the vector

```r
x <- c(3, 4)
```

the Euclidean length is

$$
|\mathbf{x}| =
\sqrt{x_1^2+x_2^2}.
$$

In R:

```r
sqrt(sum(x^2))
```

Output:

```text
[1] 5
```

Another possibility is:

```r
norm(
  matrix(x),
  type = "2"
)
```

---

# 7. Normalizing a Vector

A normalized vector has length 1.

```r
x <- c(3, 4)

x_norm <- sqrt(sum(x^2))

x_unit <- x / x_norm

x_unit
```

Output:

```text
[1] 0.6 0.8
```

Check its length:

```r
sqrt(sum(x_unit^2))
```

Output:

```text
[1] 1
```

---

# 8. Creating a Matrix

A matrix can be created using `matrix()`.

```r
A <- matrix(
  c(
    1, 2,
    3, 4
  ),
  nrow = 2,
  byrow = TRUE
)

A
```

Output:

```text
     [,1] [,2]
[1,]    1    2
[2,]    3    4
```

The option

```r
byrow = TRUE
```

tells R to fill the matrix row by row.

Without it, R fills matrices column by column.

---

# 9. Accessing Matrix Elements

Suppose:

```r
A <- matrix(
  c(
    1, 2, 3,
    4, 5, 6,
    7, 8, 9
  ),
  nrow = 3,
  byrow = TRUE
)
```

The element in row 2, column 3 is:

```r
A[2, 3]
```

Output:

```text
[1] 6
```

The second row is:

```r
A[2, ]
```

The third column is:

```r
A[, 3]
```

---

# 10. Matrix Addition and Subtraction

```r
A <- matrix(
  c(
    1, 2,
    3, 4
  ),
  nrow = 2,
  byrow = TRUE
)

B <- matrix(
  c(
    5, 6,
    7, 8
  ),
  nrow = 2,
  byrow = TRUE
)

A + B
A - B
```

---

# 11. Multiplying a Matrix by a Scalar

```r
A <- matrix(
  c(
    1, 2,
    3, 4
  ),
  nrow = 2,
  byrow = TRUE
)

3 * A
```

Output:

```text
     [,1] [,2]
[1,]    3    6
[2,]    9   12
```

---

# 12. Element-by-Element Matrix Multiplication

The `*` operator multiplies corresponding matrix elements.

```r
A <- matrix(
  c(
    1, 2,
    3, 4
  ),
  nrow = 2,
  byrow = TRUE
)

B <- matrix(
  c(
    5, 6,
    7, 8
  ),
  nrow = 2,
  byrow = TRUE
)

A * B
```

Output:

```text
     [,1] [,2]
[1,]    5   12
[2,]   21   32
```

This is **not** matrix multiplication.

---

# 13. Matrix-Vector Multiplication

Suppose

$$
A =
\begin{pmatrix}
1 & 2 \\
3 & 4
\end{pmatrix}
$$

and

$$
\mathbf{x} =
\begin{pmatrix}
5 \\
6
\end{pmatrix}.
$$

In R:

```r
A <- matrix(
  c(
    1, 2,
    3, 4
  ),
  nrow = 2,
  byrow = TRUE
)

x <- c(5, 6)

A %*% x
```

Output:

```text
     [,1]
[1,]   17
[2,]   39
```

because

$$
A\mathbf{x}=
\begin{pmatrix}
1(5)+2(6) \\
3(5)+4(6)
\end{pmatrix}=
\begin{pmatrix}
17 \\
39
\end{pmatrix}.
$$

---

# 14. Matrix-Matrix Multiplication

Matrix multiplication uses `%*%`.

```r
A <- matrix(
  c(
    1, 2,
    3, 4
  ),
  nrow = 2,
  byrow = TRUE
)

B <- matrix(
  c(
    5, 6,
    7, 8
  ),
  nrow = 2,
  byrow = TRUE
)

C <- A %*% B

C
```

Output:

```text
     [,1] [,2]
[1,]   19   22
[2,]   43   50
```

Note the distinction:

```r
A * B
```

means element-by-element multiplication, while

```r
A %*% B
```

means matrix multiplication.

---

# 15. Matrix Transpose

The transpose of a matrix is obtained using `t()`.

```r
A <- matrix(
  c(
    1, 2, 3,
    4, 5, 6
  ),
  nrow = 2,
  byrow = TRUE
)

A
```

gives:

```text
     [,1] [,2] [,3]
[1,]    1    2    3
[2,]    4    5    6
```

Now:

```r
t(A)
```

gives:

```text
     [,1] [,2]
[1,]    1    4
[2,]    2    5
[3,]    3    6
```

---

# 16. Outer Product

The outer product of two vectors produces a matrix.

```r
x <- c(1, 2, 3)
y <- c(4, 5)

outer(x, y)
```

Output:

```text
     [,1] [,2]
[1,]    4    5
[2,]    8   10
[3,]   12   15
```

It can also be written as:

```r
x %o% y
```

---

# 17. Identity Matrix

An identity matrix can be created using `diag()`.

For a \(3\times3\) identity matrix:

```r
I <- diag(3)

I
```

Output:

```text
     [,1] [,2] [,3]
[1,]    1    0    0
[2,]    0    1    0
[3,]    0    0    1
```

---

# 18. Extracting the Diagonal

For example:

```r
A <- matrix(
  c(
    1, 2, 3,
    4, 5, 6,
    7, 8, 9
  ),
  nrow = 3,
  byrow = TRUE
)

diag(A)
```

Output:

```text
[1] 1 5 9
```

---

# 19. Matrix Trace

The trace of a matrix is the sum of its diagonal elements:

$$\mathrm{Tr}(A)=
\sum_i A_{ii}.
$$

In R:

```r
trace_A <- sum(diag(A))

trace_A
```

For the matrix above:

```text
[1] 15
```

---

# 20. Determinant

The determinant is calculated using `det()`.

```r
A <- matrix(
  c(
    1, 2,
    3, 4
  ),
  nrow = 2,
  byrow = TRUE
)

det(A)
```

Output:

```text
[1] -2
```

---

# 21. Matrix Inverse

For a nonsingular matrix, the inverse can be calculated using `solve()`.

```r
A <- matrix(
  c(
    1, 2,
    3, 4
  ),
  nrow = 2,
  byrow = TRUE
)

A_inv <- solve(A)

A_inv
```

We can verify the result using:

```r
A %*% A_inv
```

which should give approximately the identity matrix.

Because of numerical roundoff, values that mathematically should be zero may sometimes appear as very small numbers such as:

```text
2.220446e-16
```

---

# 22. Solving a System of Linear Equations

Suppose we want to solve:

$$
2x + y = 5
$$

$$
x + 3y = 6.
$$

Write this as:

$$
A\mathbf{x}=\mathbf{b},
$$

where

$$
A=
\begin{pmatrix}
2 & 1 \\
1 & 3
\end{pmatrix}
$$

and

$$
\mathbf{b}=
\begin{pmatrix}
5 \\
6
\end{pmatrix}.
$$

In R:

```r
A <- matrix(
  c(
    2, 1,
    1, 3
  ),
  nrow = 2,
  byrow = TRUE
)

b <- c(5, 6)

solution <- solve(A, b)

solution
```

Output:

```text
[1] 1.8 1.4
```

Therefore,

$$
x=1.8,\qquad y=1.4.
$$

For solving linear equations, it is usually better to use:

```r
solve(A, b)
```

rather than explicitly calculating:

```r
solve(A) %*% b
```

---

# 23. Eigenvalues and Eigenvectors

Consider the matrix

$$
A=
\begin{pmatrix}
2 & 1 \\
1 & 2
\end{pmatrix}.
$$

In R:

```r
A <- matrix(
  c(
    2, 1,
    1, 2
  ),
  nrow = 2,
  byrow = TRUE
)

result <- eigen(A)
```

The eigenvalues are:

```r
result$values
```

and the eigenvectors are:

```r
result$vectors
```

The columns of `result$vectors` contain the eigenvectors corresponding to the eigenvalues in `result$values`.

---

# 24. Checking an Eigenvalue Equation

An eigenvector satisfies:

$$
A\mathbf{v}=
\lambda\mathbf{v}.
$$

Take the first eigenvector:

```r
lambda <- result$values[1]

v <- result$vectors[, 1]
```

Now calculate:

```r
A %*% v
```

and:

```r
lambda * v
```

The two results should be the same apart from small numerical roundoff errors.

---

# 25. Symmetric Matrices

A matrix is symmetric if:

$$
A=A^T.
$$

For example:

```r
A <- matrix(
  c(
    2, 1,
    1, 3
  ),
  nrow = 2,
  byrow = TRUE
)

A
t(A)
```

Check numerically:

```r
isSymmetric(A)
```

Output:

```text
[1] TRUE
```

---

# 26. Matrix Products Involving Transposes

Products such as

$$
A^T A
$$

are common in statistics and numerical methods.

In R:

```r
A <- matrix(
  c(
    1, 2,
    3, 4,
    5, 6
  ),
  nrow = 3,
  byrow = TRUE
)

t(A) %*% A
```

Similarly,

$$
AA^T
$$

is:

```r
A %*% t(A)
```

These two matrices generally have different dimensions.

---

# 27. Cross Product in Three Dimensions

For three-dimensional vectors, the vector cross product can be written manually.

Suppose:

```r
a <- c(1, 0, 0)
b <- c(0, 1, 0)
```

Define:

```r
cross_product <- function(a, b) {

  c(
    a[2] * b[3] - a[3] * b[2],
    a[3] * b[1] - a[1] * b[3],
    a[1] * b[2] - a[2] * b[1]
  )
}
```

Then:

```r
cross_product(a, b)
```

Output:

```text
[1] 0 0 1
```

---

# 28. Example: Combining Vector and Matrix Operations

Consider:

```r
A <- matrix(
  c(
    2, 1,
    1, 3
  ),
  nrow = 2,
  byrow = TRUE
)

x <- c(1, 2)
y <- c(3, 4)
```

Vector dot product:

```r
x %*% y
```

Matrix-vector product:

```r
A %*% x
```

Matrix-matrix product:

```r
A %*% A
```

These represent three common levels of linear algebra calculations:

```text
vector  with vector
matrix  with vector
matrix  with matrix
```

---

# 29. Example: Quadratic Form

Expressions of the form

$$
\mathbf{x}^T A \mathbf{x}
$$

occur frequently in statistics, optimization, and physics.

For example:

```r
A <- matrix(
  c(
    2, 1,
    1, 3
  ),
  nrow = 2,
  byrow = TRUE
)

x <- c(1, 2)

value <- t(x) %*% A %*% x

value
```

The result is a \(1\times1\) matrix.

To convert it to an ordinary numeric value:

```r
as.numeric(value)
```

---

# 30. Useful Linear Algebra Functions

Some commonly used functions are:

| Operation                    | R command        |
| ---------------------------- | ---------------- |
| Vector addition              | `x + y`          |
| Scalar-vector multiplication | `a * x`          |
| Dot product                  | `x %*% y`        |
| Vector norm                  | `sqrt(sum(x^2))` |
| Matrix addition              | `A + B`          |
| Element-wise multiplication  | `A * B`          |
| Matrix-vector multiplication | `A %*% x`        |
| Matrix-matrix multiplication | `A %*% B`        |
| Transpose                    | `t(A)`           |
| Outer product                | `outer(x, y)`    |
| Identity matrix              | `diag(n)`        |
| Diagonal elements            | `diag(A)`        |
| Determinant                  | `det(A)`         |
| Matrix inverse               | `solve(A)`       |
| Solve \(Ax=b\)               | `solve(A, b)`    |
| Eigenvalues/eigenvectors     | `eigen(A)`       |
| Check symmetry               | `isSymmetric(A)` |

---

# Summary

R distinguishes between element-by-element operations and linear algebra operations.

For example:

```r
A * B
```

performs element-by-element multiplication, whereas:

```r
A %*% B
```

performs matrix multiplication.

A useful progression of operations is:

```r
# Vector-vector operation

x %*% y
```

```r
# Matrix-vector operation

A %*% x
```

```r
# Matrix-matrix operation

A %*% B
```

These operations form the basis of many calculations in statistics, data analysis, numerical methods, and scientific computing.

