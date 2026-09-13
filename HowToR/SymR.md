# Symbolic Calculations in R

R is primarily designed for numerical and statistical computing, but it can also perform symbolic calculations.

Simple symbolic differentiation can be done using **base R**. More advanced symbolic algebra can be performed using the `caracas` package, which provides an R interface to the Python package **SymPy**.

This guide demonstrates:

* symbolic expressions,
* differentiation,
* substitution,
* numerical evaluation,
* integration,
* simplification and expansion,
* solving equations,
* Taylor expansions,
* multivariable derivatives,
* symbolic matrices,
* converting symbolic results into ordinary R functions.

---

# 1. Symbolic Differentiation with Base R

Base R provides the function `D()` for symbolic differentiation.

For example, consider

$$
f(x)=x^3+2x^2+5x+1.
$$

Create the symbolic expression:

```r
f <- expression(x^3 + 2*x^2 + 5*x + 1)

f
```

Differentiate with respect to \(x\):

```r
df <- D(f, "x")

df
```

R returns a symbolic expression equivalent to

$$
\frac{df}{dx}=
3x^2+4x+5.
$$

---

# 2. Substituting a Value into a Symbolic Result

Once the derivative has been calculated symbolically, a numerical value can be substituted using `eval()`.

For example, evaluate

$$
\frac{df}{dx}
$$

at \(x=2\):

```r
df <- D(f, "x")

eval(
  df,
  envir = list(x = 2)
)
```

This evaluates

$$
3(2)^2+4(2)+5=25.
$$

Thus the output is:

```text
[1] 25
```

---

# 3. Evaluate the Original Function

The same method can be used to evaluate the original symbolic expression.

```r
f <- expression(x^3 + 2*x^2 + 5*x + 1)

eval(
  f,
  envir = list(x = 2)
)
```

This calculates

$$
f(2)=
2^3+2(2^2)+5(2)+1
=27.
$$

---

# 4. Convert a Symbolic Derivative into an R Function

A symbolic result can also be wrapped inside an ordinary R function.

```r
f <- expression(x^3 + 2*x^2 + 5*x + 1)

df <- D(f, "x")

df_function <- function(x) {

  eval(
    df,
    envir = list(x = x)
  )
}
```

Now the derivative can be evaluated like an ordinary function:

```r
df_function(2)
```

Output:

```text
[1] 25
```

and:

```r
df_function(5)
```

evaluates the derivative at \(x=5\).

---

# 5. Second Derivative with Base R

Differentiate the first derivative again:

```r
f <- expression(x^3 + 2*x^2 + 5*x + 1)

df <- D(f, "x")

d2f <- D(df, "x")

d2f
```

This gives

$$
\frac{d^2f}{dx^2}=
6x+4.
$$

Evaluate it at \(x=2\):

```r
eval(
  d2f,
  envir = list(x = 2)
)
```

---

# More General Symbolic Algebra with `caracas`

For more advanced symbolic calculations, the `caracas` package can be used.

`caracas` uses the Python symbolic mathematics package **SymPy**.

---

# 6. Installing `caracas`

Install the R package:

```r
install.packages("caracas")
```

`caracas` also requires SymPy.

A convenient way to install it is:

```r
caracas::install_sympy()
```

You can check whether SymPy is available using:

```r
caracas::has_sympy()
```

The desired result is:

```text
[1] TRUE
```

Then load the package:

```r
library(caracas)
```

If you need to select a particular Python environment, configure `reticulate` **before** loading `caracas`.

For example:

```r
library(reticulate)

py_config()

library(caracas)
```

---

# 7. Creating Symbolic Variables

Create a symbolic variable using `symbol()`:

```r
library(caracas)

x <- symbol("x")
```

Now expressions involving `x` remain symbolic.

For example:

```r
f <- x^3 + 2*x^2 + 5*x + 1

f
```

---

# 8. Symbolic Differentiation

Differentiate using `der()`:

```r
df <- der(f, x)

df
```

For

$$
f(x)=x^3+2x^2+5x+1,
$$

the result is

$$
f'(x)=3x^2+4x+5.
$$

---

# 9. Substituting into a Symbolically Derived Expression

The function `subs()` substitutes values into symbolic expressions.

For example:

```r
df <- der(f, x)

df_at_2 <- subs(
  df,
  x,
  2
)

df_at_2
```

This substitutes \(x=2\) into the symbolic derivative.

The same operation can also be written using a named list:

```r
df_at_2 <- subs(
  df,
  list(x = 2)
)
```

