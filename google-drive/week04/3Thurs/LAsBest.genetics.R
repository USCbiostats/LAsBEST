#libraries we'll need to install
# basic package to pull from github
install.packages("remotes")
# nice color themes
remotes::install_github("jakelawlor/PNWColors") 
# coalescent simulator
install.packages("learnPopGen")

# tidyverse
install.packages("tidyverse")

# randomized SVD
install.packages("rsvd")

# broom
install.packages("broom")

# Part I: Simulate genotype at a single variant in a population with no inbreeding
# aka Hardy-Weinberg Equilbrium (HWE)

# minor allele frequency
p <- 0.1
n_ind <- 100

# sample from binomial distribution (assuming HWE)
G <- rbinom(n_ind, 2, p)

# Using moment estimation
Nxx <- table(G)
exp_p_hat <- (2 * Nxx[3] + Nxx[2]) / (2 * n_ind)
exp_q_hat <- (2 * Nxx[1] + Nxx[2]) / (2 * n_ind)

cat("True frequency: ", p, " Moment-based Estimated frequency: ", exp_p_hat)

# Using MLE estimators
mle_p_hat <- mean(G) / 2.0
mle_q_hat <- 1 - p_hat

cat("True frequency: ", p, " MLE Estimated frequency: ", mle_p_hat)

library(PNWColors)
library(learnPopGen)

# let's simulate a haploid population with constant population size 10 over
# 15 generations with no selection or population structure
n_ind <- 10
n_gen <- 15

# setup color palette
colors <- pnw_palette("Bay", n_ind)

# this should generate a figure
coalescent.plot(n=n_ind, ngen=n_gen, colors = colors)

# let's load genotype data from YRI and CEU individuals in 1000G/Geuvadis
load("GEUVADIS.chr22.LABEST.RData")

# Part II let's inspect actual genotyping data

# first let's load tidyverse to make analysis smoother
library(tidyverse)

#inspect our new data
head(df_geuv)

#dimensions of genotype data on chr 22
dim(G)

# check if missing data
any(is.na(G))

# replace missing values with mean == 2*maf
for (c_idx in 1:ncol(G)) {
  c_jdx <- is.na(G[,c_idx])
  G[c_jdx, c_idx] <- mean(G[,c_idx], na.rm=TRUE)
}

# let's compute the principal components using only chr 22
# first let's center and scale
Z <- scale(G)
chr22_svd <- rsvd::rsvd(Z, k=5)

#check the dimensions
dim(chr22_svd$u)

# do this to simplify downstream plotting
chr22_svd_u <- chr22_svd$u
colnames(chr22_svd_u) <- paste0("PC", 1:5)
df_chr22_svd_u <- bind_cols(tibble(IID = rownames(Z)), as_tibble(chr22_svd_u))

# PC1 v PC2 on chr22 data
ggplot(df_chr22_svd_u, aes(PC1, PC2)) + 
  geom_point()

# pull pop info from `df_geuv`
df_chr22_svd_u <- left_join(df_chr22_svd_u, df_geuv %>% select(IID, POP), by="IID")
ggplot(df_chr22_svd_u, aes(PC1, PC2, color=POP)) + 
  geom_point()

# compare with pre-computed genome-wide estimates
ggplot(df_geuv, aes(PC1, PC2, color=POP)) + 
  geom_point()

# Part III GWAS

# simulate from the alternative of genetics -> complex trait
# heritability of 10%
h2g <- 0.1
n_ind <- nrow(Z)
p_snp <- ncol(Z)
beta <- rnorm(p_snp, sd=sqrt(h2g / p_snp))
g_ind <- Z %*% beta
s2g <- var(g_ind)
s2e <- (s2g * ( 1 / h2g) )- s2g
y <- g_ind + rnorm(n_ind, sd=sqrt(s2e))

for (c_idx in 1:p_snp) {
  tidy(lm(y  ~ G[,c_idx]))
}
