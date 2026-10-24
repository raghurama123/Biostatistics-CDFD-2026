<table style="width:100%; border:none;">
<tr>
<td style="width:33%; text-align:left; border:none;"><a href="../Lec06/Lec06.html"><strong>← Previous Lecture</strong></a></td>
<td style="width:34%; text-align:center; border:none;"><a href="../"><strong>Home</strong></a></td>
<td style="width:33%; text-align:right; border:none;"><strong>Next Lecture →</strong></td>
</tr>
</table>

# Lecture 07 — Correlation, Linear Regression, and Analysis of Covariance (ANCOVA)

Building on the analysis of variance (ANOVA) framework introduced in [Lecture 06](../Lec06/Lec06.html), this lecture examines relationships between measured variables through **correlation** and **simple linear regression**. It then introduces **analysis of covariance (ANCOVA)**, which combines a categorical factor and a continuous covariate in one linear model.

The worked examples use data from Philip Rowe, *Essential Statistics for the Pharmaceutical Sciences*, 2nd edition, Chapters 15 and 16.

---

# 1. From ANOVA to continuous predictors

In [Lecture 06](../Lec06/Lec06.html), we expressed an observed response as an overall mean, a group effect, and random error. The one-way ANOVA model was

$$
X_{ij}=\mu+\alpha_j+\varepsilon_{ij}.
$$

Here, the explanatory variable is **categorical**: each observation belongs to a treatment group. However, biological responses may also depend on **continuous predictors**, such as age, concentration, or height. The choice of statistical method depends on whether the explanatory variables are categorical, continuous, or a combination of both.

| Scientific question | Response (continuous) | Explanatory variable(s) | Method |
|---|---|---|---|
| Does mean enzyme activity differ across treatments? | Enzyme activity | Treatment group (categorical) | One-way ANOVA |
| How is drug content associated with the height of a leaf? | Drug content | Leaf height (continuous) | Correlation / regression |
| Do treatments differ in mean lung-function improvement after accounting for age? | Percentage change in FEV1 (forced expiratory volume in one second) | Treatment (categorical) and age (continuous) | ANCOVA |

**Unifying idea:** ANOVA, linear regression, and ANCOVA are all forms of the **linear model**. Each can be fitted in R using `lm()`; what differs is the choice of explanatory variables and the scientific question.

---

# 2. Correlation: direction and strength

**Correlation** describes how two measured variables vary together. A **positive correlation** means that higher values of one variable tend to accompany higher values of the other; a **negative correlation** means that higher values of one tend to accompany lower values of the other.

For paired observations $(x_i,y_i)$, the **Pearson sample correlation coefficient** is

$$
r=\frac{\sum_{i=1}^n(x_i-\bar x)(y_i-\bar y)}
{\sqrt{\sum_{i=1}^n(x_i-\bar x)^2\sum_{i=1}^n(y_i-\bar y)^2}}.
$$

Pearson's $r$ lies between $-1$ and $+1$. Its **sign** indicates the direction of the linear association, while its **absolute value** indicates the strength. Values near zero suggest little *linear* association, but do not rule out a nonlinear relationship. The coefficient has no units and is unchanged when $x$ and $y$ are exchanged.

## Worked example — leaf height and drug content

Table 15.1 in Rowe (Chapter 15) gives 24 pairs of measurements: the height at which a leaf grew and its drug content. We ask whether drug content tends to increase or decrease with leaf height.

