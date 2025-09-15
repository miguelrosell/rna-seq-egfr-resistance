#!/bin/bash
# Similar to 04 but more robust: will resume only missing SRRs
set -euo pipefail
PROJECT_ROOT="$HOME/Documentos/Bioinfo_projects/rna-seq-egfr"
FASTQ_DIR="$PROJECT_ROOT/data/fastq/raw"
OUTPUT_DIR="$PROJECT_ROOT/quants"
SALMON_INDEX="$PROJECT_ROOT/reference/salmon_index"
THREADS=8
SRR_LIST=(8088203 8088204 8088205 8088206 8088207 8088208)

for SRR in "${SRR_LIST[@]}"; do
  OUT="$OUTPUT_DIR/SRR${SRR}"
  if [ -d "$OUT" ]; then
    echo "SRR${SRR} already processed — skipping."
    continue
  fi
  if [ ! -f "$FASTQ_DIR/SRR${SRR}_1.fastq.gz" ] || [ ! -f "$FASTQ_DIR/SRR${SRR}_2.fastq.gz" ]; then
    echo "FASTQ for SRR${SRR} not found — skipping. Check data/fastq/raw"
    continue
  fi
  echo "Processing SRR${SRR} ..."
  salmon quant -i "$SALMON_INDEX" -l A \
    -1 "$FASTQ_DIR/SRR${SRR}_1.fastq.gz" \
    -2 "$FASTQ_DIR/SRR${SRR}_2.fastq.gz" \
    --seqBias --gcBias -p $THREADS -o "$OUT"
done
