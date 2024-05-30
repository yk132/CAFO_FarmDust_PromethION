#!/usr/bin/env bash
#SBATCH --partition=dmcshared
#SBATCH --cpus-per-task=32
#SBATCH --mem=600G
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
export OUTPUT_DIR="${CAFO_DIR}/Outputs"
export SLURM_CPUS_PER_TASK="32" # CHANGE ME
export MERGED_DIR="${OUTPUT_DIR}/Job4_merged_fastq"
export BAR03_MERGED="${MERGED_DIR}/barcode03_merged.fastq"
export SPADES_OUTPUT="${OUTPUT_DIR}/Job5_metaSPAdes"
export SPADES_1="${SPADES_OUTPUT}/barcode01"
export SPADES_2="${SPADES_OUTPUT}/barcode02"
export CONTIG_01="${SPADES_1}/contigs.fasta"
export CONTIG_02="${SPADES_2}/contigs.fasta"
export METAPHLAN_OUTPUT="${OUTPUT_DIR}/Job11_MetaPhlAn4_retry2"
export METAPHLAN_DB="${METAPHLAN_OUTPUT}/Database"
#------------------------------

# make output directories 
#mkdir -p $METAPHLAN_OUTPUT
#mkdir -p $METAPHLAN_DB

# obtain latest database and store in a database folder: recommended for HPC cluster
## https://github.com/biobakery/MetaPhlAn/wiki/MetaPhlAn-4
#singularity exec \
#	--bind /work:/work \
#	--bind /hpc/group:/hpc/group \
#	docker://biobakery/metaphlan:4.0.2 \
#	metaphlan --nproc $SLURM_CPUS_PER_TASK \
 #      	--install --bowtie2db $METAPHLAN_DB

# run metaphlan4 on barcode01
#singularity exec \
#	--bind /work:/work \
#	--bind /hpc/group:/hpc/group \
#	docker://biobakery/metaphlan:4.0.2 \
#	metaphlan $CONTIG_01 --input_type fasta \
#	--bowtie2db $METAPHLAN_DB \
#	--bowtie2out $METAPHLAN_OUTPUT/barcode01.bowtie2.bz2 \
#	--nproc $SLURM_CPUS_PER_TASK \
#	-o $METAPHLAN_OUTPUT/barcode01_metaphlan.txt

# run metaphlan4 on barcode02
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://biobakery/metaphlan:4.0.2 \
	metaphlan $CONTIG_02 --input_type fasta \
	--bowtie2db $METAPHLAN_DB \
	--bowtie2out $METAPHLAN_OUTPUT/barcode02.bowtie2.bz2 \
	--nproc $SLURM_CPUS_PER_TASK \
	-o $METAPHLAN_OUTPUT/barcode02_metaphlan.txt

 	
# run metaphlan4 on barcode03
singularity exec \
	--bind /work:/work \
	--bind /hpc/group:/hpc/group \
	docker://biobakery/metaphlan:4.0.2 \
	metaphlan $BAR03_MERGED --input_type fastq \
	--bowtie2db $METAPHLAN_DB \
	--bowtie2out $METAPHLAN_OUTPUT/barcode03.bowtie2.bz2 \
	--nproc $SLURM_CPUS_PER_TASK \
	-o $METAPHLAN_OUTPUT/barcode03_metaphlan.txt
 	

# merge abundance tables
#singularity exec \
#	--bind /work:/work \
#	--bind /hpc/group:/hpc/group \
#	docker://biobakery/metaphlan:4.0.2 \
#	merge_metaphlan_tables.py barcode01_metaphlan.txt \
#	barcode02_metaphlan.txt \
#	barcode03_metaphlan.txt > merged_abundance.txt
