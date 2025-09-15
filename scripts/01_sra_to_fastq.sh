#!/bin/bash
# Convert .sra to paired .fastq.gz using fasterq-dump and pigz (if available)
set -euo pipefail
PROJECT_ROOT="$HOME/Documentos/Bioinfo_projects/rna-seq-egfr"
SRA_DIR="$PROJECT_ROOT/data/sra"
OUT_DIR="$PROJECT_ROOT/data/fastq/raw"
THREADS=4

mkdir -p "$OUT_DIR"

for SRA in "$SRA_DIR"/*.sra; do
  SRR=$(basename "$SRA" .sra)
  echo "Converting $SRR -> FASTQ..."
  # fasterq-dump will create SRR_1.fastq and SRR_2.fastq in $OUT_DIR
  fasterq-dump "$SRA" -O "$OUT_DIR" --split-files --threads $THREADS || {
    echo "fasterq-dump failed for $SRR — trying without threads..."
    fasterq-dump "$SRA" -O "$OUT_DIR" --split-files
  }

  # compress (use pigz if available)
  if command -v pigz >/dev/null 2>&1; then
    pigz -p 4 "$OUT_DIR/${SRR}_1.fastq" "$OUT_DIR/${SRR}_2.fastq"
  else
    gzip "$OUT_DIR/${SRR}_1.fastq" "$OUT_DIR/${SRR}_2.fastq"
  fi
done

echo "FASTQ conversion done. Files are in $OUT_DIR (compressed .fastq.gz)."
