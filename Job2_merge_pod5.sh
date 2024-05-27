#!/usr/bin/env bash
#SBATCH --mail-type=ALL
#SBATCH --partition=dmcshared
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=50G

set -u

#--------------------------------------------
export STORE_DIR="/hpc/home/yk132/storage"
export CAFO_DIR="${STORE_DIR}/20230908_Dust_Redo_R9"
export FILE_DIR="${CAFO_DIR}/20230908_1516_MN33275_FAK80584_b5659fa0"
export SKIP_DIR="${FILE_DIR}/pod5_skip"
export PASS_DIR="${FILE_DIR}/pod5_pass"
export FAIL_DIR="${FILE_DIR}/pod5_fail"
## output in work folder
export WORK_DIR="/work/${USER}" # CHANGE ME if needed
export CAFO_WORK_DIR="${WORK_DIR}/CAFO_Nanopore_work"
export ALL_DIR="${CAFO_WORK_DIR}/pod5_all"
export BARCODE01_DIR="${ALL_DIR}/barcode01"
export BARCODE02_DIR="${ALL_DIR}/barcode02"
export BARCODE03_DIR="${ALL_DIR}/barcode03"
export UNCLASSIFIED_DIR="${ALL_DIR}/unclassified"
#--------------------------------------------

mkdir -p CAFO_WORK_DIR
mkdir -p $ALL_DIR
mkdir -p $BARCODE01_DIR
mkdir -p $BARCODE02_DIR
mkdir -p $BARCODE03_DIR
mkdir -p $UNCLASSIFIED_DIR

# move all pod5 files from pass, fail, and skip directories to corresponding barcode or unclassified directory

cp $SKIP_DIR/* $UNCLASSIFIED_DIR

cp -n $PASS_DIR/barcode01/* $BARCODE01_DIR # -n means don't overwrite existing file
cp -n $PASS_DIR/barcode02/* $BARCODE02_DIR
cp -n $PASS_DIR/barcode03/* $BARCODE03_DIR
cp -n $PASS_DIR/unclassified/* $UNCLASSIFIED_DIR

cp -n $FAIL_DIR/barcode01/* $BARCODE01_DIR
cp -n $FAIL_DIR/barcode02/* $BARCODE02_DIR
cp -n $FAIL_DIR/barcode03/* $BARCODE03_DIR
cp -n $FAIL_DIR/unclassified/* $UNCLASSIFIED_DIR
