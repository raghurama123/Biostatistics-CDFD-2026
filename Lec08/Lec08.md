<table style="width:100%; border:none;">
<tr>
<td style="width:33%; text-align:left; border:none;"><a href="../Lec07/Lec07.html"><strong>← Previous Lecture</strong></a></td>
<td style="width:34%; text-align:center; border:none;"><a href="../"><strong>Home</strong></a></td>
<td style="width:33%; text-align:right; border:none;"><strong>Next Lecture →</strong></td>
</tr>
</table>

# Lecture 08: Shannon–Wiener Diversity Index and Hutcheson's t-Test


## 1. Species diversity and relative abundance

Biodiversity includes both **species richness** (the number of observed species) and **evenness** (how equally individuals are distributed among species). Two communities may contain the same number of species but differ in diversity if one is dominated by a single species.

Let $c$ be the number of observed species, $f_k$ the number of individuals belonging to species $k$, and $n=\sum_{k=1}^c f_k$ the total number of individuals. The relative abundance of species $k$ is

$$
p_k=\frac{f_k}{n},\qquad \sum_{k=1}^c p_k=1.
$$

## 2. Shannon–Wiener diversity index

Using natural logarithms, the Shannon–Wiener index is

$$
\boxed{H'=-\sum_{k=1}^c p_k\log p_k.}
$$

Substituting $p_k=f_k/n$ gives

$$
\begin{aligned}
H'&=-\sum_{k=1}^c\frac{f_k}{n}\log\left(\frac{f_k}{n}\right)\\
&=-\frac1n\sum_{k=1}^c f_k(\log f_k-\log n)\\
&=\frac{\log n}{n}\sum_{k=1}^c f_k-\frac1n\sum_{k=1}^c f_k\log f_k\\
&=\boxed{\log n-\frac1n\sum_{k=1}^c f_k\log f_k.}
\end{aligned}
$$

Here $\log$ denotes the natural logarithm. Species with zero observations are excluded from the sums; mathematically, $0\log0$ is treated as zero by continuity.

### Maximum diversity

For a fixed number of species $c$, Shannon diversity is maximized when all species have equal relative abundance, $p_k=1/c$. Therefore,

$$
H'_{\max}=-\sum_{k=1}^c\frac1c\log\frac1c
=-c\frac1c(-\log c)=\boxed{\log c}.
$$

Thus $0\le H'\le\log c$. A larger value generally indicates greater richness and/or evenness; comparisons require attention to sampling effort.

```r
# 01_Shannon_Index.R — base R
shannon <- function(counts) {
  counts <- counts[counts > 0]
  p <- counts / sum(counts)
  -sum(p * log(p))
}

counts <- c(25, 25, 25, 25)
H <- shannon(counts)
H_max <- log(sum(counts > 0))
cat("Shannon H' =", H, "\nMaximum =", H_max, "\n")
```

## 3. Comparing two diversity indices: Hutcheson's t-test

Suppose two **independent** samples yield $H'_1$ and $H'_2$. Test

$$
H_0:H'_1=H'_2,\qquad H_A:H'_1\ne H'_2.
$$

The approximate test statistic is

$$
\boxed{t=\frac{H'_1-H'_2}{\sqrt{\widehat{\operatorname{Var}}(H'_1)+\widehat{\operatorname{Var}}(H'_2)}}.}
$$

An approximate variance estimator, is

$$
\boxed{\widehat{\operatorname{Var}}(H')=
\frac{\displaystyle\sum_{k=1}^c f_k(\log f_k)^2-
\frac1n\left(\displaystyle\sum_{k=1}^c f_k\log f_k\right)^2}{n^2}.}
$$

This is a large-sample approximation. Some references include an additional small-sample correction; this lecture follows the uncorrected expression in the notes.

For $v_1=\widehat{\operatorname{Var}}(H'_1)$ and $v_2=\widehat{\operatorname{Var}}(H'_2)$, approximate degrees of freedom are

$$
\boxed{\nu=\frac{(v_1+v_2)^2}{v_1^2/n_1+v_2^2/n_2}.}
$$

At significance level $\alpha=0.05$, reject $H_0$ for a two-sided test when $|t|>t_{0.975,\nu}$, or equivalently when the two-sided $p$-value is less than 0.05. This procedure assumes the sampled individuals can reasonably be treated as independent and that the large-sample approximation is adequate.

## 4. Example: bird diets in Michigan and Louisiana

The handwritten example records counts in six food categories. Here, each food category is treated as a category in the Shannon calculation; strictly speaking, this measures **diet-category diversity**, not bird-species diversity.

| Diet category | Michigan blue jay | Louisiana blue jay |
|---|---:|---:|
| Oak | 47 | 48 |
| Corn / pine | 35 (corn) | 23 (pine) |
| Blackberry / grape | 7 (blackberry) | 11 (grape) |
| Beech / corn | 5 (beech) | 13 (corn) |
| Cherry / blueberry | 3 (cherry) | 8 (blueberry) |
| Other | 2 | 2 |
| **Total** | **99** | **105** |


```r
# 02_Bird_Diet_Data.R — base R
michigan <- c(Oak = 47, Corn = 35, Blackberry = 7,
              Beech = 5, Cherry = 3, Other = 2)
louisiana <- c(Oak = 48, Pine = 23, Grape = 11,
               Corn = 13, Blueberry = 8, Other = 2)

stopifnot(sum(michigan) == 99, sum(louisiana) == 105)
print(michigan)
print(louisiana)
```

## 5. R implementation

```r
# 03_Hutcheson_Test.R — base R
shannon_stats <- function(counts) {
  counts <- counts[counts > 0]
  n <- sum(counts)
  p <- counts / n
  H <- -sum(p * log(p))
  A <- sum(counts * log(counts))
  B <- sum(counts * log(counts)^2)
  variance <- (B - A^2 / n) / n^2
  list(n = n, richness = length(counts), H = H,
       variance = variance, se = sqrt(variance))
}

hutcheson_test <- function(x, y, alpha = 0.05) {
  a <- shannon_stats(x)
  b <- shannon_stats(y)
  t_stat <- (a$H - b$H) / sqrt(a$variance + b$variance)
  df <- (a$variance + b$variance)^2 /
    (a$variance^2 / a$n + b$variance^2 / b$n)
  p_value <- 2 * pt(-abs(t_stat), df = df)
  critical <- qt(1 - alpha / 2, df = df)
  list(group1 = a, group2 = b, t = t_stat,
       df = df, p_value = p_value, critical_t = critical,
       decision = if (p_value < alpha) "Reject H0" else "Do not reject H0")
}

result <- hutcheson_test(michigan, louisiana)
print(result)
```

### Interpreting the decision

The observed difference $H'_1-H'_2$ is negative if the Louisiana sample has the larger diversity index. **A negative $t$ statistic alone is not evidence of a statistically significant difference.** Compare the absolute test statistic with the two-sided critical value, or compare the $p$-value with 0.05. If $p\ge0.05$, we **do not reject** equal diversity; this does not establish that the underlying diversities are identical.

```r
# 04_Visualize_Relative_Abundance.R — base R
par(mfrow = c(1, 2))
barplot(michigan / sum(michigan), las = 2,
        main = "Michigan", ylab = "Relative abundance", ylim = c(0, 0.55))
barplot(louisiana / sum(louisiana), las = 2,
        main = "Louisiana", ylab = "Relative abundance", ylim = c(0, 0.55))
par(mfrow = c(1, 1))
```

