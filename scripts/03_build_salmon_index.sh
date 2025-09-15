#!/bin/bash
set -euo pipefail
PROJECT_ROOT="$HOME/Documentos/Bioinfo_projects/rna-seq-egfr"
REF_DIR="$PROJECT_ROOT/reference"
TRANSCRIPT_FASTA="$REF_DIR/gencode.v49.transcripts.fa.gz"   # or transcripts.fa
INDEX_DIR="$REF_DIR/salmon_index"

mkdir -p "$REF_DIR"

if [ ! -d "$INDEX_DIR" ]; then
  echo "Building Salmon index (this may take a while)..."
  salmon index -t "$TRANSCRIPT_FASTA" -i "$INDEX_DIR" --gencode
  echo "Index built at $INDEX_DIR"
else
  echo "Index already exists at $INDEX_DIR"
fi
