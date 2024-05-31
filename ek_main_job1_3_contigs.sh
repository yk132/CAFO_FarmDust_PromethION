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
# this file covers: fastQC, building contigs with metaSPAdes, QC with QUAST, mapping with Bowtie2, and visualization with angi'o  


# quailty check with fastQC 
# JOBID_1=$(sbatch --parsable --job-name=fastQC --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job1_fastqc.sh)

# build contigs; need to add dependency later! 
#JOBID_2=$(sbatch --parsable --dependency=afterok:${JOBID_1} --job-name=flye --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job2_metaFlye.sh)
###JOBID_2=$(sbatch --parsable --job-name=flye --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job2_metaFlye.sh)

# check quality before medaka with quast
JOBID_4=$(sbatch --parsable --job-name=quast --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job3_quast.sh)

# polish with medaka

# and let's check contig quality 
#JOBID_4=$(sbatch --parsable --job-name=quast --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job4_QUAST.sh)
#JOBID_4=$(sbatch --parsable --dependency=afterok:${JOBID_3} --job-name=quast --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job4_QUAST.sh)

