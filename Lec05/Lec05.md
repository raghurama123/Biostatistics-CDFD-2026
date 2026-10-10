<table style="width:100%; border:none;">
<tr>

<td style="width:33%; text-align:left; border:none;">
<a href="../Lec04/Lec04.html"><strong>← Previous Lecture</strong></a>
</td>

<td style="width:34%; text-align:center; border:none;">
<a href="../"><strong>Home</strong></a>
</td>

<td style="width:33%; text-align:right; border:none;">
<a href="../Lec06/Lec06.html"><strong>Next Lecture →</strong></a>
</td>

</tr>
</table>



# Lecture 05 — Statistical Tests for Means, Variances, and Categorical Data


## Contents

1. [Recap: Z-test for a population mean](#1-recap-z-test-for-a-population-mean)
2. [Student's t-distribution](#2-students-t-distribution)
3. [One-sample t-test](#3-one-sample-t-test)
4. [Two-sample t-tests](#4-two-sample-t-tests)
5. [One-way ANOVA: comparing more than two means](#5-one-way-anova-comparing-more-than-two-means)
6. [Chi-square test for one population variance](#6-chi-square-test-for-one-population-variance)
7. [F-test for comparing two variances](#7-f-test-for-comparing-two-variances)
8. [Levene's test for comparing variances](#8-levenes-test-for-comparing-variances)
9. [Chi-square goodness-of-fit test for categorical data](#9-chi-square-goodness-of-fit-test-for-categorical-data)
10. [Chi-square test of independence](#10-chi-square-test-of-independence)
11. [Choosing the appropriate test](#11-choosing-the-appropriate-test)
12. [Practice problems](#12-practice-problems)

---

# 1. Recap: Z-test for a population mean

Suppose we want to test whether a population mean, $\mu$, differs from a hypothesized value, $\mu_0$.

For a two-tailed test,

$$
H_0:\mu=\mu_0
\qquad\text{and}\qquad
H_A:\mu\ne\mu_0.
$$

When the **population standard deviation is known**, the Z-statistic is

$$
\boxed{Z=\frac{\bar X-\mu_0}{\sigma/\sqrt n}}.
$$

Here $\bar X$ is the sample mean and $\sigma/\sqrt n$ is the standard error of the sample mean. Under $H_0$, $Z$ follows the standard normal distribution if the observations are independent and the population is normal, or approximately so for sufficiently large samples under appropriate conditions.

For a significance level $\alpha=0.05$, the rejection rules are:

| Alternative hypothesis | Reject $H_0$ when |
|---|---|
| $H_A:\mu\ne\mu_0$ | $\lvert Z\rvert>1.96$ |
| $H_A:\mu>\mu_0$ | $Z>1.645$ |
| $H_A:\mu<\mu_0$ | $Z<-1.645$ |

The critical values above are rounded values for $\alpha=0.05$.

## R example: a two-tailed Z-test

Suppose a sample of $n=25$ measurements has mean $52$. We want to test whether the population mean is $50$, knowing that the population standard deviation is $4$.

```r
# Z-test: known population standard deviation
mu0 <- 50
xbar <- 52
sigma <- 4
n <- 25
alpha <- 0.05

z <- (xbar - mu0) / (sigma / sqrt(n))
p_value <- 2 * pnorm(-abs(z))
z_critical <- qnorm(1 - alpha / 2)

z
p_value
z_critical

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

**Question:** What changes if $\sigma$ is *not* known, and we calculate the standard deviation, $s$, from the same sample?

Simply replacing $\sigma$ with $s$ introduces additional uncertainty. This is why we need the **t-distribution**.

---

# 2. Student's t-distribution

The **Student's t-distribution** was developed by William Sealy Gosset, who published under the pseudonym *Student* while working at the Guinness brewery.

When the population standard deviation $\sigma$ is unknown, we estimate it with the sample standard deviation,

$$
s=\sqrt{\frac{\sum_{i=1}^{n}(X_i-\bar X)^2}{n-1}}.
$$

The estimated standard error is

$$
SE=\frac{s}{\sqrt n}.
$$

For an independent random sample from a normal population, the statistic

$$
\boxed{T=\frac{\bar X-\mu}{s/\sqrt n}}
$$

follows a Student's t-distribution with

$$
\boxed{\nu=n-1}
$$

degrees of freedom.

## How is it different from the normal distribution?

- Both distributions are symmetric and centered at zero.
- The t-distribution has **heavier tails**, reflecting uncertainty from estimating $\sigma$.
- Its shape depends on the degrees of freedom, $\nu$.
- As $\nu$ increases, the t-distribution approaches the standard normal distribution.

## R: compare normal and t-distributions

```r
x <- seq(-4, 4, length.out = 500)

plot(
  x, dnorm(x), type = "l", lwd = 2,
  xlab = "Z or t", ylab = "Probability density",
  main = "Normal and Student's t-distributions"
)

lines(x, dt(x, df = 3), col = "red", lwd = 2)
lines(x, dt(x, df = 20), col = "blue", lwd = 2)

legend(
  "topright",
  legend = c("Normal", "t: df = 3", "t: df = 20"),
  col = c("black", "red", "blue"),
  lty = 1, lwd = 2
)

# Compare two-tailed critical values for alpha = 0.05
qnorm(0.975)
qt(0.975, df = 3)
qt(0.975, df = 20)
```

---

# 3. One-sample t-test

A one-sample t-test asks whether a population mean differs from a specified value when $\sigma$ is **unknown**.

For example: *Does the mean body temperature of a crab population differ from $24^\circ\mathrm{C}$?*

## Hypotheses and test statistic

For a two-tailed test,

$$
H_0:\mu=\mu_0,
\qquad
H_A:\mu\ne\mu_0.
$$

The test statistic is

$$
\boxed{t=\frac{\bar x-\mu_0}{s/\sqrt n}},
\qquad \nu=n-1.
$$

For significance level $\alpha$, the rejection regions are:

| Test | Alternative | Reject $H_0$ if |
|---|---|---|
| Two-tailed | $\mu\ne\mu_0$ | $\lvert t\rvert>t_{1-\alpha/2,\nu}$ |
| Right-tailed | $\mu>\mu_0$ | $t>t_{1-\alpha,\nu}$ |
| Left-tailed | $\mu<\mu_0$ | $t<t_{\alpha,\nu}$ |

Here $t_{p,\nu}$ means the $p$th quantile of the t-distribution with $\nu$ degrees of freedom, obtained using `qt(p, df = nu)`.

## R example: crab body temperatures

### Problem: Crab body temperature versus lake water temperature

Crabs live in a lake where the water temperature is assumed to be **24°C**.

We want to determine whether the **mean body temperature of the crabs is different from the temperature of the surrounding lake water**.

To investigate this question, we measure the body temperatures of 10 randomly selected crabs and perform a **one-sample t-test**, using 24°C as the reference temperature.

The following crab body temperatures are **illustrative data**.


```r
# One-sample t-test: crab body temperature (degrees C)
crab_temp <- c(
  23.1, 23.4, 24.2, 24.7, 23.9,
  23.8, 24.6, 24.3, 23.6, 24.1
)

mu0 <- 24
alpha <- 0.05

# Manually calculate p-value
n <- length(crab_temp)

# Calculate the statistic manually
t_stat <- (mean(crab_temp) - mu0) /
  (sd(crab_temp) / sqrt(n))

df <- n - 1
p_value <- 2 * pt(-abs(t_stat), df = df)

print(t_stat)
print(p_value)

# Use the built-in R test

# H0: population mean is 24 degrees C
# HA: population mean is different from 24 degrees C
result <- t.test(crab_temp, mu = mu0, alternative = "two.sided")
# Other alternatives, if specified before inspecting the data:
#t.test(crab_temp, mu = mu0, alternative = "less")
#t.test(crab_temp, mu = mu0, alternative = "greater")

p_value <- result$p.value
print(p_value)

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

The two-tailed test does **not** provide evidence that the mean differs from $24^\circ\mathrm{C}$ at the 5% significance level. This does **not** establish that the true mean is exactly $24^\circ\mathrm{C}$.

### Connection to confidence intervals

When $\sigma$ is unknown, the usual t-based confidence interval for the population mean is

$$
\boxed{
\bar x\ \pm\ t_{1-\alpha/2,n-1}\frac{s}{\sqrt n}
}.
$$

For a two-tailed test at $\alpha=0.05$, we reject $H_0:\mu=\mu_0$ precisely when the corresponding **95% two-sided t-confidence interval** excludes $\mu_0$.

---

# 4. Two-sample t-tests

Suppose we have two groups, such as germination measurements from plants grown **in a greenhouse** and **in a garden**.

We want to test whether the population means differ:

$$
H_0:\mu_1-\mu_2=0,
\qquad
H_A:\mu_1-\mu_2\ne0.
$$

## Independent samples: Welch's t-test

When the observations in the two groups are independent, the usual default is **Welch's t-test**, which does *not* assume equal population variances.

Its test statistic is

$$
\boxed{
t=\frac{(\bar x_1-\bar x_2)-\Delta_0}
{\sqrt{s_1^2/n_1+s_2^2/n_2}}
},
$$

where $\Delta_0=0$ when testing equality of means. Welch's method uses an approximate degrees-of-freedom calculation, which R performs automatically.

## R example: germination measurements


```r
# Measurements in two independent groups
greenhouse <- c(69.3, 75.5, 81.0, 74.7, 72.3, 70.7, 76.9)
garden <- c(69.5, 64.6, 74.0, 84.8, 71.0, 93.9, 81.2, 73.4, 88.0)

mean(greenhouse)
mean(garden)
sd(greenhouse)
sd(garden)

boxplot(
  greenhouse, garden,
  names = c("Greenhouse", "Garden"),
  ylab = "Germination measurement",
  main = "Comparison of two groups"
)

# Default: Welch's two-sample t-test
t.test(greenhouse, garden, alternative = "two.sided")
```

## Pooled two-sample t-test

If independent observations come from normal populations with the **same population variance**, the classical pooled two-sample t-test uses

$$
s_p^2=
\frac{(n_1-1)s_1^2+(n_2-1)s_2^2}{n_1+n_2-2},
$$

and

$$
t=\frac{(\bar x_1-\bar x_2)-\Delta_0}
{s_p\sqrt{1/n_1+1/n_2}},
\qquad \nu=n_1+n_2-2.
$$

In R, its command is `t.test(group1, group2, var.equal = TRUE)`.


## Paired t-test

What if the *same individuals* are measured before and after treatment? Those measurements are paired, not independent between conditions.

Define a difference for each individual,

$$
D_i=X_{i,\mathrm{after}}-X_{i,\mathrm{before}}.
$$

A paired t-test is a one-sample t-test of $H_0:\mu_D=0$ applied to the differences.

```r
before <- c(12.5, 13.1, 11.4, 14.0, 12.9, 13.7, 11.9, 12.2)
after  <- c(13.4, 13.5, 11.7, 15.0, 13.2, 14.0, 12.6, 13.1)

# Same eight individuals measured twice
t.test(after, before, paired = TRUE)

# Equivalent calculation
t.test(after - before, mu = 0)
```

---

# 5. One-way ANOVA: comparing more than two means

A t-test compares **two means**. What if we want to compare mean enzyme activity under **three treatments**: control, low dose, and high dose?

Performing a separate t-test for every pair can increase the probability of at least one false-positive result. **Analysis of variance (ANOVA)** provides an overall test of whether the group means are the same.

Despite its name, ANOVA is primarily a **test of means**. It tests for differences in means by comparing variation **between groups** with variation **within groups**.

## Hypotheses

For $k$ independent groups with population means $\mu_1,\ldots,\mu_k$,

$$
H_0:\mu_1=\mu_2=\cdots=\mu_k,
$$

$$
H_A:\text{at least one population mean differs}.
$$

Rejecting $H_0$ does **not** mean that every pair of group means differs. ANOVA first answers the overall question; comparisons between particular groups are a separate step.

## How does ANOVA work?

Let $X_{ij}$ be observation $i$ in group $j$, let $\bar X_j$ be the mean of group $j$, and let $\bar X$ be the overall (grand) mean. If group $j$ has $n_j$ observations, define

$$
SS_{\mathrm{between}}=\sum_{j=1}^{k}n_j(\bar X_j-\bar X)^2
$$

and

$$
SS_{\mathrm{within}}=\sum_{j=1}^{k}\sum_{i=1}^{n_j}(X_{ij}-\bar X_j)^2.
$$

For $N=\sum_j n_j$ total observations, the mean squares are

$$
MS_{\mathrm{between}}=\frac{SS_{\mathrm{between}}}{k-1},
\qquad
MS_{\mathrm{within}}=\frac{SS_{\mathrm{within}}}{N-k}.
$$

The **one-way ANOVA F-statistic** is

$$
\boxed{F=\frac{MS_{\mathrm{between}}}{MS_{\mathrm{within}}}}.
$$

Under $H_0$, assuming independent normal errors with a common variance, this follows an F-distribution with degrees of freedom

$$
\nu_1=k-1,\qquad \nu_2=N-k.
$$

A **large F-statistic** suggests that the differences among group means are large compared with the variation among observations within each group. ANOVA therefore has a **right-tailed** rejection region:

$$
F>F_{1-\alpha,\,k-1,\,N-k}.
$$

> [!NOTE]
> The F-statistic used in ANOVA compares **mean squares** (between-group variation versus within-group variation). The two-sample F-test later in this lecture compares **two sample variances**. Both use an F-distribution, but they answer different scientific questions.

## R example: enzyme activity under three treatments

The following data are **illustrative measurements**, not results from a published experiment. Assume each measurement comes from a different independently assigned experimental unit.

```r
# One-way ANOVA: enzyme activity under three treatments
control <- c(10.2, 11.4, 10.9, 12.0, 11.3, 10.7)
low_dose <- c(11.0, 12.6, 11.8, 12.1, 13.2, 12.4)
high_dose <- c(13.1, 14.3, 13.8, 14.9, 12.9, 14.1)

experiment <- data.frame(
  activity = c(control, low_dose, high_dose),
  treatment = factor(
    rep(c("Control", "Low dose", "High dose"), each = 6),
    levels = c("Control", "Low dose", "High dose")
  )
)

# Examine the observations and group means
experiment
aggregate(activity ~ treatment, data = experiment, FUN = mean)

boxplot(
  activity ~ treatment, data = experiment,
  xlab = "Treatment", ylab = "Enzyme activity",
  main = "Enzyme activity under three treatments"
)

# Standard one-way ANOVA
fit <- aov(activity ~ treatment, data = experiment)
summary(fit)

# Show how the F-statistic is calculated
k <- nlevels(experiment$treatment)
N <- nrow(experiment)
grand_mean <- mean(experiment$activity)

ss_between <- sum(tapply(
  experiment$activity, experiment$treatment,
  function(x) length(x) * (mean(x) - grand_mean)^2
))

ss_within <- sum(tapply(
  experiment$activity, experiment$treatment,
  function(x) sum((x - mean(x))^2)
))

ms_between <- ss_between / (k - 1)
ms_within <- ss_within / (N - k)
F_stat <- ms_between / ms_within
p_value <- pf(F_stat, df1 = k - 1, df2 = N - k,
              lower.tail = FALSE)

F_stat
p_value
qf(0.95, df1 = k - 1, df2 = N - k)
```

Compare the manually calculated F-statistic and p-value with the `summary(fit)` output. The ANOVA table reports the **degrees of freedom**, **sum of squares**, **mean squares**, **F value**, and **p-value**.

## Which groups differ? Tukey's post-hoc test

If the overall ANOVA provides evidence of unequal means, we may want to know *which pairs* of treatments differ. **Tukey's honest significant difference (HSD) test** makes pairwise comparisons while controlling the family-wise error rate under the standard one-way ANOVA assumptions.

```r
# Continue in the same 05_ANOVA.R script
TukeyHSD(fit)

# Visualize estimated pairwise differences and confidence intervals
plot(TukeyHSD(fit))
```

For each pair, examine the estimated difference, adjusted p-value (`p adj`), and confidence interval. A significant overall ANOVA does **not** imply that all pairs must differ.

## Assumptions and alternatives

Standard one-way ANOVA assumes **independent observations**, approximately normal **errors within groups**, and approximately **equal population variances**. Extreme outliers can distort the result. Independence comes from the experimental design, not from a plot or a significance test.

- When the group variances differ substantially, **Welch's one-way ANOVA** is a useful alternative:

  ```r
  # Base R; does not assume equal group variances
  oneway.test(activity ~ treatment, data = experiment,
              var.equal = FALSE)
  ```

- When the **same subjects** are measured under several conditions, observations are related. Use a repeated-measures ANOVA or an appropriate mixed-effects model, **not** this independent-groups analysis.
- Tukey's HSD is for the standard equal-variance ANOVA framework; if you use Welch's ANOVA, choose a suitable heteroscedastic post-hoc procedure rather than automatically applying `TukeyHSD()`.

**Connection to the t-test:** With exactly two independent groups and equal-variance assumptions, one-way ANOVA and the pooled two-sample t-test give equivalent tests; in fact, $F=t^2$. ANOVA naturally extends the same logic to **three or more groups**.

---

# 6. Chi-square test for one population variance

So far, we have been testing population **means**. Now the question changes:

*Is the population variance equal to a specified value?*

For a random sample from a **normal population**, the statistic

$$
\boxed{\chi^2=\frac{(n-1)s^2}{\sigma_0^2}}
$$

follows a chi-square distribution with

$$
\nu=n-1
$$

degrees of freedom when

$$
H_0:\sigma^2=\sigma_0^2.
$$

For the two-tailed alternative $H_A:\sigma^2\ne\sigma_0^2$, reject $H_0$ when

$$
\chi^2 < \chi^2_{\alpha/2,\nu}
\quad\text{or}\quad
\chi^2 > \chi^2_{1-\alpha/2,\nu}.
$$

The chi-square distribution is **nonnegative and generally right-skewed**. Unlike the Z- and t-distributions, it is not symmetric around zero.

## R example

```r
# One-sample variance test (illustrative measurements)
x <- c(39, 43, 38, 44, 41, 40, 45, 37, 42, 41)

sigma0 <- 3          # Hypothesized population SD
alpha <- 0.05
n <- length(x)
df <- n - 1

chi2_stat <- df * var(x) / sigma0^2

# Two-tailed p-value
p_lower <- pchisq(chi2_stat, df = df)
p_upper <- pchisq(chi2_stat, df = df, lower.tail = FALSE)
p_value <- min(1, 2 * min(p_lower, p_upper))

# Critical values
lower_critical <- qchisq(alpha / 2, df = df)
upper_critical <- qchisq(1 - alpha / 2, df = df)

chi2_stat
p_value
c(lower_critical, upper_critical)

# A two-sided confidence interval for population variance
ci_variance <- c(
  lower = df * var(x) / qchisq(1 - alpha / 2, df),
  upper = df * var(x) / qchisq(alpha / 2, df)
)
ci_variance
```

For a right-tailed alternative $\sigma^2>\sigma_0^2$, use the **upper-tail** probability; for a left-tailed alternative $\sigma^2<\sigma_0^2$, use the **lower-tail** probability.

> [!NOTE]
> The chi-square test for a single population variance is particularly sensitive to violations of normality. Do not use it automatically for strongly skewed data or data with major outliers.

---

# 7. F-test for comparing two variances

Suppose we have independent samples from two populations and want to know whether their **variances** differ.

$$
H_0:\sigma_1^2=\sigma_2^2,
\qquad
H_A:\sigma_1^2\ne\sigma_2^2.
$$

If both populations are normal, under $H_0$ the statistic

$$
\boxed{F=\frac{s_1^2}{s_2^2}}
$$

follows an F-distribution with degrees of freedom

$$
\nu_1=n_1-1,
\qquad
\nu_2=n_2-1.
$$

For a **two-tailed** F-test, reject for values of $F$ that are either unusually small or unusually large:

$$
F<F_{\alpha/2,\nu_1,\nu_2}
\quad\text{or}\quad
F>F_{1-\alpha/2,\nu_1,\nu_2}.
$$

It is common in handwritten calculations to put the larger sample variance in the numerator so that $F\ge1$. If you do so, **the corresponding numerator and denominator degrees of freedom must also be swapped**. R's `var.test()` handles the tails correctly without requiring this rearrangement.

## R example: insects captured in two traps

These data correspond to the two-trap example in the notes.

```r
# Number of insects captured on repeated sampling occasions
trap1 <- c(41, 35, 33, 36, 40, 46, 31, 37, 34, 30, 38)
trap2 <- c(52, 57, 62, 55, 64, 57, 56, 55, 60, 59)

# Compare variability, not means
var(trap1)
var(trap2)

# Calculate F manually
F_stat <- var(trap1) / var(trap2)
df1 <- length(trap1) - 1
df2 <- length(trap2) - 1

p_left <- pf(F_stat, df1, df2)
p_right <- pf(F_stat, df1, df2, lower.tail = FALSE)
p_value <- min(1, 2 * min(p_left, p_right))

F_stat
p_value

# Built-in two-sided F-test
var.test(trap1, trap2)
```

For this example, $F\approx1.70$ and the two-sided p-value is approximately $0.44$. There is insufficient evidence to conclude that the population variances differ.

**Important limitation:** An F-test for two variances assumes *independent samples from normal populations*. Its results can be strongly affected by outliers or non-normal data.

---

# 8. Levene's test for comparing variances

The F-test is appropriate when normality is reasonable. For biological data that may not be normally distributed, **Levene's test** offers a less normality-sensitive approach to comparing variability between groups.

A widely used variant is the **Brown–Forsythe test**, which centers observations around each group's **median**.

For each observation $X_{ij}$ in group $j$, define

$$
D_{ij}=\left|X_{ij}-\widetilde X_j\right|,
$$

where $\widetilde X_j$ is that group's sample median.

We then compare the mean absolute deviations across groups using an analysis of variance (ANOVA) F-statistic.

## R example: greenhouse and garden variability

```r
# Same independent groups used in Section 4
greenhouse <- c(69.3, 75.5, 81.0, 74.7, 72.3, 70.7, 76.9)
garden <- c(69.5, 64.6, 74.0, 84.8, 71.0, 93.9, 81.2, 73.4, 88.0)

measurement <- c(greenhouse, garden)
group <- factor(rep(
  c("Greenhouse", "Garden"),
  times = c(length(greenhouse), length(garden))
))

# Brown-Forsythe (median-centered Levene) test in base R
group_median <- ave(measurement, group, FUN = median)
absolute_deviation <- abs(measurement - group_median)

summary(aov(absolute_deviation ~ group))

# Optional alternative using the car package, if installed:
# car::leveneTest(measurement ~ group, center = median)
```

The null hypothesis is that the population variances are equal. A small p-value provides evidence of differing variability. Levene's test still assumes **independent observations** and is not a universal solution to every kind of non-normality.

**Why both an F-test and Levene's test?** They address similar questions but have different assumptions. Do not switch between them only to obtain a smaller p-value.

---

# 9. Chi-square goodness-of-fit test for categorical data

The previous tests used **numerical measurements**. Now suppose each observation belongs to one of several **categories**.

For example, suppose 20 bird sightings were recorded across four habitats. Under a simple null model, sightings are equally likely in each habitat.

| Habitat | Expected probability | Expected count | Observed count |
|---|---:|---:|---:|
| Forest | $1/4$ | 5 | 1 |
| Tree canopy | $1/4$ | 5 | 0 |
| Lawn | $1/4$ | 5 | 1 |
| Pond | $1/4$ | 5 | 18 |
| **Total** | **1** | **20** | **20** |

For $k$ mutually exclusive categories with pre-specified probabilities $p_i$, under $H_0$ the expected counts are

$$
E_i=np_i.
$$

The **Pearson chi-square goodness-of-fit statistic** is

$$
\boxed{\chi^2=\sum_{i=1}^{k}\frac{(O_i-E_i)^2}{E_i}}.
$$

If the category probabilities are fully specified under $H_0$ and the approximation is adequate, the statistic approximately follows a chi-square distribution with $k-1$ degrees of freedom. We reject for sufficiently **large** values.

Notice that this is a **different use of the chi-square distribution** from the variance test in Section 6.

## R example: unequal habitat counts

```r
# Observed bird sightings across four habitats
observed <- c(
  Forest = 1,
  TreeCanopy = 0,
  Lawn = 1,
  Pond = 18
)

# H0: each habitat is equally likely
p0 <- rep(0.25, 4)
expected <- sum(observed) * p0

# Calculate the statistic manually
chi2_stat <- sum((observed - expected)^2 / expected)
chi2_stat

# Chi-square goodness-of-fit test
chisq.test(observed, p = p0)

# Compare with the critical value (alpha = 0.05)
qchisq(0.95, df = 3)

barplot(
  rbind(Observed = observed, Expected = expected),
  beside = TRUE,
  legend.text = TRUE,
  ylab = "Count",
  main = "Bird sightings: observed versus expected"
)
```

The chi-square statistic is $45.2$, which is much larger than the 5% critical value. Thus the observations provide strong evidence **against the equal-probability model**. This does not, by itself, explain *why* the habitats have different counts; for example, differences in sampling effort may also matter.

### When is the chi-square approximation valid?

Observations should be independent, and categories should be mutually exclusive. Expected counts should not be too small; a common introductory guideline is that they should generally be at least 5. If the expected counts are small, an exact or simulation-based multinomial approach may be preferable.

In this example, all four expected counts are 5, even though one **observed** count is zero. The rule concerns **expected**, not observed, counts.

---

# 10. Chi-square test of independence

Another use of Pearson's chi-square statistic is to test whether **two categorical variables are associated**.

For example: *Is treatment group associated with whether an individual responds to treatment?*

Unlike goodness of fit (one categorical variable with specified expected probabilities), a test of independence uses a **contingency table** containing counts classified by two variables.

Under independence, the expected cell count is

$$
E_{ij}=\frac{(\text{row total}_i)(\text{column total}_j)}{\text{grand total}}.
$$

## R example: treatment and response

```r
counts <- matrix(
  c(18, 12,
     8, 22),
  nrow = 2,
  byrow = TRUE,
  dimnames = list(
    Treatment = c("Control", "Drug"),
    Outcome = c("Responder", "Nonresponder")
  )
)

counts

# Chi-square test of independence
chisq.test(counts, correct = FALSE)

# Expected counts under the null hypothesis
chisq.test(counts, correct = FALSE)$expected

# For a 2 x 2 table with small expected cell counts:
# fisher.test(counts)
```

For a contingency table with $r$ rows and $c$ columns, the degrees of freedom are $(r-1)(c-1)$. With small expected counts in a $2\times2$ table, **Fisher's exact test** is often preferred.

---

# 11. Choosing the appropriate test

The first question is **what you want to test**: one mean, a comparison of two or more means, a variance, a categorical distribution, or an association. The second question is whether your data satisfy the assumptions.

| Scientific question | Typical test | Important condition |
|---|---|---|
| Is one population mean equal to $\mu_0$? | One-sample Z-test | Population $\sigma$ known |
| Is one population mean equal to $\mu_0$? | One-sample t-test | Population $\sigma$ unknown; independent observations |
| Do two independent groups differ in mean? | Welch's two-sample t-test | Independent groups |
| Did the same individuals change between two measurements? | Paired t-test | Matched observations; appropriate differences |
| Do three or more independent groups differ in mean? | One-way ANOVA | Independent observations; approximately normal errors; similar group variances |
| Do three or more independent groups differ in mean with unequal variances? | Welch's one-way ANOVA | Independent observations; allows unequal group variances |
| Is one population variance equal to $\sigma_0^2$? | One-sample chi-square variance test | Normally distributed population |
| Do two population variances differ? | F-test | Independent, normally distributed groups |
| Do group variances differ without relying strongly on normality? | Levene / Brown–Forsythe test | Independent observations |
| Do observed category counts fit specified probabilities? | Chi-square goodness-of-fit test | Adequate expected counts |
| Are two categorical variables associated? | Chi-square test of independence | Adequate expected cell counts |

**A test of a mean is not a test of a variance.** Two groups can have similar means but different variances, or different means but similar variances. Likewise, a categorical chi-square test is not the same procedure as a chi-square variance test.

For every hypothesis test, report the **test used**, **test statistic**, **degrees of freedom** when applicable, **p-value**, and a conclusion in terms of the scientific question. Report confidence intervals and the size of the observed difference when relevant. Failure to reject $H_0$ is not proof that $H_0$ is true.


