<table style="width:100%; border:none;">
<tr>
<td style="width:33%; text-align:left; border:none;"><a href="../Lec04/Lec04.html"><strong>← Previous Lecture</strong></a></td>
<td style="width:34%; text-align:center; border:none;"><a href="../"><strong>Home</strong></a></td>
<td style="width:33%; text-align:right; border:none;"><a href="../Lec06/Lec06.html"><strong>Next Lecture →</strong></a></td>
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

> [!IMPORTANT]
> **How to work through this lecture:** Create a separate folder for Lecture 05. For each test, first read the **data table**, **summary of quantities**, and **worked calculation**. Only then run the two R code blocks: **(A) manual calculation** and **(B) R test function**. Save these as **separate, independently runnable `.R` files** (for example, `03_OneSampleT_manual.R` and `03_OneSampleT_Rtest.R`). Do not rely on variables left over from running a different code block.
>
> The examples use **illustrative data**. Unless stated otherwise, the significance level is $\alpha=0.05$, and tests are **two-sided**. Both code versions print either `Reject H0` or `Do not reject H0`.

**Common sequence for every test:** scientific question → **table of observed measurements or counts** → **table of calculated quantities** → hypotheses and hand calculation → p-value and decision → standalone manual R script → standalone R test-function script. Even when the same dataset is reused for a different test, its observed data are shown again before that test's calculation. For the Z-test, only summary information is available, so the input summary replaces a raw-data table. The two scripts should give the same test statistic (where available) and p-value, up to rounding.

---

# 1. Recap: Z-test for a population mean

A **one-sample Z-test** asks whether a population mean differs from a reference value when the **population standard deviation $\sigma$ is known**.

Under $H_0:\mu=\mu_0$, the statistic is

$$
Z=\frac{\bar X-\mu_0}{\sigma/\sqrt n}.
$$

For a two-sided alternative $H_A:\mu\ne\mu_0$, unusually large positive or negative Z-scores provide evidence against $H_0$. At $\alpha=0.05$, the approximate critical values are $-1.96$ and $+1.96$.

## Worked example — first understand the data

Suppose a sample of 25 independent measurements has mean 52. Previous reliable information establishes a **population standard deviation of 4**. Is the population mean different from 50?

Only **summary data** are provided for this example; individual observations are not available. Therefore, the following **input data table** replaces a raw-measurements table.

| Quantity | Symbol | Value |
|---|---|---:|
| Hypothesized population mean | $\mu_0$ | 50 |
| Observed sample mean | $\bar x$ | 52 |
| Known population SD | $\sigma$ | 4 |
| Sample size | $n$ | 25 |
| Significance level | $\alpha$ | 0.05 |
| Standard error | $\sigma/\sqrt n$ | 0.800 |

**Step 1 — hypotheses:** $H_0:\mu=50$; $H_A:\mu\ne50$.

**Step 2 — standard error:** $SE=4/\sqrt{25}=0.8$.

**Step 3 — statistic:**

$$
Z=\frac{52-50}{0.8}=2.50.
$$

**Step 4 — two-sided p-value:**

$$
p=2P(Z\ge2.50)\approx0.0124.
$$

**Step 5 — decision:** $0.0124<0.05$, so **reject $H_0$**. There is evidence that the population mean differs from 50. Statistical significance alone does not show whether the observed difference of 2 units is biologically important.

### A. Manual Z-test in R

```r
# 01_Ztest_manual.R — base R only
mu0 <- 50
xbar <- 52
sigma <- 4             # Known population SD
n <- 25
alpha <- 0.05

SE <- sigma / sqrt(n)
z_stat <- (xbar - mu0) / SE
p_value <- 2 * pnorm(-abs(z_stat))

print(c(SE = SE, z = z_stat, p_value = p_value))

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

### B. Z-test using an R test function

Base R has no dedicated `z.test()` function. The **BSDA** package provides `zsum.test()` for summary data (install once using `install.packages("BSDA")`).

```r
# 01_Ztest_Rtest.R — requires the BSDA package
# install.packages("BSDA")  # Run once, if needed

mu0 <- 50
xbar <- 52
sigma <- 4
n <- 25
alpha <- 0.05

result <- BSDA::zsum.test(
  mean.x = xbar, sigma.x = sigma, n.x = n,
  mu = mu0, alternative = "two.sided"
)
print(result)
p_value <- result$p.value

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

**Question:** What changes if $\sigma$ is *unknown* and must be estimated from the same observations? This additional uncertainty leads to **Student's t-distribution**.

---

# 2. Student's t-distribution

The **Student's t-distribution** was introduced by William Sealy Gosset, who published under the pseudonym *Student* while working at the Guinness brewery.

When $\sigma$ is unknown, use the sample standard deviation

$$
s=\sqrt{\frac{\sum_{i=1}^{n}(X_i-\bar X)^2}{n-1}}.
$$

For an independent sample from a normal population, the standardized sample mean

$$
T=\frac{\bar X-\mu}{s/\sqrt n}
$$

has a t-distribution with $\nu=n-1$ **degrees of freedom**.

- Both the standard normal and t-distributions are symmetric about zero.
- The t-distribution has **heavier tails** because $s$ is an estimate of $\sigma$.
- Its shape depends on the degrees of freedom; as $\nu$ grows, it approaches the standard normal distribution.

## R illustration — compare t- and normal distributions

This is a **distribution plot**, not a hypothesis test; it therefore needs only one R script.

```r
# 02_TDistribution.R
x <- seq(-4, 4, length.out = 500)

plot(x, dnorm(x), type = "l", lwd = 2,
     xlab = "Z or t", ylab = "Probability density",
     main = "Normal and Student's t-distributions")
lines(x, dt(x, df = 3), col = "red", lwd = 2)
lines(x, dt(x, df = 20), col = "blue", lwd = 2)
legend("topright", legend = c("Normal", "t: df = 3", "t: df = 20"),
       col = c("black", "red", "blue"), lty = 1, lwd = 2)

# Two-sided 5% critical values
qnorm(0.975)
qt(0.975, df = 3)
qt(0.975, df = 20)
```

---

# 3. One-sample t-test

A **one-sample t-test** compares the population mean with a specified reference value when the population standard deviation is unknown.

## Worked example — crab body temperature versus lake water

Crabs inhabit a lake whose water temperature is assumed to be **24°C**. We want to know whether the **mean crab body temperature differs from the surrounding lake water temperature**. The following temperatures of ten independently sampled crabs are **illustrative**.

**Observed data:**

| Crab | Body temperature (°C) | Crab | Body temperature (°C) |
|---|---:|---|---:|
| 1 | 23.1 | 6 | 23.8 |
| 2 | 23.4 | 7 | 24.6 |
| 3 | 24.2 | 8 | 24.3 |
| 4 | 24.7 | 9 | 23.6 |
| 5 | 23.9 | 10 | 24.1 |

Before calculating the statistic, identify **all quantities needed**:

| Quantity | Symbol | Value |
|---|---|---:|
| Reference lake temperature | $\mu_0$ | 24°C |
| Sample size | $n$ | 10 |
| Sum of observations | $\sum x_i$ | 239.7°C |
| Sample mean | $\bar x$ | 23.970°C |
| Sum of squared deviations | $\sum(x_i-\bar x)^2$ | 2.361 |
| Sample variance | $s^2=2.361/9$ | 0.26233 |
| Sample SD | $s$ | 0.51218°C |
| Standard error | $s/\sqrt{10}$ | 0.16197°C |
| Degrees of freedom | $n-1$ | 9 |

