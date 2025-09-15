# Plot volcano and extract top genes
library(ggplot2)
library(dplyr)
project_root <- file.path(Sys.getenv("HOME"), "Documentos", "Bioinfo_projects", "rna-seq-egfr")
res <- read.csv(file.path(project_root, "analysis", "results", "deseq2_results.csv"), row.names=1)

# Volcano: protect against padj == 0 -> add small epsilon
res$padj[is.na(res$padj)] <- 1
res$minusLog10FDR <- -log10(res$padj + 1e-300)

p <- ggplot(as.data.frame(res), aes(x=log2FoldChange, y=minusLog10FDR)) +
  geom_point(aes(color = padj < 0.05 & abs(log2FoldChange) > 1), alpha=0.6) +
  scale_color_manual(values = c("grey", "red")) +
  theme_minimal() +
  labs(title="Volcano Plot - DESeq2",
       x="Log2 Fold Change (Resistant vs Sensitive)",
       y="-log10(FDR)")

ggsave(filename=file.path(project_root, "analysis", "results", "figures", "volcano.png"), plot=p, width=8, height=6)

# Significant genes
resSig <- subset(res, padj < 0.05 & abs(log2FoldChange) > 1)
write.csv(resSig, file = file.path(project_root, "analysis", "results", "deseq_significant.csv"))

# Top 20 by padj
res_top20 <- as.data.frame(resSig) %>% arrange(padj) %>% head(20)
res_top20$direction <- ifelse(res_top20$log2FoldChange > 0, "Up in Resistant", "Up in Sensitive")
write.csv(res_top20, file=file.path(project_root, "analysis", "results", "top20_genes.csv"))
