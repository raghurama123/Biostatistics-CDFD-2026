<table style="width:100%; border:none;">
<tr>
<td style="width:33%; text-align:left; border:none;"><a href="../Lec05/Lec05.html"><strong>← Previous Lecture</strong></a></td>
<td style="width:34%; text-align:center; border:none;"><a href="../"><strong>Home</strong></a></td>
<td style="width:33%; text-align:right; border:none;"><a href="../Lec07/Lec07.html"><strong>Next Lecture →</strong></a></td>
</tr>
</table>

# Lecture 06 — Analysis of Variance: Beyond One-Way ANOVA

# 1. Recall: one-way (or one-factor) ANOVA

In Lecture 05, we investigated whether **enzyme activity depends on the dose of a treatment**.

The experiment included three treatment groups:

- **Control:** No treatment (zero dose).
- **Low dose:** A low concentration of the treatment.
- **High dose:** A high concentration of the treatment.

Although there are three treatment groups, they represent **three levels of the same experimental factor: treatment dose**.

A **factor** is an experimental variable that may influence the measured outcome. The different values or categories of that factor are called **levels**.

| Component | In our experiment |
|---|---|
| Factor | Treatment dose |
| Levels | Control, Low dose, High dose |
| Number of factors | 1 |
| Number of levels | 3 |
| Measured response | Enzyme activity |

Since we vary only **one factor (treatment dose)**, this is called **one-way ANOVA**, regardless of how many levels that factor has.

The scientific question is:

**Does mean enzyme activity differ among the three treatment doses?**

One-way ANOVA compares the means of the three independent groups to test this question.

Lecture 05 used **$X_{ij}$ for an individual measurement**, where **$i$ is the observation number** and **$j$ is the treatment-group number**. We keep exactly that convention in Lecture 06.

Recall the enzyme-activity measurements from Lecture 05:

| Observation $i$ | Control ($j=1$) | Low dose ($j=2$) | High dose ($j=3$) |
|---|---:|---:|---:|
| 1 | 10.2 | 11.0 | 13.1 |
| 2 | 11.4 | 12.6 | 14.3 |
| 3 | 10.9 | 11.8 | 13.8 |
| 4 | 12.0 | 12.1 | 14.9 |
| 5 | 11.3 | 13.2 | 12.9 |
| 6 | 10.7 | 12.4 | 14.1 |
| **Group mean** | **11.0833** | **12.1833** | **13.8500** |

Here $X_{ij}$ means **the measurement in row $i$, column $j$**:

| Symbol | Where to look in the table | Value |
|---|---|---:|
| $X_{11}$ | Observation 1, Control | 10.2 |
| $X_{21}$ | Observation 2, Control | 11.4 |
| $X_{12}$ | Observation 1, Low dose | 11.0 |
| $X_{32}$ | Observation 3, Low dose | 11.8 |
| $X_{13}$ | Observation 1, High dose | 13.1 |
| $X_{63}$ | Observation 6, High dose | 14.1 |

**The subscripts are labels, not multiplication.** Thus $X_{32}=11.8$ is the third observation in the second treatment group.

Each group has its own mean, written $\bar X_j$. For example, $\bar X_1=11.0833$ is the Control mean. The **grand mean** over all 18 measurements is $\bar X=12.3722$.

A one-way ANOVA model describes each measurement as

$$
\boxed{X_{ij}=\mu+\alpha_j+\varepsilon_{ij}}
$$

- $X_{ij}$: observation $i$ from treatment group $j$.
- $\mu$: common baseline (the overall population mean, with effects constrained to sum to zero).
- $\alpha_j$: the effect of treatment group $j$ relative to that baseline.
- $\varepsilon_{ij}$: random error for observation $i$ in group $j$.

**Worked decomposition:** For the first Control measurement, $X_{11}=10.2$:

$$
\begin{aligned}
10.2
&= \underbrace{12.3722}_{\text{sample grand mean}}
 + \underbrace{(11.0833-12.3722)}_{\text{estimated Control effect}}\\