**Step 1 — hypotheses:** $H_0:\mu=24$; $H_A:\mu\ne24$. Here 24°C is a **fixed reference value**, not the mean of a second sample.

**Step 2 — calculate the standard deviation:**

$$
s=\sqrt{\frac{2.361}{10-1}}\approx0.5122.
$$

**Step 3 — statistic:**

$$
t=\frac{23.970-24}{0.5122/\sqrt{10}}\approx-0.1852.
$$

**Step 4 — two-sided p-value:** $p=2P(T_9\le-0.1852)\approx0.8572$.

**Step 5 — decision:** $p>0.05$, so **do not reject $H_0$**. There is insufficient evidence that mean crab body temperature differs from 24°C. The approximate 95% confidence interval is **23.604°C to 24.336°C**, which contains 24°C. **This does not prove that the mean is exactly 24°C.**

If lake temperature were estimated from sample measurements instead of treated as known, the appropriate test would depend on whether crab and water measurements were paired or independent.

### A. Manual one-sample t-test

```r
# 03_OneSampleT_manual.R — base R only
crab_temp <- c(23.1, 23.4, 24.2, 24.7, 23.9,
               23.8, 24.6, 24.3, 23.6, 24.1)
mu0 <- 24
alpha <- 0.05

n <- length(crab_temp)
xbar <- mean(crab_temp)
s <- sd(crab_temp)
SE <- s / sqrt(n)
df <- n - 1
t_stat <- (xbar - mu0) / SE
p_value <- 2 * pt(-abs(t_stat), df = df)

print(c(n = n, mean = xbar, SD = s, SE = SE,
        df = df, t = t_stat, p_value = p_value))

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

### B. One-sample `t.test()`

```r
# 03_OneSampleT_Rtest.R — base R only
crab_temp <- c(23.1, 23.4, 24.2, 24.7, 23.9,
               23.8, 24.6, 24.3, 23.6, 24.1)
mu0 <- 24
alpha <- 0.05

result <- t.test(crab_temp, mu = mu0, alternative = "two.sided")
print(result)
p_value <- result$p.value    # Not result$statistic!

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

**Connection to confidence intervals:** The two-sided $(1-\alpha)100\%$ confidence interval is

$$
\bar x\ \pm\ t_{1-\alpha/2,n-1}\frac{s}{\sqrt n}.
$$

For a two-sided test at $\alpha=0.05$, the null mean is rejected exactly when the corresponding 95% confidence interval excludes it.

---

# 4. Two-sample t-tests

The scientific question determines whether two sets of measurements are **independent** or **paired**. Welch's and pooled t-tests compare **independent groups**; the paired t-test analyzes **within-individual differences**.

## 4.1. Welch's t-test — independent groups

### Worked example — greenhouse versus garden

Are population mean germination measurements different between plants grown in a greenhouse and plants grown in a garden? The following illustrative measurements come from **independent plants**.

**Observed data:**

| Measurement | Greenhouse | Garden |
|---|---:|---:|
| 1 | 69.3 | 69.5 |
| 2 | 75.5 | 64.6 |
| 3 | 81.0 | 74.0 |
| 4 | 74.7 | 84.8 |
| 5 | 72.3 | 71.0 |
| 6 | 70.7 | 93.9 |
| 7 | 76.9 | 81.2 |
| 8 | — | 73.4 |
| 9 | — | 88.0 |

The dashes indicate **no greenhouse observation** (the sample sizes differ); rows do not define pairs.

| Quantity | Greenhouse (1) | Garden (2) |
|---|---:|---:|
| Number, $n_j$ | 7 | 9 |
| Sum, $\sum x_i$ | 520.4 | 700.4 |
| Mean, $\bar x_j$ | 74.343 | 77.822 |
| Sample variance, $s_j^2$ | 15.866 | 93.372 |
| Sample SD, $s_j$ | 3.983 | 9.663 |
| Contribution to $SE^2$, $s_j^2/n_j$ | 2.267 | 10.375 |

**Step 1 — hypotheses:** $H_0:\mu_1-\mu_2=0$; $H_A:\mu_1-\mu_2\ne0$.

**Step 2 — difference in means:** $\bar x_1-\bar x_2=74.343-77.822=-3.479$.

**Step 3 — standard error:**

$$
SE=\sqrt{\frac{s_1^2}{n_1}+\frac{s_2^2}{n_2}}
=\sqrt{\frac{15.866}{7}+\frac{93.372}{9}}\approx3.555.
$$

**Step 4 — t-statistic and Welch degrees of freedom:**

$$
t=\frac{-3.479}{3.555}\approx-0.9786,
$$

$$
\nu=\frac{(s_1^2/n_1+s_2^2/n_2)^2}
{(s_1^2/n_1)^2/(n_1-1)+(s_2^2/n_2)^2/(n_2-1)}\approx11.167.
$$

**Step 5 — p-value and decision:** The two-sided $p\approx0.3485>0.05$; **do not reject $H_0$**. We have insufficient evidence that the two population means differ. Welch's test is the usual default because it **does not assume equal population variances**.

### A. Manual Welch test

```r
# 04_WelchT_manual.R — base R only
greenhouse <- c(69.3, 75.5, 81.0, 74.7, 72.3, 70.7, 76.9)
garden <- c(69.5, 64.6, 74.0, 84.8, 71.0,
            93.9, 81.2, 73.4, 88.0)
alpha <- 0.05

n1 <- length(greenhouse)
n2 <- length(garden)
xbar1 <- mean(greenhouse)
xbar2 <- mean(garden)
v1 <- var(greenhouse)
v2 <- var(garden)
SE <- sqrt(v1 / n1 + v2 / n2)
t_stat <- (xbar1 - xbar2) / SE
df <- (v1 / n1 + v2 / n2)^2 /
  ((v1 / n1)^2 / (n1 - 1) + (v2 / n2)^2 / (n2 - 1))
p_value <- 2 * pt(-abs(t_stat), df = df)

print(c(mean1 = xbar1, mean2 = xbar2, SE = SE,
        t = t_stat, df = df, p_value = p_value))

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

### B. Welch `t.test()`

```r
# 04_WelchT_Rtest.R — base R only
greenhouse <- c(69.3, 75.5, 81.0, 74.7, 72.3, 70.7, 76.9)
garden <- c(69.5, 64.6, 74.0, 84.8, 71.0,
            93.9, 81.2, 73.4, 88.0)
alpha <- 0.05

result <- t.test(greenhouse, garden, alternative = "two.sided",
                 var.equal = FALSE)
print(result)
p_value <- result$p.value

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}

boxplot(greenhouse, garden,
        names = c("Greenhouse", "Garden"),
        ylab = "Germination measurement")
