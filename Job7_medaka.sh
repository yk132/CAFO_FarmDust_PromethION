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
export FASTQ_DIR="${CAFO_RES_DIR}/demux_simplex_filtered"
export FLYE_RES_DIR="${CAFO_RES_DIR}/Job2_flye_res"
export FLYE_A_DIR="${FLYE_RES_DIR}/FarmA"
export FLYE_C_DIR="${FLYE_RES_DIR}/FarmC"
export FLYE_BLANK_DIR="${FLYE_RES_DIR}/Blank"
export FLYE_UNCLASSIFIED_DIR="${FLYE_RES_DIR}/Unclassified"
export FARMA_ASSEMBLED="${FLYE_A_DIR}/assembly.fasta"
export FARMC_ASSEMBLED="${FLYE_C_DIR}/assembly.fasta"
export BLANK_ASSEMBLED="${FLYE_BLANK_DIR}/assembly.fasta"
export UNCLASSIFIED_ASSEMBLED="${FLYE_UNCLASSIFIED_DIR}/assembly.fasta"
# medaka output
export MEDAKA_RES_DIR="${CAFO_RES_DIR}/Job7_medaka"
export MEDAKA_FARMA="${MEDAKA_RES_DIR}/Farm_A"
export MEDAKA_FARMC="${MEDAKA_RES_DIR}/Farm_C"
export MEDAKA_BLANK="${MEDAKA_RES_DIR}/Blank"
export MEDAKA_UNCLASSIFIED="${MEDAKA_RES_DIR}/Unclassified"
export MODEL="r1041_e82_400bps_sup_v4.3.0"
export NTHREADS="32"
#-------------------------------


#-------------------------------
if [ -v SLURM_GPUS_ON_NODE ] && (( $SLURM_GPUS_ON_NODE >= 1 )); then
  export DORADO_DEVICE="cuda:all" ;
else 
  export DORADO_DEVICE="cpu" ;
fi
echo $DORADO_DEVICE
#-----------------------------

mkdir -p $MEDAKA_RES_DIR
mkdir -p $MEDAKA_FARMA
mkdir -p $MEDAKA_FARMC
mkdir -p $MEDAKA_BLANK
mkdir -p $MEDAKA_UNCLASSIFIED

# medaka docker pull nanozoo/medaka:1.11.3--ce388c3

# polish contig with medaka 
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
        docker://nanozoo/medaka:1.11.3--ce388c3 \
	medaka consensus --model $MODEL \
	--threads $NTHREADS
 	$FARMA_ASSEMBLED -i ${FASTQ_DIR}/Farm_A.fastq.gz -o $MEDAKA_FARMA