This form becomes particularly useful when several variables must be substituted.

---

# 10. Numerical Evaluation

A symbolic result may remain an exact symbolic object.

To request a numerical approximation, use `N()`:

```r
N(df_at_2)
```

Therefore, a common pattern is:

```r
f <- x^3 + 2*x^2 + 5*x + 1

df <- der(f, x)

result <- subs(
  df,
  x,
  2
)

N(result)
```

The sequence is therefore:

```text
Define expression
       |
       v
Differentiate symbolically
       |
       v
Substitute numerical value
       |
       v
Evaluate numerically
```

---

# 11. Several Symbolic Variables

More than one symbolic variable can be defined.

```r
x <- symbol("x")
y <- symbol("y")

f <- x^2*y + sin(x)
```

Differentiate with respect to \(x\):

```r
df_dx <- der(f, x)

df_dx
```

Differentiate with respect to \(y\):

```r
df_dy <- der(f, y)

df_dy
```

---

# 12. Substitute Several Variables at Once

Suppose

$$
f(x,y)=x^2y+\sin(x).
$$

After calculating

```r
df_dx <- der(f, x)
```

we can substitute

$$
x=1,\qquad y=3
$$

using:

```r
value <- subs(
  df_dx,
  list(
    x = 1,
    y = 3
  )
)

value
```

Obtain a numerical approximation with:

```r
N(value)
```

This is particularly useful when an analytical expression contains several parameters.

---

# 13. Symbolic Parameters

Variables do not have to represent only coordinates. They can also represent symbolic parameters.

For example:

```r
x <- symbol("x")
a <- symbol("a")
b <- symbol("b")

f <- a*x^2 + b*x
```

Differentiate with respect to \(x\):

```r
df <- der(f, x)

df
```

which represents

$$
\frac{df}{dx}=2ax+b.
$$

Now substitute

$$
a=2,\qquad b=3,\qquad x=4.
$$

```r
value <- subs(
  df,
  list(
    a = 2,
    b = 3,
    x = 4
  )
)

N(value)
```

This demonstrates an important feature of symbolic computation: parameters can remain symbolic until their values are required.

---

# 14. Substitute a Symbolic Expression

Substitution does not have to involve a numerical value.

For example:

```r
x <- symbol("x")
y <- symbol("y")

f <- x^2 + 2*x
```

Replace \(x\) by \(y+1\):

```r
g <- subs(
  f,
  x,
  y + 1
)

g
```

The result remains symbolic.

It can then be simplified:

```r
simplify(g)
```

or expanded:

```r
expand(g)
```

---

# 15. Simplifying Expressions

Consider:

```r
x <- symbol("x")

f <- (x^2 - 1) / (x - 1)
```

Simplify it using:

```r
simplify(f)
```

The result is equivalent to

$$
x+1.
$$

---

# 16. Expanding Expressions

Consider:

```r
x <- symbol("x")

f <- (x + 1)^3
```

Expand:

```r
expand(f)
```

giving

$$
x^3+3x^2+3x+1.
$$

---

# 17. Symbolic Integration

Consider

$$
f(x)=x^2.
$$

Create the expression:

```r
x <- symbol("x")

f <- x^2
```

Calculate the indefinite integral:

```r
F <- int(f, x)

F
```

which corresponds to

$$
\int x^2\,dx=
\frac{x^3}{3}.
$$

---

# 18. Definite Integration

A definite integral can also be calculated.

For example:

$$
\int_0^2 x^2\,dx.
$$

In R:

```r
result <- int(
  x^2,
  x,
  0,
  2
)

result
```

Request a numerical value:

```r
N(result)
```

---

# 19. Differentiate an Integral

Symbolic operations can be combined.

For example:

```r
x <- symbol("x")

f <- x^2 + sin(x)

F <- int(f, x)

F
```

Now differentiate the symbolic integral:

```r
der(F, x)
```

The result should reproduce the original function.

---

# 20. Solving an Equation

Consider

$$
2x^2-x=0.
$$

Define the expression:

```r
x <- symbol("x")

eq <- 2*x^2 - x
```

Solve:

```r
solve_sys(eq, x)
```

The solutions are

$$
x=0
$$

and

$$
x=\frac{1}{2}.
$$

---

# 21. Solving an Equation Written as Left = Right

Suppose

$$
2x+2=x.
$$

Define the two sides:

```r
x <- symbol("x")

lhs <- 2*x + 2
rhs <- x
```

Then:

