#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=300G
#SBATCH --mail-type=ALL

set -u

# compatible with Dr. Josh Granek's code (THANK YOU!!) 
## bring over results first, which are basecalled, demuxed, and simplex-filtered .fastq files. 

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage" ## CHANGE ME
export CAFO_DIR="${STORE_DIR}/data/CAFO_FarmDust_PromethION/CAFO_FarmDust/"
export CAFO_GIT_DIR="${STORE_DIR}/CAFO_FarmDust_PromethION"
export CAFO_RES_DIR="${CAFO_DIR}/CAFO_PromethION_output"
export DEMUX_RES_DIR="${CAFO_RES_DIR}/demux_simplex_filtered"
export FARM_A="${DEMUX_RES_DIR}/Farm_A.fastq.gz"
export FARM_C="${DEMUX_RES_DIR}/Farm_C.fastq.gz"
export FARM_BLANK="${DEMUX_RES_DIR}/Blanks_pooled.fastq.gz"
export UNCLASSIFIED_BLANK="${DEMUX_RES_DIR}/unclassified.fastq.gz"
export FASTQC_RES_DIR="${CAFO_RES_DIR}/Job1_fastqc_res"

export PIPELINE_DIR="/work/${USER}/CAFO_PromethION/" ## CHANGE ME
export PIPELINE_RES="${PIPELINE_DIR}/results/"
export PIPELINE_DEMUX="${PIPELINE_RES}/simplex_filtered_fastqs"
#----------------------------------

# move fastq files to storage folder
mkdir -p $DEMUX_RES_DIR
mkdir -p $FASTQC_RES_DIR

cp $PIPELINE_DEMUX/*.fastq.gz $DEMUX_RES_DIR/*.fastq.gz

# Run FastQC on raw reads
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/fastqc:0.12.1 \
	fastqc -o $FASTQC_RES_DIR --extract --memory 10000 -t 30 -f fastq \
	$DEMUX_RES_DIR/* 

# Get FastQC version for reproducibility
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/fastqc:0.12.1 \
	fastqc -v 
