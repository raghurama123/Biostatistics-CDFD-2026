# Biostatistics-CDFD-2026

A Biostatistics course offered to PhD students at [_BRIC-Centre for DNA Fingerprinting and Diagnostics - CDFD_](https://www.cdfd.org.in/) during August-December 2026. 

## Lecture notes
Read the lecture notes here: [**https://raghurama123.github.io/Biostatistics-CDFD-2026/**](https://raghurama123.github.io/Biostatistics-CDFD-2026/)

Additional content will be added as the course progresses.

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

## How to do various things in R programming? 

The [`HowToR`](HowToR/) folder contains short manuals and examples explaining how to perform various tasks in **R**. 

## General reference

The main general reference for the course is the online book:

**[Modern Statistics for Modern Biology](https://www.huber.embl.de/msmb/)**
Susan Holmes and Wolfgang Huber    

The book provides a modern introduction to statistical thinking and data analysis for biological applications, with extensive use of R.

## Contact
Raghunathan Ramakrishnan     
Tata Institute of Fundamental Research Hyderabad, India     
Email: ramakrishnan@tifr.res.in