&\quad+\underbrace{(10.2-11.0833)}_{\text{observed residual}}\\
&=12.3722-1.2889-0.8833.
\end{aligned}
$$

This is an **exact sample-data decomposition** using estimates of the unknown model parameters. It connects the model directly to the **between-group** and **within-group** deviations calculated in Lecture 05. In the model, random errors are assumed independent with mean zero and common variance; normality supports the classical small-sample F-test.

The null hypothesis remains exactly the one used in Lecture 05:

$$
H_0:\mu_1=\mu_2=\cdots=\mu_k.
$$

Equivalently, with the usual constraint that the group effects sum to zero, $H_0$ says that all $\alpha_j=0$. This new notation **describes the same one-way ANOVA**, rather than introducing a new statistical test.

ANOVA partitions the total sum of squares:

$$
SS_{\mathrm{total}}=SS_{\mathrm{between}}+SS_{\mathrm{within}}.
$$

The statistic is

$$
F=\frac{MS_{\mathrm{between}}}{MS_{\mathrm{within}}}.
$$

A large $F$ indicates that the differences among group means are large relative to ordinary variation within groups. **A significant overall ANOVA does not identify which group means differ**; appropriately adjusted comparisons, such as Tukey's HSD, address that question.

### Recall in R

```r
# 01_RecallOneWay.R — standalone, base R
control <- c(10.2, 11.4, 10.9, 12.0, 11.3, 10.7)
low <- c(11.0, 12.6, 11.8, 12.1, 13.2, 12.4)
high <- c(13.1, 14.3, 13.8, 14.9, 12.9, 14.1)

df <- data.frame(
  activity = c(control, low, high),
  treatment = factor(rep(c("Control", "Low", "High"), each = 6))
)

fit <- aov(activity ~ treatment, data = df)
print(summary(fit))
print(TukeyHSD(fit))
```

**Question:** What if enzyme activity also depends on genotype? Would the treatment have the same effect in every genotype? One-way ANOVA cannot directly answer that second question.

---

# 2. Factors, levels, and factorial experiments

We now add a second factor. A **factor** is an explanatory variable, such as treatment, genotype, catalyst, or mixing method; its categories are called **levels**.

Suppose a chemical synthesis uses two factors:

| Factor | Levels | Number of levels |
|---|---|---:|
| Catalyst | Platinum, Palladium, Iridium, Palladium/Iridium, Rhodium | 5 |
| Mixing | Stirring, Ultrasonication | 2 |

If every catalyst is tested under both mixing conditions, there are

$$
5\times2=10
$$

**factor combinations** (also called *cells*). Testing all combinations is a **full factorial design**. With five independent syntheses per cell, the total number of observations is

$$
N=5\times2\times5=50.
$$

The scientific questions are now:

1. Does mean yield differ by **catalyst**?
2. Does mean yield differ by **mixing method**?
3. Does the **effect of mixing depend on the catalyst**?

The third question concerns an **interaction**.

### Generate a factorial design in R

```r
# 02_FactorialDesign.R — standalone, base R
catalyst <- c("Platinum", "Palladium", "Iridium", "PdIr", "Rhodium")
mixing <- c("Stirred", "Ultrasonic")

design <- expand.grid(catalyst = catalyst, mixing = mixing)
print(design)                    # 5 x 2 = 10 combinations
print(nrow(design))

# Add five replicate rows per combination
design_50 <- design[rep(seq_len(nrow(design)), each = 5), ]
row.names(design_50) <- NULL
print(table(design_50$catalyst, design_50$mixing))
```

> [!NOTE]
> Replication means **independent experimental units**, not repeatedly recording the same underlying unit as though the readings were independent. The experimental design determines what counts as a replicate.

---

# 3. Two-way (or two-factor) ANOVA: the statistical model

For two categorical factors $A$ and $B$, we add **one more group index** while continuing to put the **observation/replicate index first**:

$$
\boxed{X_{ijk}=\mu+\alpha_j+\beta_k+(\alpha\beta)_{jk}+\varepsilon_{ijk}}
$$

