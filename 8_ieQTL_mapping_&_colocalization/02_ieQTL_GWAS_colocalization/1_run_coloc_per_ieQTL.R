#!/usr/bin/env Rscript
# =============================================================================
#  Module 2, step 1 : Colocalisation between cell-type-specific ieQTLs and GWAS
# =============================================================================
#
#  Description
#  -----------
#  For a single significant ieQTL (selected by a row index into the table of
#  significant ieQTLs), this script runs `coloc::coloc.abf()` - the Approximate
#  Bayes Factor colocalisation test - between
#
#      (1) the ieQTL cis-association signal of the ieGene (quantitative trait),
#          taken from the FULL cis-QTL summary statistics produced by tensorQTL
#          in interaction mode (Module 1 re-run without --best_only), and
#      (2) each GWAS trait that has at least one variant with p < 1e-5 on the
#          same chromosome.
#
#  Only variants belonging to the ieGene itself are used, and the genotype main
#  effect (b_g / b_g_se / pval_g) is compared with the GWAS effect. This is the
#  standard way of asking whether a single shared causal variant drives both the
#  cell-type-dependent expression change and the GWAS phenotype (PP.H4).
#
#  The script is meant to be run once per ieQTL, typically as an HPC array job
#  with one task per row of the significant-ieQTL table.
#
#  Usage
#  -----
#      Rscript 1_run_coloc_per_ieQTL.R xi=1
#
#      # one array task per significant ieQTL
#      qsub -t 1-<N_IEQTL> -cwd -pe smp 1 run_coloc_array.sh
#
#  Dependencies
#  ------------
#      install.packages(c("coloc", "data.table", "dplyr", "tidyr"))
#
#  Output (written to DIR_OUTPUT)
#  ------------------------------
#      ${tissue}.interactions_${celltype}.${geneid}.coloc_results.csv.gz
#          Per-variant posterior probabilities for every GWAS trait tested.
#      ${tissue}.interactions_${celltype}.${geneid}.coloc_summary.csv.gz
#          One row per GWAS trait with the colocalisation posterior
#          probabilities PP.H0..PP.H4 (PP.H4 = shared causal variant).
#      ${tissue}.interactions_${celltype}.${geneid}.coloc_priors.csv.gz
#          The priors used by coloc.abf for each run.
# =============================================================================

suppressPackageStartupMessages({
    library(coloc)
    library(data.table)
    library(dplyr)
    library(tidyr)
})

# Convenience string-concatenation operator.
"%&%" <- function(a, b) paste0(a, b)

# -----------------------------------------------------------------------------
# USER CONFIGURATION - edit every path below before running
# -----------------------------------------------------------------------------

# Working directory of this module; all relative paths below resolve from here.
BASE_DIR <- "/path/to/Pig_GTEx_ISU_immuneCell/ieqtl_and_gwas/coloc"

# FULL tensorQTL interaction-mode cis-QTL summary statistics, one sub-directory
# per tissue:
#     ${DIR_FULL_SUMMARY}/${tissue}/${tissue}.interactions_${celltype}.cis_qtl_pairs.${chr}.txt.gz
DIR_FULL_SUMMARY <- "/path/to/Pig_GTEx_ISU_immuneCell/ieqtl_and_gwas/prepare_ieqtl_full_summary/output_full_summary"

# GWAS summary statistics, one gzipped tab-delimited file per trait:
#     ${DIR_GWAS_SUMMARY}/${trait}.txt.gz
DIR_GWAS_SUMMARY <- "/path/to/Pig_GTEx/MetaGWAS_V3/GWAS_Summary_Release/Overlap_GWAS_eQTL_v3.1"

# Gene annotation used to obtain the TSS. The column `end` is taken as the TSS
# (transcription start site). Expected columns include: gene_id, ..., end.
FILE_TSS_ANNOT <- "/path/to/Pig_GTEx_eQTL/eqtl_mapping/Sus_scrofa.Sscrofa11.1.100.tss.gz"

# Pre-computed list of trait/chromosome pairs that carry at least one GWAS
# variant with p < 1e-5. Format: one "trait.chr<N>" identifier per line, no
# header. Used to skip GWAS traits with no signal on the ieQTL chromosome.
FILE_TRAIT_CHR_SIG <- "/path/to/Pig_GTEx_GWAS_and_eQTLs/Preprocessing_v3/Trait.CHR.significant_1e-5.txt"

