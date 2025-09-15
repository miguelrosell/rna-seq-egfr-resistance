#!/bin/bash
set -euo pipefail
PROJECT_ROOT="$HOME/Documentos/Bioinfo_projects/rna-seq-egfr"
FASTQ_DIR="$PROJECT_ROOT/data/fastq/raw"   # fastq.gz files
OUTPUT_DIR="$PROJECT_ROOT/quants"
SALMON_INDEX="$PROJECT_ROOT/reference/salmon_index"
THREADS=8

mkdir -p "$OUTPUT_DIR"

# list of SRR IDs
SRR_LIST=(8088203 8088204 8088205 8088206 8088207 8088208)

for SRR in "${SRR_LIST[@]}"; do
  OUT="$OUTPUT_DIR/SRR${SRR}"
  if [ -d "$OUT" ]; then
    echo "SRR${SRR} already exists at ${OUT}. Skipping."
    continue
  fi
  echo "Quantifying SRR${SRR}..."
  salmon quant -i "$SALMON_INDEX" -l A \
    -1 "$FASTQ_DIR/SRR${SRR}_1.fastq.gz" \
    -2 "$FASTQ_DIR/SRR${SRR}_2.fastq.gz" \
    --seqBias --gcBias -p $THREADS -o "$OUT"
done
