#!/usr/bin/env bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=20G

set -Eeuo pipefail # https://stackoverflow.com/a/821419



#-----------------------------
CUR_BAM_DIR_ARRAY=(${CUR_BAM_DIR}/*.bam)
#-----------------------------

BAM_FILE=${CUR_BAM_DIR_ARRAY[$SLURM_ARRAY_TASK_ID]}

BAM_BASE=$(basename "$BAM_FILE" ".bam")
FILTERED_BAM="${SIMPLEX_FILTER_BAMS}/${BAM_BASE}.bam"
TEMP_FILTERED_BAM="${SIMPLEX_FILTER_BAMS}/${BAM_BASE}_temp.bam"

# SIMPLEX_FILTER_BAM_STAMP="${STAMP_DIR}/simplex_filter_bam_stamp_${BAM_BASE}.txt"

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

if [ -f "${FILTERED_BAM}" ]; then 
  echo "${FILTERED_BAM} exists. Skipping 'samtools merge'"
else
  echo "Running 'samtools merge' on per-channel uBAMs"
  apptainer exec \
	  ${DORADO_SIF_PATH} \
    samtools view -b -h \
      -D dx:${BAM_FILTER} \
      --threads ${SLURM_JOB_CPUS_PER_NODE} \
      ${BAM_FILE} > \
      ${TEMP_FILTERED_BAM}

  SIMPLEX_FILTER_BAM_EXIT=$?

  if [ "$SIMPLEX_FILTER_BAM_EXIT" -eq 0 ]; then
    echo "simplex filter bam successful"
    #  date > $SIMPLEX_FILTER_BAM_STAMP
    mv ${TEMP_FILTERED_BAM} ${FILTERED_BAM}
  else
    echo "simplex filter bam FAILED"
    rm ${TEMP_FILTERED_BAM}
  fi
fi

