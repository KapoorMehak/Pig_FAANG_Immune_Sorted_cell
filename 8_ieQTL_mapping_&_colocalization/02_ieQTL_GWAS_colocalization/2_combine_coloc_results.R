#!/usr/bin/env Rscript
# =============================================================================
#  Module 2, step 2 : Combine per-ieQTL colocalisation summaries
# =============================================================================
#
#  Description
#  -----------
#  Merges the per-ieQTL `*.coloc_summary.csv.gz` files produced by step 1 into a
#  single table with one row per (tissue, cell type, ieGene, GWAS trait), adding
#  the tissue / cell type / gene identifiers parsed from the file names.
#
#  Usage
#  -----
#      Rscript 2_combine_coloc_results.R
#
#  Dependencies
#  ------------
#      install.packages("data.table")
#
#  Input
#  -----
#      ${DIR_COLOC_RESULTS}/${tissue}.interactions_${celltype}.${geneid}.coloc_summary.csv.gz
#
#  Output
#  ------
#      ${DIR_COMBINED}/ieqtl_and_gwas.coloc_summary.csv.gz
# =============================================================================

suppressPackageStartupMessages({
    library(data.table)
})

# Convenience string-concatenation operator.
"%&%" <- function(a, b) paste0(a, b)

# -----------------------------------------------------------------------------
# USER CONFIGURATION - edit every path below before running
# -----------------------------------------------------------------------------

# Working directory of this module; all relative paths below resolve from here.
BASE_DIR <- "/path/to/Pig_GTEx_ISU_immuneCell/ieqtl_and_gwas/coloc"

# Directory holding the per-ieQTL output of step 1.
DIR_COLOC_RESULTS <- "./output_coloc/"

# Directory where the merged table is written.
DIR_COMBINED <- "./coloc_results"

# Name of the merged output file.
OUT_FILE <- "ieqtl_and_gwas.coloc_summary.csv.gz"

# -----------------------------------------------------------------------------
# Collect the per-ieQTL summary files
# -----------------------------------------------------------------------------
setwd(BASE_DIR)
dir.create(DIR_COMBINED, showWarnings = FALSE, recursive = TRUE)

# The list of ieQTLs to merge is derived from the `*.coloc_results.csv.gz` files,
# as in the original analysis. Step 1 always writes the `.coloc_results`,
# `.coloc_summary` and `.coloc_priors` files together for a given ieQTL, so this
# selects exactly the set of ieQTLs for which a summary exists.
fs <- list.files(DIR_COLOC_RESULTS,
                 pattern = "\\.coloc_results\\.csv\\.gz$",
                 full.names = FALSE)

if (length(fs) == 0) {
    stop("No colocalisation result files found in " %&% DIR_COLOC_RESULTS)
}

# Parse tissue / cell type / gene id from file names of the form
#     ${tissue}.interactions_${celltype}.${geneid}.coloc_results.csv.gz
fname_re <- "^([^.]+)\\.interactions_([^.]+)\\.([^.]+)\\.coloc_results\\.csv\\.gz$"
parsed <- regmatches(fs, regexec(fname_re, fs))
matched <- lengths(parsed) == 4

if (!all(matched)) {
    warning("Skipping " %&% sum(!matched) %&% " file(s) with unexpected names: " %&%
            paste(fs[!matched], collapse = ", "))
}

tis_ct_gn <- do.call("rbind", lapply(parsed[matched], function(x) {
    data.frame(tissue = x[2], celltype = x[3], geneid = x[4],
               stringsAsFactors = FALSE)
}))

message("Combining " %&% nrow(tis_ct_gn) %&% " colocalisation result file(s).")

# -----------------------------------------------------------------------------
# Read and merge
# -----------------------------------------------------------------------------
coloc_summary_list <- vector("list", nrow(tis_ct_gn))

for (i in seq_len(nrow(tis_ct_gn))) {
    message(i %&% " / " %&% nrow(tis_ct_gn))

    tis <- tis_ct_gn$tissue[i]
    ct  <- tis_ct_gn$celltype[i]
    gn  <- tis_ct_gn$geneid[i]

    resprefix <- DIR_COLOC_RESULTS %&% tis %&% ".interactions_" %&% ct %&% "." %&% gn
    summary_file <- resprefix %&% ".coloc_summary.csv.gz"

    if (!file.exists(summary_file)) {
        next
    }

    coloc_summary <- fread(summary_file, nThread = 23)
    if (nrow(coloc_summary) == 0) {
        next
    }

    # Annotate each row with the identifiers parsed from the file name
    coloc_summary$tissue   <- tis
    coloc_summary$celltype <- ct
    coloc_summary$geneid   <- gn

    coloc_summary_list[[i]] <- coloc_summary
}

coloc_summary_df <- rbindlist(coloc_summary_list, fill = TRUE)

# -----------------------------------------------------------------------------
# Write the combined table
# -----------------------------------------------------------------------------
fwrite(coloc_summary_df, DIR_COMBINED %&% "/" %&% OUT_FILE)

message("Done. " %&% nrow(coloc_summary_df) %&% " colocalisation tests written to " %&%
        DIR_COMBINED %&% "/" %&% OUT_FILE)