```

## 4.2. Pooled two-sample t-test — independent groups

The **pooled t-test** makes the additional assumption that both independent populations have the **same variance**. We use the same greenhouse and garden measurements as in Welch's test, but combine their estimates of variance.

### Worked example — observed measurements first

The **observed data** are shown again so that this test can be studied independently of Welch's test. They are *independent groups*, not paired measurements; dashes indicate that the greenhouse group has fewer observations.

| Observation | Greenhouse | Garden |
|---|---:|---:|
| 1 | 69.3 | 69.5 |
| 2 | 75.5 | 64.6 |
| 3 | 81.0 | 74.0 |
| 4 | 74.7 | 84.8 |
| 5 | 72.3 | 71.0 |
| 6 | 70.7 | 93.9 |
| 7 | 76.9 | 81.2 |
| 8 | — | 73.4 |
| 9 | — | 88.0 |

**Quantities needed for the pooled t-statistic:**

| Quantity | Value |
|---|---:|
| $n_1,n_2$ | 7, 9 |
| $\bar x_1,\bar x_2$ | 74.343, 77.822 |
| $s_1^2,s_2^2$ | 15.866, 93.372 |
| Degrees of freedom $n_1+n_2-2$ | 14 |
| Pooled variance $s_p^2$ | 60.155 |
| Pooled standard error | 3.909 |

**Manual walk-through:** Under $H_0:\mu_1-\mu_2=0$,

$$
s_p^2=\frac{(n_1-1)s_1^2+(n_2-1)s_2^2}{n_1+n_2-2}
=\frac{6(15.866)+8(93.372)}{14}\approx60.155,
$$

$$
t=\frac{74.343-77.822}{\sqrt{60.155}\sqrt{1/7+1/9}}
\approx-0.8902.
$$

With 14 degrees of freedom, the two-sided $p\approx0.3884>0.05$; **do not reject $H_0$**. The sample variances differ substantially, so **Welch's test is more appropriate as a default** for these data.

### A. Manual pooled t-test

```r
# 04_PooledT_manual.R — base R only
greenhouse <- c(69.3, 75.5, 81.0, 74.7, 72.3, 70.7, 76.9)
garden <- c(69.5, 64.6, 74.0, 84.8, 71.0,
            93.9, 81.2, 73.4, 88.0)
alpha <- 0.05

n1 <- length(greenhouse)
n2 <- length(garden)
df <- n1 + n2 - 2
sp2 <- ((n1 - 1) * var(greenhouse) +
        (n2 - 1) * var(garden)) / df
SE <- sqrt(sp2 * (1 / n1 + 1 / n2))
t_stat <- (mean(greenhouse) - mean(garden)) / SE
p_value <- 2 * pt(-abs(t_stat), df = df)

print(c(pooled_variance = sp2, SE = SE,
        t = t_stat, df = df, p_value = p_value))

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

### B. Pooled `t.test()`

```r
# 04_PooledT_Rtest.R — base R only
greenhouse <- c(69.3, 75.5, 81.0, 74.7, 72.3, 70.7, 76.9)
garden <- c(69.5, 64.6, 74.0, 84.8, 71.0,
            93.9, 81.2, 73.4, 88.0)
alpha <- 0.05

result <- t.test(greenhouse, garden,
                 alternative = "two.sided", var.equal = TRUE)
print(result)
p_value <- result$p.value

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

## 4.3. Paired t-test — repeated measurements on the same individuals

A paired test is appropriate when **the same subjects** are measured before and after treatment. Instead of treating the two columns as independent, calculate one difference $D_i=X_{i,\mathrm{after}}-X_{i,\mathrm{before}}$ per subject.

### Worked example — observations and necessary quantities

**Observed data:**

| Subject | Before | After | Difference $D_i$ |
|---|---:|---:|---:|
| 1 | 12.5 | 13.4 | 0.9 |
| 2 | 13.1 | 13.5 | 0.4 |
| 3 | 11.4 | 11.7 | 0.3 |
| 4 | 14.0 | 15.0 | 1.0 |
| 5 | 12.9 | 13.2 | 0.3 |
| 6 | 13.7 | 14.0 | 0.3 |
| 7 | 11.9 | 12.6 | 0.7 |
| 8 | 12.2 | 13.1 | 0.9 |

| Quantity computed from the **differences** | Value |
|---|---:|
| Number of subjects, $n$ | 8 |
| Sum of differences | 4.800 |
| Mean difference, $\bar D$ | 0.600 |
| $\sum(D_i-\bar D)^2$ | 0.660 |
| Variance of differences, $s_D^2$ | 0.09429 |
| SD of differences, $s_D$ | 0.30706 |
| Standard error, $s_D/\sqrt8$ | 0.10856 |
| Degrees of freedom | 7 |

**Step 1:** $H_0:\mu_D=0$; $H_A:\mu_D\ne0$.

**Step 2:** Use the **difference SD**, not the SD of the before or after columns.

**Step 3:**

$$
t=\frac{\bar D-0}{s_D/\sqrt n}
=\frac{0.600}{0.30706/\sqrt8}\approx5.5268.
$$

**Step 4:** Two-sided $p\approx0.000881$ for $\nu=7$.

**Step 5:** **Reject $H_0$**. The data provide evidence of a mean change, and the observed mean change is positive.

### A. Manual paired t-test

```r
# 04_PairedT_manual.R — base R only
before <- c(12.5, 13.1, 11.4, 14.0, 12.9, 13.7, 11.9, 12.2)
after <- c(13.4, 13.5, 11.7, 15.0, 13.2, 14.0, 12.6, 13.1)
alpha <- 0.05

D <- after - before
n <- length(D)
df <- n - 1
mean_D <- mean(D)
sd_D <- sd(D)
SE <- sd_D / sqrt(n)
t_stat <- mean_D / SE
p_value <- 2 * pt(-abs(t_stat), df = df)

print(c(mean_difference = mean_D, SD_difference = sd_D,
        SE = SE, t = t_stat, df = df, p_value = p_value))

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

### B. Paired `t.test()`

