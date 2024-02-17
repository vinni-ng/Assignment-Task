setwd("D:/Data")

# List all files and directories
dir()

# Question 1

# Load the zip library
library(zip)

# Unzip the file
unzip("hiring_task.zip")

# Load the data.table library
library(data.table)

# Read the data from the gzipped file
data <- fread("hiring_task/Homo_sapiens.gene_info.gz", sep="\t")

# Store column "GeneID", "Symbol", "Synonyms" in another variable named data_needed
data_needed <- data[, c("GeneID", "Symbol", "Synonyms")]

# Load the tidyr library
library(tidyr)

# Split the Synonyms column into individual gene names and mapping
symbol_to_geneid_map <- data_needed %>%
  separate_rows(Synonyms, sep = "\\|")


# Question 2

# Read the GMT file
gmt_file <- "hiring_task/h.all.v2023.1.Hs.symbols.gmt"
gmt_lines <- readLines(gmt_file)

# Function to replace symbols with Entrez IDs
replace_symbols_with_entrez <- function(gene_symbols, symbol_to_geneid_map) {
  entrez_ids <- sapply(gene_symbols, function(symbol) {
    map <- symbol_to_geneid_map[which(symbol_to_geneid_map$Symbol == symbol), ]
    if (nrow(map) > 0) {
      return(map$GeneID)
    } else {
      return(NA)  # If symbol not found, return NA
    }
  })
  return(entrez_ids)
}

# Replace symbols with Entrez IDs in GMT lines
updated_gmt_lines <- lapply(gmt_lines, function(line) {
  fields <- unlist(strsplit(line, "\t"))
  gene_symbols <- fields[-(1:2)]  # Exclude pathway name and description
  entrez_ids <- replace_symbols_with_entrez(gene_symbols, symbol_to_geneid_map)
  updated_line <- paste(fields[1:2], entrez_ids, collapse = "\t")
  return(updated_line)
})

# Convert updated_gmt_lines to character vectors if necessary
updated_gmt_lines <- lapply(updated_gmt_lines, function(line) as.character(line))

# Write the updated GMT file
output_gmt_file <- "updated_h.all.v2023.1.Hs.entrez.gmt"
writeLines(unlist(updated_gmt_lines), con = output_gmt_file)
cat("Updated GMT file has been created:", output_gmt_file, "\n")