| Leaf | Height (m) | Drug (mg/100 g dry leaf) | Leaf | Height (m) | Drug (mg/100 g dry leaf) |
|---:|---:|---:|---:|---:|---:|
| 1 | 1.70 | 1.66 | 13 | 3.23 | 1.27 |
| 2 | 2.31 | 1.34 | 14 | 3.29 | 0.85 |
| 3 | 2.89 | 1.27 | 15 | 3.46 | 1.16 |
| 4 | 1.30 | 1.61 | 16 | 3.95 | 1.14 |
| 5 | 3.21 | 1.17 | 17 | 1.70 | 1.25 |
| 6 | 1.84 | 1.73 | 18 | 2.92 | 1.49 |
| 7 | 3.27 | 1.17 | 19 | 2.67 | 1.17 |
| 8 | 4.21 | 1.19 | 20 | 3.02 | 1.16 |
| 9 | 1.32 | 1.93 | 21 | 2.37 | 1.75 |
| 10 | 3.67 | 1.10 | 22 | 2.64 | 1.36 |
| 11 | 2.78 | 1.37 | 23 | 4.25 | 1.00 |
| 12 | 3.71 | 1.19 | 24 | 1.90 | 1.48 |

**Step 1 — examine the scatterplot.** Before calculating a correlation, look for an approximately linear trend, unusual observations, or evidence of curvature.

**Step 2 — hypotheses:** $H_0:\rho=0$ versus $H_A:\rho\ne0$, where $\rho$ is the **population** Pearson correlation.

**Step 3 — calculate the test statistic.** For the conventional Pearson correlation test, assuming independent pairs and a bivariate normal population for exact small-sample inference,

$$
t=r\sqrt{\frac{n-2}{1-r^2}},\qquad df=n-2.
$$

**Step 4 — interpret the result.** Rowe reports approximately $r=-0.777$, indicating a relatively strong negative linear association: drug content tends to be lower in leaves collected at greater heights. A small p-value provides evidence against $H_0:\rho=0$. **Correlation does not, by itself, establish causation.**


### Why are the degrees of freedom $n-1$ in a one-sample t-test?

In a one-sample t-test, we estimate the population mean $\mu$ using the sample mean $\bar X$. As the population variance $\sigma^2$ is unknown, we also estimate it using the sample variance:

$$
s^2=\frac{\sum_{i=1}^{n}(X_i-\bar X)^2}{n-1}.
$$

The denominator is $n-1$ because the sample mean $\bar X$ is estimated from the same $n$ observations. Consequently, the deviations from the sample mean must satisfy

$$
\sum_{i=1}^{n}(X_i-\bar X)=0.
$$

Once $n-1$ deviations are known, the last deviation is determined by this constraint. Therefore, only $n-1$ deviations are free to vary.

The degrees of freedom for the one-sample t-test are thus

$$
\boxed{df=n-1}.
$$

We subtract one **because estimating the sample mean imposes one constraint on the deviations**, even though both the population mean and variance are unknown.

### Why are the degrees of freedom $n-2$ in a correlation test?

In simple linear regression with an intercept, testing whether the population slope is zero is equivalent to testing whether the population Pearson correlation is zero.

The regression model is

$$
Y_i=\beta_0+\beta_1X_i+\varepsilon_i.
$$

The regression estimates **two parameters** from $n$ paired observations:

- The intercept $\beta_0$.
- The slope $\beta_1$.

The fitted values are

$$
\hat Y_i=\hat\beta_0+\hat\beta_1X_i,
$$

and the residuals are

$$
e_i=Y_i-\hat Y_i.
$$

As the intercept and slope are estimated using least squares, the residuals satisfy two constraints:

$$
\sum_{i=1}^{n}e_i=0
$$

and

$$
\sum_{i=1}^{n}X_i e_i=0.
$$

Thus, two degrees of freedom are used in fitting the regression line, leaving

$$
\boxed{df=n-2}.
$$

We subtract two **because the model estimates two regression parameters**, not simply because two variables were measured.


**General principle:** In a linear model with $n$ independent observations and $p$ linearly independent fitted parameters,

$$
\boxed{df_{\text{residual}}=n-p}.
$$


### Pearson correlation in R: `cor.test()`