```r
# 04_PairedT_Rtest.R — base R only
before <- c(12.5, 13.1, 11.4, 14.0, 12.9, 13.7, 11.9, 12.2)
after <- c(13.4, 13.5, 11.7, 15.0, 13.2, 14.0, 12.6, 13.1)
alpha <- 0.05

result <- t.test(after, before, paired = TRUE,
                 alternative = "two.sided")
print(result)
p_value <- result$p.value

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

---

# 5. One-way ANOVA: comparing more than two means

A t-test compares two population means. **One-way analysis of variance (ANOVA)** asks whether the means of **three or more independent groups** are all equal, without performing multiple unadjusted pairwise t-tests.

$$
H_0:\mu_1=\mu_2=\cdots=\mu_k,
\qquad H_A:\text{at least one population mean differs}.
$$

Although its name mentions *variance*, one-way ANOVA is a **test of population means**. It compares **between-group variation** with **within-group variation**.

## Worked example — enzyme activity under three treatments

Assume measurements come from independent experimental units assigned to control, low-dose, or high-dose treatment.

**Observed data:**

| Observation | Control | Low dose | High dose |
|---|---:|---:|---:|
| 1 | 10.2 | 11.0 | 13.1 |
| 2 | 11.4 | 12.6 | 14.3 |
| 3 | 10.9 | 11.8 | 13.8 |
| 4 | 12.0 | 12.1 | 14.9 |
| 5 | 11.3 | 13.2 | 12.9 |
| 6 | 10.7 | 12.4 | 14.1 |

**Quantities needed for the ANOVA test statistic:**

| Quantity | Control | Low dose | High dose |
|---|---:|---:|---:|
| Sample size, $n_j$ | 6 | 6 | 6 |
| Sum of observations | 66.5 | 73.1 | 83.1 |
| Group mean, $\bar X_j$ | 11.083 | 12.183 | 13.850 |
| Sample variance, $s_j^2$ | 0.3897 | 0.5617 | 0.5670 |

Let $X_{ij}$ be observation $i$ in group $j$, $\bar X_j$ its **group mean**, and $\bar X$ the **grand mean** across all observations. Here there are $k=3$ groups, $n_j=6$ observations in each, and $N=18$ observations in total.

$$
\bar X=\frac{66.5+73.1+83.1}{18}=12.3722.
$$

### Step 1 — between-group sum of squares

**Between-group variation** measures how far the group means lie from the **grand mean**, accounting for the size of each group:

$$
\boxed{SS_{\mathrm{between}}=\sum_{j=1}^{k}n_j(\bar X_j-\bar X)^2}.
$$

For example, the control group's contribution is

$$
6(11.0833-12.3722)^2\approx9.9674.
$$

The low-dose and high-dose groups contribute approximately 0.2141 and 13.1030, respectively.

### Step 2 — within-group sum of squares

**Within-group variation** measures how far **each observation lies from its own group mean**, not from the grand mean:

$$
\boxed{SS_{\mathrm{within}}=\sum_{j=1}^{k}\sum_{i=1}^{n_j}(X_{ij}-\bar X_j)^2}.
$$

For example, the control group's contribution is

$$
\begin{aligned}
SS_{\mathrm{within,control}}={}&(10.2-11.0833)^2
+(11.4-11.0833)^2\\
&+(10.9-11.0833)^2
+(12.0-11.0833)^2\\
&+(11.3-11.0833)^2
+(10.7-11.0833)^2\\
\approx{}&1.9483.
\end{aligned}
$$

### Step 3 — table of all components

| Group | $n_j$ | Mean | Sample variance $s_j^2$ | Contribution to $SS_{\mathrm{between}}$ | Contribution to $SS_{\mathrm{within}}$ |
|---|---:|---:|---:|---:|---:|
| Control | 6 | 11.083 | 0.3897 | 9.9674 | 1.9483 |
| Low dose | 6 | 12.183 | 0.5617 | 0.2141 | 2.8083 |
| High dose | 6 | 13.850 | 0.5670 | 13.1030 | 2.8350 |
| **Total** | **18** | **Grand mean = 12.372** | | **23.2844** | **7.5917** |

The total variation splits into these two components:

$$
SS_{\mathrm{total}}=SS_{\mathrm{between}}+SS_{\mathrm{within}}
=23.2844+7.5917=30.8761.
$$

### Step 4 — mean squares, F-statistic, and p-value

| Quantity | Calculation | Value |
|---|---|---:|
| Between-group degrees of freedom | $k-1$ | 2 |
| Within-group degrees of freedom | $N-k$ | 15 |
| $MS_{\mathrm{between}}$ | $23.2844/2$ | 11.6422 |
| $MS_{\mathrm{within}}$ | $7.5917/15$ | 0.50611 |
| F-statistic | $11.6422/0.50611$ | 23.0033 |

$$
\boxed{F=\frac{MS_{\mathrm{between}}}{MS_{\mathrm{within}}}
=\frac{SS_{\mathrm{between}}/(k-1)}{SS_{\mathrm{within}}/(N-k)}}.
$$

For independent normally distributed errors and equal population variances, under $H_0$ this follows an **F-distribution** with degrees of freedom $(2,15)$. A **large** F provides evidence against equality of means.

$$
p=P(F_{2,15}\ge23.0033)\approx0.00002694.
$$

**Decision:** $p<0.05$; **reject $H_0$**. At least one population mean enzyme activity differs. This result **does not identify which pairs differ**.

### A. Manual one-way ANOVA

```r
# 05_ANOVA_manual.R — base R only
control <- c(10.2, 11.4, 10.9, 12.0, 11.3, 10.7)
low_dose <- c(11.0, 12.6, 11.8, 12.1, 13.2, 12.4)
high_dose <- c(13.1, 14.3, 13.8, 14.9, 12.9, 14.1)
alpha <- 0.05

groups <- list(Control = control, LowDose = low_dose,
               HighDose = high_dose)
N <- sum(sapply(groups, length))
k <- length(groups)
grand_mean <- mean(unlist(groups))

n_j <- sapply(groups, length)
group_means <- sapply(groups, mean)
SS_between_j <- n_j * (group_means - grand_mean)^2
SS_within_j <- sapply(groups, function(x) sum((x - mean(x))^2))
print(round(data.frame(n = n_j, mean = group_means,
                       SS_between = SS_between_j,
                       SS_within = SS_within_j), 4))

SS_between <- sum(SS_between_j)
SS_within <- sum(SS_within_j)
df_between <- k - 1
df_within <- N - k
MS_between <- SS_between / df_between
MS_within <- SS_within / df_within
F_stat <- MS_between / MS_within
p_value <- pf(F_stat, df1 = df_between, df2 = df_within,
              lower.tail = FALSE)

print(c(SS_between = SS_between, SS_within = SS_within,
        MS_between = MS_between, MS_within = MS_within,
        F = F_stat, p_value = p_value))

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

### B. One-way ANOVA using `aov()`

```r
# 05_ANOVA_Rtest.R — base R only
control <- c(10.2, 11.4, 10.9, 12.0, 11.3, 10.7)
low_dose <- c(11.0, 12.6, 11.8, 12.1, 13.2, 12.4)
high_dose <- c(13.1, 14.3, 13.8, 14.9, 12.9, 14.1)
alpha <- 0.05

experiment <- data.frame(
  activity = c(control, low_dose, high_dose),
  treatment = factor(rep(c("Control", "Low dose", "High dose"), each = 6))
)

fit <- aov(activity ~ treatment, data = experiment)
result <- summary(fit)
print(result)
p_value <- result[[1]][["Pr(>F)"]][1]

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}

boxplot(activity ~ treatment, data = experiment,
        xlab = "Treatment", ylab = "Enzyme activity")
```

## Which groups differ? Tukey's HSD

After an overall ANOVA, **Tukey's honest significant difference (HSD)** compares pairs of treatment means while controlling the family-wise Type I error rate.

### Worked example — observed enzyme activity data

| Observation | Control | Low dose | High dose |
|---|---:|---:|---:|
| 1 | 10.2 | 11.0 | 13.1 |
| 2 | 11.4 | 12.6 | 14.3 |
| 3 | 10.9 | 11.8 | 13.8 |
| 4 | 12.0 | 12.1 | 14.9 |
| 5 | 11.3 | 13.2 | 12.9 |
| 6 | 10.7 | 12.4 | 14.1 |

**Quantities needed for the Tukey comparisons:**

| Quantity | Value |
|---|---:|
| Number of treatment groups, $k$ | 3 |
| Observations per group, $n$ | 6 |
| Group means: control, low dose, high dose | 11.083, 12.183, 13.850 |
| Within-group sum of squares, $SS_{\mathrm{within}}$ | 7.5917 |
| Within-group degrees of freedom, $N-k$ | 15 |
| Within-group mean square, $MS_{\mathrm{within}}$ | 0.50611 |
| Family-wise significance level, $\alpha$ | 0.05 |

**Manual walk-through:** For these **equal group sizes** ($n=6$), calculate the minimum significant absolute difference:

$$
HSD=q_{0.95;k=3,\,\nu=15}\sqrt{\frac{MS_{\mathrm{within}}}{n}}
\approx3.6734\sqrt{\frac{0.50611}{6}}\approx1.0669,
$$

