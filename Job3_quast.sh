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

# PICK UP HERE! 
export QUAST_DIR="${OUTPUT_DIR}/Job6_quast"
export QUAST_01="${QUAST_DIR}/barcode01"
export QUAST_02="${QUAST_DIR}/barcode02"
export SLURM_CPUS_PER_TASK="16" # CHANGE ME
#-------------------------------

#-------------------------------
echo $CONTIG_01
echo $CONTIG_02

mkdir -p $QUAST_DIR
mkdir -p $QUAST_01
mkdir -p $QUAST_02
#-------------------------------

# Run Quast on assembled contigs
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/quast:5.2.0 \
        metaquast.py $CONTIG_01 \
	-t $SLURM_CPUS_PER_TASK \
	-o $QUAST_01

singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://staphb/quast:5.2.0 \
        metaquast.py $CONTIG_02 \
	-t $SLURM_CPUS_PER_TASK \
	-o $QUAST_02