```r
# 01_Correlation_Rtest.R — base R
height <- c(1.70,2.31,2.89,1.30,3.21,1.84,3.27,4.21,
            1.32,3.67,2.78,3.71,3.23,3.29,3.46,3.95,
            1.70,2.92,2.67,3.02,2.37,2.64,4.25,1.90)
drug <- c(1.66,1.34,1.27,1.61,1.17,1.73,1.17,1.19,
          1.93,1.10,1.37,1.19,1.27,0.85,1.16,1.14,
          1.25,1.49,1.17,1.16,1.75,1.36,1.00,1.48)
plot(height, drug, pch = 16,
     xlab = "Leaf height (m)",
     ylab = "Drug content (mg/100 g dry leaf)",
     main = "Leaf height and drug content")
result <- cor.test(height, drug, method = "pearson")
print(result)
cat("Pearson r =", unname(result$estimate), "\n")
cat(if (result$p.value < 0.05) "Reject H0\n" else "Do not reject H0\n")
```

> [!CAUTION]
> Pearson correlation measures **linear** association and can be sensitive to outliers. Inspect the scatterplot before interpreting $r$ or its p-value. 

---

# 3. Simple linear regression

Correlation summarizes the **direction and strength of a linear association** without assigning response and predictor roles. Regression distinguishes the **response** ($Y$) from the **predictor** ($x$) and estimates how the *mean response* changes with a one-unit change in the predictor.

For the leaf example, let $Y_i$ denote drug content and $x_i$ denote leaf height. The **population regression model** is

$$
\boxed{Y_i=\beta_0+\beta_1x_i+\varepsilon_i}.
$$

- $\beta_0$: intercept — expected drug content when height is zero (possibly outside the observed range).
- $\beta_1$: slope — change in **mean** drug content for a 1 m increase in height.
- $\varepsilon_i$: unexplained random deviation from the population regression line.

The fitted sample equation is

$$
\boxed{\hat Y_i=b_0+b_1x_i}.
$$

The hat in $\hat Y_i$ denotes a **fitted value**. The coefficients $b_0$ and $b_1$ estimate the unknown population intercept $\beta_0$ and slope $\beta_1$. A negative $b_1$ indicates that the fitted mean drug content decreases as leaf height increases.

In the R formula `drug ~ height`, the response (`drug`) is on the left of `~`, and the predictor (`height`) is on the right.

### Zero conditional mean assumption

An important assumption of the regression model is

$$
\boxed{E(\varepsilon_i\mid x_i)=0}.
$$

This is the **zero conditional mean assumption**: at every specified predictor value, the expected random error is zero.

For example, among leaves growing at a given height, some may have more drug than the population regression line predicts and others less. The assumption is that these deviations average to zero **at that height**, and likewise at other heights.

It follows that

$$
\boxed{E(Y_i\mid x_i)=\beta_0+\beta_1x_i}.
$$

Thus, the population regression line describes the **expected (mean) drug content at a given height**, not the drug content of every individual leaf.

> [!NOTE]
> **Population error versus sample residual:** $\varepsilon_i$ is an unobserved deviation from the population conditional mean, whereas $e_i=Y_i-\hat Y_i$ is calculated using the fitted sample line. Ordinary least squares with an intercept ensures that the *sample residuals* sum to zero; it does **not** establish that the *population errors* have zero conditional mean.

---

# 4. Least squares, fitted values, and residuals

As in Lecture 06, distinguish the **observed response** $Y_i$, the **fitted response** $\hat Y_i$, and their difference, the **residual** $e_i$:

$$
Y_i=\hat Y_i+e_i,\qquad e_i=Y_i-\hat Y_i.
$$

The **ordinary least-squares (OLS)** method chooses $b_0$ and $b_1$ to minimize the sum of squared residuals:

$$
SSE=\sum_{i=1}^n\big[Y_i-(b_0+b_1x_i)\big]^2.
$$

For simple linear regression with an intercept, the solution is

