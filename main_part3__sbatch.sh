#!/usr/bin/env bash

set -Eeuo pipefail # https://stackoverflow.com/a/821419
shopt -s nullglob

#-----------------------------
BAM_DIR_ARRAY=(${CUR_BAM_DIR}/*.bam)

FILE_COUNT=${#BAM_DIR_ARRAY[@]}
FILE_COUNT=$(( $FILE_COUNT - 1 ))
#-----------------------------


mkdir -p ${FULL_FASTQS} ${SIMPLEX_FILTER_FASTQS}

#--------------------
# Setup for BAM filtering
export BAM_FILTER=${RESULTS_DIR}/bam_filter_tag.txt
printf "1\n0\n" > ${BAM_FILTER}
#--------------------

JOBID_50=$(sbatch --parsable --array=0-$FILE_COUNT --job-name=bam_filter --partition=${GPUJOB_PARTITION} --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.err" ${SCRIPT_PATH}/simplex_filter_bams__sbatch_job.sh)

export FASTQ_BAM_DIR=${CUR_BAM_DIR}
export FASTQ_OUT_DIR=${FULL_FASTQS}
JOBID_60=$(sbatch --parsable --array=0-$FILE_COUNT --job-name=total_fastqs --partition=${GPUJOB_PARTITION} --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.err" ${SCRIPT_PATH}/fastq_gen__sbatch_job.sh)


export FASTQ_BAM_DIR=${SIMPLEX_FILTER_BAMS}
export FASTQ_OUT_DIR=${SIMPLEX_FILTER_FASTQS}
JOBID_70=$(sbatch --parsable --array=0-$FILE_COUNT --dependency=afterok:$JOBID_50 --job-name=simpfilt_fastqs --partition=${GPUJOB_PARTITION} --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.err" ${SCRIPT_PATH}/fastq_gen__sbatch_job.sh)

