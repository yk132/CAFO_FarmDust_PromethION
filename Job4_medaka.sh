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
export FLYE_RES_DIR="${CAFO_RES_DIR}/Job2_flye_res"
export FLYE_A_DIR="${FLYE_RES_DIR}/FarmA"
export FLYE_C_DIR="${FLYE_RES_DIR}/FarmC"
export FLYE_BLANK_DIR="${FLYE_RES_DIR}/Blank"
export FLYE_UNCLASSIFIED_DIR="${FLYE_RES_DIR}/Unclassified"
export NTHREADS="16"
export FARMA_ASSEMBLED="${FLYE_A_DIR}/assembly.fasta"
export FARMC_ASSEMBLED="${FLYE_C_DIR}/assembly.fasta"
export BLANK_ASSEMBLED="${FLYE_BLANK_DIR}/assembly.fasta"
export UNCLASSIFIED_ASSEMBLED="${FLYE_UNCLASSIFIED_DIR}/assembly.fasta"
# quast output
export QUAST_RES_DIR="${CAFO_RES_DIR}/Job3_quast"
export QUAST_FARMA="${QUAST_RES_DIR}/Farm_A"
export QUAST_FARMC="${QUAST_RES_DIR}/Farm_C"
export QUAST_BLANK="${QUAST_RES_DIR}/Blank"
export QUAST_UNCLASSIFIED="${QUAST_RES_DIR}/Unclassified"

#-------------------------------

#-------------------------------
echo $FARMA_ASSEMBLED
echo $FARMC_ASSEMBLED
echo $BLANK_ASSEMBLED
echo $UNCLASSIFIED_ASSEMBLED

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
        metaquast.py $FARMA_ASSEMBLED \
	-t $NTHREADS \
	-o $QUAST_FARMA

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/quast:5.2.0 \
        metaquast.py $FARMC_ASSEMBLED \
	-t $NTHREADS \
	-o $QUAST_FARMC

 singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/quast:5.2.0 \
        metaquast.py $BLANK_ASSEMBLED \
	-t $NTHREADS \
	-o $QUAST_BLANK

 singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/quast:5.2.0 \
        metaquast.py $UNCLASSIFIED_ASSEMBLED \
	-t $NTHREADS \
	-o $QUAST_UNCLASSIFIED

