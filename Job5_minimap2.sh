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
export FARMA_SAM="${MINI_RESULTS_DIR}/farmA_alignment.sam"
export FARMB_SAM="${MINI_RESULTS_DIR}/farmC_alignment.sam"
export FARM_BLANK_SAM="${MINI_RESULTS_DIR}/farmBlank_alignment.sam"
export UNCLASSIFIED_SAM="${MINI_RESULTS_DIR}/unclassified_alignment.sam"
export FARMA_BAM="${MINI_RESULTS_DIR}/farmA_alignment.bam"
export FARMB_BAM="${MINI_RESULTS_DIR}/farmC_alignment.bam"
export FARM_BLANK_BAM="${MINI_RESULTS_DIR}/farmBlank_alignment.bam"
export UNCLASSIFIED_BAM="${MINI_RESULTS_DIR}/unclassified_alignment.bam"
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

# Run minimap2 on farmA
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/minimap2:2.26 \
	minimap2 -ax map-ont \
 	$DATABASE_MMI $FARM_A > $BAR01_SAM
 	
# Run minimap2 on barcode02
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/minimap2:2.26 \
	minimap2 -ax map-ont \
 	$DATABASE_MMI $FARM_C > $BAR02_SAM
 	
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