| Index | Meaning | Example |
|---|---|---|
| $i$ | Replicate within one factor combination | $i=1$: first synthesis |
| $j$ | Level of factor $A$ | Catalyst $j=1$: Platinum |
| $k$ | Level of factor $B$ | Mixing $k=1$: Stirred |

For example, in textbook Table 14.7:

- $X_{111}=11.1$ is **replicate 1**, **Platinum**, **Stirred**.
- $X_{211}=11.7$ is **replicate 2**, **Platinum**, **Stirred**.
- $X_{121}=15.9$ is **replicate 1**, **Palladium**, **Stirred**.
- $X_{112}=12.8$ is **replicate 1**, **Platinum**, **Ultrasonic**.

The terms of the model are:

- $\mu$: overall population mean;
- $\alpha_j$: effect of catalyst $j$;
- $\beta_k$: effect of mixing method $k$;
- $(\alpha\beta)_{jk}$: **interaction**, or departure from adding the two main effects;
- $\varepsilon_{ijk}$: random error for replicate $i$ with catalyst $j$ and mixing $k$.

In plain language:

> **Observed yield = overall mean + catalyst effect + mixing effect + interaction + replicate-to-replicate error.**

An interaction means that the effect of changing the mixing method **depends on which catalyst is used**. Without an interaction, effects are additive.

## Means and dot notation

A bar indicates an average; a **dot** in a subscript means average over that index.

| Symbol | Meaning |
|---|---|
| $\bar X_{\cdot jk}$ | Mean across replicates $i$ for catalyst $j$, mixing $k$ (cell mean) |
| $\bar X_{\cdot j\cdot}$ | Mean across replicates and mixing methods for catalyst $j$ |
| $\bar X_{\cdot\cdot k}$ | Mean across replicates and catalysts for mixing method $k$ |
| $\bar X_{\cdot\cdot\cdot}$ | Grand mean across all observations |

For example, $\bar X_{\cdot 11}=10.80$ averages the five Platinum–Stirred measurements, and $\bar X_{\cdot 1\cdot}=11.73$ averages all ten Platinum measurements across the two mixing methods. These are ordinary observation-weighted averages; the design is balanced here.

With the usual constraints on the effects, ANOVA decomposes variation as

$$
SS_{\mathrm{total}}=SS_A+SS_B+SS_{A:B}+SS_{\mathrm{error}}.
$$

For a **balanced** $a\times b$ design with $r$ replicates per combination:

| Source | Degrees of freedom | Mean square | F-statistic |
|---|---:|---|---|
| Factor A | $a-1$ | $MS_A=SS_A/(a-1)$ | $MS_A/MS_E$ |
| Factor B | $b-1$ | $MS_B=SS_B/(b-1)$ | $MS_B/MS_E$ |
| Interaction $A:B$ | $(a-1)(b-1)$ | $MS_{A:B}=SS_{A:B}/[(a-1)(b-1)]$ | $MS_{A:B}/MS_E$ |
| Residual/error | $ab(r-1)$ | $MS_E=SS_E/[ab(r-1)]$ | — |
| Total | $abr-1$ | — | — |

These F-tests use the standard **independent, equal-variance, fixed-effects** ANOVA assumptions. Designs with random factors or correlated measurements require different error structures.

## Formula notation in R

```r
# Main effects only (additive model; assumes no interaction)
yield ~ catalyst + mixing

# Interaction term alone
yield ~ catalyst:mixing

# Main effects and interaction (full factorial model)
yield ~ catalyst * mixing

# Exactly equivalent expanded formula
yield ~ catalyst + mixing + catalyst:mixing
```

**Meaning of `*`:** In a model formula, `A * B` means `A + B + A:B`; it is not arithmetic multiplication of the measured data.

## Three null hypotheses

For the full model, we consider:

- $H_{0,A}$: no main effect of A (equal **marginal means** across its levels in a balanced design).
- $H_{0,B}$: no main effect of B.
- $H_{0,A:B}$: **no interaction** (the effect of A does not change across levels of B).

