#!/usr/bin/env bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=20G

set -Eeuo pipefail # https://stackoverflow.com/a/821419


#-----------------------------
FASTQ_BAM_DIR_ARRAY=(${FASTQ_BAM_DIR}/*.bam)
#-----------------------------

BAM_FILE=${FASTQ_BAM_DIR_ARRAY[$SLURM_ARRAY_TASK_ID]}

BAM_BASE=$(basename "$BAM_FILE" ".bam")
FASTQ_FILE="${FASTQ_OUT_DIR}/${BAM_BASE}.fastq.gz"
TEMP_FASTQ_FILE="${FASTQ_OUT_DIR}/${BAM_BASE}_${SLURM_ARRAY_TASK_ID}.fastq.gz"

echo "Filtering $BAM_FILE"

# -----------------------------------
# Filter BAMs to remove simplex donors to Duplex reads
# -----------------------------------
# https://github.com/nanoporetech/dorado/issues/327
# https://github.com/nanoporetech/dorado/issues/189
#
# samtools view -b -h -d dx:1 all_reads.bam > duplex.bam
# samtools view -b -h -d dx:0 all_reads.bam > simplex.bam
#
# The below code should output a bam file containing only duplex (dx:1) and unpaired simplex (dx:0) reads with the donor simplex (dx:-1) reads removed

# printf "1\n0\n" > tag.txt
# samtools view -b -h -D dx:tags.txt all_reads.bam > duplex_Simplex.bam

if [ -f "${FASTQ_FILE}" ]; then 
  echo "${FASTQ_FILE} exists. Skipping 'samtools fastq'"
else
  echo "Running 'samtools fastq' on ${BAM_FILE}"
  apptainer exec \
	  ${DORADO_SIF_PATH} \
    samtools fastq \
      -0 ${TEMP_FASTQ_FILE} \
      --threads ${SLURM_JOB_CPUS_PER_NODE} \
      ${BAM_FILE}

  FASTQ_BAM_EXIT=$?

  if [ "$FASTQ_BAM_EXIT" -eq 0 ]; then
    echo "simplex filter bam successful"
    mv ${TEMP_FASTQ_FILE} ${FASTQ_FILE}
  else
    echo "simplex filter bam FAILED"
    rm ${TEMP_FASTQ_FILE}
  fi
fi


