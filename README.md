# Porcine Immune Cell Epigenomic Atlas

A comprehensive pipeline for epigenomic atlas of porcine immune cells, integrating 126 epigenetic datasets across eight sorted immune cell populations.

## Background
Understanding porcine cellular immune mechanisms is essential for optimizing animal production and establishing pigs as biomedical models for human disease. This pipeline generates and integrates ChIP-seq (histone modifications), ATAC-seq, and DNA methylation data to characterize the regulatory landscape of porcine immune cells at high resolution.

Key findings:
- Identification of **15 chromatin states** across immune cell types
- Identification of **cell-type-specific regulatory elements (csREs)**
- Prediction of **870 cell-specific super-enhancers** enriched for lineage-defining transcription factor motifs
- Integration with **PigGTEx eQTL** data and immune capacity trait GWAS variants
- **Comparative epigenomics** revealing conserved chromatin states between pig and human immune cells

## Pipeline Overview

```
1_read_processing
       ↓
2_TAD_prediction
       ↓
3_chromatin_state_prediction
       ↓
4_enhancer_target_prediction
       ↓
5_identify_cell_specific_REs
       ↓
6_superEnhancer_prediction
       ↓
7_GWAS_eQTL_integration
       ↓
8_comparative_epigenomics_analyses
```

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

**Species:** *Sus scrofa* (pig) — Reference genome: Sscrofa10.6

**Cell populations:** 8 sorted immune cell populations

**Dataset:** 126 epigenetic datasets including:
- ChIP-seq (histone modifications: activating and repressive marks)
- ATAC-seq (chromatin accessibility)
- DNA methylation
- RNAseq

---

## Tools & Software

| Tool | Usage |
|------|-------|
| [nf-core](https://nf-co.re/) | Pipeline framework for read processing and alignment |
| [MACS2](https://github.com/macs3-project/MACS) | Peak calling for ChIP-seq and ATAC-seq |
| [HOMER](http://homer.ucsd.edu/homer/) | Motif analysis, peak annotation |
| [deepTools](https://deeptools.readthedocs.io/) | BAM/bigWig processing, QC, signal visualization |
| [ROSE](https://bitbucket.org/young_computation/rose) | Super-enhancer identification |
| [MEME Suite](https://meme-suite.org/) | Transcription factor motif discovery and enrichment |

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
