setwd(D:/Data)

# Load required libraries
library(data.table)
library(dplyr)
library(ggplot2)

# Read the data from the gzipped file
data <- fread("hiring_task/Homo_sapiens.gene_info.gz", sep="\t")

# Select the necessary columns
data_needed <- data[, c("Symbol", "chromosome")]

# Count the frequency of each chromosome
chromosome_counts <- table(data_needed$chromosome)

# Add chromosome counts to the data table
data_needed$chromosome_counts <- chromosome_counts[as.character(data_needed$chromosome)]

# Select unique chromosome counts
Chromosome_gene_counts <- unique(data_needed[, c("chromosome", "chromosome_counts")])


# Order by chromosome, ensuring X/Y/MT/Un come last
Chromosome_gene_counts <- Chromosome_gene_counts %>%
  arrange(
    factor(chromosome, levels = c(1:22, "X", "Y", "MT", "Un"))  # Factor with custom order
  )

# Exclude the 25th, 26th and 28th columns
Chromosome_gene_counts <- Chromosome_gene_counts[-c(27,28,29), ]

# Convert chromosome column to factor with custom levels
Chromosome_gene_counts$chromosome <- factor(Chromosome_gene_counts$chromosome, levels = unique(Chromosome_gene_counts$chromosome))

# Draw histogram
ggplot(Chromosome_gene_counts, aes(x = chromosome, y = chromosome_counts)) +
  geom_bar(fill = "gray") +
  labs(x = "Chromosome", y = "Gene count", title = "Number of genes in each chromosome") 


# Save plot as PDF
ggsave("chromosome_gene_counts.pdf", plot)
