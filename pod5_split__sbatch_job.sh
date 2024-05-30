#!/usr/bin/env bash

# #SBATCH --partition=chsi
# #SBATCH -A chsi

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50
#SBATCH --mem=150G

# #SBATCH --mail-type=END,FAIL

# Things seem to go wrong with pod5 subset if --cpus-per-task is too high. 
# Might be able to go higher than 50 cpus, but I haven't titrated it
# A test run with 50 cpus on 100Gb data (~1TB) from one PromethION finished in 2 hours 
# Memory utilization maxed out at 72.06 GB, so I am reducing --mem from 300G to 150G
# Note that running pod5 subset with input POD5s on /datacommons and output on /cwork 
# seemed to be much faster than running pod5 subset with both input and output on /cwork

set -Eeuo pipefail # https://stackoverflow.com/a/821419

POD5_SUMMARY_WCHANNEL="${WORK_DIR}/pod5_summary_wchannel.tsv"
POD5_VIEW_STAMP="${STAMP_DIR}/pod5_view_stamp.txt"
POD5_SUBSET_STAMP="${STAMP_DIR}/pod5_subset_stamp.txt"


# pod5 view /path/to/your/dataset/ --include "read_id, channel" --output summary.tsv
if [ -f "${POD5_VIEW_STAMP}" ]; then 
  echo "${POD5_VIEW_STAMP} exists. Skipping pod5 view"
else
  echo "Running pod5 view"

  apptainer exec \
    ${POD5_SIF_PATH} \
    pod5 view ${POD5_DIR} --include "read_id, channel" --output ${POD5_SUMMARY_WCHANNEL}
  date > $POD5_VIEW_STAMP
fi

# pod5 subset /path/to/your/dataset/ --summary summary.tsv --columns channel --output split_by_channel
if [ -f "${POD5_SUBSET_STAMP}" ]; then 
  echo "${POD5_SUBSET_STAMP} exists. Skipping pod5 subset"
else
  echo "Running pod5 subset"
  mkdir -p $SPLIT_POD5_DIR

  apptainer exec \
    ${POD5_SIF_PATH} \
    pod5 subset ${POD5_DIR} --summary ${POD5_SUMMARY_WCHANNEL} --columns channel --threads $SLURM_JOB_CPUS_PER_NODE --output $SPLIT_POD5_DIR
  date > $POD5_SUBSET_STAMP

fi

# Need to submit subsequent jobs here, because the number of per-channel pod5 
# files isn't known until after "pod5 running" subset. We need to know the 
# number of files to submit as an sbatch array
sbatch --job-name=main_2 --output="$LOG_DIR/%x-%A-%a.log" --error="$LOG_DIR/%x-%A-%a.log"    ${SCRIPT_PATH}/main_part2__sbatch.sh

