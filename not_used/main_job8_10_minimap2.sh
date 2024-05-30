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
# this file covers: getting the database for minimap2 from wf_metagenomics pipeline, using minimap2 for classification
# and again using wf_metagenomics pipeline to convert minimap2 results to tsv (sam -> bam -> tsv) 

# Download database
JOBID_8=$(sbatch --parsable --job-name=getdb --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job8_getdb.sh)
## this yields an error that I can't really track back but still downloads the database

# Run minimap2 and convert res to bam 
## this is for CHECKING!!!
# JOBID_9=$(sbatch --parsable --job-name=minimap --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job9_minimap2.sh)

JOBID_9=$(sbatch --parsable --dependency=afterok:${JOBID_8} --job-name=minimap --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job9_minimap2.sh)

# Convert minimap2 res to tsv
## this is for CHECKING!! 
# JOBID_10=$(sbatch --parsable --job-name=tsv --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job10_bam_to_tsv.sh)

JOBID_10=$(sbatch --parsable --dependency=afterok:${JOBID_8}:${JOBID_9} --job-name=tsv --output="$LOG_DIR/%x.%j.out" --error="$LOG_DIR/%x.%j.err" Job10_bam_to_tsv.sh)

