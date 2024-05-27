#!/usr/bin/env bash
#SBATCH --partition=chsi
#SBATCH -A chsi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=250G
#SBATCH --mail-type=ALL

set -u

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"
export CAFO_GIT_DIR="${CAFO_DIR}/CAFO_Nanopore_clean"
export WORK_DIR="/work/${USER}" # CHANGE ME if needed 
export CAFO_WORK_DIR="${WORK_DIR}/CAFO_Nanopore_work"
export OUTPUT_DIR="${CAFO_DIR}/Outputs"
export SLURM_CPUS_PER_TASK="32" # CHANGE ME
export MERGED_DIR="${OUTPUT_DIR}/Job4_merged_fastq"
export BAR01_MERGED="${MERGED_DIR}/barcode01_merged.fastq"
export BAR02_MERGED="${MERGED_DIR}/barcode02_merged.fastq"
export ILAB_DIR="${STORE_DIR}/ILAB_Dust"
export SPADES_OUTPUT="${OUTPUT_DIR}/Job5_metaSPAdes"
export SPADES_1="${SPADES_OUTPUT}/barcode01"
export SPADES_2="${SPADES_OUTPUT}/barcode02"
export CONTIG_01="${SPADES_1}/contigs.fasta"
export CONTIG_02="${SPADES_2}/contigs.fasta"
export MAP_DIR="${OUTPUT_DIR}/Job7_mapping_bwa"
#-------------------------------

#-------------------------------
mkdir -p $MAP_DIR
#-------------------------------

# Barcode 1 is Farm C
## build index
# cd $SPADES_1
# singularity exec \
#	--bind /work:/work \
#	--bind /hpc/group:/hpc/group \
#        docker://staphb/bwa:0.7.17 \
#        bwa index $CONTIG_01 -p barcode01

## Run bwa mem on Nanopore long reads: NOT paired end!!
#singularity exec \
#	--bind /work:/work \
#	--bind /hpc/group:/hpc/group \
#        docker://staphb/bwa:0.7.17 \
#        bwa mem barcode01 -t $SLURM_CPUS_PER_TASK \
#	$BAR01_MERGED > $MAP_DIR/barcode01_nanopore.sam

## Illumina short reads
### First, must uncompress the files! 
# cd $ILAB_DIR
# gunzip -k *.gz

# cd $SPADES_1
#singularity exec \
#	--bind /work:/work \
#	--bind /hpc/group:/hpc/group \
#        docker://staphb/bwa:0.7.17 \
#        bwa mem barcode01 -t $SLURM_CPUS_PER_TASK \
#	$ILAB_DIR/Farm_C_Dust_S2_L001_R1_001.fastq \
# 	$ILAB_DIR/Farm_C_Dust_S2_L001_R2_001.fastq  > $MAP_DIR/barcode01_illumina_pe.sam

 
# barcode 2 is Farm A 
## build index
cd $SPADES_2
#singularity exec \
#	--bind /work:/work \
#	--bind /hpc/group:/hpc/group \
#        docker://staphb/bwa:0.7.17 \
#        bwa index $CONTIG_02 -p barcode02

## map Nanopore reads
#singularity exec \
#	--bind /work:/work \
#	--bind /hpc/group:/hpc/group \
#        docker://staphb/bwa:0.7.17 \
#        bwa mem barcode02 -t $SLURM_CPUS_PER_TASK \
#	$BAR02_MERGED > $MAP_DIR/barcode02_nanopore.sam

## map Illumina reads
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/bwa:0.7.17 \
        bwa mem barcode02 -t $SLURM_CPUS_PER_TASK \
	$ILAB_DIR/Farm_A_Dust_S3_L001_R1_001.fastq \
        $ILAB_DIR/Farm_A_Dust_S3_L001_R2_001.fastq  > $MAP_DIR/barcode02_illumina_pe.sam
