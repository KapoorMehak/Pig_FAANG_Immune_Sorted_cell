library(biomaRt)

load('/immuneCell_cpm_by_tad.Rdata')
h3k27ac_cpm <- read.table('/enh_tmm_normalized_h3k27ac_cpm.txt', header = T)
head(h3k4me1_cpm)

atac_cpm <- read.table('/enh_tmm_normalized_ATAC_cpm_cells.txt',header = T)
head(atac_cpm)

loops <- read.table('/merged_loops.bed12',header = T)
names(loops) <- c('chr', 'start', 'end')

enh_annot <- read.table('/*_enh_cts.txt',header = T, row.names = 1)
enh_annot <- enh_annot[rownames(enh_annot) %in% rownames(atac_cpm),1:3]
head(enh_annot)

atac_cpm <- atac_cpm[,names(immuneCell_tad_tpm[[1]])]
h3k27ac_cpm <- h3k27ac_cpm[,names(immuneCell_tad_tpm[[1]])]
h3k4me1_cpm <- h3k4me1_cpm[,names(immuneCell_tad_tpm[[1]])]

atac_cor_mat <- list()
atac_pval_mat <- list()
h3k27ac_cor_mat <- list()
h3k27ac_pval_mat <- list()
h3k4me1_cor_mat <- list()
h3k4me1_pval_mat <- list()

system.time({
  for (i in 1:nrow(loops)){
    enh <- atac_cpm[rownames(enh_annot[as.character(enh_annot$Chr) == as.character(loops$chr[i]) & enh_annot$Start > loops$start[i] & enh_annot$Start < loops$end[i],]),]
    atac_cor_mat[[paste(loops$chr[i], paste(loops$start[i], loops$end[i], sep = '-'), sep = ':')]] <- matrix(0, nrow(enh), nrow(immuneCell_tad_tpm[[i]]),
                                                                                                              dimnames = list(rownames(enh), rownames(immuneCell_tad_tpm[[i]])))
    atac_pval_mat[[paste(loops$chr[i], paste(loops$start[i], loops$end[i], sep = '-'), sep = ':')]] <- matrix(0, nrow(enh), nrow(immuneCell_tad_tpm[[i]]),
                                                                                                               dimnames = list(rownames(enh), rownames(immuneCell_tad_tpm[[i]])))
    if (nrow(enh) > 0 & nrow(immuneCell_tad_tpm[[i]]) > 0){
      for (j in 1:nrow(enh)){
        for (k in 1:nrow(immuneCell_tad_tpm[[i]])){
          atac_cor_mat[[i]][j,k] <- cor.test(unlist(enh[j,]), unlist(immuneCell_tad_tpm[[i]][k,]), method = 'pearson')$estimate
          atac_pval_mat[[i]][j,k] <- cor.test(unlist(enh[j,]), unlist(immuneCell_tad_tpm[[i]][k,]), method = 'pearson')$p.value
        }
      }
    }
    enh <- h3k27ac_cpm[rownames(enh_annot[as.character(enh_annot$Chr) == as.character(loops$chr[i]) & enh_annot$Start > loops$start[i] & enh_annot$Start < loops$end[i],]),]
    h3k27ac_cor_mat[[paste(loops$chr[i], paste(loops$start[i], loops$end[i], sep = '-'), sep = ':')]] <- matrix(0, nrow(enh), nrow(immuneCell_tad_tpm[[i]]),
                                                                                                             dimnames = list(rownames(enh), rownames(immuneCell_tad_tpm[[i]])))
    h3k27ac_pval_mat[[paste(loops$chr[i], paste(loops$start[i], loops$end[i], sep = '-'), sep = ':')]] <- matrix(0, nrow(enh), nrow(immuneCell_tad_tpm[[i]]),
                                                                                                              dimnames = list(rownames(enh), rownames(immuneCell_tad_tpm[[i]])))
    if (nrow(enh) > 0 & nrow(immuneCell_tad_tpm[[i]]) > 0){
      for (j in 1:nrow(enh)){
        for (k in 1:nrow(immuneCell_tad_tpm[[i]])){
          h3k27ac_cor_mat[[i]][j,k] <- cor.test(unlist(enh[j,]), unlist(immuneCell_tad_tpm[[i]][k,]), method = 'pearson')$estimate
          h3k27ac_pval_mat[[i]][j,k] <- cor.test(unlist(enh[j,]), unlist(immuneCell_tad_tpm[[i]][k,]), method = 'pearson')$p.value
        }
      }
    }
    enh <- h3k4me1_cpm[rownames(enh_annot[as.character(enh_annot$Chr) == as.character(loops$chr[i]) & enh_annot$Start > loops$start[i] & enh_annot$Start < loops$end[i],]),]
    h3k4me1_cor_mat[[paste(loops$chr[i], paste(loops$start[i], loops$end[i], sep = '-'), sep = ':')]] <- matrix(0, nrow(enh), nrow(immuneCell_tad_tpm[[i]]),
                                                                                                                dimnames = list(rownames(enh), rownames(immuneCell_tad_tpm[[i]])))
    h3k4me1_pval_mat[[paste(loops$chr[i], paste(loops$start[i], loops$end[i], sep = '-'), sep = ':')]] <- matrix(0, nrow(enh), nrow(immuneCell_tad_tpm[[i]]),
                                                                                                                 dimnames = list(rownames(enh), rownames(immuneCell_tad_tpm[[i]])))
    if (nrow(enh) > 0 & nrow(immuneCell_tad_tpm[[i]]) > 0){
      for (j in 1:nrow(enh)){
        for (k in 1:nrow(immuneCell_tad_tpm[[i]])){
          h3k4me1_cor_mat[[i]][j,k] <- cor.test(unlist(enh[j,]), unlist(immuneCell_tad_tpm[[i]][k,]), method = 'pearson')$estimate
          h3k4me1_pval_mat[[i]][j,k] <- cor.test(unlist(enh[j,]), unlist(immuneCell_tad_tpm[[i]][k,]), method = 'pearson')$p.value
        }
      }
    }
  }
})

save(atac_cor_mat, atac_pval_mat, h3k27ac_cor_mat, h3k27ac_pval_mat, h3k4me1_cor_mat, h3k4me1_pval_mat,
     file ='immuneCell_enhancer_gene_correlation_matrices.Rdata')

