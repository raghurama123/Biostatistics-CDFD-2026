# Biostatistics-CDFD-2026

A Biostatistics course offered to PhD students at [_BRIC-Centre for DNA Fingerprinting and Diagnostics - CDFD_](https://www.cdfd.org.in/) during August-December 2026. 

Course materials, R scripts, examples, and notes for the **Biostatistics 2026** course.

The repository is organized lecture-wise. Each lecture folder contains the corresponding R scripts, data files, and lecture notes.

## Repository structure

```text
Biostatistics-CDFD-2026/
│
├── README.md
│
└── Lec01/
|   ├── Lec01.md
|   ├── Rbasics.R
|   ├── ...
└── Lec02/
|   ├── ...
```

Additional lecture folders will be added as the course progresses.

## Lecture 01

Lecture 01 introduces R:

[**Lec01/Lec01.md**](https://github.com/raghurama123/Biostatistics-CDFD-2026/tree/main/Lec01/Lec01.md)

1. **R Basics** — basic syntax, variables, vectors, data frames, descriptive statistics, plots, statistical tests, correlation, and linear regression.
2. **Reading data files** — reading CSV/TSV files, inspecting data, selecting rows and columns, modifying data, and saving results.
3. **ggplot2** — introduction to plotting with `ggplot2`, including scatter plots and fitted regression lines.
4. **Bioconductor** — a first example using `Biostrings` to work with DNA sequences.

## Lecture 02

Lecture 02 introduces discrete probability distributions and hypothesis testing using biological examples:

[**Lec02/Lec02.md**](https://github.com/raghurama123/Biostatistics-CDFD-2026/tree/main/Lec02/Lec02.md)

1. **Discrete random variables** — introduction to discrete data, probability distributions, and biological examples involving counts.
2. **Binomial distribution** — modeling repeated independent trials with two possible outcomes, illustrated using coin tosses and implemented in R with `dbinom()` and `pbinom()`.
3. **Expected value and variance** — understanding the expected number of successes, $E[X]=np$, and the variance, $\mathrm{Var}(X)=np(1-p)$, of a binomial random variable.
4. **Central Limit Theorem** — understanding how the binomial distribution approaches a normal distribution when the number of trials is large, leading to the approximation
   $$
   X \approx N\left(np,\;np(1-p)\right).
   $$
5. **Poisson distribution** — modeling counts of rare events and understanding the Poisson approximation to the binomial distribution when $n$ is large and $p$ is small.
6. **HIV mutation example** — modeling the number of mutations in an HIV genome using the binomial distribution and comparing it with the Poisson approximation.
7. **Cumulative probability** — calculating probabilities such as $P(X\leq x)$ by summing individual probabilities and using cumulative distribution functions.
8. **Hypothesis testing** — introducing the null and alternative hypotheses, p-values, significance levels, rejection regions, and left-tailed tests using the HIV mutation example.
9. **Confidence and significance levels** — connecting $\alpha=0.05$ with a corresponding 95% probability level and interpreting significance thresholds in discrete probability distributions.



## How to do various things in R programming? 

The [`HowToR`](HowToR/) folder contains short manuals and examples explaining how to perform various tasks in **R**. 

## General reference

The main general reference for the course is the online book:

**Modern Statistics for Modern Biology**
Susan Holmes and Wolfgang Huber

https://www.huber.embl.de/msmb/

The book provides a modern introduction to statistical thinking and data analysis for biological applications, with extensive use of R and Bioconductor.