If interaction is important, the average main effect may conceal the scientifically relevant differences. Interpret the interaction **before** making broad claims about the main effects.

---

# 4. Example 1: catalyst and mixing method

**Source:** Rowe, Chapter 14, Table 14.7 (p. 190) and ANOVA Table 14.10 (p. 193).

**Scientific question:** Does drug-synthesis yield (%) depend on the catalyst, mixing method, or their interaction?

Five separate syntheses were reported for **each** catalyst–mixing combination. All 50 published measurements follow.

## Observed measurements: yield (%)

| Mixing | Replicate | Platinum | Palladium | Iridium | Pd/Ir alloy | Rhodium |
|---|---:|---:|---:|---:|---:|---:|
| Stirred | 1 | 11.1 | 15.9 | 10.9 | 14.1 | 13.0 |
| Stirred | 2 | 11.7 | 18.9 | 13.4 | 13.9 | 12.3 |
| Stirred | 3 | 9.8 | 18.9 | 10.5 | 14.2 | 11.0 |
| Stirred | 4 | 12.1 | 15.5 | 12.2 | 13.5 | 9.9 |
| Stirred | 5 | 9.3 | 17.2 | 10.9 | 14.0 | 10.6 |
| Ultrasonic | 1 | 12.8 | 20.0 | 14.8 | 16.3 | 13.1 |
| Ultrasonic | 2 | 13.8 | 19.9 | 11.9 | 17.2 | 13.4 |
| Ultrasonic | 3 | 12.3 | 19.5 | 15.3 | 16.0 | 13.8 |
| Ultrasonic | 4 | 12.4 | 20.5 | 14.3 | 15.1 | 13.6 |
| Ultrasonic | 5 | 12.0 | 18.3 | 15.2 | 17.0 | 12.8 |

## Summary: cell means

| Mixing | Platinum | Palladium | Iridium | Pd/Ir alloy | Rhodium |
|---|---:|---:|---:|---:|---:|
| Stirred | 10.80 | 17.28 | 11.58 | 13.94 | 11.36 |
| Ultrasonic | 12.66 | 19.64 | 14.30 | 16.32 | 13.34 |
| **Ultrasonic − stirred** | **1.86** | **2.36** | **2.72** | **2.38** | **1.98** |

Ultrasonication produces an observed yield increase of roughly **2–3 percentage points** for every catalyst. Because these increases are similar, the pattern suggests an **approximately additive effect** (little catalyst × mixing interaction). Their average is **2.26 percentage points**; the interaction test below assesses whether the differences among these increases exceed what random variation could explain.


## Two-way ANOVA using `aov()`

```r
# 03_Catalyst_aov.R — standalone, base R
alpha <- 0.05
catalyst <- c("Platinum", "Palladium", "Iridium", "PdIr", "Rhodium")
stir <- list(
  c(11.1, 11.7, 9.8, 12.1, 9.3),
  c(15.9, 18.9, 18.9, 15.5, 17.2),
  c(10.9, 13.4, 10.5, 12.2, 10.9),
  c(14.1, 13.9, 14.2, 13.5, 14.0),
  c(13.0, 12.3, 11.0, 9.9, 10.6)
)
ultra <- list(
  c(12.8, 13.8, 12.3, 12.4, 12.0),
  c(20.0, 19.9, 19.5, 20.5, 18.3),
  c(14.8, 11.9, 15.3, 14.3, 15.2),
  c(16.3, 17.2, 16.0, 15.1, 17.0),
  c(13.1, 13.4, 13.8, 13.6, 12.8)
)

make_rows <- function(values, mixing_label) {
  data.frame(
    catalyst = rep(catalyst, each = 5),
    mixing = mixing_label,
    yield = unlist(values, use.names = FALSE)
  )
}
df <- rbind(make_rows(stir, "Stirred"),
            make_rows(ultra, "Ultrasonic"))
df$catalyst <- factor(df$catalyst, levels = catalyst)
df$mixing <- factor(df$mixing, levels = c("Stirred", "Ultrasonic"))

print(table(df$catalyst, df$mixing))
print(aggregate(yield ~ catalyst + mixing, data = df, FUN = mean))
fit <- aov(yield ~ catalyst * mixing, data = df)
result <- summary(fit)
print(result)

p <- result[[1]][1:3, "Pr(>F)"]
for (i in seq_along(p)) {
  cat(names(p)[i], ":", if (p[i] < alpha) "Reject H0" else "Do not reject H0", "\n")
}
```

