library(tidyverse)

input_dir <- file.path("./7_GWAS_eQTL_enrichment_analyses/GWAS_overlap")

gwas_enha1_files <- list.files(input_dir)
gwas_enha1_files <- gwas_enha1_files[grepl("EnhA1.txt", gwas_enha1_files) & !grepl("gz", gwas_enha1_files)]

tcell_traits <- c("./Data/GWAS_bed/S_CD4CD8LR.bed.gz", "./Data/GWAS_bed/S_CD4CD8NP.bed.gz",
                  "./Data/GWAS_bed/S_CD4LP.bed.gz", "/Data/GWAS_bed/S_CD4NCD8NP.bed.gz",
                  "./Data/GWAS_bed/S_CD4NCD8P.bed.gz", "./Data/GWAS_bed/S_CD8LP.bed.gz")

sig_gwas_list <- list()

# Filter overlaps for SNPS associated with T cell traits
for (file in gwas_enha1_files[c(5:10, 17:18)]) {

  sig_gwas_list[[file]] <- read.table(file.path(input_dir, file)) %>%
    rename("state_chr" = V1,
           "state_start" = V2,
           "state_end" = V3,
           "state" = V4,
           "trait" = V5,
           "snp_chr" = V6,
           "snp_start" = V7,
           "snp_end" = V8,
           "snp_id" = V9,
           "pvalue" = V10) %>%
    filter(pvalue < 1e-15 & trait %in% tcell_traits)

}
# filter for all QTL SNP regions above
bcell_qtl_enh <- enh_target %>%
  filter(((enh_chr == 2 & enh_start > 100822800 & enh_end < 101723600) | (enh_chr == 16 & enh_start > 51200 & enh_end < 432600) | (enh_chr == 5 & enh_start > 62072400 & enh_end < 63304600)) & cell_type %in% c("Bcell", "CD21pB", "CD21nB", "common"))

bcell_qtl_target_genes <- bcell_qtl_enh %>%
  pull(target_gene_name) %>%
  unique()

bcell_qtl_enr_genes <- enr_genes %>%
  filter(Symbol %in% bcell_qtl_target_genes) %>%
  pull(Symbol) %>%
  unique()

bcell_qtl_enh %>%
  filter(target_gene_name %in% tcell_qtl_enr_genes) %>%
  print(n = 33)

# Repeat for myeloid genes
myeloid_gwas_list <- list()

for (file in gwas_enha1_files[11:14]) {

  myeloid_gwas_list[[file]] <- read.table(file.path(input_dir, file)) %>%
    rename("state_chr" = V1,
           "state_start" = V2,
           "state_end" = V3,
           "state" = V4,
           "trait" = V5,
           "snp_chr" = V6,
           "snp_start" = V7,
           "snp_end" = V8,
           "snp_id" = V9,
           "pvalue" = V10) %>%
    filter(pvalue < 1e-6 & trait %in% c("./Data/GWAS_bed/S_IFGIL10.bed.gz", "./Data/GWAS_bed/S_LYSOZ.bed.gz", "./Data/GWAS_bed/S_WBC.bed.gz", "./Data/GWAS_bed/S_MONOP.bed.gz", "./Data/GWAS_bed/S_NEUT.bed.gz"))

}


# filter enhancers for QTL SNP regions
myeloid_qtl_enh <- enh_target %>%
  filter(((enh_chr == 7 & enh_start >= 12626800 & enh_end <= 12678400) | (enh_chr == 7 & enh_start >= 19486200 & enh_end <= 19486600)))

myeloid_qtl_target_genes <- myeloid_qtl_enh %>%
  pull(target_gene_name) %>%
  unique()

myeloid_qtl_enr_genes <- enr_genes %>%
  filter(Symbol %in% myeloid_qtl_target_genes & Cell_type == "Mono") %>%
  pull(Symbol) %>%
  unique()

myeloid_qtl_enh %>%
  filter(X7 %in% myeloid_qtl_enr_genes) %>%
  print(n = 33)




## Superenhancer


gwas_se_files <- list.files(input_dir)
gwas_se_files <- gwas_se_files[grepl("SuperEnhancers.txt", gwas_se_files) & !grepl("gz|Bcell", gwas_se_files)]

tcell_traits <- c("./Data/GWAS_bed/S_CD4CD8LR.bed.gz", "./Data/GWAS_bed/S_CD4CD8NP.bed.gz",
                  "./Data/GWAS_bed/S_CD4LP.bed.gz", "/Data/GWAS_bed/S_CD4NCD8NP.bed.gz",
                  "./Data/GWAS_bed/S_CD4NCD8P.bed.gz", "./Data/GWAS_bed/S_CD8LP.bed.gz")

sig_gwas_list <- list()

for (file in gwas_se_files) {

  sig_gwas_list[[file]] <- read.table(file.path(input_dir, file)) %>%
    rename("state_chr" = V1,
           "state_start" = V2,
           "state_end" = V3,
           "state" = V4,
           "trait" = V5,
           "snp_chr" = V6,
           "snp_start" = V7,
           "snp_end" = V8,
           "snp_id" = V9,
           "pvalue" = V10) %>%
    filter(pvalue < 1e-15 & trait %in% tcell_traits)

}

lapply(sig_gwas_list, nrow)

lapply(sig_gwas_list, function(x) x[x$pvalue < 1e-30,])

tcell_qtl_enh <- enh_target %>%
  filter(X1 == 5 & X2 >= 62700000 & X3 <= 67195200)

tcell_qtl_target_genes <- tcell_qtl_enh %>%
  pull(X7) %>%
  unique()

tcell_qtl_enr_genes <- enr_genes %>%
  filter(Symbol %in% tcell_qtl_target_genes & Cell_type %in% c("CD8+CD4-", "CD8-CD4+", "CD8+CD4+")) %>%
  pull(Symbol) %>%
  unique()

tcell_qtl_enh %>%
  filter(X7 %in% tcell_qtl_enr_genes) %>%
  print(n = 33)



