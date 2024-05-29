#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=300G
#SBATCH --mail-type=ALL

set -u

#------------------------
export DORADO_SIF_PATH='oras://gitlab-registry.oit.duke.edu/granek-lab/granek-container-images/dorado-simg:0.4.2'
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/data/CAFO_FarmDust_PromethION/CAFO_FarmDust/"
export CAFO_GIT_DIR="${STORE_DIR}/CAFO_FarmDust_PromethION"
export POD5_DIR="${CAFO_DIR}/20240521_1737_P2S-01272-B_PAS35763_a5f7cd95/pod5"

## fastq in storage folder
export CAFO_RES_DIR="${CAFO_DIR}/CAFO_PromethION_output"
export WORK_DIR="/work/${USER}" # CHANGE ME if needed 
export DORADO_MODEL_DIR="${WORK_DIR}/dorado_models" # CHANGE ME 
export DORADO_1041_SUP="dna_r10.4.1_e8.2_400bps_sup@v4.2.0" # CHANGE ME 
export DORADO_RES_DIR="${CAFO_RES_DIR}/Job2_dorado_fastq_res"
export DORADO_RES_FASTQ="${CAFO_RES_DIR}/basecalled.fastq"
export DEMUX_RES_DIR="${CAFO_RES_DIR}/Job3_demux_res"
export NTHREADS="32"
export KIT_NAME="SQK-RBK114-24"
#------------------------

mkdir -p $DEMUX_RES_DIR

singularity exec \
       --nv \
       --bind /work:/work \
       --bind /hpc/group:/hpc/group \
       ${DORADO_SIF_PATH} \
       dorado demux \
       --output-dir ${DEMUX_RES_DIR}  \
       --kit-name ${KIT_NAME} \
       --emit-fastq \
       --threads ${NTHREADS} 