### Calculate the observed mixing effect in R

Run this after `03_Catalyst_aov.R`, while its `df` is available:

```r
# Mean yield for each catalyst and mixing method
group_means <- aggregate(
  yield ~ catalyst + mixing,
  data = df,
  FUN = mean
)

print(group_means)

# Overall mean yield for each mixing method
mixing_means <- aggregate(
  yield ~ mixing,
  data = df,
  FUN = mean
)

print(mixing_means)

# Average increase due to ultrasonication
increase <- mixing_means$yield[
  mixing_means$mixing == "Ultrasonic"
] - mixing_means$yield[
  mixing_means$mixing == "Stirred"
]

cat("Mean yield increase =", increase,
    "percentage points\n")
```

### Interpreting and reporting the ANOVA results

In `summary(fit)`, **Df** gives the degrees of freedom, **Sum Sq** the sum of squares, **Mean Sq** the mean square, **F value** the test statistic, and **Pr(>F)** the p-value. Each F-statistic compares the mean square for that term with the residual mean square. We report it as $F_{df_1,df_2}$, where $df_1$ is the term's degrees of freedom and $df_2$ is the residual degrees of freedom.

| Source | Df | F value | p-value |
|---|---:|---:|---:|
| Catalyst | 4 | 67.41 | $<0.001$ |
| Mixing | 1 | 57.20 | $<0.001$ |
| Catalyst × Mixing | 4 | 0.27 | 0.898 |
| Residuals | 40 | — | — |

At $\alpha=0.05$, catalyst and mixing both have significant main effects, while the interaction is not significant. Thus, mean yield differs among catalysts and between mixing methods, but there is **insufficient evidence** that the effect of mixing differs among catalysts. The observed average improvement with ultrasonication is **2.26 percentage points**; the lack of significant interaction does not establish that its effect is exactly equal for all catalysts.

**Example of statistical reporting:**

> Two-way ANOVA indicated effects of catalyst ($F_{4,40}=67.41$, $p<0.001$) and mixing method ($F_{1,40}=57.20$, $p<0.001$), with no detected catalyst × mixing interaction ($F_{4,40}=0.27$, $p=0.898$). Ultrasonication increased mean yield by approximately 2.26 percentage points across the five catalysts studied.

The F-statistics, degrees of freedom, and p-values come from `summary(fit)`; the average yield difference comes from the group means calculated with `aggregate()`.

---

# 5. Interpreting main effects and interaction

An **interaction** is present when changing one factor produces different effects at different levels of another factor.

For Example 1, the effect of changing from stirred to ultrasonic mixing is:

$$
\Delta_j=\bar X_{\cdot j2}-\bar X_{\cdot j1}.
$$

Here $k=1$ means Stirred and $k=2$ means Ultrasonic. The differences (1.86, 2.36, 2.72, 2.38, 1.98) are similar, and the interaction F-test is non-significant. Thus, the experiment is **consistent with** an approximately common mixing effect of 2.26 yield percentage points.

An **interaction plot** shows cell means. If the effect is additive, lines are approximately parallel. If the effect changes across factor levels, lines are not parallel. These plots are **descriptive**; statistical inference requires the appropriate test and assumptions.

### R: interaction plot for Example 1

