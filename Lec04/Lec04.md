<table style="width:100%; border:none;">
<tr>

<td style="width:33%; text-align:left; border:none;">
<a href="../Lec03/Lec03.html"><strong>← Previous Lecture</strong></a>
</td>

<td style="width:34%; text-align:center; border:none;">
<a href="../"><strong>Home</strong></a>
</td>

<td style="width:33%; text-align:right; border:none;">
<a href="../Lec05/Lec05.html"><strong>Next Lecture →</strong></a>
</td>

</tr>
</table>

# Lecture 04 — Multinomial Models, Errors, and Statistical Power

This lecture has two parts.

In the first part, we continue working with discrete probability models and introduce:

1. a biological example involving epitope detection;
2. the multinomial distribution.

In the second part, we return to hypothesis testing and examine what can happen when a statistical decision is made:

3. Type I error;
4. Type II error;
5. statistical power;
6. the connection between power, sample size, effect size, and the significance level $\alpha$.

[1. Epitope Detection and the Poisson Distribution](#epitope-detection-and-the-poisson-distribution)  
[2. Multinomial Distribution](#multinomial-distribution)  
[3. Statistical Decisions and Errors](#statistical-decisions-and-errors)  
[4. Type I Error and Alpha](#type-i-error-and-alpha)  
[5. Type II Error](#type-ii-error)  
[6. Statistical Power](#statistical-power)  
[7. What Determines Power?](#what-determines-power)  

---


# 1. Epitope Detection and the Poisson Distribution

File: [`EpitopeDetection.R`](EpitopeDetection.R)

An **epitope** is a small part of an antigen, such as a short region of a protein, that can be recognized by the immune system. If we examine $$ n $$ candidate peptide regions and classify each one as either **detected as an epitope** or **not detected**, the number of detected epitopes can be modeled using a **binomial distribution**. When the number of candidate regions is large and the probability of detecting an epitope at any one region is small, this binomial distribution can be approximated by a **Poisson distribution** with $$ \lambda = np $$.

A useful application of the Poisson distribution arises when we count relatively rare events.

Suppose a protein contains

$$
n
$$

possible peptide positions that could produce an epitope recognized by the immune system.

If each position has a small probability

$$
p
$$

of producing a detectable epitope, and the positions can be treated as approximately independent, then the number of detected epitopes can be modeled initially as

$$
X\sim\mathrm{Binomial}(n,p).
$$

The probability $$ p $$ is a model parameter. In a real study, it would need to be estimated from prior data or specified from previous knowledge; it is not usually known exactly.

When

$$
n
$$

is large and

$$
p
$$

is small, the binomial distribution can be approximated by a Poisson distribution with

$$
\lambda=np.
$$

Thus,

$$
X\approx\mathrm{Poisson}(\lambda).
$$

---

## Example

Suppose a protein contains

$$
n=500
$$

candidate peptide positions, and assume the probability that any one position produces a detectable epitope is

$$
p=0.004.
$$

Then the expected number of detected epitopes is

$$
E[X]=np
$$

so

$$
E[X]=500\times0.004=2.
$$

Thus,

$$
\lambda=2.
$$

The Poisson model is therefore

$$
X\sim\mathrm{Poisson}(2).
$$

---

## Probability of exactly 3 detected epitopes

For a Poisson random variable,

$$
P(X=x)=\frac{e^{-\lambda}\lambda^x}{x!}.
$$

In R:

```r
dpois(
  3,
  lambda = 2
)
```

This calculates

$$
P(X=3).
$$

---

## Probability of at least one detected epitope

We can calculate

$$
P(X\ge1)
$$

using

$$
P(X\ge1)=1-P(X=0).
$$

In R:

```r
1 - dpois(
  0,
  lambda = 2
)
```

or equivalently:

```r
ppois(
  0,
  lambda = 2,
  lower.tail = FALSE
)
```

---

## Comparing the binomial and Poisson models

The exact binomial model is

$$
X\sim\mathrm{Binomial}(500,0.004).
$$

The Poisson approximation is

$$
X\sim\mathrm{Poisson}(2).
$$

For example:

```r
dbinom(
  3,
  size = 500,
  prob = 0.004
)

dpois(
  3,
  lambda = 2
)
```

The two probabilities should be very similar.

This is another example of the relationship

$$
\mathrm{Binomial}(n,p)
\longrightarrow
\mathrm{Poisson}(\lambda)
$$

when

$$
n\text{ is large},\qquad
p\text{ is small},\qquad
np=\lambda.
$$

---

# 2. Multinomial Distribution

File: [`MultinomialDistribution.R`](MultinomialDistribution.R)

The binomial distribution applies when each trial has only two possible outcomes.

For example:

```text
mutation / no mutation

allele A / allele B

success / failure
```

But many biological variables have more than two possible outcomes.

For example, a nucleotide can be

```text
A
C
G
T
```

A genotype may have several categories, and a microbial sample may contain many different species.

The **multinomial distribution** extends the binomial distribution to more than two categories.

---

## Simple example: rolling a die

A fair six-sided die has six possible outcomes:

```text
1
2
3
4
5
6
```

For one roll,

$$
P(1)=P(2)=\cdots=P(6)=\frac{1}{6}.
$$

Suppose the die is rolled

$$
n=60
$$

times.

Let

$$
X_1,X_2,\ldots,X_6
$$

be the numbers of times that faces 1 through 6 occur.

Then

$$
(X_1,X_2,\ldots,X_6)
\sim
\mathrm{Multinomial}
\left(
60;
\frac16,\frac16,\frac16,\frac16,\frac16,\frac16
\right).
$$

The six counts must add to 60:

$$
X_1+X_2+\cdots+X_6=60.
$$

The expected count for each face is

$$
E[X_i]=np_i
=
60\times\frac16
=
10.
$$

This does **not** mean that every set of 60 rolls will give exactly 10 occurrences of each face. The observed counts vary because of random variation.

For example, one experiment might produce:

```text
Face      1   2   3   4   5   6
Count     8  11   9  12  10  10
```

The important idea is that each trial has **more than two possible categories**, and we record the count in each category.

---

## Multinomial model

Suppose each observation can fall into one of

$$
k
$$

categories with probabilities

$$
p_1,p_2,\ldots,p_k
$$

where

$$
p_1+p_2+\cdots+p_k=1.
$$

After

$$
n
$$

independent observations, let

$$
X_1,X_2,\ldots,X_k
$$

be the counts in the different categories.

Then

$$
(X_1,X_2,\ldots,X_k)
\sim
\mathrm{Multinomial}(n;p_1,p_2,\ldots,p_k).
$$

The counts must satisfy

$$
X_1+X_2+\cdots+X_k=n.
$$

---

## Example: DNA nucleotide counts

Suppose the nucleotide probabilities are

$$
P(A)=0.30,
$$

$$
P(C)=0.20,
$$

$$
P(G)=0.20,
$$

and

$$
P(T)=0.30.
$$

Thus,

$$
0.30+0.20+0.20+0.30=1.
$$

For a DNA sequence of length

$$
n=100,
$$

the expected counts are

$$
E[X_A]=100\times0.30=30,
$$

$$
E[X_C]=100\times0.20=20,
$$

$$
E[X_G]=100\times0.20=20,
$$

and

$$
E[X_T]=100\times0.30=30.
$$

These are expected values, not counts that must occur in every simulated sequence.

---

## Multinomial probability

For counts

$$
x_1,x_2,\ldots,x_k
$$

with

$$
x_1+x_2+\cdots+x_k=n,
$$

the multinomial probability is

$$
P(X_1=x_1,\ldots,X_k=x_k)
=
\frac{n!}{x_1!x_2!\cdots x_k!}
p_1^{x_1}p_2^{x_2}\cdots p_k^{x_k}.
$$

In R, `dmultinom()` calculates this probability.

For example, suppose that among 10 DNA bases we observe:

```text
A    3
C    2
G    2
T    3
```

Using the probabilities

$$
(0.30,0.20,0.20,0.30),
$$

the probability of obtaining exactly these counts is:

```r
dmultinom(
  x = c(3, 2, 2, 3),
  prob = c(0.30, 0.20, 0.20, 0.30)
)
```

This is the multinomial analogue of using `dbinom()` for the probability of an exact binomial count.

---

## Binomial as a special case

The multinomial distribution becomes a binomial distribution when there are only two categories.

For example,

$$
p_1=p
$$

and

$$
p_2=1-p.
$$

Then

$$
(X_1,X_2)
$$

contains the numbers of successes and failures, and knowing one count automatically determines the other.

Thus:

```text
2 categories     -> binomial

3 or more categories -> multinomial
```

---

# 3. Statistical Decisions and Errors

In Lecture 03, we used hypothesis testing to make a statistical decision.

The decision rule was:

$$
p\text{-value}<\alpha
\quad\Rightarrow\quad
\text{reject }H_0
$$

and

$$
p\text{-value}\ge\alpha
\quad\Rightarrow\quad
\text{do not reject }H_0.
$$

However, a statistical decision can be correct or incorrect.

There are two possible realities:

```text
H0 is true

H0 is false
```

and two possible decisions:

```text
reject H0

do not reject H0
```

This gives four possibilities.

| Reality | Decision | Result |
|---|---|---|
| $H_0$ true | Do not reject $H_0$ | Correct decision |
| $H_0$ true | Reject $H_0$ | Type I error |
| $H_0$ false | Do not reject $H_0$ | Type II error |
| $H_0$ false | Reject $H_0$ | Correct detection |

---

# 4. Type I Error and Alpha

File: [`Type1Error.R`](Type1Error.R)

A **Type I error** occurs when

$$
H_0
$$

is actually true but we reject it.

Thus,

$$
\boxed{
\text{Type I error}
=
\text{rejecting a true }H_0
}
$$

The probability of a Type I error is denoted by

$$
\alpha.
$$

Therefore,

$$
\boxed{
\alpha
=
P(\text{reject }H_0\mid H_0\text{ is true})
}
$$

This gives the significance level a direct interpretation.

This interpretation also helps explain how we choose $\alpha$.

Suppose that $H_0$ is actually true and that we could repeat the same experiment many times. We then ask:

> **Out of 100 such experiments, in how many are we willing to reject $H_0$ by mistake?**

If we choose

$$
\alpha=0.05,
$$

we are allowing a Type I error in about

$$
5\text{ out of }100
$$

repeated experiments when $H_0$ is true.

Similarly,

$$
\alpha=0.01
$$

means allowing a Type I error in about

$$
1\text{ out of }100
$$

such experiments.

Thus, choosing $\alpha$ means deciding how much risk of a false rejection we are willing to tolerate.

---

# 5. Type II Error

File: [`Type2Error.R`](Type2Error.R)

A **Type II error** occurs when

$$
H_0
$$

is false but we do not reject it.

Thus,

$$
\boxed{
\text{Type II error}
=
\text{failing to reject a false }H_0
}
$$

The probability of a Type II error is denoted by

$$
\beta.
$$

---

## Why $\beta$ is not fixed by $\alpha$

Before discussing $\beta$, recall how we defined the **rejection region** in Lecture 03.

In the EXACT trial, we tested

$$
H_0:p=0.40
$$

against

$$
H_A:p>0.40.
$$

There were

$$
n=55
$$

patients, and the significance level was

$$
\alpha=0.025.
$$

Under the null hypothesis,

$$
X\sim\mathrm{Binomial}(55,0.40).
$$

Because this was a right-tailed test, we needed to find a sufficiently large value of $X$ such that the probability of obtaining that value or something still larger under $H_0$ was no greater than $\alpha$.

For

$$
X\ge30,
$$

the probability under $H_0$ is

```r
1 - pbinom(
  29,
  size = 55,
  prob = 0.40
)
```

which gives approximately

$$
P(X\ge30\mid H_0)=0.0204.
$$

Since

$$
0.0204<0.025,
$$

$X\ge30$ could be used as the rejection region.

Why not use

$$
X\ge29?
$$

For this region,

```r
1 - pbinom(
  28,
  size = 55,
  prob = 0.40
)
```

gives approximately

$$
P(X\ge29\mid H_0)=0.0379.
$$

Since

$$
0.0379>0.025,
$$

using $X\ge29$ would make the probability of a Type I error larger than the chosen significance level.

Therefore, the critical value is

$$
\boxed{30}
$$

and the statistical decision rule is

```text
X >= 30    -> reject H0

X <= 29    -> do not reject H0
```

Thus, $\alpha$ is determined by probabilities calculated under the null model

$$
p=p_0=0.40.
$$

Now consider a **Type II error**.

A Type II error occurs when $H_0$ is false but the observation still falls in the do-not-reject region,

$$
X\le29.
$$

To calculate the probability of this happening, however, we must specify what the true value of $p$ is when $H_0$ is false.

For example, suppose the true probability of benefit is

$$
p=0.50.
$$

Then

$$
X\sim\mathrm{Binomial}(55,0.50),
$$

and the Type II error probability is

$$
\beta
=
P(X\le29\mid p=0.50).
$$

In R:

```r
pbinom(
  29,
  size = 55,
  prob = 0.50
)
```

If instead the true probability is

$$
p=0.60,
$$

then

$$
\beta
=
P(X\le29\mid p=0.60),
$$

which is calculated using

```r
pbinom(
  29,
  size = 55,
  prob = 0.60
)
```

If the true probability is even larger, for example

$$
p=0.70,
$$

then

```r
pbinom(
  29,
  size = 55,
  prob = 0.70
)
```

gives an even smaller probability of remaining in the do-not-reject region.

The reason is:

```text
true p close to p0 = 0.40
        -> alternative distribution overlaps strongly with H0
        -> often X <= 29
        -> larger beta

true p farther above p0 = 0.40
        -> observations tend to be larger
        -> more often X >= 30
        -> smaller beta
```

Therefore, unlike $\alpha$, there is **not one value of $\beta$ determined only by the test**.

Instead,

$$
\boxed{
\beta
=
P(\text{do not reject }H_0
\mid
\text{a particular alternative is true})
}
$$

The value of $\beta$ therefore depends on the particular true value of $p$ that we consider.

---

# 6. Statistical Power

File: [`PowerBinomial.R`](PowerBinomial.R)

Statistical **power** is the probability of correctly rejecting the null hypothesis when a specified alternative is true.

Because

$$
\beta
$$

is the probability of failing to reject a false null hypothesis,

$$
\boxed{
\mathrm{Power}=1-\beta
}
$$

Equivalently,

$$
\boxed{
\mathrm{Power}
=
P(\text{reject }H_0\mid \text{a particular alternative is true})
}
$$

---

## Example using the EXACT trial

Continue with the EXACT trial.

We tested

$$
H_0:p=0.40
$$

against

$$
H_A:p>0.40,
$$

with

$$
n=55
$$

and

$$
\alpha=0.025.
$$

The rejection region was

$$
X\ge30.
$$

Therefore:

```text
X >= 30    -> reject H0

X <= 29    -> do not reject H0
```

Now suppose that the null hypothesis is false and that the true probability of benefit is

$$
p=0.60.
$$

Then

$$
X\sim\mathrm{Binomial}(55,0.60).
$$

The Type II error probability is

$$
\beta
=
P(X\le29\mid p=0.60).
$$

In R:

```r
beta <- pbinom(
  29,
  size = 55,
  prob = 0.60
)

beta
```

Power is the probability of entering the rejection region when this alternative is true:

$$
\mathrm{Power}
=
P(X\ge30\mid p=0.60).
$$

In R:

```r
power <- pbinom(
  29,
  size = 55,
  prob = 0.60,
  lower.tail = FALSE
)

power
```

or equivalently:

```r
power <- 1 - beta
```

Thus,

$$
\boxed{
\beta+\mathrm{Power}=1
}
$$

for the same specified alternative.

---

## Power depends on the true alternative

Just as $\beta$ depends on the true value of $p$, power also depends on the true value of $p$.

For example:

```r
# Power if the true probability is 0.50
pbinom(
  29,
  size = 55,
  prob = 0.50,
  lower.tail = FALSE
)

# Power if the true probability is 0.60
pbinom(
  29,
  size = 55,
  prob = 0.60,
  lower.tail = FALSE
)

# Power if the true probability is 0.70
pbinom(
  29,
  size = 55,
  prob = 0.70,
  lower.tail = FALSE
)
```

If the true probability is close to

$$
p_0=0.40,
$$

the alternative distribution overlaps strongly with the null distribution, so it is difficult to reach the rejection region.

Therefore, power is relatively low.

If the true probability is much larger than

$$
0.40,
$$

larger values of $X$ become more common and the probability of reaching

$$
X\ge30
$$

increases.

Therefore:

```text
true p close to p0
        -> harder to distinguish from H0
        -> larger beta
        -> lower power

true p farther from p0
        -> easier to distinguish from H0
        -> smaller beta
        -> higher power
```

---

## Power curve

Power can be calculated over a range of possible true values of $p$.

```r
p_true <- seq(
  0.40,
  0.80,
  by = 0.01
)

power <- pbinom(
  29,
  size = 55,
  prob = p_true,
  lower.tail = FALSE
)
```

Plot:

```r
plot(
  p_true,
  power,
  type = "l",
  lwd = 2,
  xlab = "True probability of benefit, p",
  ylab = "Power",
  ylim = c(0, 1),
  main = "Power Curve for the EXACT Trial"
)
```

At

$$
p=0.40,
$$

we are back at the null model.

The probability of rejection is then

$$
P(X\ge30\mid p=0.40)
\approx0.0204,
$$

which is the actual Type I error probability for this discrete rejection region.

As the true value of $p$ increases above 0.40, the power increases.

---

# 7. What Determines Power?

Several factors influence statistical power.

---

## 1. Effect size

For the EXACT trial, the null hypothesis is

$$
H_0:p=0.40.
$$

Suppose the true probability is

$$
p=0.45.
$$

This value is close to the null value, so the distributions under

$$
p=0.40
$$

and

$$
p=0.45
$$

overlap strongly.

It is therefore difficult to distinguish the alternative from the null model.

Now suppose the true probability is

$$
p=0.70.
$$

This is much farther from the null value.

Large values of $X$ are then much more common, making it easier to enter the rejection region

$$
X\ge30.
$$

Therefore:

$$
\boxed{
\text{larger effect size}
\Rightarrow
\text{higher power}
}
$$

Here, the effect size can be thought of simply as how far the true value of $p$ is from the null value

$$
p_0=0.40.
$$

---

## 2. Sample size

The EXACT trial used

$$
n=55
$$

patients.

Suppose we want to detect the same difference between

$$
p_0=0.40
$$

and a true value such as

$$
p=0.60.
$$

With a small sample, random variation is relatively large, so the null and alternative distributions overlap more strongly.

With a larger sample, the observed proportion tends to be more tightly concentrated around the true value of $p$.

The null and alternative distributions therefore become easier to distinguish.

Thus:

$$
\boxed{
\text{larger }n
\Rightarrow
\text{higher power}
}
$$

This is one reason why sample size is an important part of study design.

---

## 3. Significance level

In the EXACT trial,

$$
\alpha=0.025.
$$

The rejection region was chosen so that the probability of a Type I error under

$$
H_0:p=0.40
$$

was no greater than this level.

If we choose a smaller value of $\alpha$, we require stronger evidence before rejecting $H_0$.

The rejection region therefore moves farther into the tail of the null distribution.

This reduces the probability of a Type I error, but it also makes it harder to reject $H_0$ when an alternative is actually true.

Therefore, holding the sample size and true effect fixed:

$$
\boxed{
\text{smaller }\alpha
\Rightarrow
\text{smaller Type I error probability}
}
$$

but generally also

$$
\boxed{
\text{smaller }\alpha
\Rightarrow
\text{lower power}
}
$$

Conversely, a larger $\alpha$ makes rejection easier and generally increases power, but at the cost of a higher probability of Type I error.

Thus, choosing $\alpha$ involves a balance between:

```text
avoiding false rejection of H0
```

and

```text
having enough power to detect a real effect
```

---

# 8. Connecting $\alpha$, $\beta$, and Power

The EXACT trial now gives one consistent example of all three quantities.

Under the null hypothesis,

$$
H_0:p=0.40,
$$

with rejection region

$$
X\ge30,
$$

the Type I error probability is

$$
P(X\ge30\mid p=0.40)
\approx0.0204.
$$

For a particular alternative, for example

$$
p=0.60,
$$

the Type II error probability is

$$
\beta
=
P(X\le29\mid p=0.60),
$$

and the power is

$$
1-\beta
=
P(X\ge30\mid p=0.60).
$$

So the same critical value divides the possible observations into two regions:

```text
                     critical value
                          30
                           |
                           v

X <= 29                    |      X >= 30
do not reject H0           |      reject H0
---------------------------|---------------------------->
```

What the two regions mean depends on which model is actually true.

If

$$
p=0.40,
$$

then falling in

$$
X\ge30
$$

is a Type I error.

If instead

$$
p=0.60,
$$

then falling in

$$
X\le29
$$

is a Type II error, while falling in

$$
X\ge30
$$

is a correct detection.

Thus:

$$
\boxed{
\alpha
=
P(\text{reject }H_0\mid H_0\text{ is true})
}
$$

$$
\boxed{
\beta
=
P(\text{do not reject }H_0\mid \text{a particular alternative is true})
}
$$

and

$$
\boxed{
\mathrm{Power}=1-\beta
}
$$

The critical value is fixed by the test design, but the values of $\beta$ and power change depending on which alternative value of $p$ is considered.

---
