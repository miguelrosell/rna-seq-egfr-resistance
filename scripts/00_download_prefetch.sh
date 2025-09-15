
#!/bin/bash
#Download SRR files for RNA-seq project (it is robust, reproducible and with messages and error handling)

set -euo pipefail

#Project root
PROJECT_ROOT="$HOME/Documentos/Bioinfo_projects/rna-seq-egfr"
cd "$PROJECT_ROOT"

#We use this to create folder structure
mkdir -p data/sra data/fastq/raw data/fastq/gz qc results

#SRR list
SRR_FILE="data/srr_selected.txt"
if [ ! -f "$SRR_FILE" ]; then
  echo "Creating $SRR_FILE with selected SRR accessions..."
  cat > "$SRR_FILE" <<'EOF'
SRR8088203
SRR8088204
SRR8088205
SRR8088206
SRR8088207
SRR8088208
EOF
fi

#Download SRR files
while read -r SRR; do
  echo "Prefetching $SRR..."
  prefetch "$SRR" -O data/sra || { echo "Prefetch failed for $SRR"; exit 1; }
done < "$SRR_FILE"

echo "We have downloaded the .sra files to data/sra/"

