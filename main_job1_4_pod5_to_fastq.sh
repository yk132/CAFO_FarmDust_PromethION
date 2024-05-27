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
# this file covers: pod5 to fastq including quality check with fastQC 

# Download Dorado Models
JOBID_1=$(sbatch --parsable --job-name=download_model --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job1_download_model.sh)

# Migrate all pod5 files into a single folder
JOBID_2=$(sbatch --parsable --job-name=merge --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job2_merge_pod5.sh)

# Run Dorado
JOBID_3=$(sbatch --parsable --dependency=afterok:${JOBID_1}:${JOBID_2} --job-name=dorado --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job3_dorado_fastq_demux.sh)

# Merge FASTQ files and check for quality with fastQC
JOBID_4=$(sbatch --parsable --dependency=afterok:${JOBID_3} --job-name=fastqc --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job4_merge_fastq_fastqc.sh)

