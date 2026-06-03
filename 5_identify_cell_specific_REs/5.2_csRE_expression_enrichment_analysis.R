library(biomaRt)

ensembl <- useMart('ensembl', host = 'http://jul2019.archive.ensembl.org',
                   dataset = 'sscrofa_gene_ensembl')
files <- list.files('5.1_identify_cell_specific_REs/output/cell_specific_states/')
states <- as.character(c(1:15))
state_cells <- c('CD21nB', 'CD21pB',
                 'CD4T',  
                 'CD8CD4T',  'CD8T',
                 'Myeloid', 'Neut',
                 'NK', 'SWC6gdT')

state_genes <- list()

for (i in 1:length(states)){
  subfiles <- paste0('5.1_identify_cell_specific_REs/output/cell_specific_states/',files[grep(paste0('state', as.numeric(states[i]), '.bed'), files)])
  state_genes[[states[i]]] <- list()
  for (j in 1:length(subfiles)){
    bed <- read.table(subfiles[j], header = F)
    if (states[i] %in% c('2','6','12','13', '14')){
      coords <-paste(bed$V1, bed$V2-10000, bed$V3+10000, sep = ':')
    }else{
      coords <- paste(bed$V1, bed$V2-2000, bed$V3+2000, sep = ':')
    }
    state_genes[[states[i]]][[state_cells[j]]] <- unique(getBM(attributes = c('ensembl_gene_id', 'external_gene_name'),
                                                       filter = 'chromosomal_region',
                                                       values = coords, mart = ensembl, useCache = FALSE)$ensembl_gene_id)
  }
}
expr <- read.table('~/enriched_immune_genes.txt', header = T)
head(expr)

expr_cells <- c('CD21-', 'CD21+', 'CD8-CD4+', 'CD8+CD4+', 'CD8+CD4-',
                'Mono', 'NEU', 'NK', 'GDTCR')

enr <- array(0, dim = c(length(state_cells), length(expr_cells), length(state_genes)),
              dimnames = list(state_cells, state_cells, states))
pval <- array(0, dim = c(length(state_cells), length(expr_cells), length(state_genes)),
              dimnames = list(state_cells, state_cells, states))

for (i in 1:length(state_genes)){
  for (j in 1:length(state_cells)){
    for (k in 1:length(expr_cells)){
      expr_enr <- as.character(expr[expr$Cell_type == expr_cells[k] & expr$Enriched == 'Yes' & expr$Significant == 'Yes',]$EnsemblID)
      enr[state_cells[j],state_cells[k],states[i]] <- (sum(state_genes[[i]][[j]] %in% expr_enr)/length(expr_enr))/(length(state_genes[[i]][[j]][state_genes[[i]][[j]] %in% expr$EnsemblID])/length(unique(expr$EnsemblID)))
      pval[state_cells[j],state_cells[k],states[i]] <- -log10(phyper(sum(state_genes[[i]][[j]] %in% expr_enr),
                            length(expr_enr),
                            length(unique(expr$EnsemblID)) - length(expr_enr),
                            length(state_genes[[i]][[j]][state_genes[[i]][[j]] %in% expr$EnsemblID]),
                            lower.tail = F))
    }
  }
}

save(state_genes, enr, pval, file ='5.2_csRE_expression_enrichment/output/csRE_expression_enrichment.Rdata')
