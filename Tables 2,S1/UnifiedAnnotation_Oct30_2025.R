# Set working directory
setwd("C:/Users/eliez/Documents/OneDrive - Imperial College London/PhD/Bioinformatics")

# Load necessary libraries
library(biomaRt)
library(dplyr)
library(stringr)
library(readr)

# Load GeneCards genes
GeneCards_df <- read_csv("GCR2.csv") #"Dermatitis, Atopic"
GeneCards_df <- GeneCards_df[GeneCards_df$`Relevance score` >= 4, ]
GeneCards_genes <- GeneCards_df$`Gene Symbol`

common_genes <- GeneCards_genes #to get genes without SNP filtering, run and jump to line 32

# Load Consensus SNPs genes
ConsensusSNPs_df <- read.csv("ConsensusSNPs.csv", stringsAsFactors = FALSE)
ConsensusSNPs_genes <- unique(ConsensusSNPs_df[,1])

# Clean encoding if needed
ConsensusSNPs_genes <- iconv(ConsensusSNPs_genes, from = "UTF-8", to = "ASCII//TRANSLIT")
ConsensusSNPs_genes <- ConsensusSNPs_genes[!is.na(ConsensusSNPs_genes) & ConsensusSNPs_genes != ""]

# Find intersection
common_genes <- intersect(GeneCards_genes, ConsensusSNPs_genes)

# Check how many
cat("Number of genes in both datasets:", length(common_genes), "\n")

# Connect to Ensembl Biomart
ensembl <- useMart("ensembl", dataset = "hsapiens_gene_ensembl")

# Retrieve GO Biological Process annotations
gene_annotations <- getBM(
  attributes = c("external_gene_name", "go_id", "name_1006"),
  filters = "external_gene_name",
  values = common_genes,
  mart = ensembl
)

# Rename columns for clarity
colnames(gene_annotations) <- c("Gene", "GO", "Annotation")

# Source"ParamsXGenesDictionary.R" first

keyword_lists <- list(
  YpbKp = keywordsYpbKp,
  dB = keywordsdB,
  KB = keywordsKB,
  KA = keywordsKA,
  KC = keywordsKC,
  Ybr = keywordsYbr,
  Ybb = keywordsYbb,
  Yab = keywordsYab,
  dC = keywordsdC,
  dA = keywordsdA
)

# Loop over all keyword lists
for (key in names(keyword_lists)) {
  current_keywords <- keyword_lists[[key]]
  
  filtered_genes <- gene_annotations %>%
    filter(!is.na(Annotation) & Annotation != "") %>%
    filter(str_detect(tolower(Annotation), paste(tolower(current_keywords), collapse = "|")))
  
  assign(paste0("FilteredGenes_", key), filtered_genes)
  
  write.csv(filtered_genes, paste0("FilteredGenes_", key, ".csv"), row.names = FALSE)
}

filtered_genes_objects <- ls(pattern = "^FilteredGenes_")

for (obj_name in filtered_genes_objects) {
  df <- get(obj_name)
  unique_genes <- unique(df$Gene)
  cat("\nUnique genes in", obj_name, ":\n")
  print(unique_genes)
}
