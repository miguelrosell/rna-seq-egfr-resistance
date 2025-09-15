#!/bin/bash
# Now we want to convert .sra files to paired .fastq.gz files, so that we can work with the fastq.gzs more easily. 
# This, like earlier, uses fasterq-dump + pigz (multithreaded gzip)

set -euo pipefail

#These are the project directories I used
PROJECT_ROOT="$HOME/Documentos/Bioinfo_projects/rna-seq-egfr"
SRA_DIR="$PROJECT_ROOT/data/sra"
OUT_DIR="$PROJECT_ROOT/data/fastq/raw"
SRR_FILE="$PROJECT_ROOT/data/srr_selected.txt"
THREADS=4

#We also create an output folder in case it doesn't exist
mkdir -p "$OUT_DIR"

#We check that SRR list exists
if [ ! -f "$SRR_FILE" ]; then
  echo "SRR list ($SRR_FILE) not found! Please make sure it exists."
  exit 1
fi

#Loop through each SRR accession
while read -r SRR; do
  SRA_FILE="$SRA_DIR/${SRR}.sra"

  # We want to check if the .sra file exists as well
  if [ ! -f "$SRA_FILE" ]; then
    echo "$SRA_FILE does not exist, skipping..."
    continue
  fi

  echo "Converting $SRR -> FASTQ..."

  #Now we run fasterq-dump to split into paired files and use multithreading; fallback to single-thread if it fails
  fasterq-dump "$SRA_FILE" -O "$OUT_DIR" --split-files --threads $THREADS || {
    echo "fasterq-dump failed with threads, retrying without threads..."
    fasterq-dump "$SRA_FILE" -O "$OUT_DIR" --split-files
  }

  # This now compresses FASTQ files using pigz if available, and gzip otherwise
  if command -v pigz >/dev/null 2>&1; then
    pigz -p $THREADS "$OUT_DIR/${SRR}_1.fastq" "$OUT_DIR/${SRR}_2.fastq"
  else
    gzip "$OUT_DIR/${SRR}_1.fastq" "$OUT_DIR/${SRR}_2.fastq"
  fi

  echo "$SRR conversion and compression done."

done < "$SRR_FILE"

echo "All FASTQ files are ready in $OUT_DIR (.fastq.gz)."