```r
solve_sys(
  lhs,
  rhs,
  x
)
```

---

# 22. Taylor Series

Consider

$$
f(x)=\cos(x).
$$

Define:

```r
x <- symbol("x")

f <- cos(x)
```

A Taylor expansion about \(x=0\) can be calculated with:

```r
series <- taylor(
  f,
  x0 = 0,
  n = 5
)

series
```

To remove the symbolic remainder term:

```r
series <- drop_remainder(series)

series
```

The result corresponds to

$$
\cos(x)
\approx
1-\frac{x^2}{2}
+\frac{x^4}{24}.
$$

We can substitute a numerical value into the derived series:

```r
approx_value <- subs(
  series,
  x,
  0.2
)

N(approx_value)
```

and compare it with:

```r
cos(0.2)
```

---

# 23. Convert a Symbolic Expression into an R Function

A useful feature of `caracas` is the ability to convert a symbolic expression into an ordinary R function.

Consider:

```r
x <- symbol("x")

f <- x^3 + 2*x^2 + 5*x + 1
```

Differentiate it:

```r
df <- der(f, x)
```

Convert the symbolic derivative into an R function:

```r
df_function <- as_func(df)
```

Now evaluate it normally:

```r
df_function(2)
```

or:

```r
df_function(5)
```

This is useful when the analytical expression is derived once but must then be evaluated many times numerically.

---

# 24. Symbolically Derive First, Numerically Evaluate Many Times

A common scientific workflow is:

```r
library(caracas)

x <- symbol("x")

# Define function
f <- exp(-x^2)

# Derive analytically
df <- der(f, x)

# Convert analytical derivative to an R function
df_function <- as_func(df)

# Evaluate at several points
df_function(0)
df_function(0.5)
df_function(1)
df_function(2)
```

This approach separates the symbolic derivation from the later numerical calculations.

---

# 25. Symbolic Gradient

For a multivariable function

$$
f(x,y)=x^2+xy+y^2,
$$

define:

```r
x <- symbol("x")
y <- symbol("y")

f <- x^2 + x*y + y^2
```

Calculate the two partial derivatives:

```r
df_dx <- der(f, x)

df_dy <- der(f, y)
```

The gradient is

$$
\nabla f=
\begin{pmatrix}
\frac{\partial f}{\partial x} \\
\frac{\partial f}{\partial y}
\end{pmatrix}.
$$

Evaluate the gradient at

$$
x=1,\qquad y=2:
$$

```r
gx <- subs(
  df_dx,
  list(x = 1, y = 2)
)

gy <- subs(
  df_dy,
  list(x = 1, y = 2)
)

N(gx)
N(gy)
```

---

# 26. Second Derivatives

Repeated differentiation can be used to calculate higher derivatives.

For example:

```r
x <- symbol("x")

f <- x^4 + 2*x^3

df <- der(f, x)

d2f <- der(df, x)

d2f
```

Then evaluate the second derivative at \(x=2\):

```r
value <- subs(
  d2f,
  x,
  2
)

N(value)
```

---

# 27. Symbolic Matrices

`caracas` can also work with symbolic matrices.

For example, define

$$
A=
\begin{pmatrix}
a & b \\
c & d
\end{pmatrix}.
$$

```r
A <- matrix(
  c(
    "a", "b",
    "c", "d"
  ),
  nrow = 2,
  byrow = TRUE
)

A_sym <- as_sym(A)

A_sym
```

---

# 28. Symbolic Determinant

Calculate:

```r
det(A_sym)
```

The symbolic result is

$$
\det(A)=ad-bc.
$$

Values can then be substituted.

For example:

```r
det_A <- det(A_sym)

value <- subs(
  det_A,
  list(
    a = 1,
    b = 2,
    c = 3,
    d = 4
  )
)

N(value)
```

---

# 29. Symbolic Matrix Inverse

The inverse can be obtained using:

```r
A_inv <- inv(A_sym)

A_inv
```

The result remains symbolic.

For a \(2\times2\) matrix, it corresponds to

$$
A^{-1}=
\frac{1}{ad-bc}
\begin{pmatrix}
d & -b \\
-c & a
\end{pmatrix}.
$$

---

# 30. Export a Symbolic Result to LaTeX

Symbolic expressions can be converted into LaTeX using `tex()`.

For example:

```r
x <- symbol("x")

f <- x^3 + 2*x^2 + 5*x + 1

df <- der(f, x)

tex(df)
```

This is useful when symbolic results need to be included in reports, papers, or lecture notes.

