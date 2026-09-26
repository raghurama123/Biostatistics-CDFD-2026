<table style="width:100%; border:none;">
<tr>

<td style="width:33%; text-align:left; border:none;">
<a href="../Lec02/Lec02.html"><strong>← Previous Lecture</strong></a>
</td>

<td style="width:34%; text-align:center; border:none;">
<a href="../"><strong>Home</strong></a>
</td>

<td style="width:33%; text-align:right; border:none;">
<a href="../Lec04/Lec04.html"><strong>Next Lecture →</strong></a>
</td>

</tr>
</table>

# Lecture 03 — Exact Binomial Tests in Biostatistics

In this lecture we first summarize the general logic of an **exact binomial test** and then apply it to three biological examples:

1. Mendel's pea experiments;
2. allele-specific expression;
3. the EXACT precision-oncology trial.

[1. Review of the Exact Binomial Test](#1-review-of-the-exact-binomial-test)  
[2. Exact Binomial Test in R](#2-exact-binomial-test-in-r)  
[3. Problem 1: Mendel's Pea Experiments](#3-problem-1-mendels-pea-experiments)  
[4. Problem 2: Allele-Specific Expression](#4-problem-2-allele-specific-expression)  
[5. Problem 3: Precision Oncology — The EXACT Trial](#5-problem-3-precision-oncology--the-exact-trial)  
[6. Comparing the Three Problems](#6-comparing-the-three-problems)  

---

# 1. Review of the Exact Binomial Test

## When is a binomial distribution suitable?

A binomial distribution is suitable when the same type of trial is repeated and each trial has only **two possible outcomes**.

Examples include:

```text
round seed       / wrinkled seed

allele A read    / allele B read

benefit          / no benefit

mutation         / no mutation

positive         / negative

survived         / did not survive
```

The two outcomes are often called

```text
success
failure
```

For example, in Mendel's experiment:

```text
success = round seed
failure = wrinkled seed
```

A binomial model requires four main conditions:

1. the experiment consists of a known number of trials, $n$
2. each trial has two possible outcomes
3. each trial has the same probability of success, $p$
4. the trials are independent

Under these conditions, if 
$$
X=\text{number of successes among the }n\text{ trials},
$$

then

$$
X\sim\mathrm{Binomial}(n,p).
$$

---

## From a binomial model to a hypothesis test

Suppose we observe the number of successes among $n$ independent trials.

Let

$$
X=\text{number of successes}.
$$

If each trial has the same probability of success $p$, then

$$
X\sim\mathrm{Binomial}(n,p).
$$

This probability $p$ is generally unknown.

A hypothesis test compares the data with a specified reference value

$$
p_0.
$$

The value $p_0$ is the probability specified by the null hypothesis. It is **not necessarily estimated from the current data**, and it does **not** have to come from an earlier experiment with the same sample size $n$.

Depending on the problem, $p_0$ may come from:

* a theoretical model;
* previous experiments or published evidence;
* prior scientific knowledge;
* a predefined benchmark used in the study design.

For example, in Mendel's pea experiment,

$$
p_0=0.75
$$

comes from the Mendelian $3:1$ model, not from the 7324 observed seeds.

The current experiment supplies

$$
n
$$

and

$$
x_{\mathrm{obs}},
$$

while $p_0$ specifies the probability to be tested.

Thus:

```text
p0        reference probability specified by H0

n         number of trials in the current experiment

x_obs     observed number of successes in the current experiment
```

The null distribution is then constructed by combining the current sample size $n$ with the null probability $p_0$:

$$
\boxed{
X\sim\mathrm{Binomial}(n,p_0)
}
$$

So $n$ and $p_0$ play different roles:

```text
p0        specifies the success probability under H0

n         determines how many trials are in the binomial experiment

n + p0    together determine the null binomial distribution
```

The null hypothesis is usually written as

$$
H_0:p=p_0.
$$

Under $H_0$,

$$
X\sim\mathrm{Binomial}(n,p_0).
$$

This distribution describes the counts that could occur because of random variation if the null hypothesis were true.

---

## The observed success count and proportion

If we observe

$$
x_{\mathrm{obs}}
$$

successes among

$$
n
$$

trials, the observed proportion is

$$
\hat p=\frac{x_{\mathrm{obs}}}{n}.
$$

The observed proportion is an estimate calculated from the sample.

It is different from

$$
p_0,
$$

which is the probability specified by the null hypothesis.

Thus:

```text
p0        probability specified by H0

p-hat     proportion observed in the sample

p-value   probability calculated under H0
```

These are three different quantities.

---

## Expected number of successes under $H_0$

Under the null hypothesis,

$$
E[X]=np_0.
$$

The observed count can be compared with this expected value.

However, simply finding that

$$
x_{\mathrm{obs}}\ne np_0
$$

does not show that the null hypothesis is wrong.

Even when $H_0$ is true, random sampling variation causes the observed number of successes to vary from experiment to experiment.

The hypothesis test therefore asks a different question:

> **How unusual is the observed result, or a result still more extreme, if $H_0$ is true?**

Another useful way to think about the same question is:

> **Does the new observation fall within the range of results that we would commonly expect if $H_0$ were true, or does it fall in an unusually extreme part of the distribution?**

---

## The 95-out-of-100 interpretation

Suppose we use a two-sided test with

$$
\alpha=0.05.
$$

Imagine that the null hypothesis is true and that we could repeat the same experiment many times.

Because of random variation, each repetition would give a slightly different number of successes.

Conceptually, the null distribution can be divided into:

```text
unusually low          results compatible          unusually high
   results                  with H0                    results

     tail               central region                  tail
      |                       |                          |
      v                       v                          v

   about 2.5%             about 95%                 about 2.5%
```

So, approximately:

> **If $H_0$ is true, about 95 out of 100 repeated experiments would give results in the central, non-rejection region, while about 5 out of 100 would give results sufficiently extreme to fall in the tails.**

The central region can therefore be thought of informally as a **compatibility window** for the null model.

```text
inside the compatibility window
        -> result is not unusually different from H0
        -> do not reject H0

outside the compatibility window
        -> result is unusually extreme under H0
        -> reject H0
```

However, this idea needs two important qualifications.

First, the test is about the **observed count**

$$
X
$$

or equivalently the observed proportion

$$
\hat p=\frac{X}{n}.
$$

It is not saying that there is a 95% probability that $H_0$ is true.

Second, the binomial distribution is discrete. Therefore, the probability in the central region cannot always be exactly 95%, because the boundaries must occur at integer counts. The actual non-rejection probability may be slightly greater than 95%.

Thus, instead of asking

> "Is the new observed proportion exactly equal to $p_0$?"

we ask

> **"Is the observed count or observed proportion within the range of random variation that we would normally expect if $p=p_0$?"**

This is the basic logic used in all three examples in this lecture.

---

## Choosing the alternative hypothesis

The scientific question determines the alternative hypothesis.

| Scientific question | Alternative hypothesis | Type of test | R |
|---|---|---|---|
| Is $p$ smaller than $p_0$? | $H_A:p<p_0$ | left-tailed | `"less"` |
| Is $p$ larger than $p_0$? | $H_A:p>p_0$ | right-tailed | `"greater"` |
| Is $p$ different from $p_0$? | $H_A:p\ne p_0$ | two-sided | `"two.sided"` |

The alternative hypothesis should be chosen from the scientific question, not from the direction seen in the data after the experiment.

---

## $p$-value and the cumulative distribution function

Under the null hypothesis,

$$
H_0:p=p_0,
$$

the number of successes follows

$$
X\sim\mathrm{Binomial}(n,p_0).
$$

The **cumulative distribution function (CDF)** of this null distribution is

$$
F(x)=P(X\le x\mid H_0).
$$

It gives the probability, assuming $H_0$ is true, of obtaining $x$ successes or fewer.

A **p-value** is calculated from the probability distribution specified by the null hypothesis. For a binomial test,

$$
X\sim\mathrm{Binomial}(n,p_0),
$$

so the null distribution is determined by the **current experiment's sample size** $n$ together with the probability $p_0$ specified by $H_0$.

Importantly, `binom.test()` does not calculate $p_0$ from $x_{\mathrm{obs}}$ and $n$. The value $p_0$ is supplied by the user through the argument

```r
p = p0
```

whereas the observed sample proportion is calculated from the data as

$$
\hat p=\frac{x_{\mathrm{obs}}}{n}.
$$

The p-value then measures the probability, under this null distribution, of obtaining the observed result $x_{\mathrm{obs}}$ or a result farther in the direction specified by the alternative hypothesis $H_A$.


---

## Left-tailed test

For

$$
H_A:p<p_0,
$$

small values of $X$ provide evidence against $H_0$.

If we observe

$$
x_{\mathrm{obs}},
$$

then the p-value is the probability of obtaining the observed value or an even smaller value:

$$
p\text{-value}
=
P(X\le x_{\mathrm{obs}}\mid H_0).
$$

Using the CDF,

$$
\boxed{
p\text{-value}=F(x_{\mathrm{obs}})
}
$$

In R, `pbinom()` calculates the binomial CDF:

```r
pbinom(
  x_obs,
  size = n,
  prob = p0
)
```

For example, if

$$
x_{\mathrm{obs}}=3,
$$

the p-value is

$$
P(X\le3\mid H_0)
=
P(X=0)+P(X=1)+P(X=2)+P(X=3).
$$

So the p-value includes the observed result and all results that are still more extreme in the direction

$$
p<p_0.
$$

---

## Right-tailed test

For

$$
H_A:p>p_0,
$$

large values of $X$ provide evidence against $H_0$.

The p-value is therefore

$$
p\text{-value}
=
P(X\ge x_{\mathrm{obs}}\mid H_0).
$$

Therefore,

$$
P(X\ge x_{\mathrm{obs}})
=
1-P(X\le x_{\mathrm{obs}}-1).
$$

The subtraction of 1 is needed because $X$ is a discrete integer count.

For example, if

$$
x_{\mathrm{obs}}=34,
$$

then

$$
P(X\ge34)
=
1-P(X\le33).
$$

This is because

$$ 
P(X\le33) + P(X\ge34)
=
1.
$$

The CDF gives

$$
F(x)=P(X\le x).
$$

Thus,

$$
\boxed{
p\text{-value}
=
1-F(x_{\mathrm{obs}}-1)
}
$$

In R:

```r
1 - pbinom(
  x_obs - 1,
  size = n,
  prob = p0
)
```

or equivalently,

```r
pbinom(
  x_obs - 1,
  size = n,
  prob = p0,
  lower.tail = FALSE
)
```

---

## Calculating the p-value using `binom.test()`

Instead of calculating the tail probability directly with `pbinom()`, R can perform the complete exact binomial test using

```r
result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "less"
)
```

Here:

```text
x             observed number of successes

n             total number of trials

p             probability specified by H0

alternative   direction of the alternative hypothesis
```

Here, the arguments come from two different sources:

```text
x, n          observed data from the current experiment

p = p0        reference probability specified by H0
```

Thus, `binom.test()` uses $n$ and $p_0$ to construct the null distribution

$$
X\sim\mathrm{Binomial}(n,p_0),
$$

and then evaluates the observed value $x_{\mathrm{obs}}$ within that distribution.

The `alternative` argument determines which results are considered more extreme:

```r
alternative = "less"
```

corresponds to

$$
H_A:p<p_0,
$$

```r
alternative = "greater"
```

corresponds to

$$
H_A:p>p_0,
$$

and

```r
alternative = "two.sided"
```

corresponds to

$$
H_A:p\ne p_0.
$$

`binom.test()` calculates the exact p-value and stores the result in the object `result`.

The p-value can then be extracted using

```r
p_value <- result$p.value
```

and displayed using

```r
print(p_value)
```

Thus, for a left-tailed test,

```r
result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "less"
)

p_value <- result$p.value
```

gives the same tail probability as

```r
pbinom(
  x_obs,
  size = n,
  prob = p0
)
```

Similarly, for a right-tailed test,

```r
result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "greater"
)

p_value <- result$p.value
```

gives

$$
P(X\ge x_{\mathrm{obs}}\mid H_0).
$$

So:

```text
pbinom()      calculates the required cumulative/tail probability directly

binom.test()  performs the complete exact binomial hypothesis test

result$p.value
               extracts the p-value calculated by binom.test()
```

**Useful values stored in `result`:**

| R expression | Meaning |
|---|---|
| `result$p.value` | p-value of the hypothesis test |
| `result$estimate` | estimated success probability, $\hat p=x_{\mathrm{obs}}/n$ |
| `result$conf.int` | confidence interval for the underlying probability $p$ |
| `result$null.value` | probability specified by the null hypothesis, $p_0$ |

Example:

```r
p_value <- result$p.value
p_hat <- result$estimate
conf_int <- result$conf.int
p0_used <- result$null.value
````



---

## Two-sided test

For

$$
H_A:p\ne p_0,
$$

results that are either unusually small **or** unusually large can provide evidence against $H_0$.

In R, use

```r
result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "two.sided"
)

p_value <- result$p.value
```

For an exact two-sided binomial test, the p-value is not generally obtained by simply doubling one tail probability.

Therefore, rather than manually combining CDF values, it is preferable to let

```r
binom.test()
```

perform the exact two-sided calculation.

---

## Summary

For a binomial random variable under $H_0$,

$$
F(x)=P(X\le x\mid H_0).
$$

Therefore:

$$
\boxed{
\begin{aligned}
H_A:p<p_0
&\quad\Rightarrow\quad
p\text{-value}=F(x_{\mathrm{obs}}),\\[4pt]
H_A:p>p_0
&\quad\Rightarrow\quad
p\text{-value}=1-F(x_{\mathrm{obs}}-1).
\end{aligned}
}
$$

In practice, the complete exact test can be performed using

```r
result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "less"   # or "greater" or "two.sided"
)
```

and the p-value obtained using

```r
p_value <- result$p.value
```

The p-value therefore answers the question:

> **Assuming $H_0$ were true, $p$-value is the probability of observing the observed result or a result farther in the direction of $H_A$.**


---

## Significance level and statistical decision

Before performing the test, choose a significance level

$$
\alpha.
$$

A commonly used value is

$$
\alpha=0.05.
$$

For a two-sided test, this means that approximately the most extreme 5% of outcomes under $H_0$ form the rejection regions, while approximately 95% form the central **compatibility region**.

Because the binomial distribution is discrete, these probabilities are not always exactly 5% and 95%.

The decision rule is

$$
\boxed{
p\text{-value}<\alpha
\quad\Longrightarrow\quad
\text{Reject }H_0
}
$$

and

$$
\boxed{
p\text{-value}\ge\alpha
\quad\Longrightarrow\quad
\text{Do not reject }H_0
}
$$

A p-value is **not** the probability that the null hypothesis is true.

It is a probability calculated **assuming that $H_0$ is true**.

---

# 2. Exact Binomial Test in R

The general R template is:

```r
result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "less"   # or "greater" or "two.sided"
)

result
```

The p-value can be extracted using

```r
p_value <- result$p.value

p_value
```

The observed proportion is

```r
p_hat <- x_obs / n

p_hat
```

Choose the significance level:

```r
alpha <- 0.05
```

Then make the decision:

```r
if (p_value < alpha) {
  print("Reject H0")
} else {
  print("Do not reject H0")
}
```

For every problem, follow the same sequence:

1. identify $n$, $x_{\mathrm{obs}}$, and $p_0$;
2. write $H_0$;
3. write $H_A$;
4. determine the direction of the test;
5. calculate $\hat p$ and, when useful, $E[X]=np_0$;
6. perform `binom.test()`;
7. report the p-value;
8. compare the p-value with $\alpha$;
9. state the statistical conclusion in words.

---

# 3. Problem 1: Mendel's Pea Experiments

**Mendel, G.** *Versuche über Pflanzen-Hybriden*. Verhandlungen des naturforschenden Vereines in Brünn **4**, 3–47 (1866).  
   English translation and original numerical results:  
   <https://www.mendelweb.org/Mendel.html>

---

Gregor Mendel studied inheritance in pea plants.

Mendel's seed-shape experiment can be understood using a simple monohybrid cross. Suppose the allele

$$
A
$$

produces the dominant **round** phenotype and

$$
a
$$

produces the recessive **wrinkled** phenotype. If two heterozygous plants are crossed,

$$
Aa \times Aa,
$$

the possible offspring genotypes are

$$
AA,\quad Aa,\quad Aa,\quad aa.
$$

Thus, the expected genotype ratio is

$$
1:2:1.
$$

Because both

$$
AA
$$

and

$$
Aa
$$

have the dominant round phenotype, three of the four possible offspring are expected to be round, while only

$$
aa
$$

is expected to be wrinkled. Therefore, the expected phenotype ratio is

$$
3:1,
$$

and the expected probability of a round seed is

$$
p_0=\frac{3}{4}=0.75.
$$

Here,

$$
p_0=0.75
$$

comes from the **Mendelian genetic model**. It is not calculated from the 7324 seeds observed in the experiment.

The experiment instead provides the sample size and observed number of round seeds:

$$
n=7324,
\qquad
x_{\mathrm{obs}}=5474.
$$

These quantities are then combined with $p_0=0.75$ to define the null distribution

$$
X\sim\mathrm{Binomial}(7324,0.75).
$$

---

In one experiment involving seed shape, he obtained

$$
n=7324
$$

seeds.

Of these,

$$
5474
$$

were round or roundish and

$$
1850
$$

were wrinkled.

According to the Mendelian model, the expected ratio of dominant to recessive phenotypes is

$$
3:1.
$$

Therefore, the expected probability of a round seed is

$$
p_0=\frac{3}{4}=0.75.
$$

We want to test whether the observed proportion of round seeds is **different from** the expected Mendelian probability.

Use

$$
\alpha=0.05.
$$

---

## Step 1: Identify the quantities

A success will be defined as a **round seed**.

Therefore,

$$
n=7324,
$$

$$
x_{\mathrm{obs}}=5474,
$$

and

$$
p_0=0.75.
$$

The observed proportion is

$$
\hat p=
\frac{5474}{7324}
\approx0.7474.
$$

---

## Step 2: State the hypotheses

The null hypothesis is

$$
H_0:p=0.75.
$$

The scientific question asks whether the observed probability is **different from** 0.75.

Therefore,

$$
H_A:p\ne0.75.
$$

This is a **two-sided test**.

---

## Step 3: Compare the observed and expected counts

Under $H_0$,

$$
E[X]=np_0.
$$

Therefore,

$$
E[X]
=
7324\times0.75
=
5493.
$$

We observed

$$
5474
$$

round seeds.

Thus the observed count is

$$
5493-5474=19
$$

below the expected count.

But this difference by itself does not tell us whether the deviation is statistically unusual.

We must compare the observation with the complete binomial distribution expected under $H_0$.

---

## Step 4: Perform the exact binomial test

```r
# Mendel's pea experiment

n <- 7324
x_obs <- 5474
p0 <- 0.75
alpha <- 0.05

result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "two.sided"
)

result
```

Extract the quantities of interest:

```r
p_hat <- x_obs / n
p_value <- result$p.value

p_hat
p_value
```

The observed proportion is approximately

$$
\hat p\approx0.7474.
$$

The exact two-sided p-value is approximately

$$
p\text{-value}\approx0.608.
$$

---

## Step 5: Make the statistical decision

We compare

$$
0.608
$$

with

$$
\alpha=0.05.
$$

Since

$$
0.608>0.05,
$$

we

$$
\boxed{\text{Do not reject }H_0.}
$$

---

## Biological interpretation

The observed proportion of round seeds is slightly smaller than 0.75, but the deviation is not statistically unusual under the Mendelian model.

The data therefore do not provide evidence, at the 5% significance level, that the probability of a round seed differs from

$$
0.75.
$$

This does **not** prove that the probability is exactly 0.75. It means that the observed data are compatible with that value at the chosen significance level.

Using the repeated-sampling interpretation, if

$$
p_0=0.75
$$

were correct and experiments of this size were repeated many times, the number of round seeds would vary from experiment to experiment.

The observed value

$$
x_{\mathrm{obs}}=5474
$$

falls within the range of outcomes that are not unusual under the null model.

In the informal language introduced above, it lies inside the **compatibility window** of the Mendelian model rather than in an extreme rejection region.

---

## Why is comparing 5474 with 5493 not enough?

The expected value

$$
E[X]=5493
$$

is the mean of the null distribution.

It is not the count that must occur in every experiment.

Even if

$$
p=0.75,
$$

repeated experiments would produce counts both below and above 5493.

A hypothesis test therefore measures how unusual the observed deviation is relative to the random variation expected under $H_0$.

---

# 4. Problem 2: Allele-Specific Expression

Zhou *et al.* used an exact binomial test for allele-specific expression in a haplotype-resolved diploid potato genome.

**Zhou, Q., Tang, D., Huang, W., et al.** Haplotype-resolved genome analyses of a heterozygous diploid potato. *Nature Genetics* **52**, 1018–1023 (2020).  
   <https://doi.org/10.1038/s41588-020-0699-x>

---

In a **diploid** organism, most genes are present in two copies, one on each homologous chromosome. Different versions of the same gene are called **alleles**. If the two copies differ at one or more positions, the organism is **heterozygous** at those positions. During **gene expression**, RNA is produced from the gene, and RNA sequencing generates short sequence fragments called **reads**. If a read overlaps a heterozygous position, it may be possible to determine whether that read originated from **allele A** or **allele B**. Such reads are called **allele-specific reads**. By comparing the numbers of reads assigned to the two alleles, we can test for **allele-specific expression**, that is, whether the two alleles are expressed equally or whether one allele contributes more RNA than the other.



Consider a heterozygous diploid organism with two alleles of a gene:

```text
allele A
allele B
```

If the two alleles are expressed equally, an allele-specific sequencing read is expected to originate from allele A with probability

$$
p_0=0.5.
$$

For illustration, suppose that 100 allele-specific reads are obtained:

```text
allele A    68 reads

allele B    32 reads
```

We want to test whether expression of the two alleles is different.

Use

$$
\alpha=0.05.
$$

---

## Step 1: Identify the quantities

Define a success as

> a read originating from allele A.

Then

$$
n=100,
$$

$$
x_{\mathrm{obs}}=68,
$$

and

$$
p_0=0.5.
$$

The observed proportion is

$$
\hat p=
\frac{68}{100}
=
0.68.
$$

---

## Step 2: State the hypotheses

Equal expression corresponds to

$$
H_0:p=0.5.
$$

We are interested in any departure from equal expression, whether allele A is more highly represented or less highly represented.

Therefore,

$$
H_A:p\ne0.5.
$$

This is a **two-sided test**.

---

## Step 3: Expected count under $H_0$

Under equal expression,

$$
E[X]=np_0.
$$

Therefore,

$$
E[X]
=
100\times0.5
=
50.
$$

We observed

$$
68
$$

reads from allele A.

The observed count is therefore well above the expected count of 50, but the hypothesis test is needed to determine whether such a difference could reasonably arise from random variation.

---

## Step 4: Perform the exact binomial test

```r
# Allele-specific expression

n <- 100
x_obs <- 68
p0 <- 0.5
alpha <- 0.05

result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "two.sided"
)

result
```

Extract the observed proportion and p-value:

```r
p_hat <- x_obs / n
p_value <- result$p.value

p_hat
p_value
```

The estimated probability is

$$
\hat p=0.68.
$$

The exact two-sided p-value is approximately

$$
p\text{-value}\approx0.000409.
$$

---

## Step 5: Make the statistical decision

Since

$$
0.000409<0.05,
$$

we

$$
\boxed{\text{Reject }H_0.}
$$

---

## Biological interpretation

The data provide evidence that the two alleles are not equally represented among the allele-specific reads.

Because the observed proportion is

$$
\hat p=0.68,
$$

allele A is over-represented in this sample relative to the

$$
50:50
$$

expectation.

The statistical test provides evidence of unequal allele-specific representation.

In the repeated-sampling picture, if the true probability were really

$$
p_0=0.5,
$$

most repeated samples of 100 reads would produce counts in the central compatibility region around the 50:50 expectation.

An observation of

$$
68
$$

allele-A reads is sufficiently far from the null expectation that it falls in the rejection region at

$$
\alpha=0.05.
$$

Thus, this result is outside the range that we would usually expect from random variation alone under equal allele representation.

Interpreting this as a biological difference in allele-specific expression also requires the assumptions of the analysis to be reasonable. For example, sequencing reads should provide an appropriate measure of expression and systematic mapping or technical biases should not create an artificial imbalance.


---

# 5. Problem 3: Precision Oncology — The EXACT Trial

**Prager, G. W., Unseld, M., Waneck, F., et al.** Results of the extended analysis for cancer treatment (EXACT) trial: a prospective translational study evaluating individualized treatment regimens in oncology. *Oncotarget* **10**, 942–952 (2019).  
<https://doi.org/10.18632/oncotarget.26604>

---

**Precision oncology** aims to select cancer treatments based on the molecular characteristics of an individual patient's tumor. In the EXACT trial, treatment decisions were guided by molecular profiling, and the effectiveness of the individualized treatment was compared with that of the patient's previous treatment. Treatment benefit was assessed using **progression-free survival (PFS)**, <u>the length of time during which the disease does not progress</u>. For each patient, $\mathrm{PFS}_1$ denotes progression-free survival under the individualized treatment (for example, 7 months), while $\mathrm{PFS}_0$ denotes progression-free survival under the previous treatment (for example 4 months). 

A patient was considered to have benefited from this treatment when

$$
\frac{\mathrm{PFS}_1}{\mathrm{PFS}_0}>1,
$$

meaning that progression-free survival was longer under the individualized treatment. 

Each patient can therefore be classified into one of two outcomes: **benefit** or **no benefit**, making the number of patients who benefit suitable for analysis with a binomial model.


The Extended Analysis for Cancer Treatment (**EXACT**) trial investigated individualized cancer treatments selected using molecular profiling.

For each patient, the investigators compared progression-free survival under the individualized treatment,

$$
\mathrm{PFS}_1,
$$

with progression-free survival under the previous treatment,

$$
\mathrm{PFS}_0.
$$

A patient was considered to show benefit when

$$
\frac{\mathrm{PFS}_1}{\mathrm{PFS}_0}>1.
$$

The study tested whether the probability of such a benefit was greater than

$$
p_0=0.40.
$$

> **Note:** The value $p_0=0.40$ is the pre-specified reference probability used in the null hypothesis. It is not calculated from the current observation of 34 successes among 55 patients. In general, a value such as $p_0$ may come from prior evidence, previous studies, a theoretical model, or a predefined study-design benchmark.

Among

$$
55
$$

treated patients,

$$
34
$$

had a progression-free-survival ratio greater than 1.

The study used a one-sided exact binomial test with

$$
\alpha=0.025.
$$

> **Note:** A one-sided test does not always use $\alpha=0.025$.
>
> The significance level $\alpha$ is chosen as part of the study design.
>
> In the earlier left-tailed example we used
>
> $$
> \alpha=0.05,
> $$
>
> so the full 5% rejection probability was placed in one tail.
>
> In the EXACT clinical trial, the investigators instead specified a more stringent one-sided level,
>
> $$
> \alpha=0.025.
> $$
>
> Thus, the direction of the test and the choice of $\alpha$ are separate decisions.

---

## Step 1: Identify the quantities

Define a success as

$$
\frac{\mathrm{PFS}_1}{\mathrm{PFS}_0}>1.
$$

Then

$$
n=55,
$$

$$
x_{\mathrm{obs}}=34,
$$

and

$$
p_0=0.40.
$$

The observed proportion is

$$
\hat p=
\frac{34}{55}
\approx0.618.
$$

---

## Step 2: State the hypotheses

The null hypothesis is

$$
H_0:p=0.40.
$$

The scientific question asks whether the probability of benefit is **greater than** 0.40.

Therefore,

$$
H_A:p>0.40.
$$

This is a **right-tailed test**.

In R:

```r
alternative = "greater"
```

---

## Step 3: Expected number of successes under $H_0$

Under the null hypothesis,

$$
E[X]=np_0.
$$

Therefore,

$$
E[X]
=
55\times0.40
=
22.
$$

The observed number of patients showing benefit was

$$
34,
$$

which is considerably larger than the expected value of 22.

Again, the hypothesis test determines whether this difference is sufficiently unusual under $H_0$.

---

## Step 4: Perform the exact binomial test

```r
# EXACT trial

n <- 55
x_obs <- 34
p0 <- 0.40
alpha <- 0.025

result <- binom.test(
  x = x_obs,
  n = n,
  p = p0,
  alternative = "greater"
)

result
```

Extract the relevant quantities:

```r
p_hat <- x_obs / n
p_value <- result$p.value

p_hat
p_value
```

The observed proportion is approximately

$$
\hat p\approx0.618.
$$

The one-sided exact p-value is approximately

$$
p\text{-value}\approx0.000884.
$$

---

## Step 5: Make the statistical decision

The significance level is

$$
\alpha=0.025.
$$

Since

$$
0.000884<0.025,
$$

we

$$
\boxed{\text{Reject }H_0.}
$$

---

## Interpretation

The data provide evidence, at the one-sided 2.5% significance level, that the probability of obtaining

$$
\frac{\mathrm{PFS}_1}{\mathrm{PFS}_0}>1
$$

is greater than

$$
0.40.
$$

Notice that the statistical conclusion concerns the population probability $p$. It is not simply a statement that

$$
34>22.
$$

The p-value measures how unusual the observed result is under the null distribution.

Here the test is **one-sided** and

$$
\alpha=0.025.
$$

Therefore, the rejection region is placed only in the upper tail.

Conceptually, if $H_0$ were true, approximately 97.5% of repeated results would remain below the rejection boundary, while at most about 2.5% would be sufficiently large to enter the rejection region.

Because the binomial distribution is discrete, the actual rejection probability is slightly smaller than 0.025.

The observed value

$$
X=34
$$

lies in that upper-tail rejection region.

---

## Critical region

The investigators specified that the null hypothesis would be rejected if at least 30 of the 55 patients showed a progression-free-survival ratio greater than 1.

That rejection region is

$$
X\ge30.
$$

To calculate its probability under $H_0$:

```r
1 - pbinom(
  29,
  size = 55,
  prob = 0.40
)
```

This calculates

$$
P(X\ge30\mid n=55,p_0=0.40).
$$

The probability is approximately

$$
0.0204.
$$

Since

$$
0.0204<0.025,
$$

the region

$$
X\ge30
$$

has probability less than the chosen significance level under $H_0$.

---

## Why is 30 the critical value?

Now consider one count lower:

$$
X\ge29.
$$

In R:

```r
1 - pbinom(
  28,
  size = 55,
  prob = 0.40
)
```

This probability is approximately

$$
0.0379.
$$

Therefore,

$$
P(X\ge29\mid H_0)
>
0.025,
$$

whereas

$$
P(X\ge30\mid H_0)
<
0.025.
$$

Thus the smallest integer count that gives a right-tail probability no larger than the significance level is

$$
\boxed{30}.
$$

The rejection region is therefore

$$
\boxed{X\ge30}.
$$

This also illustrates the discreteness of the binomial distribution.

We cannot choose a fractional number of patients to make the rejection probability exactly

$$
0.025.
$$

The actual probability of the rejection region is therefore slightly smaller than the nominal significance level.

---

## Observed p-value versus critical region

The rejection region asks:

> Which observations would cause us to reject $H_0$ at the chosen significance level?

For this test,

$$
X\ge30.
$$

The p-value asks:

> Starting from the observed result, how much probability is in the null distribution at least this extreme in the direction of $H_A$?

Since we observed

$$
X=34,
$$

the p-value is

$$
P(X\ge34\mid H_0).
$$

In R:

```r
1 - pbinom(
  33,
  size = 55,
  prob = 0.40
)
```

This is approximately

$$
0.000884.
$$

Since

$$
34\ge30,
$$

the observation lies inside the rejection region.

Equivalently,

$$
0.000884<0.025.
$$

Both approaches give the same statistical decision.

---

# 6. Comparing the Three Problems

Before comparing the examples, it is useful to keep the three main quantities separate:

```text
p0        reference probability specified by H0

n         number of trials in the current experiment

x_obs     observed number of successes
```

The null model is

$$
X\sim\mathrm{Binomial}(n,p_0).
$$

The value $p_0$ does not need to come from an earlier experiment with the same $n$. For example:

```text
Mendel             p0 = 0.75 comes from a genetic model

Allele expression  p0 = 0.50 represents equal allelic contribution

EXACT trial         p0 = 0.40 is a pre-specified study benchmark
```

All three problems use the same basic statistical model:

$$
X\sim\mathrm{Binomial}(n,p).
$$

But their scientific questions are different.

| Example | $n$ | $x_{\mathrm{obs}}$ | $p_0$ | $H_A$ | Test | $\alpha$ | Approx. p-value |
|---|---:|---:|---:|---|---|---:|---:|
| Mendel | 7324 | 5474 | 0.75 | $p\ne0.75$ | two-sided | 0.05 | 0.608 |
| Allele-specific expression | 100 | 68 | 0.50 | $p\ne0.50$ | two-sided | 0.05 | 0.000409 |
| EXACT trial | 55 | 34 | 0.40 | $p>0.40$ | right-tailed | 0.025 | 0.000884 |

The important point is that the direction of the test comes from the **scientific question**.

```text
different from     -> two-sided

smaller than       -> left-tailed

greater than       -> right-tailed
```

The same observed count could lead to different p-values if a different alternative hypothesis were specified.

---
