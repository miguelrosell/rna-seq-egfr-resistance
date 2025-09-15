#!/bin/bash
set -euo pipefail
PROJECT_ROOT="$HOME/Documentos/Bioinfo_projects/rna-seq-egfr"
FASTQ_DIR="$PROJECT_ROOT/data/fastq/raw"
QC_DIR="$PROJECT_ROOT/qc_reports"

mkdir -p "$QC_DIR"

echo "Running FastQC..."
fastqc "$FASTQ_DIR"/*.fastq.gz -o "$QC_DIR" -t 4

echo "Running MultiQC..."
cd "$QC_DIR"
multiqc .