```r
# 04_Catalyst_interaction.R — standalone, base R
catalyst <- c("Platinum", "Palladium", "Iridium", "PdIr", "Rhodium")
stir <- c(10.80, 17.28, 11.58, 13.94, 11.36)
ultra <- c(12.66, 19.64, 14.30, 16.32, 13.34)

# Plot each catalyst's line from stirred to ultrasonic mixing
plot(c(1, 2), range(c(stir, ultra)), type = "n", xaxt = "n",
     xlab = "Mixing method", ylab = "Mean yield (%)",
     main = "Catalyst x mixing: approximately additive effects")
axis(1, at = 1:2, labels = c("Stirred", "Ultrasonic"))
for (i in seq_along(catalyst)) {
  lines(1:2, c(stir[i], ultra[i]), type = "b", pch = i, lty = i)
}
legend("topleft", legend = catalyst, pch = seq_along(catalyst),
       lty = seq_along(catalyst), cex = 0.8, bty = "n")

increase <- ultra - stir
print(data.frame(catalyst, increase))
cat("Average improvement =", mean(increase), "percentage points\n")
```

> [!IMPORTANT]
> **Main effect vs interaction:** A main effect describes an average difference across the other factor's levels (for a balanced design). An interaction asks whether those **differences themselves differ**. When a meaningful interaction exists, report effects **within each level** rather than assuming there is one universal treatment effect.

---

# 6. Example 2: tablet strength with interaction

**Source:** Rowe, Chapter 14, Table 14.12 (p. 195) and Table 14.13 (p. 196).

**Scientific question:** How do punch design (A, B, C) and compression force (low, high) affect the tensile strength (MPa) of tablets?

There are $3\times2=6$ combinations, **six replicates in each**, and $N=36$ observations.

## Observed measurements: tensile strength (MPa)

| Compression force | Replicate | Punch A | Punch B | Punch C |
|---|---:|---:|---:|---:|
| Low | 1 | 4.00 | 6.49 | 7.92 |
| Low | 2 | 4.79 | 8.35 | 8.15 |
| Low | 3 | 5.50 | 6.40 | 7.60 |
| Low | 4 | 5.15 | 6.37 | 9.64 |
| Low | 5 | 5.26 | 6.86 | 9.98 |
| Low | 6 | 6.55 | 8.08 | 9.23 |
| High | 1 | 4.90 | 9.63 | 14.60 |
| High | 2 | 4.90 | 9.67 | 13.81 |
| High | 3 | 5.04 | 8.72 | 13.20 |
| High | 4 | 6.93 | 8.08 | 14.62 |
| High | 5 | 7.13 | 10.25 | 13.77 |
| High | 6 | 5.82 | 8.10 | 13.18 |

## Summary: means and effects of force

| Punch | Low force mean | High force mean | High − low (MPa) |
|---|---:|---:|---:|
| A | 5.208 | 5.787 | **0.578** |
| B | 7.092 | 9.075 | **1.983** |
| C | 8.753 | 13.863 | **5.110** |

The observed benefit of higher compression force differs markedly by punch design: **0.58 MPa** for A versus **5.11 MPa** for C. We use the interaction F-test to assess whether this pattern provides evidence of a genuine difference in force effects.

## Two-way ANOVA using `aov()`

```r
# 05_Tablet_aov.R — standalone, base R
alpha <- 0.05
low <- list(
  A = c(4.00, 4.79, 5.50, 5.15, 5.26, 6.55),
  B = c(6.49, 8.35, 6.40, 6.37, 6.86, 8.08),
  C = c(7.92, 8.15, 7.60, 9.64, 9.98, 9.23)
)
high <- list(
  A = c(4.90, 4.90, 5.04, 6.93, 7.13, 5.82),
  B = c(9.63, 9.67, 8.72, 8.08, 10.25, 8.10),
  C = c(14.60, 13.81, 13.20, 14.62, 13.77, 13.18)
)
make_rows <- function(group, force_label) {
  data.frame(punch = rep(names(group), each = 6),
             force = force_label,
             strength = unlist(group, use.names = FALSE))
}
df <- rbind(make_rows(low, "Low"), make_rows(high, "High"))
df$punch <- factor(df$punch, levels = c("A", "B", "C"))
df$force <- factor(df$force, levels = c("Low", "High"))

print(aggregate(strength ~ punch + force, data = df, mean))
fit <- aov(strength ~ punch * force, data = df)
result <- summary(fit)
print(result)

p <- result[[1]][1:3, "Pr(>F)"]
for (i in seq_along(p)) {
  cat(names(p)[i], ":", if (p[i] < alpha) "Reject H0" else "Do not reject H0", "\n")
}

interaction.plot(df$force, df$punch, df$strength,
                 xlab = "Compression force", ylab = "Mean strength (MPa)",
                 trace.label = "Punch", main = "Tablet strength: interaction")
```
### Calculate punch-specific force effects in R

