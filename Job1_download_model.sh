#!/usr/bin/env bash
#SBATCH --mail-type=ALL
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=10G

set -u

#------------------------
export DORADO_SIF_PATH='oras://gitlab-registry.oit.duke.edu/granek-lab/granek-container-images/dorado-simg:0.4.2'
export WORK_DIR="/work/${USER}" # CHANGE ME if needed 
export DORADO_MODEL_DIR="${WORK_DIR}/dorado_models" # CHANGE ME 
export DORADO_1041_SUP="dna_r10.4.1_e8.2_400bps_sup@v5.0.0" # CHANGE ME 
#------------------------


if [ -d "${DORADO_1041_SUP}/${DORADO_1041_SUP}" ]; then
  echo "${DORADO_1041_SUP}/${DORADO_1041_SUP} exists."
else
  echo "${DORADO_MODEL_DIR}/${DORADO_1041_SUP} does NOT exist. Need to download models"
  mkdir -p $DORADO_MODEL_DIR

  singularity exec \
    --bind /work:/work \
    ${DORADO_SIF_PATH} \
    dorado download --directory $DORADO_MODEL_DIR --model $DORADO_1041_SUP
fi

