#!/bin/bash
# Download listed SRR files using prefetch (more robust for TLS issues)
set -euo pipefail
PROJECT_ROOT="$HOME/Documentos/Bioinfo_projects/rna-seq-egfr"
cd "$PROJECT_ROOT"

mkdir -p data/sra
# SRR list is in data/srr_selected.txt
while read -r SRR; do
  echo "Prefetching $SRR..."
  prefetch "$SRR" -O data/sra || { echo "prefetch failed for $SRR"; exit 1; }
done < data/srr_selected.txt

echo "Done downloading .sra files to data/sra/"
