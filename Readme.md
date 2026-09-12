# Biostatistics-CDFD-2026

Course materials, R scripts, examples, and notes for the **Biostatistics 2026** course.

The repository is organized lecture-wise. Each lecture folder contains the corresponding R scripts, data files, and lecture notes.

## Repository structure

```text
Biostatistics-CDFD-2026/
│
├── README.md
│
└── Lec01/
    ├── Lec01.md
    ├── Rbasics.R
    ├── ReadCSV.R
    ├── Plotggplot2.R
    ├── BioConductor.R
    └── data files used in the examples
```

Additional lecture folders will be added as the course progresses.

## Lecture 01

Lecture 01 introduces R and follows this sequence:

1. **R Basics** — basic syntax, variables, vectors, data frames, descriptive statistics, plots, statistical tests, correlation, and linear regression.
2. **Reading data files** — reading CSV/TSV files, inspecting data, selecting rows and columns, modifying data, and saving results.
3. **ggplot2** — introduction to plotting with `ggplot2`, including scatter plots and fitted regression lines.
4. **Bioconductor** — a first example using `Biostrings` to work with DNA sequences.

Lecture notes:

[**Lec01/Lec01.md**](https://github.com/raghurama123/Biostatistics-CDFD-2026/tree/main/Lec01/Lec01.md)

Lecture folder:

[**Lec01**](https://github.com/raghurama123/Biostatistics-CDFD-2026/tree/main/Lec01)

## General reference

The main general reference for the course is the online book:

**Modern Statistics for Modern Biology**
Susan Holmes and Wolfgang Huber

https://www.huber.embl.de/msmb/

The book provides a modern introduction to statistical thinking and data analysis for biological applications, with extensive use of R and Bioconductor.

## Working with the repository

Clone the repository:

```bash
git clone https://github.com/raghurama123/Biostatistics-CDFD-2026.git
cd Biostatistics-CDFD-2026
```

The lecture folders can then be opened in RStudio.

When possible, use relative file paths in the R scripts so that the examples work after cloning the repository on another computer.

For example, if `students.csv` is in the same folder as the R script:

```r
students <- read.csv("students.csv")
```

rather than using a computer-specific absolute path.

## Software

The examples primarily use:

* **R**
* **RStudio**
* **ggplot2**
* **Bioconductor**

Some Bioconductor examples use the `Biostrings` package.

To install the required packages:

```r
install.packages("ggplot2")
install.packages("BiocManager")
BiocManager::install("Biostrings")
```

## Notes

The repository will be updated as new lectures, examples, and exercises are added during the course.
# 