$$
b_1=\frac{\sum(x_i-\bar x)(Y_i-\bar Y)}{\sum(x_i-\bar x)^2}
=\frac{S_{xy}}{S_{xx}},
\qquad b_0=\bar Y-b_1\bar x.
$$

With an intercept in the fitted model, the total variation in the response can be partitioned as

$$
\underbrace{\sum(Y_i-\bar Y)^2}_{SST}
=\underbrace{\sum(\hat Y_i-\bar Y)^2}_{SSR}
+\underbrace{\sum(Y_i-\hat Y_i)^2}_{SSE}.
$$

This is the regression version of the ANOVA decomposition: **total variation = variation explained by the model + residual variation**.

### Fit the least-squares regression line in R

```r
# 02_Regression_lm.R — base R
height <- c(1.70,2.31,2.89,1.30,3.21,1.84,3.27,4.21,
            1.32,3.67,2.78,3.71,3.23,3.29,3.46,3.95,
            1.70,2.92,2.67,3.02,2.37,2.64,4.25,1.90)
drug <- c(1.66,1.34,1.27,1.61,1.17,1.73,1.17,1.19,
          1.93,1.10,1.37,1.19,1.27,0.85,1.16,1.14,
          1.25,1.49,1.17,1.16,1.75,1.36,1.00,1.48)
fit <- lm(drug ~ height)
print(summary(fit))
print(data.frame(observed = drug, fitted = fitted(fit),
                 residual = resid(fit)))
plot(height, drug, pch = 16, xlab = "Height (m)",
     ylab = "Drug content (mg/100 g)")
abline(fit, col = "blue", lwd = 2)
```

**Think:** In one-way ANOVA, all observations in a group have the same fitted group mean. In regression, different values of height generally produce different fitted values. Use the fitted equation to predict drug content at a height of 3 m.

---

# 5. Testing and interpreting regression

To assess whether mean drug content changes linearly with height, test whether the **population regression slope** differs from zero:

$$
H_0:\beta_1=0,\qquad H_A:\beta_1\ne0.
$$

With independent errors, constant error variance, and normally distributed errors for exact small-sample inference, the residual variance estimate and standard error of the estimated slope are

$$
s^2=\frac{SSE}{n-2},\qquad SE(b_1)=\frac{s}{\sqrt{S_{xx}}}.
$$

The test statistic is

$$
t=\frac{b_1}{SE(b_1)},\qquad df=n-2.
$$

A $(1-\alpha)100\%$ confidence interval for the population slope is

$$
b_1\pm t_{1-\alpha/2,n-2}SE(b_1).
$$

The **coefficient of determination** is

$$
R^2=1-\frac{SSE}{SST}.
$$

For a model fitted with an intercept, $R^2$ is the **proportion of the observed variation in the response explained by the fitted model**. In simple linear regression, $R^2=r^2$. 

### Test the slope, inspect confidence intervals, and make predictions

```r
# 03_SlopeTest_lm.R — base R
height <- c(1.70,2.31,2.89,1.30,3.21,1.84,3.27,4.21,
            1.32,3.67,2.78,3.71,3.23,3.29,3.46,3.95,
            1.70,2.92,2.67,3.02,2.37,2.64,4.25,1.90)
drug <- c(1.66,1.34,1.27,1.61,1.17,1.73,1.17,1.19,
          1.93,1.10,1.37,1.19,1.27,0.85,1.16,1.14,
          1.25,1.49,1.17,1.16,1.75,1.36,1.00,1.48)
fit <- lm(drug ~ height)
print(summary(fit))
print(confint(fit))
new_leaf <- data.frame(height = 3)
print(predict(fit, newdata = new_leaf, interval = "confidence"))
print(predict(fit, newdata = new_leaf, interval = "prediction"))
```

**Confidence interval versus prediction interval:** A confidence interval expresses uncertainty about the **population mean drug content** at a specified height. A prediction interval accounts for uncertainty about the drug content of **one new leaf** at that height; it is wider because individual leaves also vary around the mean. Predictions far outside the observed height range (1.30–4.25 m) involve extrapolation and may be unreliable.

