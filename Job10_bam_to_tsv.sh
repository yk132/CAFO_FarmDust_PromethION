#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=300G
#SBATCH --mail-type=ALL

set -u

# now that wf-metagenomics accepts .bam as input, can we use the Minimap results .bam files as input? 

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"
export CAFO_GIT_DIR="${CAFO_DIR}/CAFO_Nanopore_clean"
export WORK_DIR="/work/${USER}" # CHANGE ME if needed 
export CAFO_WORK_DIR="${WORK_DIR}/CAFO_Nanopore_work"
export IMAGEDIR="${WORK_DIR}/images"
export NXF_SINGULARITY_CACHEDIR="$APPTAINER_CACHEDIR"
export NXF_WORK="${CAFO_WORK_DIR}/nf_working"
export NXF_TEMP="${CAFO_WORK_DIR}/nf_temp"
export DATA_DIR="${CAFO_DIR}/20230908_1516_MN33275_FAK80584_b5659fa0"
export OUTPUT_DIR="${CAFO_DIR}/Outputs"
export DB_DIR="${OUTPUT_DIR}/Job8_db"
export MERGED_DIR="${OUTPUT_DIR}/Job4_merged_fastq"
export BARCODE03_FASTQ="${MERGED_DIR}/barcode03_merged.fastq"
export SLURM_CPUS_PER_TASK="40" # CHANGE ME
export MINIMAP2_OUTPUT="${OUTPUT_DIR}/Job9_Minimap"
export BAR01_BAM="${MINIMAP2_OUTPUT}/barcode01_alignment.bam"
export BAR02_BAM="${MINIMAP2_OUTPUT}/barcode02_alignment.bam"
export BAR03_BAM="${MINIMAP2_OUTPUT}/barcode03_alignment.bam"
export TSV_DIR="${OUTPUT_DIR}/Job10_bam_to_tsv"
export RES_DIR01="${TSV_DIR}/res_barcode01"
export RES_DIR02="${TSV_DIR}/res_barcode02"
export RES_DIR03="${TSV_DIR}/res_barcode03"
#------------------------------

# make directories

mkdir -p $NXF_WORK
mkdir -p $NXF_TEMP
mkdir -p $TSV_DIR
mkdir -p $RES_DIR01
mkdir -p $RES_DIR02
mkdir -p $RES_DIR03

# update wf-metagenomics
nextflow pull epi2me-labs/wf-metagenomics/

# Run nextflow on barcode 01
nextflow run epi2me-labs/wf-metagenomics/main.nf \
	-profile singularity \
	-c ./nextflow.config \
	--bam $BAR01_BAM \
	--database_set ncbi_16s_18s_28s_ITS \
	--classifier minimap2 \
	--threads $SLURM_CPUS_PER_TASK \
	--out_dir $RES_DIR01 \
	--min_len 50 \
	--store_dir $DB_DIR 

# barcode02
#nextflow run epi2me-labs/wf-metagenomics/main.nf \
#	-profile singularity \
#	-c ./nextflow.config \
#	--bam $BAR02_BAM \
#	--database_set ncbi_16s_18s_28s_ITS \
#	--classifier minimap2 \
#	--threads $SLURM_CPUS_PER_TASK \
#	--out_dir $RES_DIR02 \
#	--min_len 50 \
#	--store_dir $DB_DIR 
 
# barcode03
#nextflow run epi2me-labs/wf-metagenomics/main.nf \
#	-profile singularity \
#	-c ./nextflow.config \
#	--bam $BAR03_BAM \
#	--database_set ncbi_16s_18s_28s_ITS \
#	--classifier minimap2 \
#	--threads $SLURM_CPUS_PER_TASK \
#	--out_dir $RES_DIR03 \
#	--min_len 50 \
#	--store_dir $DB_DIR 
