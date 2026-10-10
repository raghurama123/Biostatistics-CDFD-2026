# Biostatistics-CDFD-2026

A Biostatistics course offered to PhD students at _BRIC-Centre for DNA Fingerprinting and Diagnostics - CDFD_ during August-December 2026. 

## Lecture notes

### [**Lecture 01**](https://raghurama123.github.io/Biostatistics-CDFD-2026/Lec01/Lec01.html)

Lecture 01 introduces R:

1. **R Basics** — basic syntax, variables, vectors, data frames, descriptive statistics, plots, statistical tests, correlation, and linear regression.
2. **Reading data files** — reading CSV/TSV files, inspecting data, selecting rows and columns, modifying data, and saving results.
3. **ggplot2** — introduction to plotting with `ggplot2`, including scatter plots and fitted regression lines.
4. **Bioconductor** — a first example using `Biostrings` to work with DNA sequences.

### [**Lecture 02**](https://raghurama123.github.io/Biostatistics-CDFD-2026/Lec02/Lec02.html)

Lecture 02 introduces discrete probability distributions and hypothesis testing using biological examples:

1. **Discrete random variables** — introduction to discrete data, probability distributions, and biological examples involving counts.
2. **Binomial distribution** — modeling repeated independent trials with two possible outcomes, illustrated using coin tosses and implemented in R with `dbinom()` and `pbinom()`.
3. **Poisson distribution** — modeling counts of rare events and understanding the Poisson approximation to the binomial distribution when $n$ is large and $p$ is small.
4. **HIV mutation example** — modeling the number of mutations in an HIV genome using the binomial distribution and comparing it with the Poisson approximation.
5. **Cumulative probability** — calculating probabilities such as $P(X\leq x)$ by summing individual probabilities and using cumulative distribution functions.
6. **Hypothesis testing** — introducing the null and alternative hypotheses, p-values, significance levels, rejection regions, and left-tailed tests using the HIV mutation example.
7. **Confidence and significance levels** — connecting $\alpha=0.05$ with a corresponding 95% probability level and interpreting significance thresholds in discrete probability distributions.

### [**Lecture 03**](https://raghurama123.github.io/Biostatistics-CDFD-2026/Lec03/Lec03.html)

Lecture 03 develops exact binomial hypothesis testing using biological examples:

1. **When to use the binomial distribution** — recognizing situations with a fixed number of independent trials, two possible outcomes per trial, and a constant probability of success.
2. **Null model and observed proportion** — distinguishing between the null probability $p_0$, the unknown underlying probability $p$, the observed proportion $\hat p$, and the expected count $np_0$.
3. **Hypothesis testing and compatibility regions** — interpreting $\alpha=0.05$ as defining an approximately 95% central region of outcomes expected under $H_0$ and rejection regions in the tails.
4. **p-values and the CDF** — calculating left- and right-tailed p-values using cumulative probabilities with `pbinom()` and understanding the connection between the CDF and hypothesis testing.
5. **Exact binomial test in R** — using `binom.test()` for left-tailed, right-tailed, and two-sided tests and extracting the p-value using `result$p.value`.
6. **Mendel's pea experiment** — testing whether the observed proportion of round seeds differs from the Mendelian expectation of $p_0=0.75$.
7. **Allele-specific expression** — testing whether allele-specific sequencing reads deviate from the 50:50 expectation using a two-sided exact binomial test.
8. **EXACT precision-oncology trial** — performing a right-tailed exact binomial test with $\alpha=0.025$ and connecting the p-value with the critical rejection region.

### [**Lecture 04**](https://raghurama123.github.io/Biostatistics-CDFD-2026/Lec04/Lec04.html)

Lecture 04 introduces inference for a population mean using the normal distribution:

1. **Central Limit Theorem** — understanding the sampling distribution of the sample mean and the standard error $\sigma/\sqrt{n}$.
2. **Standard normal distribution** — standardizing sample means using the Z-score and calculating probabilities with `pnorm()`.
3. **Confidence intervals and critical values** — using standard normal critical values to construct confidence intervals for a population mean.
4. **Sample size for a fixed confidence interval** — estimating the sample size required for a chosen confidence level and margin of error, including the use of prior or pilot estimates of variability.
5. **One-sample Z-test** — testing a population mean when the population standard deviation is known, including left-tailed, right-tailed, and two-tailed tests.
6. **Statistical decisions and errors** — relating true positives, true negatives, false positives, and false negatives to hypothesis-testing decisions.
7. **Type I and Type II errors** — interpreting $\alpha$ and $\beta$ as the probabilities of false-positive and false-negative decisions.
8. **Statistical power** — defining power as $1-\beta$ and examining how effect size, sample size, variability, and significance level affect power.

### [**Lecture 05**](https://raghurama123.github.io/Biostatistics-CDFD-2026/Lec05/Lec05.html)

Lecture 05 extends hypothesis testing beyond the Z-test to compare population means, variances, and categorical data:

1. **Recap of the Z-test** — reviewing hypothesis testing for a population mean when the population standard deviation $\sigma$ is known.
2. **Student's t-distribution** — understanding why the t-distribution is used when $\sigma$ is unknown, how it differs from the normal distribution, and the role of degrees of freedom.
3. **One-sample t-test** — testing whether a population mean differs from a specified value using `t.test()`, illustrated by comparing crab body temperature with lake water temperature.
4. **Two-sample t-tests** — comparing means from independent samples using Welch's or pooled t-tests, and comparing paired observations using a paired t-test.
5. **Analysis of Variance (ANOVA)** — comparing means across three or more groups using the F-statistic, performing one-way ANOVA with `aov()`, and identifying differences between groups using Tukey's post-hoc test.
6. **Chi-square test for one variance** — testing whether a population variance differs from a specified value using the chi-square distribution.
7. **F-test for two variances** — comparing variability between two populations using the F-distribution and `var.test()`.
8. **Levene's test** — testing whether groups have equal variances using a method less sensitive to departures from normality.
9. **Chi-square goodness-of-fit test** — comparing observed categorical counts with expected frequencies under a hypothesized probability distribution using `chisq.test()`.
10. **Chi-square test of independence** — testing whether two categorical variables are associated using contingency tables and `chisq.test()`, with Fisher's exact test as an alternative for sparse tables.
11. **Choosing the appropriate statistical test** — selecting a test based on the scientific question, data type, number of groups, study design, and statistical assumptions.

_Additional content will be added as the course progresses._

## Repository 

The repository [https://github.com/raghurama123/Biostatistics-CDFD-2026](https://github.com/raghurama123/Biostatistics-CDFD-2026) contains R scripts, data, and notes.

The repository is organized lecture-wise. Each lecture folder contains the corresponding R scripts, data files, and lecture notes.

```text
Biostatistics-CDFD-2026/
│
├── README.md
│
└── Lec01/
|   ├── Lec01.md
|   ├── Lec01.html
|   ├── Rbasics.R
|   ├── ...
└── Lec02/
|   ├── ...
```


## Interactive plots

- [Normal distribution](https://raghurama123.github.io/Biostatistics-CDFD-2026/interactive_plots/NormalDistribution.html)
- [Binomial distribution](https://raghurama123.github.io/Biostatistics-CDFD-2026/interactive_plots/BinomialDistribution.html)
- [Hypothesis testing, Type-I/Type-II errors, power  using Z-test](https://raghurama123.github.io/Biostatistics-CDFD-2026/interactive_plots/HypothesisTestingZtest.html)

## How to do various things in R programming? 

The [`HowToR`](HowToR/) folder contains short manuals and examples explaining how to perform various tasks in **R**. 

## General references

1. Biostatistical Analysis, Jerrold H. Zar, Ed. 5, Pearson Education (2014)  
2. **[Modern Statistics for Modern Biology](https://www.huber.embl.de/msmb/)** by Susan Holmes and Wolfgang Huber   

## Contact
Raghunathan Ramakrishnan     
Tata Institute of Fundamental Research Hyderabad, India     
Email: ramakrishnan@tifr.res.in
