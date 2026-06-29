# Bioconductor packages
require(SingleCellExperiment)

load('~/Downloads/sce.Rdata')
sce
counts(sce)


# what do the counts look like?


# normalization
# log CPM+1, SCT
assay(sce, 'normcounts') <- log1p(1000* t(t(counts(sce)) / colSums(counts(sce))))
require(scuttle)
sce <- logNormCounts(sce)


# what do the normalized counts look like?


# feature selection
rowData(sce)$geneVar <- rowVars(assay(sce,'logcounts'))
minVar <- sort(rowData(sce)$geneVar, decreasing = TRUE)[1000] # 5000
sce <- sce[rowData(sce)$geneVar >= minVar, ]


# dim reduction
# pca, umap/tsne
# prcomp(t(assay(sce,'normcounts')))
pca <- BiocSingular::runPCA(t(assay(sce,'logcounts')), rank = 20)
require(irlba)
pca <- irlba::prcomp_irlba(t(assay(sce,'normcounts')), n = 10)

# components of output

# % variance explained
plot(0:20, cumsum(c(0, pca$sdev^2)) , type = 'b')


reducedDim(sce,'pca') <- pca$x

require(uwot)
umap <- uwot::umap(reducedDim(sce,'pca'))


# clustering
# SC3, Seurat
require(scran)
clus <- clusterCells(sce, use.dimred='pca',
                     BLUSPARAM=NNGraphParam(cluster.fun="louvain")) 


plot(umap, asp=1, col = colorby(clus))

# cell type ID
# sc-type, singleR, scPred

# differential abundance
# exact test

# differential expression
# pseudobulk?


