#!/usr/bin/env bash
#SBATCH --partition=chsi
#SBATCH -A chsi
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100G
#SBATCH --mail-type=ALL

set -u

#-------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/data/CAFO_FarmDust_PromethION/CAFO_FarmDust/"
export CAFO_GIT_DIR="${STORE_DIR}/CAFO_FarmDust_PromethION"
export CAFO_RES_DIR="${CAFO_DIR}/CAFO_PromethION_output"
export NTHREADS="16"
# quast output
export QUAST_RES_DIR="${CAFO_RES_DIR}/Job8_medaka_quast"
export QUAST_FARMA="${QUAST_RES_DIR}/Farm_A"
export QUAST_FARMC="${QUAST_RES_DIR}/Farm_C"
export QUAST_BLANK="${QUAST_RES_DIR}/Blank"
export QUAST_UNCLASSIFIED="${QUAST_RES_DIR}/Unclassified"
# inputs from medaka
export MEDAKA_RES_DIR="${CAFO_RES_DIR}/Job7_medaka"
export MEDAKA_FARMA_CONTIG="${MEDAKA_RES_DIR}/Farm_A/consensus.fasta"
export MEDAKA_FARMC_CONTIG="${MEDAKA_RES_DIR}/Farm_C/consensus.fasta"
export MEDAKA_BLANK_CONTIG="${MEDAKA_RES_DIR}/Blank/consensus.fasta"
export MEDAKA_UNCLASSIFIED_CONTIG="${MEDAKA_RES_DIR}/Unclassified/consensus.fasta"
#-------------------------------

#-------------------------------
echo $MEDAKA_FARMA_CONTIG
echo $MEDAKA_FARMC_CONTIG
echo $MEDAKA_BLANK_CONTIG
echo $MEDAKA_UNCLASSIFIED_CONTIG

mkdir -p $QUAST_RES_DIR
mkdir -p $QUAST_FARMA
mkdir -p $QUAST_FARMC
mkdir -p $QUAST_BLANK
mkdir -p $QUAST_UNCLASSIFIED
#-------------------------------

# Run Quast on assembled contigs
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/quast:5.2.0 \
        metaquast.py $MEDAKA_FARMA_CONTIG \
	-t $NTHREADS \
	-o $QUAST_FARMA

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/quast:5.2.0 \
        metaquast.py $MEDAKA_FARMC_CONTIG \
	-t $NTHREADS \
	-o $QUAST_FARMC

 singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/quast:5.2.0 \
        metaquast.py $MEDAKA_BLANK_CONTIG \
	-t $NTHREADS \
	-o $QUAST_BLANK

 singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/quast:5.2.0 \
        metaquast.py $MEDAKA_UNCLASSIFIED_CONTIG \
	-t $NTHREADS \
	-o $QUAST_UNCLASSIFIED