where $q$ is a quantile of the **studentized range distribution** (obtained with `qtukey()` in R).

| Pair | Absolute difference of means | Tukey-adjusted p-value | Decision at 0.05 |
|---|---:|---:|---|
| Control – low dose | 1.100 | 0.04290 | Reject equality |
| Control – high dose | 2.767 | 0.0000189 | Reject equality |
| Low dose – high dose | 1.667 | 0.002785 | Reject equality |

For these illustrative data, **all three pairs differ** at family-wise $\alpha=0.05$. In other datasets, a significant overall ANOVA does *not* necessarily mean that all pairs differ.

### A. Manual Tukey comparisons

```r
# 05_Tukey_manual.R — base R only; equal-sized groups
control <- c(10.2, 11.4, 10.9, 12.0, 11.3, 10.7)
low_dose <- c(11.0, 12.6, 11.8, 12.1, 13.2, 12.4)
high_dose <- c(13.1, 14.3, 13.8, 14.9, 12.9, 14.1)
alpha <- 0.05

groups <- list(Control = control, LowDose = low_dose,
               HighDose = high_dose)
k <- length(groups)
n <- length(control)        # Equal sample sizes in this example
N <- sum(sapply(groups, length))
df_within <- N - k
SS_within <- sum(sapply(groups, function(x) sum((x - mean(x))^2)))
MS_within <- SS_within / df_within
means <- sapply(groups, mean)

HSD <- qtukey(1 - alpha, nmeans = k, df = df_within) *
  sqrt(MS_within / n)
print(c(MS_within = MS_within, HSD = HSD))

pairs <- combn(names(means), 2, simplify = FALSE)
for (pair in pairs) {
  difference <- abs(means[pair[1]] - means[pair[2]])
  q_stat <- difference / sqrt(MS_within / n)
  p_value <- ptukey(q_stat, nmeans = k, df = df_within,
                    lower.tail = FALSE)
  cat("Comparison:", pair[1], "vs", pair[2],
      "| difference:", difference, "| adjusted p:", p_value, "\n")
  if (p_value < alpha) {
    print("Reject H0")
  } else {
    print("Do not reject H0")
  }
}
```

### B. Tukey comparisons using `TukeyHSD()`

```r
# 05_Tukey_Rtest.R — base R only
control <- c(10.2, 11.4, 10.9, 12.0, 11.3, 10.7)
low_dose <- c(11.0, 12.6, 11.8, 12.1, 13.2, 12.4)
high_dose <- c(13.1, 14.3, 13.8, 14.9, 12.9, 14.1)
alpha <- 0.05

experiment <- data.frame(
  activity = c(control, low_dose, high_dose),
  treatment = factor(rep(c("Control", "Low dose", "High dose"), each = 6))
)
fit <- aov(activity ~ treatment, data = experiment)
result <- TukeyHSD(fit)
print(result)

adjusted_p <- result$treatment[, "p adj"]
for (comparison in names(adjusted_p)) {
  p_value <- adjusted_p[[comparison]]
  cat("Comparison:", comparison, "| adjusted p:", p_value, "\n")
  if (p_value < alpha) {
    print("Reject H0")
  } else {
    print("Do not reject H0")
  }
}
plot(result)
```

## Alternative when variances differ: Welch's one-way ANOVA

Ordinary ANOVA assumes approximately **equal population variances**. Welch's ANOVA allows unequal variances.

### Worked example — observed enzyme activity data

| Observation | Control | Low dose | High dose |
|---|---:|---:|---:|
| 1 | 10.2 | 11.0 | 13.1 |
| 2 | 11.4 | 12.6 | 14.3 |
| 3 | 10.9 | 11.8 | 13.8 |
| 4 | 12.0 | 12.1 | 14.9 |
| 5 | 11.3 | 13.2 | 12.9 |
| 6 | 10.7 | 12.4 | 14.1 |

**Quantities needed for the Welch ANOVA F-statistic:**

| Treatment | $n_j$ | Mean $\bar x_j$ | Variance $s_j^2$ | Weight $w_j=n_j/s_j^2$ |
|---|---:|---:|---:|---:|
| Control | 6 | 11.083 | 0.3897 | 15.398 |
| Low dose | 6 | 12.183 | 0.5617 | 10.682 |
| High dose | 6 | 13.850 | 0.5670 | 10.582 |

**Manual walk-through:** The **weighted grand mean** is $\bar x_w=\sum_j w_j\bar x_j/\sum_jw_j\approx12.2024$. Define

$$
A=\sum_{j=1}^k\frac{(1-w_j/\sum_iw_i)^2}{n_j-1}\approx0.26892.
$$

The Welch statistic and approximate denominator degrees of freedom are

$$
F_W=\frac{\dfrac{\sum_jw_j(\bar x_j-\bar x_w)^2}{k-1}}
{1+\dfrac{2(k-2)}{k^2-1}A}\approx22.494,
\qquad
\nu_2=\frac{k^2-1}{3A}\approx9.916.
$$

The right-tail p-value is approximately **0.0002065**, so **reject equality of means**. Welch's ANOVA tests the same overall null hypothesis as ordinary ANOVA, but uses different weights and degrees of freedom. Its post-hoc comparisons should not automatically use the equal-variance Tukey HSD procedure.

### A. Manual Welch ANOVA

```r
# 05_WelchANOVA_manual.R — base R only
control <- c(10.2, 11.4, 10.9, 12.0, 11.3, 10.7)
low_dose <- c(11.0, 12.6, 11.8, 12.1, 13.2, 12.4)
high_dose <- c(13.1, 14.3, 13.8, 14.9, 12.9, 14.1)
alpha <- 0.05

groups <- list(control, low_dose, high_dose)
k <- length(groups)
n_j <- sapply(groups, length)
means <- sapply(groups, mean)
variances <- sapply(groups, var)
weights <- n_j / variances
weighted_mean <- sum(weights * means) / sum(weights)
A <- sum((1 - weights / sum(weights))^2 / (n_j - 1))
F_stat <- (sum(weights * (means - weighted_mean)^2) / (k - 1)) /
  (1 + 2 * (k - 2) * A / (k^2 - 1))
df1 <- k - 1
df2 <- (k^2 - 1) / (3 * A)
p_value <- pf(F_stat, df1 = df1, df2 = df2, lower.tail = FALSE)

print(c(weighted_mean = weighted_mean, F = F_stat,
        df1 = df1, df2 = df2, p_value = p_value))

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

### B. Welch ANOVA using `oneway.test()`

```r
# 05_WelchANOVA_Rtest.R — base R only
control <- c(10.2, 11.4, 10.9, 12.0, 11.3, 10.7)
low_dose <- c(11.0, 12.6, 11.8, 12.1, 13.2, 12.4)
high_dose <- c(13.1, 14.3, 13.8, 14.9, 12.9, 14.1)
alpha <- 0.05

experiment <- data.frame(
  activity = c(control, low_dose, high_dose),
  treatment = factor(rep(c("Control", "Low dose", "High dose"), each = 6))
)
result <- oneway.test(activity ~ treatment, data = experiment,
                      var.equal = FALSE)
print(result)
p_value <- result$p.value

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

**Assumptions:** Standard one-way ANOVA requires independent observations, approximately normal residuals in each group, and approximately equal population variances. Welch's ANOVA relaxes the equal-variance assumption but not independence. For measurements repeated on the same subjects, use a repeated-measures model instead of independent-groups ANOVA. For exactly two groups under equal-variance assumptions, pooled $t^2=F$.

