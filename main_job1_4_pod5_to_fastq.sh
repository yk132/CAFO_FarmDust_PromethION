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
# this file covers: pod5 to fastq including quality check with fastQC 

# Download Dorado Models
JOBID_1=$(sbatch --parsable --job-name=download_model --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job1_download_model.sh)

# Run Dorado
JOBID_2=$(sbatch --parsable --dependency=afterok:${JOBID_1} --job-name=dorado --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job2_dorado_fastq_demux.sh)

# Merge FASTQ files and check for quality with fastQC
# JOBID_4=$(sbatch --parsable --dependency=afterok:${JOBID_3} --job-name=fastqc --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job4_merge_fastq_fastqc.sh)

