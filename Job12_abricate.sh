#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=300G
#SBATCH --mail-type=ALL

set -u

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
export MERGED_DIR="${DATA_DIR}/dorado_fastq_results/Merged_bam_fastq"
export BARCODE03_FASTQ="${MERGED_DIR}/barcode03_merged.fastq"
export OUTPUT_DIR="${CAFO_DIR}/Outputs"
export DB_DIR="${OUTPUT_DIR}/Job8_db"
export RESULTS_DIR="${OUTPUT_DIR}/Job8_wf_meta_barcode03_res"
export SLURM_CPUS_PER_TASK="32" # CHANGE ME
export MERGED_DIR="${OUTPUT_DIR}/Job4_merged_fastq"
export BAR03_MERGED="${MERGED_DIR}/barcode03_merged.fastq"
export SPADES_OUTPUT="${OUTPUT_DIR}/Job5_metaSPAdes"
export SPADES_1="${SPADES_OUTPUT}/barcode01"
export SPADES_2="${SPADES_OUTPUT}/barcode02"
export CONTIG_01="${SPADES_1}/contigs.fasta"
export CONTIG_02="${SPADES_2}/contigs.fasta"
export ABRICATE_OUTPUT="${OUTPUT_DIR}/Job12_ABRicate"
#------------------------------

# make output directories 
mkdir -p $ABRICATE_OUTPUT

#get database 
# cd $ABRICATE_OUTPUT
#singularity exec \
#	--bind /work:/work \
#	--bind /hpc/group:/hpc/group \
#	docker://staphb/abricate:1.0.1-insaflu-220727 \
#	abricate-get_db --db ncbi --force

# database list 
cd $ABRICATE_OUTPUT
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://staphb/abricate:1.0.1-insaflu-220727 \
	abricate --list > database.tsv

# Run ABRicate 
### abricate doesn't accept raw fastq files, and as such, barcode03 cannot be run
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://staphb/abricate:1.0.1-insaflu-220727 \
	abricate $CONTIG_01 > amr_bar01.tsv

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://staphb/abricate:1.0.1-insaflu-220727 \
	abricate $CONTIG_02 > amr_bar02.tsv

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://staphb/abricate:1.0.1-insaflu-220727 \
	abricate --summary amr_bar01.tsv amr_bar02.tsv