---

# 6. Chi-square test for one population variance

The scientific question now concerns **variation**, not the mean: *Does an assay's population standard deviation differ from a benchmark of 3 units?*

## Worked example — replicate assay measurements

**Observed data:**

| Replicate | Measurement | Replicate | Measurement |
|---|---:|---|---:|
| 1 | 39 | 6 | 40 |
| 2 | 43 | 7 | 45 |
| 3 | 38 | 8 | 37 |
| 4 | 44 | 9 | 42 |
| 5 | 41 | 10 | 41 |

**Quantities needed for the chi-square statistic:**

| Quantity | Symbol | Value |
|---|---|---:|
| Number of observations | $n$ | 10 |
| Sample mean | $\bar x$ | 41.000 |
| Sum of squared deviations | $\sum(x_i-\bar x)^2$ | 60.000 |
| Sample variance | $s^2=60/9$ | 6.6667 |
| Sample SD | $s$ | 2.5820 |
| Reference SD | $\sigma_0$ | 3.000 |
| Reference variance | $\sigma_0^2$ | 9.000 |
| Degrees of freedom | $n-1$ | 9 |

**Step 1 — hypotheses:** $H_0:\sigma^2=9$; $H_A:\sigma^2\ne9$.

**Step 2 — statistic:** For independent observations from a **normal population**, under $H_0$,

$$
\chi^2=\frac{(n-1)s^2}{\sigma_0^2}
=\frac{9(6.6667)}{9}=6.6667,
\qquad\nu=9.
$$

**Step 3 — two-sided probability:** The chi-square distribution is asymmetric. Use twice the smaller tail probability:

$$
p=2\min\{P(\chi^2_9\le6.6667),P(\chi^2_9\ge6.6667)\}
\approx0.6564.
$$

**Step 4 — decision:** $p>0.05$; **do not reject $H_0$**. There is insufficient evidence that the population SD differs from 3. The two-sided 5% rejection boundaries are approximately **2.700** and **19.023** for the chi-square statistic.

This test is **sensitive to non-normality and outliers**. It is different from the chi-square test for categorical counts in Sections 9–10.

### A. Manual one-sample chi-square variance test

```r
# 06_ChiSquareVariance_manual.R — base R only
x <- c(39, 43, 38, 44, 41, 40, 45, 37, 42, 41)
sigma0 <- 3
alpha <- 0.05

n <- length(x)
df <- n - 1
s2 <- var(x)
chi2_stat <- df * s2 / sigma0^2
p_lower <- pchisq(chi2_stat, df = df)
p_upper <- pchisq(chi2_stat, df = df, lower.tail = FALSE)
p_value <- min(1, 2 * min(p_lower, p_upper))

print(c(sample_variance = s2, chi_square = chi2_stat,
        df = df, p_value = p_value))
print(qchisq(c(alpha / 2, 1 - alpha / 2), df = df))

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

### B. One-sample variance test using `EnvStats::varTest()`

Base R has no dedicated one-sample `var.test()` function; `var.test()` compares **two** variances. For a single variance, the **EnvStats** package provides `varTest()` (install once using `install.packages("EnvStats")`).

```r
# 06_ChiSquareVariance_Rtest.R — requires EnvStats
# install.packages("EnvStats")  # Run once, if needed
x <- c(39, 43, 38, 44, 41, 40, 45, 37, 42, 41)
sigma0 <- 3
alpha <- 0.05

result <- EnvStats::varTest(x, sigma.squared = sigma0^2,
                            alternative = "two.sided")
print(result)
p_value <- result$p.value

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

---

# 7. F-test for comparing two variances

An **F-test for two variances** asks whether two independent normal populations have the same variability. This differs from the **ANOVA F-test**, which compares population means.

## Worked example — insect counts in two traps

Suppose the following insect counts come from independent sampling occasions.

**Observed data:**

| Occasion | Trap 1 | Trap 2 |
|---|---:|---:|
| 1 | 41 | 52 |
| 2 | 35 | 57 |
| 3 | 33 | 62 |
| 4 | 36 | 55 |
| 5 | 40 | 64 |
| 6 | 46 | 57 |
| 7 | 31 | 56 |
| 8 | 37 | 55 |
| 9 | 34 | 60 |
| 10 | 30 | 59 |
| 11 | 38 | — |

Rows are **not paired**; the second trap has only ten observations.

**Quantities needed for the F-statistic:**

| Quantity | Trap 1 | Trap 2 |
|---|---:|---:|
| Sample size | 11 | 10 |
| Sample mean | 36.455 | 57.700 |
| Sample variance | 21.8727 | 12.9000 |
| Sample SD | 4.6768 | 3.5917 |
| Degrees of freedom | 10 | 9 |

**Step 1 — hypotheses:** $H_0:\sigma_1^2=\sigma_2^2$; $H_A:\sigma_1^2\ne\sigma_2^2$.

**Step 2 — statistic:**

$$
F=\frac{s_1^2}{s_2^2}=\frac{21.8727}{12.9}\approx1.6956,
\qquad(\nu_1,\nu_2)=(10,9).
$$

**Step 3 — two-sided p-value:**

$$
p=2\min\{P(F_{10,9}\le1.6956),P(F_{10,9}\ge1.6956)\}
\approx0.4401.
$$

**Step 4 — decision:** $p>0.05$; **do not reject $H_0$**. There is insufficient evidence of different population variances. This test assumes independent samples and approximately normal populations; **insect counts may not meet the normality assumption**, so the example is for illustrating the calculation.

### A. Manual F-test for two variances

```r
# 07_Ftest_manual.R — base R only
trap1 <- c(41, 35, 33, 36, 40, 46, 31, 37, 34, 30, 38)
trap2 <- c(52, 57, 62, 55, 64, 57, 56, 55, 60, 59)
alpha <- 0.05

v1 <- var(trap1)
v2 <- var(trap2)
df1 <- length(trap1) - 1
df2 <- length(trap2) - 1
F_stat <- v1 / v2
p_lower <- pf(F_stat, df1 = df1, df2 = df2)
p_upper <- pf(F_stat, df1 = df1, df2 = df2, lower.tail = FALSE)
p_value <- min(1, 2 * min(p_lower, p_upper))

print(c(variance1 = v1, variance2 = v2, F = F_stat,
        df1 = df1, df2 = df2, p_value = p_value))

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

### B. F-test using `var.test()`

```r
# 07_Ftest_Rtest.R — base R only
trap1 <- c(41, 35, 33, 36, 40, 46, 31, 37, 34, 30, 38)
trap2 <- c(52, 57, 62, 55, 64, 57, 56, 55, 60, 59)
alpha <- 0.05

result <- var.test(trap1, trap2, alternative = "two.sided")
print(result)
p_value <- result$p.value

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

If the larger sample variance is placed in the numerator manually, its degrees of freedom must move with it. The R function already handles both tails without this rearrangement.

---

# 8. Levene's test for comparing variances

**Levene's test** compares variation across groups with less reliance on normality than the classical variance-ratio F-test. A common version, the **Brown–Forsythe test**, first calculates the absolute distance of each observation from its **group median**:

$$
D_{ij}=|X_{ij}-\widetilde X_j|.
$$

Then it performs a one-way ANOVA on these **absolute deviations**. Although it uses an F-statistic, the target is **equality of variability**, not equality of the original group means.

