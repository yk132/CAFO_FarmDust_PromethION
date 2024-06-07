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
export WORK_DIR="/work/${USER}" # CHANGE ME if needed 
export CAFO_WORK_DIR="${WORK_DIR}/CAFO_Nanopore_work"
export IMAGEDIR="${WORK_DIR}/images"
export NXF_SINGULARITY_CACHEDIR="$APPTAINER_CACHEDIR"
export NXF_WORK="${CAFO_WORK_DIR}/nf_working"
export NXF_TEMP="${CAFO_WORK_DIR}/nf_temp"
# inputs from medaka
export MEDAKA_RES_DIR="${CAFO_RES_DIR}/Job7_medaka"
export MEDAKA_FARMA_CONTIG="${MEDAKA_RES_DIR}/Farm_A/consensus.fasta"
export MEDAKA_FARMC_CONTIG="${MEDAKA_RES_DIR}/Farm_C/consensus.fasta"
export MEDAKA_BLANK_CONTIG="${MEDAKA_RES_DIR}/Blank/consensus.fasta"
export MEDAKA_UNCLASSIFIED_CONTIG="${MEDAKA_RES_DIR}/Unclassified/consensus.fasta"
# output directories
export ABRICATE_RES_DIR="${CAFO_RES_DIR}/Job9_ABRicate"
export ABR_FARMA="${ABRICATE_RES_DIR}/amr_farm_a.tsv"
export ABR_FARMC="${ABRICATE_RES_DIR}/amr_farm_c.tsv"
export ABR_BLANK="${ABRICATE_RES_DIR}/amr_blank.tsv"
export ABR_UNCLASSIFIED="${ABRICATE_RES_DIR}/amr_unclassified.tsv"
#------------------------------

# make output directories 
mkdir -p $ABRICATE_RES_DIR

#get database 
cd $ABRICATE_RES_DIR
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://staphb/abricate:1.0.1-insaflu-220727 \
	abricate-get_db --db ncbi --force

# database list 
cd $ABRICATE_RES_DIR
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://staphb/abricate:1.0.1-insaflu-220727 \
	abricate --list > database.tsv

# Run ABRicate 
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://staphb/abricate:1.0.1-insaflu-220727 \
	abricate $MEDAKA_FARMA_CONTIG > $ABR_FARMA

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://staphb/abricate:1.0.1-insaflu-220727 \
	abricate $MEDAKA_FARMC_CONTIG > $ABR_FARMC

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://staphb/abricate:1.0.1-insaflu-220727 \
	abricate $MEDAKA_BLANK_CONTIG > $ABR_BLANK

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://staphb/abricate:1.0.1-insaflu-220727 \
	abricate $MEDAKA_UNCLASSIFIED_CONTIG > $ABR_UNCLASSIFIED


singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://staphb/abricate:1.0.1-insaflu-220727 \
	abricate --summary $ABR_FARMA $ABR_FARMC $ABR_BLANK $ABR_UNCLASSIFIED