# Table of significant ieQTLs to test, one row per ieQTL.
# Required columns: tissue, celltype, gene, var_id
FILE_IEQTL_SIG <- "../../ase_for_ieqtl/ASEval_ieQTL_DF.significant.csv.gz"

# Output directory, relative to BASE_DIR.
DIR_OUTPUT <- "./output_coloc/"

# cis-window (bp) around the TSS used to subset the GWAS summary statistics.
CIS_WINDOW <- 1e6

# GWAS significance threshold: traits whose minimum p-value inside the cis-window
# is above this value are skipped.
GWAS_PVAL_THRESHOLD <- 1e-5

# -----------------------------------------------------------------------------
# Command-line arguments: a single row index `xi` into FILE_IEQTL_SIG
# -----------------------------------------------------------------------------
args <- commandArgs(TRUE)

if (length(args) == 0) {
    stop("No arguments supplied. Usage: Rscript 1_run_coloc_per_ieQTL.R xi=<index>")
}
for (a in args) {
    eval(parse(text = a))   # e.g. "xi=1" creates the variable `xi`
}
if (!exists("xi")) {
    stop("Argument `xi` (row index of the significant-ieQTL table) is required.")
}
xi <- as.integer(xi)

# -----------------------------------------------------------------------------
# Load reference tables
# -----------------------------------------------------------------------------
setwd(BASE_DIR)
dir.create(DIR_OUTPUT, showWarnings = FALSE, recursive = TRUE)

# GWAS trait names = file names of the GWAS summary directory (without ".txt.gz")
traits <- gsub(".txt.gz", "", list.files(DIR_GWAS_SUMMARY))

tss_annot <- fread(FILE_TSS_ANNOT)

# trait/chromosome pairs with at least one genome-wide suggestive GWAS signal
Trait.CHR.sig <- fread(FILE_TRAIT_CHR_SIG, header = FALSE)$V1

# Table of significant ieQTLs (one row per tissue / cell type / ieGene / ieSNP)
ASEval_ieQTL_DF <- fread(FILE_IEQTL_SIG)
nrieqtl <- nrow(ASEval_ieQTL_DF)

# =============================================================================
# Colocalisation for a single ieQTL
# =============================================================================
message(xi %&% " / " %&% nrieqtl)

tmp      <- ASEval_ieQTL_DF[xi, ]
tissue   <- tmp$tissue
celltype <- tmp$celltype
geneid   <- tmp$gene
CHR      <- gsub("_(.)*", "", tmp$var_id)   # chromosome parsed from the variant id

# TSS of the ieGene (used to centre the cis-window)
tss_pos_hits <- tss_annot$end[tss_annot$gene_id == geneid]
if (length(tss_pos_hits) == 0) {
    stop("No TSS annotation found for gene " %&% geneid)
}
tss_pos <- tss_pos_hits[1]

# -----------------------------------------------------------------------------
# 1. Build the ieQTL dataset for coloc (genotype main effect of the ieGene)
# -----------------------------------------------------------------------------
path_ieqtl <- DIR_FULL_SUMMARY %&% "/" %&% tissue %&% "/" %&% tissue %&%
    ".interactions_" %&% celltype %&% ".cis_qtl_pairs." %&% CHR %&% ".txt.gz"

ieqtl <- fread(path_ieqtl, data.table = FALSE)
ieqtl <- ieqtl[ieqtl$phenotype_id == geneid, ]          # keep the ieGene only

# variant_id has the form chr_pos_ref_alt
ieqtl <- separate(ieqtl, variant_id, c("chr", "pos", "ref", "alt"), remove = FALSE)
ieqtl <- rename(ieqtl, snp = variant_id)

# Sample size reconstructed from allele count / allele frequency
# (ma_count / af / 2 gives the number of samples when af <= 0.5).
ieqtl_samplesize <- unique(round((ieqtl$ma_count / ieqtl$af / 2)[ieqtl$af <= 0.5]))

# Map tensorQTL columns onto the names expected by coloc:
#     pval_g   -> pvalues     (genotype main-effect p-value)
#     b_g      -> beta        (genotype main-effect effect size)
#     b_g_se   -> varbeta     (standard error; squared below to obtain a variance)
#     af       -> MAF
ieqtl_clean <- ieqtl %>%
    select(snp, pos, af, pval_g, b_g, b_g_se) %>%
    rename(MAF = af, pvalues = pval_g, position = pos, beta = b_g, varbeta = b_g_se) %>%
    as.list()

