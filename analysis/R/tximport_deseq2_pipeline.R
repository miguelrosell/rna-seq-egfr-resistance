# tximport + DESeq2 pipeline: THIS IS THE R CODE I USED ONCE I HAD THE quants.sf FILES FROM SALMON.
# Use tximport with the Gencode annotation file you downloaded.
# tximport converts transcript-level data (from Salmon) to gene-level counts, summing/weighting all transcripts per gene.
# The result is a gene-by-sample count matrix (genes in rows, samples in columns).
# This matrix is prepared for DESeq2 (although we haven't run DESeq2 yet in the script), allowing downstream differential expression analysis.
# Run this in the analysis/r/ folder or adjust paths!!¡¡

library(tximport)
library(readr)
library(DESeq2)
library(GenomicFeatures)
library(dplyr)

project_root <- Sys.getenv("HOME") %>% file.path("Documentos","Bioinfo_projects","rna-seq-egfr")
base_dir <- file.path(project_root, "quants")
samples <- c("SRR8088203","SRR8088204","SRR8088205","SRR8088206","SRR8088207","SRR8088208")
files <- file.path(base_dir, samples, "quants.sf")
names(files) <- samples

# Create tx2gene map from GTF
gtf_file <- file.path(project_root, "reference", "gencode.v49.chr_patch_hapl_scaff.basic.annotation.gtf.gz")
txdb <- makeTxDbFromGFF(gtf_file, format="gtf")
tx2gene <- select(txdb, keys=keys(txdb, keytype="TXNAME"), keytype="TXNAME", columns="GENEID")
colnames(tx2gene) <- c("transcript_id", "gene_id")

# Import with tximport (gene summarization)
txi <- tximport(files, type="salmon", tx2gene=tx2gene)

# Define sample table: three sensitive then three resistant
coldata <- data.frame(row.names = names(files),
                      condition = c("sensitive","sensitive","sensitive",
                                    "resistant","resistant","resistant"))

# Create DESeq object
dds <- DESeqDataSetFromTximport(txi, colData = coldata, design = ~ condition)

# Pre-filtering
keep <- rowSums(counts(dds)) > 1
dds <- dds[keep,]

# Run DESeq
dds <- DESeq(dds)

# Results: resistant vs sensitive
res <- results(dds, contrast=c("condition","resistant","sensitive"))
resOrdered <- res[order(res$padj),]

# Save results
write.csv(as.data.frame(resOrdered), file=file.path(project_root, "analysis", "results", "deseq2_results.csv"))