---

# 31. Exact and Numerical Results

Symbolic calculations often preserve exact quantities.

For example:

```r
x <- symbol("x")

result <- int(
  x^2,
  x,
  0,
  2
)

result
```

may retain the exact fraction

$$
\frac{8}{3}.
$$

To obtain its decimal representation:

```r
N(result)
```

Thus:

```text
symbolic result
      |
      +---- exact form
      |
      +---- N(...) ----> numerical approximation
```

---

# 32. A Complete Example

The following example demonstrates a useful symbolic-to-numerical workflow.

Consider

$$
f(x)=a x^3+b x^2+c.
$$

We want to:

1. define the function symbolically,
2. calculate its first derivative,
3. calculate its second derivative,
4. substitute parameter values,
5. evaluate both derivatives at \(x=2\).

```r
library(caracas)

# ------------------------------------------------------------
# Define symbols
# ------------------------------------------------------------

x <- symbol("x")
a <- symbol("a")
b <- symbol("b")
c <- symbol("c")


# ------------------------------------------------------------
# Define symbolic function
# ------------------------------------------------------------

f <- a*x^3 + b*x^2 + c

f


# ------------------------------------------------------------
# First derivative
# ------------------------------------------------------------

df <- der(f, x)

df


# ------------------------------------------------------------
# Second derivative
# ------------------------------------------------------------

d2f <- der(df, x)

d2f


# ------------------------------------------------------------
# Substitute values
#
# a = 2
# b = 3
# c = 1
# x = 2
# ------------------------------------------------------------

df_value <- subs(
  df,
  list(
    a = 2,
    b = 3,
    c = 1,
    x = 2
  )
)

d2f_value <- subs(
  d2f,
  list(
    a = 2,
    b = 3,
    c = 1,
    x = 2
  )
)


# ------------------------------------------------------------
# Numerical results
# ------------------------------------------------------------

N(df_value)

N(d2f_value)
```

The important workflow is:

```text
Define symbols
      |
      v
Construct symbolic expression
      |
      v
Perform symbolic operation
      |
      v
Substitute parameter values
      |
      v
Numerical evaluation
```

---

# 33. Base R or `caracas`?

For simple symbolic differentiation, base R is often sufficient:

```r
f <- expression(x^3 + sin(x))

df <- D(f, "x")

eval(
  df,
  envir = list(x = 2)
)
```

For more general symbolic calculations, use `caracas`:

```r
x <- symbol("x")

f <- x^3 + sin(x)

df <- der(f, x)

value <- subs(
  df,
  x,
  2
)

N(value)
```

`caracas` is particularly useful when calculations require:

* symbolic integration,
* equation solving,
* simplification,
* polynomial expansion,
* Taylor series,
* several symbolic variables,
* symbolic parameters,
* symbolic matrices,
* higher derivatives.

---

# 34. Useful Commands

| Task                       | Base R         | `caracas`     |
| -------------------------- | -------------- | ------------- |
| Define symbolic expression | `expression()` | `symbol()`    |
| Differentiate              | `D()`          | `der()`       |
| Substitute values          | `eval()`       | `subs()`      |
| Numerical evaluation       | `eval()`       | `N()`         |
| Simplify                   | limited        | `simplify()`  |
| Expand                     | limited        | `expand()`    |
| Integrate                  | —              | `int()`       |
| Solve equations            | —              | `solve_sys()` |
| Taylor expansion           | —              | `taylor()`    |
| Convert to R function      | manual         | `as_func()`   |
| Symbolic matrices          | limited        | `as_sym()`    |
| Matrix inverse             | —              | `inv()`       |
| Export LaTeX               | —              | `tex()`       |

---

# Summary

For simple symbolic differentiation using only base R:

```r
f <- expression(x^3 + 2*x^2 + 5*x + 1)

df <- D(f, "x")

eval(
  df,
  envir = list(x = 2)
)
```

For more general symbolic calculations:

```r
library(caracas)

x <- symbol("x")

f <- x^3 + 2*x^2 + 5*x + 1

df <- der(f, x)

value <- subs(
  df,
  x,
  2
)

N(value)
```

The central symbolic workflow is:

```text
Symbolic expression
        |
        v
Symbolic manipulation
        |
        v
Derived expression
        |
        v
subs(...)
        |
        v
Expression with values inserted
        |
        v
N(...)
        |
        v
Numerical result
```

This allows an analytical expression to be derived once and subsequently evaluated for many different numerical parameters.