## Worked example — greenhouse versus garden variability

We reuse the **independent** greenhouse and garden measurements from Section 4. First, consider the **original observations**, before applying any transformation. The rows do not represent pairs.

**Observed data:**

| Observation | Greenhouse | Garden |
|---|---:|---:|
| 1 | 69.3 | 69.5 |
| 2 | 75.5 | 64.6 |
| 3 | 81.0 | 74.0 |
| 4 | 74.7 | 84.8 |
| 5 | 72.3 | 71.0 |
| 6 | 70.7 | 93.9 |
| 7 | 76.9 | 81.2 |
| 8 | — | 73.4 |
| 9 | — | 88.0 |

**Step 1 — calculate deviations:** The greenhouse median is $74.7$, and the garden median is $74.0$. Subtract the appropriate group's median from each observation, then take the absolute value.

| Observation | Greenhouse deviation $|X-74.7|$ | Garden deviation $|X-74.0|$ |
|---|---:|---:|
| 1 | 5.4 | 4.5 |
| 2 | 0.8 | 9.4 |
| 3 | 6.3 | 0.0 |
| 4 | 0.0 | 10.8 |
| 5 | 2.4 | 3.0 |
| 6 | 4.0 | 19.9 |
| 7 | 2.2 | 7.2 |
| 8 | — | 0.6 |
| 9 | — | 14.0 |

Now the **absolute deviations** (not the original measurements) are the inputs to the ANOVA calculation.

| Quantity | Greenhouse | Garden |
|---|---:|---:|
| Number of deviations | 7 | 9 |
| Group median (original data) | 74.700 | 74.000 |
| Mean absolute deviation | 3.0143 | 7.7111 |

The **grand mean of the 16 absolute deviations** is 5.65625.

**Step 2 — hypotheses:** $H_0$: the population variances are equal; $H_A$: they differ.

**Step 3 — between/within sums of squares of deviations:**

$$
SS_{\mathrm{between,dev}}\approx86.8619,\qquad
SS_{\mathrm{within,dev}}\approx375.7975.
$$

**Step 4 — F-statistic:** There are two groups and 16 observations:

$$
F=\frac{86.8619/(2-1)}{375.7975/(16-2)}\approx3.2360,
\qquad (\nu_1,\nu_2)=(1,14).
$$

**Step 5 — p-value:** $P(F_{1,14}\ge3.2360)\approx0.0936$.

**Step 6 — decision:** $p>0.05$; **do not reject $H_0$**. The observed garden spread is larger, but this sample does not give sufficient evidence of differing population variances. Not rejecting does **not prove equality of variances**.

### A. Manual Brown–Forsythe test

```r
# 08_Levene_manual.R — base R only
greenhouse <- c(69.3, 75.5, 81.0, 74.7, 72.3, 70.7, 76.9)
garden <- c(69.5, 64.6, 74.0, 84.8, 71.0,
            93.9, 81.2, 73.4, 88.0)
alpha <- 0.05

groups <- list(Greenhouse = greenhouse, Garden = garden)
deviations <- lapply(groups, function(x) abs(x - median(x)))
n_j <- sapply(deviations, length)
dev_means <- sapply(deviations, mean)
all_deviations <- unlist(deviations)
grand_mean <- mean(all_deviations)
N <- length(all_deviations)
k <- length(deviations)

SS_between <- sum(n_j * (dev_means - grand_mean)^2)
SS_within <- sum(sapply(deviations, function(x) sum((x - mean(x))^2)))
F_stat <- (SS_between / (k - 1)) / (SS_within / (N - k))
p_value <- pf(F_stat, df1 = k - 1, df2 = N - k,
              lower.tail = FALSE)

print(c(SS_between = SS_between, SS_within = SS_within,
        F = F_stat, p_value = p_value))

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

### B. Brown–Forsythe test using `car::leveneTest()`

The `car` package provides a direct `leveneTest()` function. Set `center = median` to use the Brown–Forsythe version (install once using `install.packages("car")`).

```r
# 08_Levene_Rtest.R — requires the car package
# install.packages("car")  # Run once, if needed
greenhouse <- c(69.3, 75.5, 81.0, 74.7, 72.3, 70.7, 76.9)
garden <- c(69.5, 64.6, 74.0, 84.8, 71.0,
            93.9, 81.2, 73.4, 88.0)
alpha <- 0.05

measurement <- c(greenhouse, garden)
group <- factor(rep(c("Greenhouse", "Garden"),
                    times = c(length(greenhouse), length(garden))))
result <- car::leveneTest(measurement ~ group, center = median)
print(result)
p_value <- result[["Pr(>F)"]][1]

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

**Base R alternative:** `summary(aov(abs(measurement - ave(measurement, group, FUN = median)) ~ group))` performs the same median-centered calculation without installing `car`. Independence remains important, and the test is not immune to all non-normality or outliers.

---

# 9. Chi-square goodness-of-fit test for categorical data

A **chi-square goodness-of-fit test** compares observed counts in **one categorical variable** with counts expected under specified category probabilities.

## Worked example — bird sightings across four habitats

Suppose there are 20 independent bird sightings and, under $H_0$, each of the four habitats is equally likely to contain a sighting. For this illustrative example, assume comparable observation effort across habitats.

**Observed data:** The four habitat counts, prior to any expected-value calculation, are:

| Habitat | Observed count $O_i$ |
|---|---:|
| Forest | 1 |
| Tree canopy | 0 |
| Lawn | 1 |
| Pond | 18 |
| **Total** | **20** |

**Quantities needed for the chi-square test statistic:** Under the specified null model, every habitat has probability $p_i=0.25$ and hence expected count $E_i=20(0.25)=5$.

| Habitat | Null probability $p_i$ | Observed $O_i$ | Expected $E_i$ | Contribution $(O_i-E_i)^2/E_i$ |
|---|---:|---:|---:|---:|
| Forest | 0.25 | 1 | 5 | 3.2 |
| Tree canopy | 0.25 | 0 | 5 | 5.0 |
| Lawn | 0.25 | 1 | 5 | 3.2 |
| Pond | 0.25 | 18 | 5 | 33.8 |
| **Total** | **1.00** | **20** | **20** | **45.2** |

Notice that **expected counts**, rather than observed counts, determine whether the chi-square approximation is appropriate.

**Step 1 — hypotheses:** $H_0:p_i=0.25$ for all four habitats; $H_A$: not all the probabilities are 0.25.

**Step 2 — expected counts:** $E_i=np_i=20(0.25)=5$ in every habitat.

**Step 3 — statistic:**

$$
\chi^2=\sum_{i=1}^k\frac{(O_i-E_i)^2}{E_i}
=3.2+5.0+3.2+33.8=45.2.
$$

**Step 4 — degrees of freedom and p-value:** With $k=4$ fully specified category probabilities, $\nu=k-1=3$ and the right-tail $p\approx8.39\times10^{-10}$.

**Step 5 — decision:** **Reject $H_0$**. Sightings differ strongly from an equal-probability model. This does not establish why, since unequal survey effort or other environmental variables could explain some differences.

The chi-square approximation is reasonable here because the **expected** count is 5 in every category, even though one **observed** count is zero. Independent observations and mutually exclusive categories are also required.

### A. Manual goodness-of-fit test

