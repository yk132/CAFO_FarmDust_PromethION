#!/usr/bin/env bash

set -u
shopt -s nullglob

#-----------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"
export CAFO_GIT_DIR="${CAFO_DIR}/CAFO_Nanopore_clean"
export LOG_DIR="${CAFO_GIT_DIR}/log_dir"
#-----------------------------

mkdir -p ${LOG_DIR}
# this file covers: make abundance tables with MetaPhlAn4. 

# Run metaphlan4
JOBID_11=$(sbatch --parsable --job-name=metaphlan --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job11_metaphlan_retry_v2.sh)

## RETRY code
#JOBID_11=$(sbatch --parsable --job-name=metaphlan --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job11_metaphlan_retry.sh)
# Run ABRicate. This can be done concurrently 
# JOBID_12=$(sbatch --parsable --job-name=abricate --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job12_abricate.sh)



#JOBID_10=$(sbatch --parsable --dependency=afterok:${JOBID_8}:${JOBID_9} --job-name=tsv --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job10_bam_to_tsv.sh)

