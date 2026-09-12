# ============================================================
# Simple Bioconductor example: working with a DNA sequence
# ============================================================

# Bioconductor packages are installed using BiocManager.
# Run these installation commands only once.

#install.packages("BiocManager")
#BiocManager::install("Biostrings")


# Load the Biostrings package
library(Biostrings)


# ------------------------------------------------------------
# Create a DNA sequence
# ------------------------------------------------------------

dna <- DNAString("ATGGCCATTGTAATGGGCCGCTGAAAGGGTGCCCGATAG")

dna


# ------------------------------------------------------------
# Length of the DNA sequence
# ------------------------------------------------------------

length(dna)


# ------------------------------------------------------------
# Count each nucleotide
# ------------------------------------------------------------

letterFrequency(
  dna,
  letters = c("A", "C", "G", "T")
)


# ------------------------------------------------------------
# Calculate GC content
# ------------------------------------------------------------

gc_count <- letterFrequency(
  dna,
  letters = c("G", "C")
)

gc_percent <- sum(gc_count) / length(dna) * 100

gc_percent


# ------------------------------------------------------------
# Find the reverse complement
# ------------------------------------------------------------

reverseComplement(dna)


# ------------------------------------------------------------
# Translate DNA into an amino-acid sequence
# ------------------------------------------------------------

protein <- translate(dna)

protein

