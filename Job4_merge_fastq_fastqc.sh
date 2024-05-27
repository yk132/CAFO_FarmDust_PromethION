#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=300G
#SBATCH --mail-type=ALL

set -u

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"
export CAFO_GIT_DIR="${CAFO_DIR}/CAFO_Nanopore_clean"
export WORK_DIR="/work/${USER}" # CHANGE ME if needed 
export CAFO_WORK_DIR="${WORK_DIR}/CAFO_Nanopore_work"
export OUTPUT_DIR="${CAFO_DIR}/Outputs"
export DORADO_RESULTS_DIR="${OUTPUT_DIR}/Job3_dorado_fastq_res"
export SLURM_CPUS_PER_TASK="40" # CHANGE ME
export MERGED_DIR="${OUTPUT_DIR}/Job4_merged_fastq"
export BAR01_MERGED="${MERGED_DIR}/barcode01_merged.fastq"
export BAR02_MERGED="${MERGED_DIR}/barcode02_merged.fastq"
export BAR03_MERGED="${MERGED_DIR}/barcode03_merged.fastq"
export FASTQC_DIR="${OUTPUT_DIR}/Job4_fastqc"

#------------------------------

# merge fastq files 
mkdir -p $MERGED_DIR

cat ${DORADO_RESULTS_DIR}/*01.fastq > $BAR01_MERGED
cat ${DORADO_RESULTS_DIR}/*02.fastq > $BAR02_MERGED
cat ${DORADO_RESULTS_DIR}/*03.fastq > $BAR03_MERGED

# output folder for fastqc
mkdir -p $FASTQC_DIR

# Run FastQC on raw reads
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/fastqc:latest \
	fastqc -o $FASTQC_DIR --extract --memory 10000 -t 24 -f fastq \
	$MERGED_DIR/* 

# Get FastQC version for reproducibility
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/fastqc:latest \
	fastqc -v 