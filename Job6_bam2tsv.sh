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
export CAFO_DIR="${STORE_DIR}/data/CAFO_FarmDust_PromethION/CAFO_FarmDust/"
export CAFO_GIT_DIR="${STORE_DIR}/CAFO_FarmDust_PromethION"
export CAFO_RES_DIR="${CAFO_DIR}/CAFO_PromethION_output"
export WORK_DIR="/work/${USER}" # CHANGE ME if needed 
export CAFO_WORK_DIR="${WORK_DIR}/CAFO_Nanopore_work"
export NXF_SINGULARITY_CACHEDIR="$APPTAINER_CACHEDIR"
export NXF_WORK="${CAFO_WORK_DIR}/nf_working"
export NXF_TEMP="${CAFO_WORK_DIR}/nf_temp"
export NTHREADS="32"
export DEMUX_RES_DIR="${CAFO_RES_DIR}/demux_simplex_filtered"
export FARM_A="${DEMUX_RES_DIR}/Farm_A.fastq.gz"
export FARM_C="${DEMUX_RES_DIR}/Farm_C.fastq.gz"
export FARM_BLANK="${DEMUX_RES_DIR}/Blanks_pooled.fastq.gz"
export UNCLASSIFIED="${DEMUX_RES_DIR}/unclassified.fastq.gz"
export DB_DIR="${CAFO_RES_DIR}/Job4_Minimap2_db"
export MINI_RESULTS_DIR="${CAFO_RES_DIR}/Job5_minimap_res"
export SLURM_CPUS_PER_TASK="32" # CHANGE ME
export DATABASE_DIR="${DB_DIR}/ncbi_16s_18s_28s_ITS/ncbi_16s_18s_28s_ITS_db"
export DATABASE_FNA="${DATABASE_DIR}/ncbi_16s_18s_28s_ITS.fna"
export DATABASE_MMI="${DATABASE_DIR}/ncbi_16s_18s_28s_ITS.mmi"
export FARMA_BAM="${MINI_RESULTS_DIR}/farmA_alignment.bam"
export FARMC_BAM="${MINI_RESULTS_DIR}/farmC_alignment.bam"
export FARM_BLANK_BAM="${MINI_RESULTS_DIR}/farmBlank_alignment.bam"
export UNCLASSIFIED_BAM="${MINI_RESULTS_DIR}/unclassified_alignment.bam"
export TSV_DIR="${CAFO_RES_DIR}/Job6_bam2tsv"
export RES_DIR_FARMA="${TSV_DIR}/farmA_tsv"
export RES_DIR_FARMC="${TSV_DIR}/farmC_tsv"
export RES_DIR_BLANK="${TSV_DIR}/blank_tsv"
export RES_DIR_UNCLASSIFIED="${TSV_DIR}/unclassified_tsv"
#------------------------------

# make directories

mkdir -p $NXF_WORK
mkdir -p $NXF_TEMP
mkdir -p $TSV_DIR
mkdir -p $RES_DIR_FARMA
mkdir -p $RES_DIR_FARMC
mkdir -p $RES_DIR_BLANK
mkdir -p $RES_DIR_UNCLASSIFIED

# update wf-metagenomics
nextflow pull epi2me-labs/wf-metagenomics/

# Run nextflow on farm A
nextflow run epi2me-labs/wf-metagenomics/main.nf \
	-profile singularity \
	-c ./nextflow.config \
	--bam $FARMA_BAM \
	--database_set ncbi_16s_18s_28s_ITS \
	--classifier minimap2 \
	--threads $SLURM_CPUS_PER_TASK \
	--out_dir $RES_DIR_FARMA \
	--min_len 50 \
	--store_dir $DB_DIR 

# Run nextflow on farm C
nextflow run epi2me-labs/wf-metagenomics/main.nf \
	-profile singularity \
	-c ./nextflow.config \
	--bam $FARM_C \
	--database_set ncbi_16s_18s_28s_ITS \
	--classifier minimap2 \
	--threads $SLURM_CPUS_PER_TASK \
	--out_dir $RES_DIR_FARMC \
	--min_len 50 \
	--store_dir $DB_DIR 

# Run nextflow on blank
nextflow run epi2me-labs/wf-metagenomics/main.nf \
	-profile singularity \
	-c ./nextflow.config \
	--bam $FARM_BLANK_BAM \
	--database_set ncbi_16s_18s_28s_ITS \
	--classifier minimap2 \
	--threads $SLURM_CPUS_PER_TASK \
	--out_dir $RES_DIR_BLANK \
	--min_len 50 \
	--store_dir $DB_DIR 

# Run nextflow on unclassified
nextflow run epi2me-labs/wf-metagenomics/main.nf \
	-profile singularity \
	-c ./nextflow.config \
	--bam $UNCLASSIFIED_BAM \
	--database_set ncbi_16s_18s_28s_ITS \
	--classifier minimap2 \
	--threads $SLURM_CPUS_PER_TASK \
	--out_dir $RES_DIR_UNCLASSIFIED \
	--min_len 50 \
	--store_dir $DB_DIR 

