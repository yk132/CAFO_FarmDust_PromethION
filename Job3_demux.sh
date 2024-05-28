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

#------------------------
export DORADO_SIF_PATH='oras://gitlab-registry.oit.duke.edu/granek-lab/granek-container-images/dorado-simg:0.4.2'
## This version is modified for /work/
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"
export CAFO_GIT_DIR="${CAFO_DIR}/CAFO_Nanopore_clean"
export WORK_DIR="/work/${USER}" # CHANGE ME if needed 
export CAFO_WORK_DIR="${WORK_DIR}/CAFO_Nanopore_work"
export ALL_DIR="${CAFO_WORK_DIR}/pod5_all"
export BARCODE01_DIR="${ALL_DIR}/barcode01"
export BARCODE02_DIR="${ALL_DIR}/barcode02"
export BARCODE03_DIR="${ALL_DIR}/barcode03"
export UNCLASSIFIED_DIR="${ALL_DIR}/unclassified"
export DORADO_MODEL_DIR="${WORK_DIR}/dorado_models" # CHANGE ME 
export DORADO_941_SUP="dna_r9.4.1_e8_sup@v3.6" # CHANGE ME
export OUTPUT_DIR="${CAFO_DIR}/Outputs"
export DORADO_RESULTS_DIR="${OUTPUT_DIR}/Job3_dorado_fastq_res"
#------------------------

mkdir -p $OUTPUT_DIR
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
       ${DORADO_MODEL_DIR}/${DORADO_941_SUP} \
       $BARCODE01_DIR/ > ${DORADO_RESULTS_DIR}/barcode_01.fastq

singularity exec \
       --nv \
       --bind /work:/work \
       --bind /hpc/group:/hpc/group \
       ${DORADO_SIF_PATH} \
       dorado basecaller -r \
       --emit-fastq\
       ${DORADO_MODEL_DIR}/${DORADO_941_SUP} \
       $BARCODE02_DIR/ > ${DORADO_RESULTS_DIR}/barcode_02.fastq

singularity exec \
       --nv \
       --bind /work:/work \
       --bind /hpc/group:/hpc/group \
       ${DORADO_SIF_PATH} \
       dorado basecaller -r \
       --emit-fastq \
       ${DORADO_MODEL_DIR}/${DORADO_941_SUP} \
       $BARCODE03_DIR/ > ${DORADO_RESULTS_DIR}/barcode_03.fastq

singularity exec \
       --nv \
       --bind /work:/work \
       --bind /hpc/group:/hpc/group \
       ${DORADO_SIF_PATH} \
       dorado basecaller -r \
       --emit-fastq \
       ${DORADO_MODEL_DIR}/${DORADO_941_SUP} \
       $UNCLASSIFIED_DIR/ > $DORADO_RESULTS_DIR/unclassified.fastq 

singularity exec \
       --nv \
       --bind /work:/work \
       --bind /hpc/group:/hpc/group \
       ${DORADO_SIF_PATH} \
       dorado demux \
       --kit-name SQK-RPB004 \
       --output-dir $DORADO_RESULTS_DIR \
       $DORADO_RESULTS_DIR/unclassified.fastq
