#!/usr/bin/env bash
#SBATCH --partition=chsi-gpu
#SBATCH -A chsi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=0
#SBATCH --gres=gpu:1
#SBATCH --mail-type=ALL

set -u

# see GitHub https://github.com/nanoporetech/dorado#duplex
# Note that this process requires GPUs, not MEM!! 

#--------------------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/data/CAFO_FarmDust_PromethION/CAFO_FarmDust/"
export CAFO_GIT_DIR="${CAFO_DIR}/CAFO_FarmDust_PromethION"
export POD5_DIR="${CAFO_DIR}/20240521_1737_P2S-01272-B_PAS35763_a5f7cd95/pod5"

## fastq in storage folder
export DORADO_SIF_PATH='oras://gitlab-registry.oit.duke.edu/granek-lab/granek-container-images/dorado-simg:0.4.2'
## This version is modified for /work/
export CAFO_RES_DIR="${CAFO_WORK_DIR}/CAFO_PromethION_output"
export WORK_DIR="/work/${USER}" # CHANGE ME if needed 
export DORADO_MODEL_DIR="${WORK_DIR}/dorado_models" # CHANGE ME 
export DORADO_1041_SUP="dna_r10.4.1_e8.2_400bps_sup@v5.0.0" # CHANGE ME 
export DORADO_RESULTS_DIR="${CAFO_RES_DIR}/Job2_dorado_fastq_res"
#--------------------------------------------

mkdir -p $CAFO_RES_DIR
mkdir -p $DORADO_RESULTS_DIR

#------------------------ from Dr. Granek
if [ -v SLURM_GPUS_ON_NODE ] && (( $SLURM_GPUS_ON_NODE >= 1 )); then
  export DORADO_DEVICE="cuda:all" ;
else 
  export DORADO_DEVICE="cpu" ;
fi
echo $DORADO_DEVICE
echo ${DORADO_SIF_PATH}
#------------------------

singularity exec \
       --nv \
       --bind /work:/work \
       --bind /hpc/group:/hpc/group \
       ${DORADO_SIF_PATH} \
       dorado basecaller -r \
       --emit-fastq \
       ${DORADO_MODEL_DIR}/${DORADO_1041_SUP} \
       $POD5_DIR/ \
       --kit-name SQKRBK114 > ${DORADO_RESULTS_DIR}/basecalled.fastq
