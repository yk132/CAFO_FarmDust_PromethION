#!/usr/bin/env bash

set -Eeuo pipefail # https://stackoverflow.com/a/821419
shopt -s nullglob

#-----------------------------
POD_DIR_ARRAY=(${SPLIT_POD5_DIR}/channel-*.pod5)

FILE_COUNT=${#POD_DIR_ARRAY[@]}
FILE_COUNT=$(( $FILE_COUNT - 1 ))
#-----------------------------

# 2. Duplex basecalling https://github.com/nanoporetech/dorado?tab=readme-ov-file#duplex
JOBID_20=$(sbatch --parsable --array=0-$FILE_COUNT --job-name=dorado_duplex --partition=${GPUJOB_PARTITION} --gpus=${GPUJOB_GPUS} --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.err" ${SCRIPT_PATH}/dorado_duplex__sbatch_job.sh)

# 3. Demux. Need to demux before mapping because demux trims reads!

if [ -v KIT_NAME ]; then 
    echo "KIT_NAME is $KIT_NAME. Queuing demux"
    JOBID_30=$(sbatch --parsable --dependency=afterok:${JOBID_20} --job-name=demux --partition=${CPUJOB_PARTITION} --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.err" ${SCRIPT_PATH}/demux__sbatch_job.sh)
    export CUR_BAM_DIR=${DEMUX_DIR}
else 
    echo "KIT_NAME is blank. Skipping demux - merging bams"
    JOBID_30=$(sbatch --parsable --dependency=afterok:${JOBID_20} --job-name=mergebams --partition=${CPUJOB_PARTITION} --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.err" ${SCRIPT_PATH}/mergebams__sbatch_job.sh)
    export CUR_BAM_DIR=${MERGED_UBAM_DIR}
fi

if [ -v GENERATE_FASTQ ] && [ "TRUE" == "${GENERATE_FASTQ}" ]; then 
    echo "GENERATE_FASTQ is SET. Generating FASTQs"
    mkdir -p ${FULL_FASTQS} ${SIMPLEX_FILTER_BAMS} ${SIMPLEX_FILTER_FASTQS}
    JOBID_40=$(sbatch --parsable --dependency=afterok:${JOBID_30} --job-name=main_part3 --partition=${CPUJOB_PARTITION} --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.err" ${SCRIPT_PATH}/main_part3__sbatch.sh)
else 
    echo "GENERATE_FASTQ is UNSET. Skipping FASTQ generation"
fi

# sjobexitmod -l 8207864 | grep FAILED

# 4. Map reads
# Run Mapping and Sorting
# sbatch --dependency=afterok:$JOBID_1 --array=0-$FILE_COUNT --job-name=map --output="$BAM_DIR/%x-%A-%a.log" --error="$BAM_DIR/%x-%A-%a.log" sbatch_map_job.sh
#-----


#-----------------------------

