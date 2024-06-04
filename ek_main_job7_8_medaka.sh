#!/usr/bin/env bash

set -u
shopt -s nullglob

#-----------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/data/CAFO_FarmDust_PromethION/CAFO_FarmDust/20240521_1737_P2S-01272-B_PAS35763_a5f7cd95"
export CAFO_GIT_DIR="${STORE_DIR}/CAFO_FarmDust_PromethION"
export LOG_DIR="${CAFO_GIT_DIR}/log_dir"
#-----------------------------

mkdir -p ${LOG_DIR}
# this file covers: polishing with medaka and QC with Quast   


# polish with medaka
#JOBID_7=$(sbatch --parsable --job-name=medaka --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job7_medaka.sh)

# and let's check contig quality 
JOBID_8=$(sbatch --parsable --job-name=quast --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job8_polished_quast.sh)
#JOBID_8=$(sbatch --parsable --dependency=afterok:${JOBID_7} --job-name=quast --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job8_polished_quast.sh)