> [!NOTE]
> **Why do Pearson correlation and simple linear regression give the same p-value?**
>
> In simple linear regression with an intercept, testing whether the population slope is zero is mathematically equivalent to testing whether the population Pearson correlation is zero:
>
> $$
> \boxed{
> H_0:\rho=0
> \quad\Longleftrightarrow\quad
> H_0:\beta_1=0
> }
> $$
>
> Both tests give the **same t-statistic, $n-2$ degrees of freedom, and two-sided p-value**, provided the same paired observations and standard model assumptions are used.
>
> Thus, both tests provide the same statistical evidence for a nonzero linear association, although they answer different scientific questions: **correlation measures the strength and direction of linear association, whereas regression estimates how the response variable changes with the predictor.**

### Why do correlation and regression use a t-statistic?

The **t-statistic** in correlation and regression follows the same idea as in a one-sample t-test: it expresses the distance between an estimated parameter and its hypothesized value in **standard-error units**.

$$
\boxed{
t=\frac{\text{Estimated parameter}-\text{Hypothesized value}}{\text{Standard error}}
}
$$

The difference lies in **which population parameter is being tested**:

| Test | t-statistic | Null hypothesis |
|---|---|---|
| One-sample t-test | $\displaystyle t=\frac{\bar X-\mu_0}{s/\sqrt n}$ | $H_0:\mu=\mu_0$ |
| Linear regression | $\displaystyle t=\frac{b_1}{SE(b_1)}$ | $H_0:\beta_1=0$ |
| Pearson correlation | $\displaystyle t=r\sqrt{\frac{n-2}{1-r^2}}$ | $H_0:\rho=0$ |


---

# 6. ANCOVA: combining a factor and a covariate

Lecture 06 examined two-way ANOVA with **categorical factors**. **Analysis of covariance (ANCOVA)** uses the same linear-model framework but combines a categorical factor, such as treatment, with a **continuous covariate**, such as age. Accounting for the covariate can reduce unexplained variation in the response.

Suppose $Y_i$ is the percent change in lung function (FEV1), $x_i$ is patient age, and $D_i$ indicates treatment:

$$
D_i=\begin{cases}0&\text{OldDrug}\\1&\text{NewDrug}.\end{cases}
$$

The **common-slopes ANCOVA** model is

$$
\boxed{Y_i=\beta_0+\tau D_i+\beta_1(x_i-x_0)+\varepsilon_i},
$$

where $x_0$ is a chosen reference age (often the overall sample mean).

- $\beta_0$: expected outcome with OldDrug at age $x_0$.
- $\tau$: **age-adjusted treatment difference**, NewDrug minus OldDrug, at the same age.
- $\beta_1$: common change in mean outcome per additional year of age.
- $\varepsilon_i$: individual deviation from the fitted treatment-specific line.


The common-slopes ANCOVA model describes the two treatment groups using **parallel regression lines**. Both groups share the same age slope $\beta$, while the treatment effect $\tau$ represents the constant vertical difference between their regression lines. Thus, the groups may have different intercepts, but the estimated treatment difference remains the same at every age.

To allow the age slope to differ between treatments, include an **interaction term**:

$$
\boxed{Y_i=\beta_0+\tau D_i+\beta_1(x_i-x_0)
+\gamma D_i(x_i-x_0)+\varepsilon_i}.
$$

Here, $\gamma$ is the **difference between the treatment-specific age slopes**. Consequently, the expected treatment contrast at age $x$ is $\tau+\gamma(x-x_0)$, which can vary with age. This is analogous to the interaction in two-way ANOVA from Lecture 06.

