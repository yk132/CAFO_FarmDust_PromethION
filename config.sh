set -u

#-----------------------------
# code from Dr. Josh Granek--thank you!!!
# Run this as :
# metarhizium-epigenetics/vicki_data/podsplit_dorado_demux/main_sbatch.sh CONFIG_FILE

# so running with this config file would be 
# metarhizium-epigenetics/vicki_data/podsplit_dorado_demux/main_sbatch.sh metarhizium-epigenetics/vicki_data/run_config_files/demo_rap6.sh

# for me within Git folder would be ./main_sbatch.sh ./config.sh
#-----------------------------

export SBATCH_ACCOUNT="chsi"
export CPUJOB_PARTITION="chsi"
export GPUJOB_PARTITION="scavenger-gpu"
export GPUJOB_GPUS="RTX2080:1"

#-----------------------------
export DORADO_SIF_PATH='oras://gitlab-registry.oit.duke.edu/granek-lab/granek-container-images/dorado-simg:v0_6_1'
export POD5_SIF_PATH='oras://gitlab-registry.oit.duke.edu/granek-lab/granek-container-images/meta-methylome-simage:v002'
#-----------------------------
#-----------------------------
#-----------------------------
# demo data
export STORE_DIR="/hpc/group/gunschlab/yk132/storage/"
export CAFO_DIR="${STORE_DIR}/data/CAFO_FarmDust_PromethION/CAFO_FarmDust/20240521_1737_P2S-01272-B_PAS35763_a5f7cd95"
export SCRATCH_DIR="/work/${USER}"
export WORK_DIR="${SCRATCH_DIR}/CAFO_PromethION"
export POD5_DIR="${CAFO_DIR}/pod5"
#-----------------------------
# dorado duplex will fail if a requested model is not available for your dataset (e.g. 6mA)
# find model names with: 
# srun --mem=20G -c 2 -A chsi -p chsi apptainer exec oras://gitlab-registry.oit.duke.edu/granek-lab/granek-container-images/dorado-simg:v0_6_1 dorado download --list
export DORADO_MODEL_STRING="sup"
#-----------------------------
export KIT_NAME="SQK-RBK114-24" # for options run see --kit-name in `dorado demux --help`
# srun --mem=5G -c 2 -A chsi -p chsi apptainer exec oras://gitlab-registry.oit.duke.edu/granek-lab/granek-container-images/dorado-simg:v0_6_1 dorado demux --help
export GENERATE_FASTQ="TRUE"

#--------------
## Sample Sheet
#--------------
# Sample Sheet Examples and Details
# https://github.com/nanoporetech/dorado/blob/release-v0.6/tests/data/barcode_demux/sample_sheet.csv
# https://github.com/nanoporetech/dorado/blob/master/documentation/SampleSheets.md
# https://community.nanoporetech.com/docs/prepare/library_prep_protocols/experiment-companion-minknow/v/mke_1013_v1_revdc_11apr2016/sample-sheet-upload

# NOTE: dorado demux currenly has issues with sample sheets in UTF8, giving errors about problematic column names 
# You can check if a files is in UTF8 with `dos2unix -ib`, which will report "UTF-8" if the file is a problem and "no_bom" if it isn't
# You can fix the file with `dos2unix --convmode ascii --newfile INPUT_FILE OUTPUT_FILE`

export SAMPLE_SHEET="${STORE_DIR}/CAFO_FarmDust_PromethION/20240521_FarmDust_PromethION_metadata_Nanopore.csv"

