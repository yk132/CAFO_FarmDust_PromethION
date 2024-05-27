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
# this file covers: building contigs with metaSPAdes, QC with QUAST, mapping with Bowtie2, and visualization with angi'o  

# Download Dorado Models
JOBID_5=$(sbatch --parsable --job-name=metaspades --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job5_metaSPAdes.sh)

# quailty check with QUAST
JOBID_6=$(sbatch --parsable --dependency=afterok:${JOBID_5} --job-name=quast --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job6_QUAST.sh)

# Mapping: for now, build bowtie2 index
JOBID_7=$(sbatch --parsable --dependency=afterok:${JOBID_5}:${JOBID_6} --job-name=mapping --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job7_mapping.sh)

## This is for CHECKING new code only! Dependency has been removed. 
#JOBID_6=$(sbatch --parsable --job-name=quast --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job6_QUAST.sh)

## This is for CHECKING new code only! Dependency has been removed. 
# JOBID_7=$(sbatch --parsable --job-name=bwa --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job7_bwa.sh)