| R formula | Interpretation |
|---|---|
| `change ~ treatment` | Unadjusted comparison of treatment means (one-way ANOVA / pooled t-test) |
| `change ~ age` | Regression using age alone |
| `change ~ treatment + age` | ANCOVA, common slopes |
| `change ~ treatment * age` | ANCOVA with treatment × age interaction |

---

# 7. Worked example: Chronic Obstructive Pulmonary Disease (COPD) treatments and age

**Source:** Rowe, Chapter 16, Table 16.1. In this clinical-trial example, patients were randomly assigned to OldDrug or NewDrug. The response was the **percentage change in FEV1 after one week**; age was recorded as a continuous covariate. The dataset includes 20 patients receiving OldDrug and 25 receiving NewDrug.

## Observed data

| Patient | OldDrug age | OldDrug FEV1 change (%) | NewDrug age | NewDrug FEV1 change (%) |
|---:|---:|---:|---:|---:|
| 1 | 61 | 23 | 72 | 28 |
| 2 | 70 | 24 | 47 | 46 |
| 3 | 77 | 15 | 57 | 40 |
| 4 | 64 | 26 | 65 | 30 |
| 5 | 53 | 28 | 52 | 38 |
| 6 | 52 | 30 | 72 | 27 |
| 7 | 77 | 10 | 63 | 39 |
| 8 | 69 | 24 | 64 | 36 |
| 9 | 48 | 30 | 45 | 50 |
| 10 | 43 | 33 | 63 | 41 |
| 11 | 62 | 23 | 56 | 36 |
| 12 | 44 | 33 | 57 | 46 |
| 13 | 58 | 20 | 63 | 38 |
| 14 | 72 | 16 | 57 | 37 |
| 15 | 47 | 29 | 50 | 35 |
| 16 | 66 | 27 | 46 | 52 |
| 17 | 55 | 32 | 74 | 25 |
| 18 | 73 | 11 | 74 | 25 |
| 19 | 61 | 24 | 55 | 36 |
| 20 | 53 | 23 | 65 | 29 |
| 21 | — | — | 58 | 42 |
| 22 | — | — | 56 | 38 |
| 23 | — | — | 43 | 43 |
| 24 | — | — | 50 | 48 |
| 25 | — | — | 44 | 41 |
| **Mean** | **60.25** | **24.05** | **57.92** | **37.84** |

As the treatment groups have different mean ages, their overall mean responses may differ partly because of age rather than treatment. ANCOVA accounts for this by comparing the predicted responses of the two treatment groups **at the same age**, thereby estimating the treatment effect after adjusting for age. In the common-slopes model, this adjusted treatment difference is represented by $\tau$ and is assumed to be constant across ages.

## 7.1. Explore the data and check interaction

**Interaction hypotheses:** $H_0:\gamma=0$ versus $H_A:\gamma\ne0$. Fit the model containing `treatment * age_c` and compare it with the common-slopes model using a partial F-test. 

```r
# 05_COPD_Interaction.R — base R
old_age <- c(61,70,77,64,53,52,77,69,48,43,62,44,58,72,47,66,55,73,61,53)
old_change <- c(23,24,15,26,28,30,10,24,30,33,23,33,20,16,29,27,32,11,24,23)
new_age <- c(72,47,57,65,52,72,63,64,45,63,56,57,63,57,50,46,74,74,55,65,58,56,43,50,44)
new_change <- c(28,46,40,30,38,27,39,36,50,41,36,46,38,37,35,52,25,25,36,29,42,38,43,48,41)
df <- data.frame(
  age = c(old_age, new_age),
  change = c(old_change, new_change),
  treatment = factor(c(rep("OldDrug", length(old_age)),
                       rep("NewDrug", length(new_age))),
                     levels = c("OldDrug", "NewDrug"))
)
df$age_c <- df$age - mean(df$age)
print(aggregate(cbind(age, change) ~ treatment, data = df, mean))
plot(df$age, df$change, col = as.integer(df$treatment), pch = 16,
     xlab = "Age (years)", ylab = "FEV1 change (%)")
legend("topright", legend = levels(df$treatment), col = 1:2, pch = 16)
fit_common <- lm(change ~ treatment + age_c, data = df)
fit_interaction <- lm(change ~ treatment * age_c, data = df)
print(summary(fit_interaction))
comparison <- anova(fit_common, fit_interaction)
print(comparison)
p_value <- comparison$`Pr(>F)`[2]
cat(if (p_value < 0.05) "Reject H0: evidence of interaction\n"
    else "Do not reject H0: insufficient evidence of interaction\n")
for (g in levels(df$treatment)) {
  d <- subset(df, treatment == g)
  abline(lm(change ~ age, data = d), col = which(levels(df$treatment) == g), lwd = 2)
}
```

