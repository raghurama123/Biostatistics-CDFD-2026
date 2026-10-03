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

# Lecture 04 — Central Limit Theorem, Z-Tests, Errors, and Statistical Power

This lecture develops hypothesis testing for a population mean using the normal distribution.

We begin with the **Central Limit Theorem**, which explains why the sample mean has an approximately normal sampling distribution. We then use this result to construct a **one-sample Z-test**, define rejection regions and p-values, and examine the possible errors that can arise from a statistical decision.

[1. Central Limit Theorem](#1-central-limit-theorem)  
[2. Standardizing the Sample Mean](#2-standardizing-the-sample-mean)  
[3. Critical Values and Confidence Intervals](#3-critical-values-and-confidence-intervals)  
[4. Estimating Sample Size for a Fixed Confidence Interval](#4-estimating-sample-size-for-a-fixed-confidence-interval)  
[5. One-Sample Z-Test](#5-one-sample-z-test)  
[6. Statistical Decisions: TP, TN, FP, and FN](#6-statistical-decisions-tp-tn-fp-and-fn)  
[7. Type I Error and Alpha](#7-type-i-error-and-alpha)  
[8. Type II Error and Beta](#8-type-ii-error-and-beta)  
[9. Statistical Power](#9-statistical-power)  
[10. What Determines Power?](#10-what-determines-power)  

---

> **Coding instructions for this lecture**
>
> Create a separate folder for this lecture, for example:
>
> ```text
> Lec04_R/
> ```
>
> Inside this folder, create a separate R script for each section or example, such as:
>
> ```text
> 01_CLT.R
> 02_StandardNormal.R
> 03_ConfidenceIntervals.R
> 04_SampleSize.R
> 05_ZTest.R
> 06_TypeI_TypeII.R
> 07_Power.R
> ```
>

---

# 1. Central Limit Theorem

Suppose a population has mean

$$
\mu
$$

and standard deviation

$$
\sigma.
$$

If we repeatedly take random samples of size

$$
n
$$

and calculate the mean of each sample,

$$
\bar X,
$$

the sample means form a **sampling distribution**.

The Central Limit Theorem tells us that, for a sufficiently large sample size,

$$
\boxed{
\bar X
\approx
N\left(
\mu,
\frac{\sigma}{\sqrt n}
\right)
}
$$

even when the original population itself is not normally distributed.

More precisely,

$$
E[\bar X]=\mu
$$

and

$$
\mathrm{SD}(\bar X)
=
\frac{\sigma}{\sqrt n}.
$$

The quantity

$$
\boxed{
\frac{\sigma}{\sqrt n}
}
$$

is called the **standard error of the mean**.

---

## Population distribution and sampling distribution are different

The population describes the values of individual observations.

For example, individual body lengths in a bird population may have

$$
\mu=47\text{ cm}
$$

and

$$
\sigma=12\text{ cm}.
$$

The sampling distribution describes the means obtained from repeated samples.

For samples of size $n$,

$$
\bar X
\approx
N\left(
47,
\frac{12}{\sqrt n}
\right).
$$

The center remains

$$
47,
$$

but the standard deviation of the sample mean is smaller than the standard deviation of individual birds.

```text
Individual observations:

mean = mu
SD   = sigma

Sample means:

mean = mu
SD   = sigma / sqrt(n)
```

As $n$ increases,

$$
\frac{\sigma}{\sqrt n}
$$

decreases.

Therefore, sample means become more tightly concentrated around the population mean.

---

## If the population is already normal

If the population itself is normally distributed, then the sampling distribution of $\bar X$ is normal for **any** sample size:

$$
\bar X
\sim
N\left(
\mu,
\frac{\sigma}{\sqrt n}
\right).
$$

If the population is not normal, the Central Limit Theorem gives an approximately normal sampling distribution when $n$ is sufficiently large.

A commonly used rule of thumb is that

$$
n\ge30
$$

is often large enough, although the required sample size depends on the shape of the population distribution.

---

## Example: mean length of birds

Suppose a bird population has

$$
\mu=47\text{ cm}
$$

and

$$
\sigma=12\text{ cm}.
$$

We take samples of

$$
n=9
$$

birds.

The standard error of the sample mean is

$$
\mathrm{SE}
=
\frac{12}{\sqrt9}
=
4.
$$

What is the probability that the sample mean is greater than 50 cm?

We standardize:

$$
Z
=
\frac{\bar X-\mu}
{\sigma/\sqrt n}
=
\frac{50-47}{4}
=
0.75.
$$

Therefore,

$$
P(\bar X>50)
=
P(Z>0.75).
$$

In R:

```r
pnorm(
  0.75,
  lower.tail = FALSE
)
```

which gives approximately

$$
0.2266.
$$

So about 22.7% of samples of size 9 would have a sample mean greater than 50 cm.

---

## What happens if the sample size increases?

Now suppose

$$
n=25.
$$

Then

$$
\mathrm{SE}
=
\frac{12}{\sqrt{25}}
=
2.4.
$$

The corresponding Z value is

$$
Z
=
\frac{50-47}{2.4}
=
1.25.
$$

Therefore,

```r
pnorm(
  1.25,
  lower.tail = FALSE
)
```

gives approximately

$$
0.1056.
$$

Thus:

```text
n = 9     -> SE = 4.0     -> P(Xbar > 50) ≈ 0.227

n = 25    -> SE = 2.4     -> P(Xbar > 50) ≈ 0.106
```

As the sample size increases, the sampling distribution becomes narrower.

This is an important reason why larger samples provide more precise estimates of a population mean.

---

# 2. Standardizing the Sample Mean

For a normally distributed variable,

$$
X\sim N(\mu,\sigma),
$$

an individual observation can be standardized using

$$
Z
=
\frac{X-\mu}{\sigma}.
$$

This converts the observation into units of standard deviation.

For a **sample mean**, however, the relevant standard deviation is the standard error:

$$
\frac{\sigma}{\sqrt n}.
$$

Therefore,

$$
\boxed{
Z
=
\frac{\bar X-\mu}
{\sigma/\sqrt n}
}
$$

for probabilities involving a sample mean.

---

## Standard normal distribution

The standardized variable follows the standard normal distribution:

$$
Z\sim N(0,1).
$$

Its probability density function is

$$
\phi(z)
=
\frac{1}{\sqrt{2\pi}}
\exp\left(
-\frac{z^2}{2}
\right).
$$

The standard normal distribution has

$$
\text{mean}=0
$$

and

$$
\text{standard deviation}=1.
$$

Some useful central areas are approximately:

| Range | Probability |
|---|---:|
| $-1\le Z\le1$ | 0.6827 |
| $-1.645\le Z\le1.645$ | 0.9000 |
| $-1.96\le Z\le1.96$ | 0.9500 |
| $-2.576\le Z\le2.576$ | 0.9900 |
| $-3\le Z\le3$ | 0.9973 |

Critical Z values can be obtained using `qnorm()`.

For example:

```r
# 95th percentile
qnorm(0.95)

# 97.5th percentile
qnorm(0.975)

# 99.5th percentile
qnorm(0.995)
```

Recall, that `qnorm(p)` always uses the left-tail cumulative probability \(p\) by default

For confidence intervals and two-tailed tests, it is often more convenient to calculate the critical Z value directly from the significance level $\alpha$:

```r
qnorm(1 - alpha / 2)
```

## Getting the central areas in R

For a symmetric interval

$$
-a \le Z \le a,
$$

the probability is

$$
P(-a \le Z \le a)
=
P(Z\le a)-P(Z\le -a).
$$

In R:

```r
# P(-1 <= Z <= 1)
pnorm(1) - pnorm(-1)
# 0.6827

# P(-1.96 <= Z <= 1.96)
pnorm(1.96) - pnorm(-1.96)
# 0.9500

# P(-2.576 <= Z <= 2.576)
pnorm(2.576) - pnorm(-2.576)
# approximately 0.9900
```

---

# 3. Critical Values and Confidence Intervals

The standard normal distribution allows us to identify regions containing a specified probability.

For example, approximately 95% of the standard normal distribution lies between

$$
-1.96
$$

and

$$
+1.96.
$$

Therefore,

$$
P(-1.96\le Z\le1.96)
\approx0.95.
$$

For the sample mean,

$$
Z
=
\frac{\bar X-\mu}
{\sigma/\sqrt n}.
$$

Thus,

$$
P\left(
-1.96
\le
\frac{\bar X-\mu}
{\sigma/\sqrt n}
\le
1.96
\right)
\approx0.95.
$$

Rearranging gives the 95% confidence interval for the population mean:

$$
\boxed{
\bar X
\pm
1.96
\frac{\sigma}{\sqrt n}
}
$$

when $\sigma$ is known.

More generally, a two-sided

$$
100(1-\alpha)\%
$$

confidence interval is

$$
\boxed{
\bar X
\pm
z_{1-\alpha/2}
\frac{\sigma}{\sqrt n}
}
$$

where

$$
z_{1-\alpha/2}
$$

is the corresponding standard normal critical value.

## Confidence interval in R

Suppose

$$
\bar X=1.29,\qquad
\sigma=3.669,\qquad
n=17,
$$

and we want a 95% confidence interval.

```r
# Sample mean
xbar <- 1.29

# Known population standard deviation
sigma <- 3.669

# Sample size
n <- 17

# Significance level
alpha <- 0.05

# Standard error
se <- sigma / sqrt(n)

# Critical Z value
zcrit <- qnorm(1 - alpha / 2)

# Margin of error
margin <- zcrit * se

# Confidence interval
lower <- xbar - margin
upper <- xbar + margin

se
zcrit
lower
upper
```

---

## Common critical values

For

$$
\alpha=0.05,
$$

a two-sided 95% interval uses

$$
z_{1-\alpha/2}
=
z_{0.975}
\approx1.96.
$$

For

$$
\alpha=0.01,
$$

a two-sided 99% interval uses

$$
z_{0.995}
\approx2.576.
$$

For a one-sided test with

$$
\alpha=0.05,
$$

the critical value is

$$
z_{0.95}
\approx1.645.
$$

Thus:

```text
right-tailed, alpha = 0.05:
    reject in Z >= 1.645

left-tailed, alpha = 0.05:
    reject in Z <= -1.645

two-tailed, alpha = 0.05:
    reject in Z <= -1.96 or Z >= 1.96
```

These critical regions lead directly to hypothesis testing.

---

## Example: confidence interval for mean weight change

Suppose a study measures change in body weight after a treatment.

Assume:

$$
\bar X=1.29\text{ kg},
$$

$$
n=17,
$$

and the known population variance is

$$
\sigma^2=13.4621\text{ kg}^2.
$$

Then

$$
\sigma
=
\sqrt{13.4621}
\approx3.669\text{ kg}.
$$

The standard error is

$$
\mathrm{SE}
=
\frac{3.669}{\sqrt{17}}
\approx0.890\text{ kg}.
$$

The 95% confidence interval is

$$
1.29
\pm
1.96(0.890),
$$

which is approximately

$$
\boxed{
[-0.45,\;3.03]\text{ kg}
}
$$

The 99% confidence interval is

$$
1.29
\pm
2.576(0.890),
$$

which is approximately

$$
\boxed{
[-1.00,\;3.58]\text{ kg}
}
$$

Notice that the 99% confidence interval is wider than the 95% confidence interval.

Greater confidence requires a wider interval.

---

# 4. Estimating Sample Size for a Fixed Confidence Interval

A confidence interval becomes narrower as the sample size increases.

For a population mean with known population standard deviation $\sigma$, a two-sided

$$
100(1-\alpha)\%
$$

confidence interval is

$$
\bar X
\pm
z_{1-\alpha/2}
\frac{\sigma}{\sqrt n}.
$$

The quantity

$$
z_{1-\alpha/2}
\frac{\sigma}{\sqrt n}
$$

is the **margin of error**, or the **half-width** of the confidence interval.

Suppose we want the confidence interval to have a specified margin of error

$$
d.
$$

Then we require

$$
d
=
z_{1-\alpha/2}
\frac{\sigma}{\sqrt n}.
$$

Solving for $n$,

$$
\sqrt n
=
\frac{z_{1-\alpha/2}\sigma}{d},
$$

so

$$
\boxed{
n
=
\left(
\frac{z_{1-\alpha/2}\sigma}{d}
\right)^2
}
$$

Because the sample size must be an integer, we **round up** to the next whole number.

Thus, before collecting the data, we can choose a desired confidence level and a desired precision, and then estimate how many observations are required.

---

## Example

Suppose we want to estimate the mean weight of a rare variety of grain.

From a previous study, assume that the population standard deviation is approximately

$$
\sigma=0.020\text{ g}.
$$

We want a 95% confidence interval with margin of error

$$
d=0.005\text{ g}.
$$

For a 95% confidence interval,

$$
\alpha=0.05
$$

and

$$
z_{1-\alpha/2}
=
z_{0.975}
\approx1.96.
$$

Therefore,

$$
n
=
\left(
\frac{1.96(0.020)}{0.005}
\right)^2
\approx61.47.
$$

We round up:

$$
\boxed{n=62}
$$

So at least 62 observations are required to obtain a 95% confidence interval with a margin of error of approximately 0.005 g, assuming $\sigma=0.020$ g.

Using the rough approximation

$$
z_{0.975}\approx2,
$$

we obtain

$$
n
\approx
\left(
\frac{2(0.020)}{0.005}
\right)^2
=64.
$$

This reproduces the convenient approximate result of about 64 observations.

---

## A narrower confidence interval requires a much larger sample

Suppose instead that we want the margin of error to be only

$$
d=0.001\text{ g}.
$$

Then

$$
n
=
\left(
\frac{1.96(0.020)}{0.001}
\right)^2
\approx1536.64.
$$

Therefore,

$$
\boxed{n=1537}
$$

observations are required.

Using the rough approximation $z\approx2$ gives

$$
n
\approx
\left(
\frac{2(0.020)}{0.001}
\right)^2
=1600.
$$

This illustrates an important point:

$$
\boxed{
\text{smaller margin of error}
\Rightarrow
\text{much larger sample size}
}
$$

Because

$$
n\propto\frac{1}{d^2},
$$

cutting the margin of error in half requires approximately four times as many observations.

---

## Calculation in R

```r
# Desired confidence level
alpha <- 0.05

# Known population standard deviation
sigma <- 0.020

# Desired margin of error
d <- 0.005

# Critical z value
zcrit <- qnorm(
  1 - alpha / 2
)

# Required sample size
n <- ceiling(
  (zcrit * sigma / d)^2
)

zcrit
n
```

For

$$
d=0.001,
$$

use:

```r
d <- 0.001

n <- ceiling(
  (zcrit * sigma / d)^2
)

n
```

---

## What if $\sigma$ is not known?

In practice, the population standard deviation

$$
\sigma
$$

is usually not known before the study begins.

A common approach is to conduct a **pilot study** and use its sample standard deviation

$$
s
$$

as an estimate of $\sigma$.

We can then obtain an initial sample-size estimate using

$$
\boxed{
n
\approx
\left(
\frac{z_{1-\alpha/2}s}{d}
\right)^2
}
$$

For example:

```r
alpha <- 0.05
s <- 0.020
d <- 0.005

zcrit <- qnorm(
  1 - alpha / 2
)

n0 <- ceiling(
  (zcrit * s / d)^2
)

n0
```

This provides a practical starting value for planning the study.

The important planning idea is:

```text
Choose the desired confidence level
        |
        v
Choose the desired margin of error d
        |
        v
Use prior information or a pilot study to estimate variability
        |
        v
Calculate the required sample size
```

> **When $\sigma$ is unknown:**  
> For inference about a population mean, we usually use the **t distribution** instead of the standard normal distribution.  
> Thus, a **t-test** can be used in place of a Z-test, with the sample standard deviation $s$ replacing the unknown population standard deviation $\sigma$.
>
> $$
> T=
> \frac{\bar X-\mu_0}
> {s/\sqrt n}
> $$
>
> For a one-sample t-test, the degrees of freedom are
>
> $$
> df=n-1.
> $$

---

# 5. One-Sample Z-Test

The same normal distribution can be used to test a hypothesis about a population mean.

For the one-sample Z-test considered here, we assume that the population standard deviation

$$
\sigma
$$

is known.

Suppose we want to test

$$
H_0:\mu=\mu_0.
$$

The Z statistic is

$$
\boxed{
Z
=
\frac{\bar X-\mu_0}
{\sigma/\sqrt n}
}
$$

Under the null hypothesis,

$$
Z\sim N(0,1).
$$

The observed value of $Z$ tells us how far the sample mean lies from the null value $\mu_0$, measured in standard errors.

---

## Three forms of the alternative hypothesis

### Two-tailed test

Use when departures in either direction are scientifically relevant:

$$
H_0:\mu=\mu_0
$$

$$
H_A:\mu\ne\mu_0.
$$

For

$$
\alpha=0.05,
$$

reject $H_0$ when

$$
|Z|\ge1.96.
$$

---

### Right-tailed test

Use when only values larger than $\mu_0$ provide evidence for the alternative:

$$
H_0:\mu=\mu_0
$$

$$
H_A:\mu>\mu_0.
$$

For

$$
\alpha=0.05,
$$

reject $H_0$ when

$$
Z\ge1.645.
$$

---

### Left-tailed test

Use when only values smaller than $\mu_0$ provide evidence for the alternative:

$$
H_0:\mu=\mu_0
$$

$$
H_A:\mu<\mu_0.
$$

For

$$
\alpha=0.05,
$$

reject $H_0$ when

$$
Z\le-1.645.
$$

---

## Critical-region approach and p-value approach

There are two equivalent ways to make the statistical decision.

### Critical-region approach

Calculate $Z$ and ask whether it lies in the rejection region.

For example, in a two-tailed test with

$$
\alpha=0.05,
$$

reject $H_0$ if

$$
|Z|\ge1.96.
$$

### p-value approach

Calculate the probability of obtaining the observed result, or something more extreme, assuming $H_0$ is true.

Then:

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

---

## Example: testing mean weight change

Continue with the weight-change example:

$$
\bar X=1.29\text{ kg},
$$

$$
\sigma=3.669\text{ kg},
$$

and

$$
n=17.
$$

Suppose the null hypothesis is

$$
H_0:\mu=0,
$$

meaning that the population mean weight change is zero.

For a two-tailed test,

$$
H_A:\mu\ne0.
$$

The standard error is

$$
\frac{3.669}{\sqrt{17}}
\approx0.890.
$$

Therefore,

$$
Z
=
\frac{1.29-0}{0.890}
\approx1.45.
$$

The two-tailed p-value is

$$
2P(Z\ge1.45).
$$

In R:

```r
z <- 1.29 / 0.890

p_value <- 2 * pnorm(
  -abs(z)
)

z
p_value
```

This gives approximately

$$
p=0.147.
$$

At

$$
\alpha=0.05,
$$

we therefore **do not reject**

$$
H_0.
$$

There is not enough evidence to conclude that the population mean weight change differs from zero.

This is consistent with the 95% confidence interval

$$
[-0.45,\;3.03],
$$

which contains the null value

$$
0.
$$

---

## The same test in R from the summary statistics

```r
xbar <- 1.29
mu0 <- 0
sigma <- sqrt(13.4621)
n <- 17

se <- sigma / sqrt(n)

z <- (xbar - mu0) / se

p_two <- 2 * pnorm(
  -abs(z)
)

se
z
p_two
```

For a right-tailed alternative:

```r
p_right <- pnorm(
  z,
  lower.tail = FALSE
)
```

For a left-tailed alternative:

```r
p_left <- pnorm(z)
```

---

# 6. Statistical Decisions: TP, TN, FP, and FN

A hypothesis test produces one of two decisions:

```text
reject H0

do not reject H0
```

But in reality, there are also two possibilities:

```text
H0 is true

H0 is false
```

Combining these gives four possible outcomes.

In the language of **true positives, false positives, true negatives, and false negatives**, we treat the effect described by the alternative hypothesis $H_A$ as the **positive** condition.

For example, consider a right-tailed test:

$$
H_0:\mu\le\mu_0
$$

and

$$
H_A:\mu>\mu_0.
$$

then:

- **positive** means that the effect described by $H_A$ is truly present, i.e. $\mu>\mu_0$;
- **negative** means that this effect is not present, corresponding to $H_0$ being true.

The statistical test then tells us whether there is enough evidence to support $H_A$.

| Reality | Decision about $H_0$ | Conclusion about $H_A$ | Outcome |
|---|---|---|---|
| $H_0$ true; effect in $H_A$ absent | Do not reject $H_0$ | Not enough evidence for $H_A$ | True negative (TN) |
| $H_0$ true; effect in $H_A$ absent | Reject $H_0$ | Evidence in favor of $H_A$ | False positive (FP) = Type I error |
| $H_A$ true; effect is present | Do not reject $H_0$ | Not enough evidence for $H_A$ | False negative (FN) = Type II error |
| $H_A$ true; effect is present | Reject $H_0$ | Evidence in favor of $H_A$ | True positive (TP) |

The true-positive / false-positive terminology is especially common in diagnostic testing and classification. In hypothesis testing, the more standard terms are **Type I error**, **Type II error**, and **power**.

---

# 7. Type I Error and Alpha

A **Type I error** occurs when

$$
H_0
$$

is actually true, but we reject it.

Thus,

$$
\boxed{
\text{Type I error}
=
\text{false positive}
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
P(\text{reject }H_0
\mid
H_0\text{ is true})
}
$$

---

## Why $\alpha$ defines the rejection region

Suppose we use a right-tailed Z-test with

$$
\alpha=0.05.
$$

Under $H_0$,

$$
Z\sim N(0,1).
$$

We choose the critical value so that only 5% of the null distribution lies above it.

Thus,

$$
P(Z\ge1.645\mid H_0)=0.05.
$$

The rejection region is therefore

$$
Z\ge1.645.
$$

If $H_0$ is actually true, about 5% of repeated experiments will nevertheless fall in this rejection region.

That is the Type I error rate.

---

## Repeated-sampling interpretation

Suppose $H_0$ is actually true and we could repeat the same experiment 100 times.

If

$$
\alpha=0.05,
$$

then we are willing to tolerate about

$$
5\text{ false rejections out of 100 experiments}.
$$

Similarly,

$$
\alpha=0.01
$$

corresponds to about

$$
1\text{ false rejection out of 100 experiments}.
$$

Thus, choosing $\alpha$ means deciding how much risk of a false-positive conclusion we are willing to tolerate.

---

# 8. Type II Error and Beta

A **Type II error** occurs when

$$
H_0
$$

is false, but we do not reject it.

Thus,

$$
\boxed{
\text{Type II error}
=
\text{false negative}
=
\text{failing to reject a false }H_0
}
$$

The probability of a Type II error is denoted by

$$
\beta.
$$

Therefore,

$$
\boxed{
\beta
=
P(\text{do not reject }H_0
\mid
\text{a particular alternative is true})
}
$$

The phrase **a particular alternative** is important.

Unlike $\alpha$, $\beta$ cannot be calculated merely by saying that $H_0$ is false.

We must specify what the true population mean actually is.

---

## Example using a right-tailed Z-test

Suppose we test

$$
H_0:\mu=0
$$

against

$$
H_A:\mu>0.
$$

Assume

$$
\sigma=3.669,
$$

$$
n=17,
$$

and

$$
\alpha=0.05.
$$

The standard error is

$$
\mathrm{SE}
=
\frac{3.669}{\sqrt{17}}
\approx0.890.
$$

For a right-tailed test,

$$
z_{\text{critical}}
=
1.645.
$$

Therefore, the critical sample mean is

$$
\bar X_{\text{critical}}
=
0
+
1.645(0.890)
\approx1.464.
$$

Our decision rule is therefore approximately:

Xbar >= 1.464     -> reject H0

Xbar < 1.464      -> do not reject H0

---

## Suppose the true mean is 2 kg

Now suppose $H_0$ is false and the true population mean is actually

$$
\mu=2\text{ kg}.
$$

A Type II error occurs if the sample mean nevertheless falls below the critical value:

$$
\bar X<1.464.
$$

Under the alternative,

$$
\bar X
\sim
N\left(
2,
0.890
\right).
$$

Therefore,

$$
\beta
=
P(\bar X<1.464\mid\mu=2).
$$

Standardizing relative to the alternative distribution:

$$
Z
=
\frac{1.464-2}{0.890}
\approx-0.60.
$$

Thus,

```r
beta <- pnorm(-0.60)

beta
```

which is approximately

$$
\boxed{
\beta\approx0.27
}
$$

So if the true mean were 2 kg, this test would fail to reject $H_0$ in about 27% of repeated experiments.

---

# 9. Statistical Power

Statistical **power** is the probability of correctly rejecting the null hypothesis when a specified alternative is true.

In the previous example,

$$
\beta
$$

is the probability of a false negative.

Therefore,

$$
\boxed{
\mathrm{Power}
=
1-\beta
}
$$

or equivalently,

$$
\boxed{
\mathrm{Power}
=
P(\text{reject }H_0
\mid
\text{a particular alternative is true})
}
$$

For the example with

$$
\mu=2,
$$

we found approximately

$$
\beta=0.27.
$$

Therefore,

$$
\mathrm{Power}
=
1-0.27
=
0.73.
$$

So the test has about

$$
73\%
$$

power to detect a true population mean of 2 kg under this particular design.

---

## The four probabilities

The four possible outcomes can now be connected directly with $\alpha$, $\beta$, and power.

| Reality | Decision | Outcome | Probability |
|---|---|---|---:|
| $H_0$ true | Reject $H_0$ | False positive / Type I error | $\alpha$ |
| $H_0$ true | Do not reject $H_0$ | True negative | $1-\alpha$ |
| Particular $H_A$ true | Do not reject $H_0$ | False negative / Type II error | $\beta$ |
| Particular $H_A$ true | Reject $H_0$ | True positive | $1-\beta$ |

Thus,

$$
\boxed{
\text{true-positive probability}
=
\text{power}
=
1-\beta
}
$$

and, for a fixed continuous Z-test,

$$
\boxed{
\text{true-negative probability}
=
1-\alpha.
}
$$

---

# 10. What Determines Power?

Power is not a fixed property of a statistical test alone.

It depends on the true effect and on the design of the experiment.

---

## 1. Effect size

Suppose

$$
H_0:\mu=0.
$$

If the true mean is only slightly different from zero, for example

$$
\mu=0.2,
$$

the null and alternative sampling distributions overlap strongly.

It is therefore difficult to distinguish the alternative from $H_0$.

If the true mean is much farther away, for example

$$
\mu=2,
$$

the distributions overlap less.

Therefore:

$$
\boxed{
\text{larger effect}
\Rightarrow
\text{higher power}
}
$$

---

## 2. Sample size

The standard error is

$$
\frac{\sigma}{\sqrt n}.
$$

As $n$ increases, the standard error decreases.

The sampling distributions become narrower, making different population means easier to distinguish.

Therefore:

$$
\boxed{
\text{larger }n
\Rightarrow
\text{smaller standard error}
\Rightarrow
\text{higher power}
}
$$

This is the same phenomenon seen earlier in the bird-length example.

---

## 3. Population variability

For fixed $n$,

$$
\mathrm{SE}
=
\frac{\sigma}{\sqrt n}.
$$

A larger population standard deviation produces a larger standard error and greater overlap between the null and alternative distributions.

Therefore:

$$
\boxed{
\text{larger }\sigma
\Rightarrow
\text{lower power}
}
$$

Precise measurements and well-controlled experiments can therefore improve power.

---

## 4. Significance level

If we reduce

$$
\alpha,
$$

the rejection region moves farther into the tail of the null distribution.

This reduces false positives, but it also makes rejecting $H_0$ more difficult.

For fixed sample size and effect size:

$$
\boxed{
\alpha\downarrow
\quad\Rightarrow\quad
\beta\uparrow
\quad\Rightarrow\quad
\text{power}\downarrow
}
$$

In contrast, increasing $\alpha$ generally increases power but also increases the probability of a Type I error.

This is an important trade-off in study design.

---