```r
# 09_GoodnessOfFit_manual.R — base R only
observed <- c(Forest = 1, TreeCanopy = 0, Lawn = 1, Pond = 18)
p0 <- c(0.25, 0.25, 0.25, 0.25)
alpha <- 0.05

N <- sum(observed)
expected <- N * p0
contribution <- (observed - expected)^2 / expected
chi2_stat <- sum(contribution)
df <- length(observed) - 1
p_value <- pchisq(chi2_stat, df = df, lower.tail = FALSE)

print(data.frame(observed = observed, expected = expected,
                 contribution = contribution))
print(c(chi_square = chi2_stat, df = df, p_value = p_value))

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

### B. Goodness-of-fit test using `chisq.test()`

```r
# 09_GoodnessOfFit_Rtest.R — base R only
observed <- c(Forest = 1, TreeCanopy = 0, Lawn = 1, Pond = 18)
p0 <- c(0.25, 0.25, 0.25, 0.25)
alpha <- 0.05

result <- chisq.test(observed, p = p0)
print(result)
print(result$expected)
p_value <- result$p.value

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}

barplot(rbind(Observed = observed, Expected = result$expected),
        beside = TRUE, legend.text = TRUE,
        ylab = "Number of sightings")
```

When expected counts are too small, consider an exact or simulation-based approach rather than relying on the asymptotic chi-square approximation.

---

# 10. Chi-square test of independence

A **chi-square test of independence** asks whether **two categorical variables** are associated. Unlike goodness of fit, its expected counts are calculated from the **row and column totals** of a contingency table.

## Worked example — treatment and response

Suppose 30 individuals are observed in each treatment group.

**Observed data:**

| Treatment | Responder | Nonresponder | Row total |
|---|---:|---:|---:|
| Control | 18 | 12 | 30 |
| Drug | 8 | 22 | 30 |
| **Column total** | **26** | **34** | **60** |

**Step 1 — hypotheses:** $H_0$: treatment and response are independent; $H_A$: treatment and response are associated.

**Step 2 — calculate the quantities needed for the chi-square statistic: expected counts under independence.**

$$
E_{ij}=\frac{(\text{row total}_i)(\text{column total}_j)}{\text{grand total}}.
$$

For control responders, $E=30(26)/60=13$. The other expected counts follow in the same way.

| Treatment/outcome | Observed $O_{ij}$ | Expected $E_{ij}$ | $(O_{ij}-E_{ij})^2/E_{ij}$ |
|---|---:|---:|---:|
| Control, responder | 18 | 13 | 1.9231 |
| Control, nonresponder | 12 | 17 | 1.4706 |
| Drug, responder | 8 | 13 | 1.9231 |
| Drug, nonresponder | 22 | 17 | 1.4706 |
| **Total** | **60** | **60** | **6.7873** |

**Step 3 — statistic:**

$$
\chi^2=\sum_{i,j}\frac{(O_{ij}-E_{ij})^2}{E_{ij}}
=1.9231+1.4706+1.9231+1.4706\approx6.7873.
$$

**Step 4 — degrees of freedom and p-value:** For an $r\times c=2\times2$ table, $\nu=(r-1)(c-1)=1$. The right-tail $p\approx0.00918$.

**Step 5 — decision:** $p<0.05$, so **reject $H_0$**. The response proportions differ between treatment groups (18/30 in control versus 8/30 in drug). This establishes an **association** in these illustrative data, not necessarily a causal effect.

The calculations use the **uncorrected Pearson chi-square statistic**. Use `correct = FALSE` in R to match the hand calculation: R's default for a $2\times2$ table applies Yates's continuity correction.

### A. Manual chi-square independence test

```r
# 10_Independence_manual.R — base R only
counts <- matrix(c(18, 12,
                   8, 22),
                 nrow = 2, byrow = TRUE,
                 dimnames = list(Treatment = c("Control", "Drug"),
                                 Outcome = c("Responder", "Nonresponder")))
alpha <- 0.05

row_totals <- rowSums(counts)
col_totals <- colSums(counts)
N <- sum(counts)
expected <- outer(row_totals, col_totals) / N
contribution <- (counts - expected)^2 / expected
chi2_stat <- sum(contribution)
df <- (nrow(counts) - 1) * (ncol(counts) - 1)
p_value <- pchisq(chi2_stat, df = df, lower.tail = FALSE)

print(counts)
print(expected)
print(contribution)
print(c(chi_square = chi2_stat, df = df, p_value = p_value))

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

### B. Independence test using `chisq.test()`

```r
# 10_Independence_Rtest.R — base R only
counts <- matrix(c(18, 12,
                   8, 22),
                 nrow = 2, byrow = TRUE,
                 dimnames = list(Treatment = c("Control", "Drug"),
                                 Outcome = c("Responder", "Nonresponder")))
alpha <- 0.05

result <- chisq.test(counts, correct = FALSE)
print(result)
print(result$expected)
p_value <- result$p.value

if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

For sparse $2\times2$ tables with small expected counts, consider **Fisher's exact test** (`fisher.test(counts)`) instead of the approximate chi-square test.

---

# 11. Choosing the appropriate test

Select a test by asking **what the scientific question concerns**, how the observations were collected, and which assumptions are reasonable. Do **not** choose a test on the basis of which one produces the smallest p-value.

| Scientific question | Test | Main condition | R test function |
|---|---|---|---|
| Is one mean equal to a reference value? | Z-test | Population SD known | `BSDA::zsum.test()` (summary data) |
| Is one mean equal to a reference value? | One-sample t-test | Unknown population SD; independent data | `t.test(x, mu = mu0)` |
| Do two independent means differ? | Welch's t-test | Independent groups; unequal variances allowed | `t.test(x, y)` |
| Do two independent means differ, assuming equal variances? | Pooled t-test | Independent groups; equal population variances | `t.test(x, y, var.equal = TRUE)` |
| Did individuals change between repeated measurements? | Paired t-test | Matched observations; differences approximately normal | `t.test(after, before, paired = TRUE)` |
| Do three or more independent means differ? | One-way ANOVA | Similar population variances; approximately normal errors | `aov()` |
| Do three or more independent means differ, with unequal variances? | Welch's ANOVA | Independent groups; unequal variances allowed | `oneway.test()` |
| Which pairs differ after ordinary ANOVA? | Tukey's HSD | Standard ANOVA assumptions | `TukeyHSD()` |
| Does one population variance equal a reference value? | One-sample chi-square variance test | Normal population | `EnvStats::varTest()` |
| Do two population variances differ? | Two-sample F-test | Two independent normal populations | `var.test()` |
| Do group variances differ under a less normality-sensitive method? | Levene/Brown–Forsythe | Independent observations | `car::leveneTest()` |
| Do observed categorical counts follow specified probabilities? | Chi-square goodness of fit | Adequate expected counts; independent observations | `chisq.test(observed, p = p0)` |
| Are two categorical variables associated? | Chi-square independence test | Adequate expected cell counts | `chisq.test(counts)` |

**Important distinctions:** A test of a **mean** is not a test of a **variance**. The ANOVA F-statistic is not the same analysis as the **two-variance F-test**. The chi-square test for **one variance** is not the same analysis as the chi-square tests for **categorical counts**.

For each test, report the **scientific question**, **hypotheses**, **test statistic**, **degrees of freedom** (where applicable), **p-value**, **decision at the chosen $\alpha$**, and a conclusion in biological terms. Report uncertainty and effect size where useful. **Failure to reject $H_0$ is not proof of equality.**

