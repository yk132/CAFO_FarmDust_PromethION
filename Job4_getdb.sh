#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=300G
#SBATCH --mail-type=ALL

# https://github.com/epi2me-labs/wf-metagenomics
# using pipeline ONLY to download the RefSeq marker gene database formatted for MiniMap2

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/data/CAFO_FarmDust_PromethION/CAFO_FarmDust/"
export CAFO_GIT_DIR="${STORE_DIR}/CAFO_FarmDust_PromethION"
export CAFO_RES_DIR="${CAFO_DIR}/CAFO_PromethION_output"
export FARM_BLANK="${MERGE_RES_DIR}/Blank.fastq"
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
export RESULTS_DIR="${CAFO_RES_DIR}/Job4_blank_wf_metagenomics"
#-------------------------------

# make directories

mkdir -p $DB_DIR
mkdir -p $NXF_WORK
mkdir -p $NXF_TEMP
mkdir -p $RESULTS_DIR

# Run nextflow with smallest data (blanks) to quickly download the database. 

nextflow run epi2me-labs/wf-metagenomics/main.nf \
	-profile singularity \
	-c ./nextflow.config \
	--fastq $FARM_BLANK \
	--database_set ncbi_16s_18s_28s_ITS \
	--classifier minimap2 \
	--threads $NTHREADS \
	--out_dir $RESULTS_DIR \
	--min_len 50 \
	--store_dir $DB_DIR 

