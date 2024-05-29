#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=300G
#SBATCH --mail-type=ALL

set -u

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/data/CAFO_FarmDust_PromethION/CAFO_FarmDust/"
export CAFO_GIT_DIR="${STORE_DIR}/CAFO_FarmDust_PromethION"
export CAFO_RES_DIR="${CAFO_DIR}/CAFO_PromethION_output"
export DEMUX_RES_DIR="${CAFO_RES_DIR}/Job3_demux_res"

export DEMUX_BAR17="${DEMUX_RES_DIR}/SQK-RBK114-24_barcode17.fastq"
export DEMUX_BAR18="${DEMUX_RES_DIR}/SQK-RBK114-24_barcode18.fastq"
export DEMUX_BAR19="${DEMUX_RES_DIR}/SQK-RBK114-24_barcode19.fastq"
export DEMUX_BAR20="${DEMUX_RES_DIR}/SQK-RBK114-24_barcode20.fastq"
export DEMUX_BAR21="${DEMUX_RES_DIR}/SQK-RBK114-24_barcode21.fastq"

export MERGE_RES_DIR="${CAFO_RES_DIR}/Job4_merge_qc_res"
export FARM_A="${MERGE_RES_DIR}/Farm_A.fastq"
export FARM_C="${MERGE_RES_DIR}/Farm_C.fastq"
export FARM_BLANK="${MERGE_RES_DIR}/Blank.fastq"
#----------------------------------

# merge fastq files 
mkdir -p $MERGE_RES_DIR

cat $DEMUX_BAR17 $DEMUX_BAR18 > $FARM_A
cat $DEMUX_BAR19 $DEMUX_BAR20 > $FARM_C
mv $DEMUX_BAR21 $FARM_BLANK

# Run FastQC on raw reads
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/fastqc:0.12.1 \
	fastqc -o $FASTQC_DIR --extract --memory 10000 -t 30 -f fastq \
	$MERGE_RES_DIR/* 

# Get FastQC version for reproducibility
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/fastqc:0.12.1 \
	fastqc -v 
