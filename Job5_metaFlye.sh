#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=300G
#SBATCH --mail-type=ALL

set -u

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/data/CAFO_FarmDust_PromethION/CAFO_FarmDust/"
export CAFO_GIT_DIR="${STORE_DIR}/CAFO_FarmDust_PromethION"
export CAFO_RES_DIR="${CAFO_DIR}/CAFO_PromethION_output"
export MERGE_RES_DIR="${CAFO_RES_DIR}/Job4_merge_qc_res"
export FARM_A="${MERGE_RES_DIR}/Farm_A.fastq"
export FARM_C="${MERGE_RES_DIR}/Farm_C.fastq"
export FARM_BLANK="${MERGE_RES_DIR}/Blank.fastq"
export FLYE_RES_DIR="${CAFO_RES_DIR}/Job5_flye_res"
export FLYE_A_DIR="${FLYE_RES_DIR}/FarmA"
export FLYE_C_DIR="${FLYE_RES_DIR}/FarmC"
export FLYE_BLANK_DIR="${FLYE_RES_DIR}/Blank"
export NTHREADS="32"
#------------------------------

# make output directories 
mkdir -p $FLYE_RES_DIR
mkdir -p $FLYE_A_DIR
mkdir -p $FLYE_C_DIR
mkdir -p $FLYE_BLANK_DIR

# Run metaFlye for Farm A
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:2.9.4 \
	flye --nano-hq $FARM_A \
 	-o $FLYE_A_DIR \
  	--meta \
   	-t $NTHREADS

# Run metaFlye for Farm C
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:2.9.4 \
	flye --nano-hq $FARM_C \
 	-o $FLYE_C_DIR \
  	--meta \
   	-t $NTHREADS

# Run metaFlye for blank
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:2.9.4 \
	flye --nano-hq $FARM_BLANK \
 	-o $FLYE_BLANK_DIR \
  	--meta \
   	-t $NTHREADS

# Run metaFlye for Farm A
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:2.9.4 \
	flye -v