Run this after `05_Tablet_aov.R`, while its `df` is available:

```r
# Mean tablet strength for each combination
group_means <- aggregate(
  strength ~ punch + force,
  data = df,
  FUN = mean
)

print(group_means)

# Calculate High - Low for each punch
low <- subset(
  group_means,
  force == "Low"
)

high <- subset(
  group_means,
  force == "High"
)

# Match the punch designs
low <- low[order(low$punch), ]
high <- high[order(high$punch), ]

# Difference in mean strength
increase <- high$strength - low$strength

results <- data.frame(
  Punch = low$punch,
  Low = low$strength,
  High = high$strength,
  Increase = increase
)

print(transform(
  results,
  Low = round(Low, 3),
  High = round(High, 3),
  Increase = round(Increase, 3)
))
```

### Interpreting and reporting the ANOVA results

The design has $a=3$ punch designs, $b=2$ force levels, and $r=6$ independent replicates per combination. The ANOVA results from `summary(fit)` are:

| Source | Df | F value | p-value |
|---|---:|---:|---:|
| Punch design | 2 | 128.23 | $<0.001$ |
| Compression force | 1 | 74.21 | $<0.001$ |
| Punch × Force | 2 | 20.35 | $<0.001$ |
| Residuals | 30 | — | — |

At $\alpha=0.05$, both punch design and compression force have significant main effects. More importantly, the **punch × force interaction** is significant, indicating that the effect of increasing compression force depends on punch design.

The observed **high-minus-low** mean strength differences are **0.58 MPa** for Punch A, **1.98 MPa** for Punch B, and **5.11 MPa** for Punch C. Because the interaction is significant, these punch-specific effects are more informative than a single average effect of force.

**Example of statistical reporting:**

> Two-way ANOVA detected a punch × force interaction ($F_{2,30}=20.35$, $p<0.001$), indicating that the effect of greater compression force differed among punch designs. The observed high-minus-low mean strength difference was approximately 0.58 MPa for A, 1.98 MPa for B, and 5.11 MPa for C.

As in Example 1, the test statistics and p-values come from `summary(fit)`; the strength differences come from the means calculated with `aggregate()`.


**Compare Examples 1 and 2:** Both show strong main effects, but only Example 2 provides strong evidence that the effect of one factor differs across the levels of the other.


---


# 7. Beyond two factors

Nothing prevents us from adding a third factor, such as genotype, sex, temperature category, or treatment duration. A **three-way factorial ANOVA** can test three main effects, three two-factor interactions, and one three-factor interaction.

For example, suppose gene expression depends on three factors:

- Treatment: control vs drug (**2 levels**)
- Genotype: wild type vs mutant (**2 levels**)
- Sex: female vs male (**2 levels**)

There are $2\times2\times2=8$ cells. A full model is:

$$
X=\mu+A+B+C+A:B+A:C+B:C+A:B:C+\varepsilon.
$$

In R:

```r
expression ~ treatment * genotype * sex
```

The three-way interaction asks whether the **treatment × genotype interaction differs by sex**. It is not just another main effect.

### R: illustrative three-factor experiment

