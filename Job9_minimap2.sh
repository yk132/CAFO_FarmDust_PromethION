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
export MINIMAP2_OUTPUT="${OUTPUT_DIR}/Job9_Minimap"
export DATABASE_DIR="${DB_DIR}/ncbi_16s_18s_28s_ITS/ncbi_16s_18s_28s_ITS_db"
export DATABASE_FNA="${DATABASE_DIR}/ncbi_16s_18s_28s_ITS.fna"
export DATABASE_MMI="${DATABASE_DIR}/ncbi_16s_18s_28s_ITS.mmi"
export BAR01_SAM="${MINIMAP2_OUTPUT}/barcode01_alignment.sam"
export BAR02_SAM="${MINIMAP2_OUTPUT}/barcode02_alignment.sam"
export BAR03_SAM="${MINIMAP2_OUTPUT}/barcode03_alignment.sam"
export BAR01_BAM="${MINIMAP2_OUTPUT}/barcode01_alignment.bam"
export BAR02_BAM="${MINIMAP2_OUTPUT}/barcode02_alignment.bam"
export BAR03_BAM="${MINIMAP2_OUTPUT}/barcode03_alignment.bam"
#------------------------------

# make output directories 
mkdir -p $MINIMAP2_OUTPUT

# Make minimap2 index (MMI) File
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/minimap2:2.26 \
	minimap2 -ax map-ont \
 	-d $DATABASE_MMI $DATABASE_FNA

# Run minimap2 on barcode01
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/minimap2:2.26 \
	minimap2 -ax map-ont \
 	$DATABASE_MMI $CONTIG_01 > $BAR01_SAM
 	
# Run minimap2 on barcode02
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/minimap2:2.26 \
	minimap2 -ax map-ont \
 	$DATABASE_MMI $CONTIG_02 > $BAR02_SAM
 	
# Run minimap2 on barcode03
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/minimap2:2.26 \
	minimap2 -ax map-ont \
 	$DATABASE_MMI $BAR03_MERGED > $BAR03_SAM

# make .bam files using samtools 
## staphb/samtools = staphb/samtools:1.19

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/samtools:1.19 \
	samtools view -b $BAR01_SAM -o $BAR01_BAM
	
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/samtools:1.19 \
	samtools view -b $BAR02_SAM -o $BAR02_BAM
	
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/samtools:1.19 \
	samtools view -b $BAR03_SAM -o $BAR03_BAM
