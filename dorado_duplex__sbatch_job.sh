#!/usr/bin/env bash

#SBATCH --mem=20G
#SBATCH --cpus-per-task=6
# #SBATCH --partition=chsi-gpu
# #SBATCH -A chsi

# #SBATCH --ntasks=1
# #SBATCH --gres=gpu:1

# #SBATCH --exclusive


set -u

#-------------------------------
if [ -v SLURM_GPUS_ON_NODE ] && (( $SLURM_GPUS_ON_NODE >= 1 )); then
  export DORADO_DEVICE="cuda:all" ;
else 
  export DORADO_DEVICE="cpu" ;
fi
echo $DORADO_DEVICE
echo ${DORADO_SIF_PATH}
#-----------------------------
POD_DIR_ARRAY=(${SPLIT_POD5_DIR}/channel-*.pod5)
#-----------------------------

POD5_FILE=${POD_DIR_ARRAY[$SLURM_ARRAY_TASK_ID]}

POD5_BASE=$(basename "$POD5_FILE" ".pod5")
DORADO_OUTPUT_BAM="${UBAM_DIR}/${POD5_BASE}.ubam"



DORADO_DUPLEX_STAMP="${STAMP_DIR}/dorado_duplex_${POD5_BASE}.txt"

if [ -f "${DORADO_DUPLEX_STAMP}" ]; then 
  echo "${DORADO_DUPLEX_STAMP} exists. Skipping dorado duplex"
else
  echo "Running dorado duplex on ${POD5_FILE}"

  # running 'dorado duplex' in DORADO_MODEL_DIR 
  # so that it finds the models downloaded there
  cd $DORADO_MODEL_DIR

  apptainer exec \
    --nv \
    ${DORADO_SIF_PATH} \
    dorado duplex \
      ${DORADO_MODEL_STRING} \
      ${POD5_FILE} \
      --device $DORADO_DEVICE \
      --threads $SLURM_JOB_CPUS_PER_NODE \
    > ${DORADO_OUTPUT_BAM}
  
  
  DUPLEX_EXIT=$?

  if [ "$DUPLEX_EXIT" -eq 0 ]; then
    echo "dorado duplex successful: ${POD5_BASE}"
    date > $DORADO_DUPLEX_STAMP
  else
    echo "dorado duplex FAILED: ${POD5_BASE}"
  fi

fi