Rowe reports an interaction p-value of approximately **0.356** (Chapter 16, Table 16.2). Since $p>0.05$, we **do not reject** $H_0:\gamma=0$. There is insufficient evidence that the age slopes differ, although this does not prove they are identical. We therefore examine the scientifically plausible common-slopes model.

## 7.2. Fit and interpret the common-slopes ANCOVA

In the common-slopes model, $H_0:\tau=0$ tests for an **age-adjusted treatment difference**, while $H_0:\beta_1=0$ tests for an association between age and response after accounting for treatment. The treatment coefficient is expressed in **percentage points**, not as a percentage relative to OldDrug.

```r
# 06_COPD_ANCOVA.R — base R
old_age <- c(61,70,77,64,53,52,77,69,48,43,62,44,58,72,47,66,55,73,61,53)
old_change <- c(23,24,15,26,28,30,10,24,30,33,23,33,20,16,29,27,32,11,24,23)
new_age <- c(72,47,57,65,52,72,63,64,45,63,56,57,63,57,50,46,74,74,55,65,58,56,43,50,44)
new_change <- c(28,46,40,30,38,27,39,36,50,41,36,46,38,37,35,52,25,25,36,29,42,38,43,48,41)
df <- data.frame(age = c(old_age, new_age),
                 change = c(old_change, new_change),
                 treatment = factor(c(rep("OldDrug", 20), rep("NewDrug", 25)),
                                    levels = c("OldDrug", "NewDrug")))
reference_age <- mean(df$age)
df$age_c <- df$age - reference_age
fit <- lm(change ~ treatment + age_c, data = df)
print(summary(fit))
print(confint(fit))
print(anova(fit))
cat("Reference age:", reference_age, "years\n")
cat("Adjusted NewDrug - OldDrug difference:",
    coef(fit)["treatmentNewDrug"], "percentage points\n")
new_patients <- data.frame(treatment = factor(c("OldDrug", "NewDrug"),
                                             levels = levels(df$treatment)),
                           age_c = c(60, 60) - reference_age)
print(cbind(new_patients, predict(fit, newdata = new_patients,
                                 interval = "confidence")))
plot(df$age, df$change, pch = 16, col = as.integer(df$treatment),
     xlab = "Age (years)", ylab = "FEV1 change (%)")
ages <- seq(min(df$age), max(df$age), length.out = 100)
for (g in levels(df$treatment)) {
  nd <- data.frame(age_c = ages - reference_age,
                   treatment = factor(rep(g, length(ages)),
                                      levels = levels(df$treatment)))
  lines(ages, predict(fit, newdata = nd),
        col = which(levels(df$treatment) == g), lwd = 2)
}
legend("topright", legend = levels(df$treatment), col = 1:2,
       pch = 16, lty = 1, bty = "n")
```

Rowe reports an age-adjusted NewDrug–OldDrug difference of approximately **12.405 percentage points** and a common age slope of approximately **−0.594 percentage points per year** (Chapter 16, Table 16.3). Interpret these as follows:

