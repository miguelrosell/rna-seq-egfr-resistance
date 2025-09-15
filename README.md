# rna-seq-egfr-resistance
Reproducible RNA-seq pipeline (Salmon+tximport+DESeq2) identifying candidate drivers of erlotinib resistance in NSCLC (GSE121634)


# RNA-seq analysis: acquired resistance to EGFR-TKI (erlotinib) in NSCLC (pilot)

Author: Miguel Rosell Hidalgo 
Project goal: Identify transcriptional changes associated with acquired resistance to erlotinib (EGFR-TKI) in NSCLC and propose testable therapeutic hypotheses.

## Summary
This repository contains the reproducible pipeline and results for the analysis of 6 RNA-seq samples from GSE121634 (3 sensitive, 3 resistant to erlotinib). The analysis includes: SRA download, FASTQ conversion, QC (FastQC, MultiQC), quantification with Salmon, gene summarization with tximport, differential expression with DESeq2, and visualization (volcano, top gene tables).

## Repo layout
(briefly describe as above)

## Reproducible steps (high-level)
1. Prepare `data/srr_selected.txt` containing SRR IDs.
2. Download SRA files with `scripts/00_download_prefetch.sh`.
3. Convert `.sra` → `.fastq.gz` with `scripts/01_sra_to_fastq.sh`.
4. Run FastQC and MultiQC: `scripts/02_fastqc_multiqc.sh`.
5. Build Salmon index (`scripts/03_build_salmon_index.sh`) using GENCODE v49 transcriptome.
6. Quantify all samples with Salmon (`scripts/04_salmon_quant_loop.sh`).
7. Run `R` pipeline: `analysis/r/tximport_deseq2_pipeline.R` and `analysis/r/volcano_and_top20.R`.

## Key results
- `analysis/results/deseq_significant.csv`: genes passing `padj < 0.05` and |log2FC| > 1
- `analysis/results/top20_genes.csv`: top 20 genes by smallest adjusted p-value
- Figures in `analysis/results/figures/`

## Notes & caveats
- Small sample size (n=3 vs n=3): results are hypothesis generating, not clinical proof.
- Do not upload raw FASTQ/SRA to GitHub; see `data/README.md` and scripts to pull raw data.
- If you want Datasets DOI: deposit processed small files (counts + results + figures) to Zenodo and link DOI in this README.

## License
MIT (or other)

## Cite
(Include a short citation to GSE121634 and GENCODE v49, Salmon, DESeq2)
