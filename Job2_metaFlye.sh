#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=300G
#SBATCH --mail-type=ALL

set -u

# Version that is after running main_sbatch.sh from Dr. Josh Granek (Thank you!!!) 
## which goes from raw pod5 --> basecalled, demuxed, simplex-filtered .fastq files

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/data/CAFO_FarmDust_PromethION/CAFO_FarmDust/"
export CAFO_GIT_DIR="${STORE_DIR}/CAFO_FarmDust_PromethION"
export CAFO_RES_DIR="${CAFO_DIR}/CAFO_PromethION_output"
export DEMUX_RES_DIR="${CAFO_RES_DIR}/demux_simplex_filtered"
export FARM_A="${DEMUX_RES_DIR}/Farm_A.fastq.gz"
export FARM_C="${DEMUX_RES_DIR}/Farm_C.fastq.gz"
export FARM_BLANK="${DEMUX_RES_DIR}/Blanks_pooled.fastq.gz"
export UNCLASSIFIED="${DEMUX_RES_DIR}/unclassified.fastq.gz"
export FLYE_RES_DIR="${CAFO_RES_DIR}/Job2_flye_res"
export FLYE_A_DIR="${FLYE_RES_DIR}/FarmA"
export FLYE_C_DIR="${FLYE_RES_DIR}/FarmC"
export FLYE_BLANK_DIR="${FLYE_RES_DIR}/Blank"
export FLYE_UNCLASSIFIED_DIR="${FLYE_RES_DIR}/Unclassified"
export NTHREADS="32"
#------------------------------

# make output directories 
mkdir -p $FLYE_RES_DIR
mkdir -p $FLYE_A_DIR
mkdir -p $FLYE_C_DIR
mkdir -p $FLYE_BLANK_DIR
mkdir -p $FLYE_UNCLASSIFIED_DIR

# Run metaFlye for Farm A
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:2.9.4 \
	flye --nano-raw $FARM_A \
 	-o $FLYE_A_DIR \
  	--meta \
   	-t $NTHREADS 

# Run metaFlye for Farm C
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:2.9.4 \
	flye --nano-raw $FARM_C \
 	-o $FLYE_C_DIR \
  	--meta \
   	-t $NTHREADS

# Run metaFlye for blank
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:2.9.4 \
	flye --nano-raw $FARM_BLANK \
 	-o $FLYE_BLANK_DIR \
  	--meta \
   	-t $NTHREADS 

# Run metaFlye for unclassified
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:2.9.4 \
	flye --nano-raw $UNCLASSIFIED \
 	-o $FLYE_UNCLASSIFIED_DIR \
  	--meta \
   	-t $NTHREADS 

# get version
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/flye:2.9.4 \
	flye -v