- Comparing patients **of the same age**, the model estimates an average FEV1 improvement **12.4 percentage points higher** with NewDrug.
- Holding treatment fixed, each additional year of age is associated with an average FEV1 improvement **0.594 percentage points lower**.
- These are model-based estimates, not statements that every individual patient will follow the line.

---

# 8. Comparing a t-test and ANCOVA

A two-sample t-test compares **unadjusted group means**, whereas ANCOVA compares **model-adjusted means at a common covariate value**. If age explains substantial variation in FEV1 response, adjusting for it can reduce the residual variation and improve precision. This benefit is not guaranteed, however, and covariate adjustment does not automatically eliminate confounding or bias.

For a fair comparison here, use a pooled two-sample t-test (`var.equal = TRUE`), corresponding to `lm(change ~ treatment)`; Welch's t-test uses a different variance assumption and is a separate alternative.

```r
# 08_COPD_Ttest_vs_ANCOVA.R — base R
old_age <- c(61,70,77,64,53,52,77,69,48,43,62,44,58,72,47,66,55,73,61,53)
old_change <- c(23,24,15,26,28,30,10,24,30,33,23,33,20,16,29,27,32,11,24,23)
new_age <- c(72,47,57,65,52,72,63,64,45,63,56,57,63,57,50,46,74,74,55,65,58,56,43,50,44)
new_change <- c(28,46,40,30,38,27,39,36,50,41,36,46,38,37,35,52,25,25,36,29,42,38,43,48,41)
df <- data.frame(age = c(old_age, new_age),
                 change = c(old_change, new_change),
                 treatment = factor(c(rep("OldDrug", 20), rep("NewDrug", 25)),
                                    levels = c("OldDrug", "NewDrug")))
unadjusted <- lm(change ~ treatment, data = df)
adjusted <- lm(change ~ treatment + age, data = df)
t_result <- t.test(new_change, old_change, var.equal = TRUE)
print(t_result)
print(summary(unadjusted))
print(summary(adjusted))
ci_unadjusted <- confint(unadjusted)["treatmentNewDrug", ]
ci_adjusted <- confint(adjusted)["treatmentNewDrug", ]
results <- rbind(
  Unadjusted = c(estimate = coef(unadjusted)["treatmentNewDrug"],
                 lower = ci_unadjusted[1], upper = ci_unadjusted[2],
                 residual_SD = sigma(unadjusted)),
  ANCOVA = c(estimate = coef(adjusted)["treatmentNewDrug"],
             lower = ci_adjusted[1], upper = ci_adjusted[2],
             residual_SD = sigma(adjusted))
)
print(results)
cat("CI widths:\n")
print(results[, "upper"] - results[, "lower"])
```

**Questions to answer:** Why is the unadjusted estimate about 13.79, while the age-adjusted estimate is about 12.4? Which confidence interval is narrower? What part of the within-treatment variation can age explain? Would you still adjust for age if it were measured **after** treatment and potentially affected by the drug?

---

# 9. Which statistical method should we use?

| Goal | Response | Predictor(s) | Typical R function |
|---|---|---|---|
| Compare two independent group means | Continuous | Binary group | `t.test(y ~ group)` |
| Compare three or more group means | Continuous | Categorical factor | `aov(y ~ group)` |
| Test two categorical factors and their interaction | Continuous | Two factors | `aov(y ~ A * B)` |
| Describe linear association | Two continuous variables | Neither designated as response | `cor.test(x, y)` |
| Estimate a continuous response from a measured predictor | Continuous | One continuous predictor | `lm(y ~ x)` |
| Compare treatment groups adjusting for a measured baseline covariate | Continuous | Group + continuous covariate | `lm(y ~ group + x)` |
| Ask whether a treatment effect changes with a covariate | Continuous | Group × continuous covariate | `lm(y ~ group * x)` |

**Take-home message:** ANOVA, linear regression, and ANCOVA use a shared modeling framework: **observed response = fitted systematic component + residual variation**. Choose among them according to the scientific question and the types of predictors available.

