# Lecture 02 — Discrete Probability Distributions and Hypothesis Testing

This lecture introduces two important probability distributions for **count data**: the **binomial distribution** and the **Poisson distribution**.

We begin with a simple coin-toss example and then move to a biological application involving mutations in the HIV genome.

The same example is then used to introduce:

* cumulative probabilities;
* significance levels;
* rejection regions;
* one-tailed and two-tailed tests;
* null and alternative hypotheses;
* p-values;
* exact binomial hypothesis testing.

[1. Binomial Distribution](#1-binomial-distribution)      
[2. Poisson Distribution](#2-poisson-distribution)     
[3. HIV Mutation Example](#3-hiv-mutation-example)     
[4. Central 95% Region for a Binomial Distribution](#4-central-95-region-for-a-binomial-distribution)     
[5. Left-Tailed Binomial Test](#5-left-tailed-binomial-test)    
[6. Cumulative Distribution Function](#6-cumulative-distribution-function)     
[7. Hypothesis Test for the HIV Mutation Rate](#7-hypothesis-test-for-the-hiv-mutation-rate)        

---

## Learning objectives

By the end of this lecture, you should be able to:

* recognize situations that can be modeled using a binomial distribution;
* calculate binomial probabilities using `dbinom()`;
* understand the meaning of the parameters $n$ and $p$;
* understand when a Poisson distribution can approximate a binomial distribution;
* calculate Poisson probabilities using `dpois()`;
* understand the parameter $\lambda$ of a Poisson distribution;
* calculate cumulative probabilities using `pbinom()`;
* obtain quantiles and critical values using `qbinom()`;
* understand the meaning of a significance level $\alpha$;
* distinguish between one-tailed and two-tailed tests;
* identify a rejection region;
* formulate null and alternative hypotheses;
* calculate and interpret a p-value;
* perform an exact binomial test using `binom.test()`;
* distinguish between **rejecting $H_0$** and **not rejecting $H_0$**.

---

# 1. Binomial Distribution

File: [`BinomialDistribution.R`](BinomialDistribution.R)

Many biological measurements are **counts**.

Examples include:

* the number of mutations in a DNA sequence;
* the number of infected individuals in a sample;
* the number of sequencing reads containing a particular base;
* the number of cells responding to a treatment.

Such quantities are **discrete variables** because they take countable values such as

$$
0,1,2,3,\ldots
$$

rather than any possible value on a continuous scale.

The **binomial distribution** is one of the simplest probability distributions for count data.

---

## Bernoulli trials

Suppose an experiment has only two possible outcomes:

```text
success
failure
```

Examples might be:

```text
head        / tail
mutation    / no mutation
infected    / not infected
positive    / negative
```

One such experiment is called a **Bernoulli trial**.

If the probability of success is

$$
p,
$$

then the probability of failure is

$$
1-p.
$$

### Connection to the Binomial distribution

A **Bernoulli trial** describes a single trial.

Let

$$
X_i =
\begin{cases}
1, & \text{if trial } i \text{ is a success},\\
0, & \text{if trial } i \text{ is a failure}.
\end{cases}
$$

Each $X_i$ is therefore a Bernoulli random variable.

If the experiment is repeated independently $n$ times, with the same probability of success $p$, then the total number of successes is

$$
X = X_1 + X_2 + \cdots + X_n.
$$

This sum follows a binomial distribution:

$$
X \sim \mathrm{Binomial}(n,p).
$$

For example:

```text
one coin toss        -> Bernoulli trial

3 coin tosses        -> X = X1 + X2 + X3
                         = total number of heads
                         -> Binomial distribution
```

So the binomial distribution can be thought of as **counting the number of successes in repeated Bernoulli trials**.

---

## Binomial experiment

A binomial distribution applies when:

1. there is a fixed number of trials, $n$;
2. each trial has two possible outcomes;
3. the probability of success, $p$, is the same for every trial;
4. the trials are independent.

If $X$ is the number of successes in $n$ trials, then

$$
X \sim \mathrm{Binomial}(n,p).
$$

The probability of obtaining exactly $x$ successes is

$$
P(X=x)=
{n \choose x}
p^x
(1-p)^{n-x}.
$$

The quantity

$$
{n \choose x}
=\frac{n!}{x!(n-x)!}
$$

counts the number of different ways in which $x$ successes can occur among $n$ trials.

---

## Example: three tosses of a fair coin

Suppose a fair coin is tossed three times.

The number of trials is

```r
n <- 3
```

and the probability of a head on each toss is

```r
p <- 0.5
```

Let

$$
X = \text{number of heads}.
$$

The possible values are

$$
X=0,1,2,3.
$$

---

## Probability of exactly three heads

In R, `dbinom()` gives the probability of obtaining **exactly** a specified number of successes.

```r
dbinom(
  3,
  size = 3,
  prob = 0.5
)
```

The arguments are:

```text
x       number of successes
size    total number of trials
prob    probability of success in each trial
```

Thus,

```r
dbinom(3, size = 3, prob = 0.5)
```

calculates

$$
P(X=3).
$$

For three fair coin tosses,

$$
P(X=3)=
{3 \choose 3}
(0.5)^3
(0.5)^0=
\frac{1}{8}=
0.125.
$$

---

## Complete binomial distribution

Instead of calculating only one probability, we can calculate all possible probabilities at once.

```r
x <- 0:n

prob <- dbinom(
  x,
  size = n,
  prob = p
)
```

Because `x` is a vector,

```r
0 1 2 3
```

R calculates

$$
P(X=0),\quad
P(X=1),\quad
P(X=2),\quad
P(X=3).
$$

The results can be placed in a data frame:

```r
results <- data.frame(
  Heads = x,
  Probability = prob
)

results
```

For three fair coin tosses, the distribution is

| Heads | Probability |
| ----: | ----------: |
|     0 |       0.125 |
|     1 |       0.375 |
|     2 |       0.375 |
|     3 |       0.125 |

Notice that

$$
\sum_x P(X=x)=1.
$$

The probabilities of all possible outcomes of a probability distribution must add to 1.

---

## Plotting a discrete probability distribution

The binomial distribution can be plotted using vertical lines:

```r
plot(
  x,
  prob,
  type = "h",
  lwd = 5,
  xlab = "Number of Heads",
  ylab = "Probability",
  main = "Binomial Distribution: 3 Coin Tosses"
)
```

Here,

```r
type = "h"
```

draws a vertical line from the horizontal axis to each probability.

This representation is useful because the binomial distribution is **discrete**.

Points can be added at the top of the lines:

```r
points(
  x,
  prob,
  pch = 16,
  cex = 1.3
)
```

Here:

* `pch = 16` gives a filled circle;
* `cex = 1.3` controls the size of the plotted points.

---

## Expected number of successes

For a binomial random variable,

$$
X \sim \mathrm{Binomial}(n,p),
$$

the symbol

$$
\sim
$$

means **"is distributed as"** or **"follows the distribution"**.

Thus,

$$
X \sim \mathrm{Binomial}(n,p)
$$

is read as:

> **$X$ follows a binomial distribution with parameters $n$ and $p$.**

Here,

* $X$ is the random variable: the number of successes;
* $n$ is the number of independent trials;
* $p$ is the probability of success in each trial.

The expected number of successes is

$$
E[X]=np.
$$

For example, if a fair coin is tossed 10 times,

$$
X \sim \mathrm{Binomial}(10,0.5),
$$

and

$$
E[X]=10\times0.5=5.
$$

This means that the **average number of heads over many repetitions of the 10-toss experiment** would approach 5. It does not mean that every set of 10 tosses will contain exactly 5 heads.

This quantity will become particularly important when we connect the binomial distribution to the Poisson distribution.


---

# 2. Poisson Distribution

File: [`PoissonDistribution.R`](PoissonDistribution.R)

The **Poisson distribution** is another probability distribution for counts.

It is often used to describe the number of events occurring within a fixed interval of:

* time;
* space;
* sequence length;
* volume;
* area.

Examples could include:

* mutations along a genome;
* sequencing errors in a read;
* radioactive decay events during a time interval;
* cells observed in a microscope field;
* rare disease cases within a population.

---

## Poisson parameter

The Poisson distribution has one parameter,

$$
\lambda,
$$

which represents the expected number of events.

If

$$
X\sim\mathrm{Poisson}(\lambda),
$$

then

$$
P(X=x)=
\frac{e^{-\lambda}\lambda^x}{x!}.
$$

The mean of the Poisson distribution is

$$
E[X]=\lambda.
$$

---

## Connection between binomial and Poisson distributions

A Poisson distribution can approximate a binomial distribution when:

$$
n \text{ is large},
$$

$$
p \text{ is small},
$$

and

$$
np=\lambda
$$

remains approximately constant.

This is particularly useful for **rare events**.

For example, we can choose

```r
lambda <- 2
```

and then examine increasingly large values of `n`:

```r
n <- 10
```

or

```r
n <- 100
```

or

```r
n <- 1000
```

To keep

$$
np=\lambda,
$$

we choose

```r
p <- lambda / n
```

Thus:

```text
n = 10       p = 0.2

n = 100      p = 0.02

n = 1000     p = 0.002
```

In each case,

$$
np=2.
$$

As $n$ becomes larger and $p$ becomes smaller, the binomial distribution becomes increasingly similar to a Poisson distribution with

$$
\lambda=2.
$$

---

## Comparing one probability

The exact binomial probability of one success is

```r
dbinom(
  1,
  size = n,
  prob = p
)
```

The corresponding Poisson probability is

```r
dpois(
  1,
  lambda = lambda
)
```

Thus:

```text
dbinom()   -> binomial probability

dpois()    -> Poisson probability
```

The `d` at the beginning of both function names can be thought of as asking for the probability associated with a particular value of the distribution.

---

## Comparing complete distributions

Consider values from 0 to 10:

```r
x <- 0:10
```

Calculate the exact binomial probabilities:

```r
binom_prob <- dbinom(
  x,
  size = n,
  prob = p
)
```

and the Poisson probabilities:

```r
poisson_prob <- dpois(
  x,
  lambda = lambda
)
```

The exact binomial distribution can then be plotted:

```r
plot(
  x,
  binom_prob,
  type = "h",
  lwd = 4,
  ylim = c(0, 0.3),
  xaxt = "n",
  xlab = "Number of successes",
  ylab = "Probability",
  main = paste(
    "Binomial vs Poisson",
    "\nn =", n,
    "   p =", p
  ),
  col = "blue"
)
```

Add integer labels to the horizontal axis:

```r
axis(
  1,
  at = x
)
```

Then add the Poisson probabilities:

```r
points(
  x,
  poisson_prob,
  pch = 16,
  cex = 1.2,
  col = "red"
)
```

---

## What happens as $n$ increases?

Try the calculation with

```r
n <- 10
```

then

```r
n <- 100
```

and finally

```r
n <- 1000
```

while always defining

```r
p <- lambda / n
```

The two distributions become progressively more similar.

This illustrates the limiting relationship

$$
\mathrm{Binomial}(n,p)
\longrightarrow
\mathrm{Poisson}(\lambda)
$$

when

$$
n\rightarrow\infty,
\qquad
p\rightarrow 0,
\qquad
np=\lambda.
$$

This relationship is particularly useful in biology because many biological events are individually rare but occur across a large number of opportunities.

---

# 3. HIV Mutation Example

File: [`HIVMutation.R`](HIVMutation.R)

We now apply the binomial and Poisson distributions to a biological example.

Suppose the HIV genome contains approximately

$$
10\,000
$$

nucleotides.

Assume that during one replication cycle each nucleotide independently has probability

$$
5\times10^{-4}
$$

of undergoing a mutation.

We ask:

> What is the probability of observing exactly 3 mutations?

---

## Defining the model

The number of nucleotides is

```r
n <- 10000
```

and the probability of mutation at each nucleotide is

```r
p <- 5e-4
```

Thus,

$$
X\sim\mathrm{Binomial}(10000,0.0005).
$$

---

## Expected number of mutations

For a binomial distribution,

$$
E[X]=np.
$$

Therefore,

$$
E[X]=
10000\times0.0005=
5.
$$

In R:

```r
lambda <- n * p

lambda
```

gives

```text
5
```

So although the mutation probability for an individual nucleotide is very small, there are many nucleotides at which a mutation could occur.

The expected number of mutations in the complete genome is therefore 5.

---

## Probability of exactly three mutations

Set

```r
x <- 3
```

The exact binomial probability is

```r
binom_prob <- dbinom(
  x,
  size = n,
  prob = p
)

print(binom_prob)
```

This calculates

$$
P(X=3)
$$

using the binomial distribution.

---

## Poisson approximation

Here,

$$
n=10000
$$

is large and

$$
p=0.0005
$$

is small.

The expected number of mutations is

$$
\lambda=np=5.
$$

This is therefore a situation in which a Poisson approximation should work well.

Calculate

```r
poisson_prob <- dpois(
  x,
  lambda = lambda
)

print(poisson_prob)
```

This gives the approximation

$$
X\approx\mathrm{Poisson}(5).
$$

The exact binomial and approximate Poisson probabilities should be very similar.

---

## Comparing the complete distributions

Consider mutation counts from 0 to 12:

```r
x <- 0:12
```

Calculate the exact binomial probabilities:

```r
binom_prob <- dbinom(
  x,
  size = n,
  prob = p
)
```

and the Poisson approximation:

```r
poisson_prob <- dpois(
  x,
  lambda = lambda
)
```

Plot the binomial probabilities:

```r
plot(
  x,
  binom_prob,
  type = "h",
  lwd = 4,
  col = "blue",
  xaxt = "n",
  xlab = "Number of mutations",
  ylab = "Probability",
  main = "HIV Mutations: Binomial vs Poisson"
)
```

Add an integer x-axis:

```r
axis(
  1,
  at = x
)
```

and the Poisson probabilities:

```r
points(
  x,
  poisson_prob,
  pch = 16,
  cex = 1.2,
  col = "red"
)
```

Because $n$ is large and $p$ is small, the red Poisson points lie very close to the exact binomial distribution.

---

## Why use the exact binomial distribution?

For this problem, R can easily calculate the exact binomial probabilities.

Therefore, there is no computational need to replace the binomial distribution with its Poisson approximation.

However, the comparison is useful because it demonstrates an important statistical relationship and explains why the Poisson distribution frequently appears in the study of rare events.

---

# 4. Central 95% Region for a Binomial Distribution

File: [`ConfidenceInterval_Binomial_2Tail.R`](ConfidenceInterval_Binomial_2Tail.R)

We now connect probability distributions with **statistical hypothesis testing**.

Suppose the mutation probability specified by a model is

$$
p=5\times10^{-4}.
$$

If that model is correct, some numbers of mutations will be common and others will be unusually small or unusually large.

We can use the binomial distribution to identify these regions.

---

## Significance level

Choose a significance level

```r
alpha <- 0.05
```

Thus,

$$
\alpha=0.05.
$$

The corresponding central probability is

$$
1-\alpha=0.95.
$$

In R:

```r
confidence_level <- 1 - alpha

confidence_level
```

gives

```text
0.95
```

For a two-tailed procedure, the significance level is divided between the two tails:

$$
\frac{\alpha}{2}=
0.025.
$$

Conceptually:

```text
left tail        central region        right tail
  2.5%               95%                  2.5%
```

For a continuous probability distribution this division can often be made exactly.

For a discrete distribution such as the binomial distribution, the available probabilities occur in discrete steps, so the tail probabilities will not necessarily be exactly 0.025.

---

## Binomial distribution under the model

Define

```r
n <- 10000
p <- 5e-4
```

and calculate the probability distribution:

```r
x <- 0:15

prob <- dbinom(
  x,
  size = n,
  prob = p
)
```

---

## Finding the central region

R's `qbinom()` function gives a **quantile** of the binomial distribution.

For the lower boundary:

```r
lower <- qbinom(
  alpha / 2,
  size = n,
  prob = p
)
```

For the upper boundary:

```r
upper <- qbinom(
  1 - alpha / 2,
  size = n,
  prob = p
)
```

The function

```r
qbinom(probability, size, prob)
```

finds the number of successes corresponding to a specified cumulative probability.

The prefix

```text
q
```

can therefore be associated with **quantile**.

---

## Visualizing the central and tail regions

We can assign different colors depending on whether a count lies inside or outside the central region:

```r
bar_col <- ifelse(
  x < lower | x > upper,
  "tomato",
  "skyblue"
)
```

The expression

```r
x < lower | x > upper
```

means

```text
x is below the lower boundary
OR
x is above the upper boundary
```

The symbol

```r
|
```

means logical **OR** in R.

The distribution can then be plotted:

```r
barplot(
  prob,
  names.arg = x,
  col = bar_col,
  xlab = "Number of mutations",
  ylab = "Probability",
  main = "Binomial Distribution of HIV Mutations"
)
```

The colors can be interpreted as:

```text
blue    central region

red     tail regions
```

---

## Connection with hypothesis testing

Suppose the null hypothesis specifies

$$
H_0:p=p_0.
$$

If an observed result falls far into either tail of the distribution expected under $H_0$, it provides evidence against that null hypothesis.

For a two-sided alternative,

$$
H_A:p\ne p_0,
$$

both unusually small and unusually large mutation counts are relevant.

Conceptually:

```text
very small X        expected X        very large X
     |                  |                  |
 evidence             compatible          evidence
against H0             with H0           against H0
```

---

## A note about discreteness

The binomial distribution is discrete.

Therefore, we cannot always choose integer boundaries that place exactly

$$
2.5\%
$$

of the probability in each tail.

The probability in the rejection region may therefore be slightly smaller than the nominal significance level.

This is an important distinction between many exact tests for discrete data and tests based on continuous probability distributions.

---

# 5. Left-Tailed Binomial Test

File: [`ConfidenceInterval_Binomial_LeftTail.R`](ConfidenceInterval_Binomial_LeftTail.R)

The previous example considered both tails of the distribution.

Sometimes the scientific question concerns only **one direction**.

Suppose we want to test whether the mutation probability is **smaller** than

$$
5\times10^{-4}.
$$

The hypotheses are

$$
H_0:p=5\times10^{-4}
$$

and

$$
H_A:p<5\times10^{-4}.
$$

Because the alternative hypothesis contains

$$
p<p_0,
$$

this is a **left-tailed test**.

---

## Why is it left-tailed?

If the true mutation probability is smaller than the value specified by $H_0$, we expect to observe unusually **small numbers of mutations**.

Therefore, evidence against $H_0$ occurs in the left tail of the distribution.

```text
small number of mutations                    large number
          |
          v

    rejection region      do-not-reject region
   <----------------|---------------------------->
```

A **right-tailed test** is also possible.

For example, if we want to test whether the mutation probability is **larger** than the value specified by $H_0$, the hypotheses would be

$$
H_0:p=p_0
$$

and

$$
H_A:p>p_0.
$$

In this case, unusually **large numbers of mutations** provide evidence against $H_0$, so the rejection region lies in the right tail.

```text
small number of mutations                    large number
                                                     |
                                                     v

    do-not-reject region          rejection region
   ----------------------------|-------------------->
```

Thus:

```text
HA: p < p0    -> left-tailed test

HA: p > p0    -> right-tailed test

HA: p != p0   -> two-tailed test
```


---

## Significance level

Again choose

```r
alpha <- 0.05
```

For a left-tailed test, the complete significance level is placed in the left tail.

Thus we want a critical value satisfying approximately

$$
P(X\le x_{\mathrm{critical}}\mid H_0)
\le 0.05.
$$

---

## Finding a critical value

First calculate

```r
q <- qbinom(
  alpha,
  size = n,
  prob = p0
)
```

However, `qbinom()` returns the first integer at which the cumulative probability **reaches or exceeds** the requested probability.

Because the binomial distribution is discrete, that value can sometimes give a cumulative probability greater than $\alpha$.

The script therefore checks it explicitly:

```r
if (pbinom(q, size = n, prob = p0) <= alpha) {

  critical <- q

} else {

  critical <- q - 1

}
```

This ensures that

$$
P(X\le \text{critical}\mid H_0)
\le\alpha.
$$

For the HIV example, the rejection region becomes

$$
X\le1.
$$

The probability of this region is approximately

$$
P(X\le1)\approx0.0404.
$$

It is smaller than 0.05 because there is no integer mutation count that gives a tail probability exactly equal to 0.05.

---

## Coloring the rejection region

The bars can be colored according to whether they lie in the rejection region:

```r
bar_col <- ifelse(
  x <= critical,
  "tomato",
  "skyblue"
)
```

Thus:

```text
tomato     rejection region

skyblue    do-not-reject region
```

Plot the distribution:

```r
barplot(
  prob,
  names.arg = x,
  col = bar_col,
  xlab = "Number of mutations",
  ylab = "Probability",
  main = "Left-Tailed Binomial Test for HIV Mutations"
)
```

---

## Interpretation

If the observed number of mutations falls in the red region,

$$
X\le1,
$$

we reject

$$
H_0.
$$

The data then provide evidence that

$$
p<p_0.
$$

If the observed number of mutations falls outside this rejection region, we **do not reject** $H_0$.

This wording is important.

```text
Do not reject H0
```

does **not** mean

```text
H0 has been proven true.
```

It means only that the observed data do not provide sufficiently strong evidence against $H_0$ at the chosen significance level.

---

# 6. Cumulative Distribution Function

File: [`HIVMutation_CDF.R`](HIVMutation_CDF.R)

So far we have often calculated probabilities for individual counts such as

$$
P(X=3).
$$

Hypothesis testing often requires probabilities such as

$$
P(X\le3).
$$

This is a **cumulative probability**.

---

## The HIV example

Under the null hypothesis,

$$
p_0=5\times10^{-4}
$$

and

$$
n=10000.
$$

Suppose we observe

$$
x_{\mathrm{obs}}=3
$$

mutations.

In R:

```r
n <- 10000
p0 <- 5e-4
x_obs <- 3
```

---

## Probability distribution under $H_0$

Calculate probabilities for mutation counts from 0 to 15:

```r
x <- 0:15

prob <- dbinom(
  x,
  size = n,
  prob = p0
)
```

The null hypothesis determines the probability distribution against which the observation will be compared.

---

## Highlighting the observed lower tail

For a left-tailed question, we are interested not only in exactly three mutations but also in outcomes even smaller than three.

Thus the relevant outcomes are

$$
0,1,2,3.
$$

They can be highlighted using

```r
bar_col <- ifelse(
  x <= x_obs,
  "tomato",
  "skyblue"
)
```

Plot the distribution:

```r
bp <- barplot(
  prob,
  names.arg = x,
  col = bar_col,
  xlab = "Number of mutations",
  ylab = "Probability",
  main = "Null distribution for HIV mutations"
)
```

The observed value can be labelled:

```r
text(
  x = bp[x_obs + 1],
  y = prob[x_obs + 1],
  labels = "observed = 3",
  pos = 3
)
```

---

## Calculating the cumulative probability manually

First calculate the individual probabilities:

```r
pvals <- dbinom(
  0:x_obs,
  size = n,
  prob = p0
)

print(pvals)
```

These are

$$
P(X=0),
$$

$$
P(X=1),
$$

$$
P(X=2),
$$

and

$$
P(X=3).
$$

Adding them gives

$$
P(X\le3)=
P(X=0)
+
P(X=1)
+
P(X=2)
+
P(X=3).
$$

In R:

```r
sum(pvals)
```

For this example,

$$
P(X\le3)
\approx0.265.
$$

---

## Using `pbinom()`

Instead of calculating the individual probabilities and adding them, R can calculate the cumulative probability directly:

```r
pbinom(
  x_obs,
  size = n,
  prob = p0
)
```

Thus

```r
pbinom(3, size = 10000, prob = 5e-4)
```

calculates

$$
P(X\le3).
$$

---

## Probability mass and cumulative probability

It is useful to distinguish two R functions:

```text
dbinom()    probability at a particular value

pbinom()    cumulative probability up to that value
```

For example,

```r
dbinom(3, size = n, prob = p0)
```

means

$$
P(X=3),
$$

whereas

```r
pbinom(3, size = n, prob = p0)
```

means

$$
P(X\le3).
$$

Graphically:

```text
dbinom(3)

0   1   2   3   4   5   6 ...
            ^
            |
        only X = 3
```

while

```text
pbinom(3)

0   1   2   3   4   5   6 ...
|-----------|
  all values
  up to 3
```

---

## Cumulative distribution function

The **cumulative distribution function**, or CDF, is defined as

$$
F(x)=P(X\le x).
$$

For the binomial distribution, `pbinom()` evaluates this function.

This idea is central to hypothesis testing because a p-value often represents the probability of obtaining the observed result **or something still more extreme** under the null hypothesis.

---

# 7. Hypothesis Test for the HIV Mutation Rate

File: [`HIVMutation_HypothesisTest.R`](HIVMutation_HypothesisTest.R)

We can now combine the ideas from the previous sections into a formal hypothesis test.

Suppose the mutation probability per nucleotide is denoted by

$$
p.
$$

This is the **underlying mutation probability** that we want to learn about from the data. Its value is generally unknown.

We need a reference value against which to compare the data. We denote this value by

$$
p_0.
$$

The subscript $0$ indicates that this is the probability specified by the **null hypothesis**, $H_0$.

In this example, we take

$$
p_0 = 5\times10^{-4}.
$$

The value $p_0$ is not calculated from the current observation. It is a **reference value specified before the hypothesis test**. Depending on the scientific problem, such a value may come from previous experiments, published evidence, an established model, or another scientifically meaningful baseline.

Thus,

```text
p     = unknown underlying mutation probability

p0    = reference mutation probability
        = 5 x 10^-4
```

We observe 3 mutations among 10,000 nucleotides.

---

## Why is a hypothesis test necessary?

If the mutation probability were

$$
p_0=5\times10^{-4},
$$

then for

$$
n=10000
$$

nucleotides, the expected number of mutations would be

$$
np_0=
10000\times5\times10^{-4} =
5.
$$

But we observed only

$$
x_{\mathrm{obs}}=3.
$$

At first, we might simply compare

$$
3<5
$$

and conclude that the mutation rate appears to be smaller.

Equivalently, the observed mutation proportion is

$$
\hat p=
\frac{3}{10000}=
3\times10^{-4},
$$

which is smaller than

$$
p_0=5\times10^{-4}.
$$

However, this comparison alone is **not sufficient**.

Even if the mutation probability really were exactly

$$
p=p_0,
$$

we would not observe exactly 5 mutations every time.

Because mutation is a random process, different experiments could produce different numbers of mutations:

```text
2 mutations
3 mutations
4 mutations
5 mutations
6 mutations
7 mutations
...
```

even when the underlying mutation probability remains unchanged.

The value

$$
np_0=5
$$

is therefore an **expected value**, not a value that must occur in every experiment.

The important question is not simply

> Is the observed number smaller than 5?

Instead, we ask

> **If the mutation probability were really $p_0$, how unusual would it be to observe only 3 mutations, or even fewer?**

This is the purpose of the hypothesis test.

It allows us to distinguish between

```text
a difference that could reasonably arise
from random variation

                    and

a difference that is sufficiently unusual
to provide evidence against the reference model
```

---

## Step 1: State the hypotheses

The null hypothesis is

$$
H_0:p=p_0,
$$

where

$$
p_0=5\times10^{-4}.
$$

Therefore,

$$
H_0:p=5\times10^{-4}.
$$

The alternative hypothesis is

$$
H_A:p<p_0,
$$

or equivalently,

$$
H_A:p<5\times10^{-4}.
$$

The null hypothesis gives us a specific probability model to use as a reference.

Under $H_0$,

$$
X\sim\mathrm{Binomial}(n,p_0).
$$

We then ask whether the observed data would be unusual if this reference model were correct.

---

## Step 2: Define the data

```r
n <- 10000

# Reference mutation probability specified by H0
p0 <- 5e-4

# Observed number of mutations
x_obs <- 3
```

Here:

```text
n       = total number of nucleotides

p0      = reference mutation probability under H0

x_obs   = observed number of mutations
```

Notice that

```text
p0 = 5e-4
```

is part of the **null model**, whereas

```text
x_obs = 3
```

comes from the **observed data**.

---

## Step 3: Decide which tail is relevant

The alternative hypothesis is

$$
H_A:p<p_0.
$$

Therefore, unusually **small** mutation counts support the alternative.

This is a **left-tailed test**.

The relevant probability is therefore

$$
P(X\le3\mid H_0).
$$

Because $H_0$ specifies

$$
p=p_0,
$$

this means calculating the probability

$$
P(X\le3)
$$

for

$$
X\sim\mathrm{Binomial}(10000,5\times10^{-4}).
$$

---

## Step 4: Calculate the p-value

The p-value is calculated directly using

```r
p_value <- pbinom(
  x_obs,
  size = n,
  prob = p0
)

print(p_value)
```

For these data,

$$
p\text{-value}
\approx0.265.
$$

This means:

> If the mutation probability were really $p_0=5\times10^{-4}$, the probability of observing 3 or fewer mutations in 10,000 nucleotides would be about 26.5%.

Therefore, observing 3 mutations is lower than the expected value of 5, but it is **not particularly unusual** under the null model.

The p-value is **not** the probability that the null hypothesis is true.

Instead, it is calculated **assuming $H_0$ is true**.

---

## Step 5: Choose a significance level

Choose

```r
alpha <- 0.05
```

Therefore,

$$
\alpha=0.05.
$$

The decision rule is

$$
p\text{-value}<\alpha
\quad\Rightarrow\quad
\text{reject }H_0.
$$

Otherwise,

$$
p\text{-value}\ge\alpha
\quad\Rightarrow\quad
\text{do not reject }H_0.
$$

---

## Step 6: Make the statistical decision

In R:

```r
if (p_value < alpha) {

  print("Reject H0")

} else {

  print("Do not reject H0")

}
```

For this example,

$$
0.265 > 0.05.
$$

Therefore,

$$
\boxed{\text{Do not reject }H_0}
$$

at the 5% significance level.

Three mutations may be below the expected value of five, but observing three or fewer mutations is not sufficiently unusual under $H_0$ to reject it.

---

## Why "3 is below 5" is not enough

Under $H_0$, the expected number of mutations is

$$
np_0=
10000\times0.0005=
5.
$$

We observed

$$
3.
$$

It might therefore be tempting to say:

```text
3 < 5, therefore the mutation rate must be lower.
```

But random variables fluctuate.

Even when the true expected number is 5, outcomes such as 3, 4, 5, 6, or 7 can occur.

Statistical hypothesis testing asks a more precise question:

> How unusual would an observation of 3 or fewer mutations be if the null hypothesis were true?

The answer is

$$
P(X\le3\mid H_0)\approx0.265.
$$

A probability of about 26.5% is not unusually small.

---

## Exact binomial test in R

R provides the function

```r
binom.test()
```

for performing an exact binomial test directly.

For this example:

```r
binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "less"
)
```

The arguments mean:

```text
x              observed number of successes

n              total number of trials

p              probability specified by H0

alternative    form of the alternative hypothesis
```

Using

```r
alternative = "less"
```

specifies

$$
H_A:p<p_0.
$$

Thus R performs a left-tailed exact binomial test.

---

## Forms of the alternative hypothesis

The `alternative` argument determines the direction of the test.

```r
alternative = "less"
```

corresponds to

$$
H_A:p<p_0.
$$

```r
alternative = "greater"
```

corresponds to

$$
H_A:p>p_0.
$$

and

```r
alternative = "two.sided"
```

corresponds to

$$
H_A:p\ne p_0.
$$

The scientific question should determine the alternative hypothesis **before** examining the result.

---

## Rejection region and p-value are two views of the same test

Earlier we constructed a left-tailed rejection region for

$$
\alpha=0.05.
$$

For the HIV example, the rejection region was

$$
X\le1.
$$

Our observation was

$$
X=3.
$$

Since 3 is not in the rejection region, we do not reject $H_0$.

The p-value approach gives the same conclusion:

$$
p\text{-value}=
P(X\le3\mid H_0)
\approx0.265
>
0.05.
$$

Therefore,

$$
\text{do not reject }H_0.
$$

Thus the two approaches are equivalent ways of viewing the same statistical decision:

```text
critical-value approach
        |
        | Is the observation in the rejection region?
        |
        v
statistical decision
        ^
        |
        | Is the p-value smaller than alpha?
        |
p-value approach
```

---

# Important Statistical Language

A hypothesis test does **not** normally prove that a hypothesis is true or false.

If

$$
p\text{-value}<\alpha,
$$

we say

```text
Reject H0
```

because the observation is sufficiently unusual under $H_0$.

If

$$
p\text{-value}\ge\alpha,
$$

we say

```text
Do not reject H0
```

because the data do not provide sufficiently strong evidence against $H_0$.

We should generally avoid saying

```text
Accept H0
```

because failure to find evidence against a hypothesis is not the same as proving that the hypothesis is correct.

---

# R Probability Functions Introduced in This Lecture

R uses a consistent naming system for probability distributions.

For the binomial distribution:

```text
dbinom()    probability of exactly x successes

pbinom()    cumulative probability P(X <= x)

qbinom()    quantile corresponding to a cumulative probability
```

For the Poisson distribution:

```text
dpois()     probability of exactly x events
```

The prefixes are useful to remember:

```text
d    density / probability mass

p    cumulative probability

q    quantile
```

For example:

```r
dbinom(
  3,
  size = 10000,
  prob = 5e-4
)
```

calculates

$$
P(X=3),
$$

while

```r
pbinom(
  3,
  size = 10000,
  prob = 5e-4
)
```

calculates

$$
P(X\le3).
$$

And

```r
qbinom(
  0.05,
  size = 10000,
  prob = 5e-4
)
```

finds a mutation count associated with the lower 5% of the cumulative distribution.



This progression connects probability theory with the statistical methods used to draw conclusions from biological data.

---

