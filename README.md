REPRODUCIBLE RNA-SEQ PIPELINE WITH SALMON+TXIMPORT+DESEQ2 CAN IDENTIFY CANDIDATE DRIVERS OF ERLOTINIB RESISTANCE IN NSCLC (GSE121634).

Author: Miguel Rosell Hidalgo
The project goal was to work to identify the transcriptional changes that are associated with erlotinib (EGFR-TKI) resistance in NSCLC and to propose therapeutic hypotheses.

##SUMMARY
This repository contains the reproducible pipeline and results for analysis of 6 RNA-seq samples from GSE121634 (3 sensitive, 3 resistant to erlotinib). The analysis includes the SRA download and FASTQ conversion as well as QC like FastQC, MultiQC. It also features quantification by way of Salmon, gene summarization with tximport, differential expression by the use of DESeq2, and visualization by means of volcano plots and top gene tables.

##TAKE INTO ACCOUNT¡
1. `data/srr_selected.txt` should have SRR IDs therein. You must prepare it.
2. Using `scripts/00_download_prefetch.sh`, download SRA files.
3. Convert `.sra` into `.fastq.gz` by using `scripts/01_sra_to_fastq.sh`.
4. Execute FastQC then MultiQC `scripts/02_fastqc_multiqc.sh`.
5. Salmon index is built using GENCODE v49 transcriptome (`scripts/03_build_salmon_index.sh`).
6. All of the samples should be quantified with use of Salmon (`scripts/04_salmon_quant_loop.sh`).
7. Run `R` pipeline: `analysis/r/tximport_deseq2_pipeline` executes. `R` and `analysis/r/volcano_in_top20`. R`.

##KEY RESULTS
- `analysis/results/deseq_significant.csv`: genes pass |log2FC| exceeding 1 plus `padj < 0.05`
- Best 20 genes by least adjusted p-value: `analysis/results/top20_genes.csv`
- Figures exist in `analysis/results/figures/`.

##NOTES AND CAVEATS
- Small sample size (n=3 vs n=3): results create hypotheses, they are not clinical evidence.
- See `data/README.md` along with scripts to pull raw data, do not upload raw FASTQ/SRA to GitHub.

##LICENSE
MIT 