# coloc expects MAF in (0, 0.5]
ieqtl_clean$MAF[ieqtl_clean$MAF > 0.5] <- 1 - ieqtl_clean$MAF[ieqtl_clean$MAF > 0.5]
ieqtl_clean$position <- as.numeric(ieqtl_clean$position)
ieqtl_clean$type <- "quant"          # expression is a quantitative trait
ieqtl_clean$N <- ieqtl_samplesize
ieqtl_clean$varbeta <- ieqtl_clean$varbeta ^ 2   # SE -> variance

check_dataset(ieqtl_clean)

# -----------------------------------------------------------------------------
# 2. Loop over GWAS traits and run coloc.abf against the ieQTL signal
# -----------------------------------------------------------------------------
coloc_results_df <- data.frame()
coloc_summary_df <- data.frame()
coloc_priors_df  <- data.frame()

# The original analysis looped over all 268 GWAS traits released in MetaGWAS
# V3.1; seq_along(traits) is equivalent as long as the GWAS summary directory
# contains exactly those files.
for (yi in seq_along(traits)) {
    message(yi)
    trait <- traits[yi]

    # Skip traits with no suggestive signal on this chromosome
    if (!trait %&% "." %&% "chr" %&% CHR %in% Trait.CHR.sig) {
        message("Without significant GWAS SNPs.")
        next
    }

    # Read only the header and the rows of the chromosome of interest, which
    # avoids loading the full genome-wide GWAS summary into memory.
    gwas <- fread(
        cmd = "zcat " %&% DIR_GWAS_SUMMARY %&% trait %&% ".txt.gz | grep -P 'chromosome|" %&% "chr" %&% CHR %&% "'",
        nThread = 23
    )

    # Restrict to the cis-window around the ieGene TSS
    gwas <- gwas[which(gwas$position >= (tss_pos - CIS_WINDOW) &
                       gwas$position <= (tss_pos + CIS_WINDOW)), ]

    if (min(gwas$pvalue) > GWAS_PVAL_THRESHOLD) {
        message("Without significant GWAS SNPs.")
        next
    }

    gwas <- rename(gwas, snp = variant_id)

    # coloc requires at least one shared variant
    if (length(intersect(ieqtl_clean$snp, gwas$snp)) == 0) {
        message("Without overlapped SNPs.")
        next
    }

    # Map GWAS columns onto the names expected by coloc. Note that
    # `standard_error` is renamed to `varbeta` and squared below.
    gwas_clean <- gwas %>%
        select(snp, position, frequency, standard_error, effect_size, pvalue, sample_size) %>%
        rename(pvalues = pvalue, beta = effect_size, varbeta = standard_error,
               MAF = frequency, N = sample_size) %>%
        as.list()

    gwas_clean$MAF[gwas_clean$MAF > 0.5] <- 1 - gwas_clean$MAF[gwas_clean$MAF > 0.5]
    gwas_clean$type <- "quant"
    gwas_clean$varbeta <- gwas_clean$varbeta ^ 2   # SE -> variance

    # Approximate Bayes Factor colocalisation test
    coloc_results <- coloc.abf(ieqtl_clean, gwas_clean)

    # Tag every table with the trait so results can be merged downstream
    coloc_results$results$trait <- trait
    coloc_results$summary$trait <- trait
    coloc_results$priors$trait  <- trait

    coloc_results_df <- rbind(coloc_results_df, coloc_results$results)
    coloc_summary_df <- rbind(coloc_summary_df, coloc_results$summary)
    coloc_priors_df  <- rbind(coloc_priors_df,  coloc_results$priors)
}

# -----------------------------------------------------------------------------
# 3. Write results
# -----------------------------------------------------------------------------
# NOTE: ieQTLs for which no GWAS trait passed the filters above have no output,
# and the array task terminates with an error. This is expected and the
# corresponding ieQTL is simply absent from the combined table produced by
# 2_combine_coloc_results.R.
if (nrow(coloc_summary_df) == 0) {
    stop("No results output.")
}

prefix_output <- DIR_OUTPUT %&% tissue %&% ".interactions_" %&% celltype %&% "." %&% geneid

fwrite(coloc_results_df, prefix_output %&% ".coloc_results.csv.gz")
fwrite(coloc_summary_df, prefix_output %&% ".coloc_summary.csv.gz")
fwrite(coloc_priors_df,  prefix_output %&% ".coloc_priors.csv.gz")
