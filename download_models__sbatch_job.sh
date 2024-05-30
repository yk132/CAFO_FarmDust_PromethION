#!/usr/bin/env bash

# #SBATCH --partition=chsi
# #SBATCH -A chsi

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=5G

set -u

mkdir -p $DORADO_MODEL_DIR

# Apptainer> dorado download --model "sup,5mCG_5hmCG" --verbose --recursive --directory /cwork/josh/temp_models --data /cwork/josh/basecall_demo/data/wf-basecalling-demo/input
#apptainer exec \
#	${DORADO_SIF_PATH} \
#	dorado download \
#		--model ${DORADO_MODEL_STRING} \
#		--directory $DORADO_MODEL_DIR #\
		#--recursive #\
		#--verbose \
		#--data ${POD5_DIR}


apptainer exec \
	${DORADO_SIF_PATH} \
	dorado download \
		--verbose \
		--model ${DORADO_MODEL_STRING} \
		--directory $DORADO_MODEL_DIR \
		--recursive \
		--data ${POD5_DIR}

