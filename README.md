# Porcine Immune Cell Epigenomic Atlas

This study presents a comprehensive epigenomic characterization of the regulatory elements controlling gene expression within major immune cell types circulating in healthy pigs. By integrating 126 epigenomic datasets across eight sorted immune cell populations, we provide a detailed catalogue of predicted chromatin states and cell-type-specific regulatory elements integrated using ChIP-seq (histone modifications), ATAC-seq, RNA-seq and DNA methylation data to characterize the regulatory landscape of porcine immune cells at high resolution.This work directly contributes to using genomic data to describe and improve phenomics in agriculture and extends the value of the domestic pig as a model for human immunity.

Key findings:
- Identification of **15 chromatin states** across immune cell types
- Identification of **cell-type-specific regulatory elements (csREs)**
- Prediction of **870 celltype-specific super-enhancers** enriched for lineage-defining transcription factor motifs
- Integration with **PigGTEx eQTL** data and immune capacity trait GWAS variants
- **Comparative epigenomics** revealing conserved chromatin states between pig and human immune cells

---
## Directory Structure

| Folder | Description |
|--------|-------------|
| `1_read_processing` | QC, trimming, alignment, and peak calling for ChIP-seq, ATAC-seq, and DNA methylation data |
| `2_TAD_prediction` | Topologically associating domain boundary prediction across immune cell types |
| `3_chromatin_state_prediction` | Genome segmentation into 15 chromatin states using HMM |
| `4_enhancer_target_prediction` | Linking enhancers to putative target genes using activity correlation and 3D chromatin data |
| `5_identify_cell_specific_REs` | Identification of cell-type-specific regulatory elements (csREs) across eight immune populations |
| `6_superEnhancer_prediction` | Super-enhancer, annotation, and TF motif enrichment analysis |
| `7_GWAS_eQTL_integration` | Enrichment of csREs for PigGTEx eQTLs and immune trait GWAS variants |
| `8_comparative_epigenomics_analyses` | Cross-species comparison of chromatin states between porcine and human immune cells |

---

## Data

**Species:** *Sus scrofa* (pig) — Reference genome: Sscrofa11.1

**Cell populations:** 8 sorted immune cell populations

**Dataset:** 126 epigenetic datasets including:
- ChIP-seq (histone modifications: activating and repressive marks,CTCF)
- ATAC-seq (chromatin accessibility)
- DNA methylation
- RNAseq
  
**Data Availibilty:**
- NCBI BioProject: PRJEB51699
- UCSC Genome Broswer: https://genome.ucsc.edu/s/mkapoor/susScr11
- FAANG Track Hub Broswer: https://api.faang.org/files/trackhubs/susScr11_sorted_cell/hub.txt
---

## Setup

1. Clone the repository:
```bash
git clone git@github.com:KapoorMehak/Pig_FAANG_Immune_Sorted_cell.git
cd Pig_FAANG_Immune_Sorted_cell
```

2. Submit jobs via SLURM:
```bash
sbatch *.sh
```