```r
# 06_ThreeWay.R — standalone, base R (simulated example)
set.seed(206)
df <- expand.grid(
  treatment = c("Control", "Drug"),
  genotype = c("WT", "Mutant"),
  sex = c("Female", "Male"),
  replicate = 1:8
)
df$treatment <- factor(df$treatment)
df$genotype <- factor(df$genotype)
df$sex <- factor(df$sex)

drug <- as.integer(df$treatment == "Drug")
mutant <- as.integer(df$genotype == "Mutant")
male <- as.integer(df$sex == "Male")

df$expression <- 10 + 2*drug + mutant + 0.5*male +
  2*drug*mutant + 1.5*drug*mutant*male +
  rnorm(nrow(df), sd = 1.5)

fit <- aov(expression ~ treatment * genotype * sex, data = df)
print(summary(fit))
print(aggregate(expression ~ treatment + genotype + sex, df, mean))
```

As the number of factors and their levels grow, the number of combinations rises rapidly. Chapter 14 (Section 14.5) introduces **fractional factorial designs**, which study a carefully selected subset of combinations, typically with assumptions about which interactions can be estimated. Such designs must be chosen **before** data collection.

---

# 8. Assumptions and model checking

For the standard fixed-effects ANOVA models in this lecture, check:

1. **Independence:** different experimental units supply independent errors. Repeated measurements on the same person or batch require a suitable dependent-data model.
2. **Residual normality:** errors within combinations are approximately normal; inspect residuals rather than requiring every pooled observation to look normal.
3. **Equal residual variance:** spread is similar across the combinations being compared.
4. **Correct specification:** include scientifically important interactions; check whether all factor combinations were observed.
5. **Balanced versus unbalanced data:** equal cell sizes make the traditional sums-of-squares decomposition simple. Unbalanced designs can still be analyzed with linear models, but the hypothesis tested by a reported ANOVA table depends on the sums-of-squares convention, factor coding, and design; sequential (Type I) tests can depend on term order.

If assumptions are seriously violated, possible alternatives include transforming the response, heteroscedasticity-robust models, generalized linear models for counts/proportions, or mixed models for clustered/repeated observations. **Welch's one-way ANOVA** from Lecture 05 does not automatically provide a general solution for all two-way unequal-variance designs.

### R: examine diagnostic plots for the tablet example

```r
# 07_Diagnostics.R — standalone, base R
low <- list(
  A = c(4.00, 4.79, 5.50, 5.15, 5.26, 6.55),
  B = c(6.49, 8.35, 6.40, 6.37, 6.86, 8.08),
  C = c(7.92, 8.15, 7.60, 9.64, 9.98, 9.23)
)
high <- list(
  A = c(4.90, 4.90, 5.04, 6.93, 7.13, 5.82),
  B = c(9.63, 9.67, 8.72, 8.08, 10.25, 8.10),
  C = c(14.60, 13.81, 13.20, 14.62, 13.77, 13.18)
)
make_rows <- function(group, force_label) {
  data.frame(punch = rep(names(group), each = 6),
             force = force_label, strength = unlist(group, use.names = FALSE))
}
df <- rbind(make_rows(low, "Low"), make_rows(high, "High"))
df$punch <- factor(df$punch)
df$force <- factor(df$force)
fit <- aov(strength ~ punch * force, data = df)

# Residuals against fitted values
plot(fitted(fit), resid(fit), pch = 16,
     xlab = "Fitted strength", ylab = "Residual")
abline(h = 0, lty = 2)

# Normal Q-Q plot of residuals
qqnorm(resid(fit))
qqline(resid(fit))

# Examine spread within each factor combination
df$cell <- interaction(df$punch, df$force, sep = "/")
boxplot(strength ~ cell, data = df,
        xlab = "Punch / Force", ylab = "Strength (MPa)")
```

Do not use a non-significant normality or variance test as proof that assumptions hold. Combine knowledge of the experimental design with graphical checks and an assessment of sample size.

---

# 9. Choosing and reporting the model

| Experimental question | Appropriate starting point | R formula/function |
|---|---|---|
| One factor, 3+ independent groups | One-way ANOVA | `aov(activity ~ A)` |
| Two fixed factors, independent observations | Two-way ANOVA | `aov(activity ~ A * B)` |
| Two fixed factors, additive effects specified in advance | Additive two-way model | `aov(activity ~ A + B)` |
| Three fixed factors | Three-way ANOVA | `aov(activity ~ A * B * C)` |

