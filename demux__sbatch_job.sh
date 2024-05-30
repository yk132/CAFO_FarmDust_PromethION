#!/usr/bin/env bash

#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --mem=100G

set -Eeuo pipefail # https://stackoverflow.com/a/821419

echo "Starting demux of $UBAM_DIR"
echo "KIT_NAME: $KIT_NAME"
echo "SAMPLE_SHEET: $SAMPLE_SHEET"
# head $SAMPLE_SHEET

DEMUX_STAMP="${STAMP_DIR}/demux_stamp.txt"
MERGEBAM_STAMP="${STAMP_DIR}/mergebam_stamp.txt"


#------------------------------------
# some channels produce empty files. Must remove them before merging! 
cd $UBAM_DIR
find . -maxdepth 1 -type f -empty -print -delete

#------------------------------------
# Merge uBAMS
#------------------------------------
# Merge per channel uBAMs, because 'dorado demux' won't merge them 
# it doesn't like that the @PG lines aren't identical because they contain the name of the input pod5s

if [ -f "${MERGEBAM_STAMP}" ]; then 
  echo "${MERGEBAM_STAMP} exists. Skipping 'samtools merge'"
else
  echo "Running 'samtools merge' on per-channel uBAMs"
	apptainer exec \
		${DORADO_SIF_PATH} \
		samtools merge \
			-o $MERGED_UBAM \
			--threads $SLURM_JOB_CPUS_PER_NODE \
			$UBAM_DIR/*.ubam
	MERGEBAM_EXIT=$?

  	if [ "$MERGEBAM_EXIT" -eq 0 ]; then
    	echo "mergebam successful"
    	date > $MERGEBAM_STAMP
  	else
    	echo "mergebam FAILED"
		rm $MERGED_UBAM
  	fi
fi
# Unless the -c or -p flags are specified then when merging @RG and @PG records into the output header then any IDs found to be duplicates of existing IDs in the output header will have a suffix appended to them to differentiate them from similar header records from other files and the read records will be updated to reflect this.
# -c
# When several input files contain @RG headers with the same ID, emit only one of them (namely, the header line from the first file we find that ID in) to the merged output file. Combining these similar headers is usually the right thing to do when the files being merged originated from the same file.

# Without -c, all @RG headers appear in the output file, with random suffixes added to their IDs where necessary to differentiate them.

# -p
# Similarly, for each @PG ID in the set of files to merge, use the @PG line of the first file we find that ID in rather than adding a suffix to differentiate similar IDs.

#------------------------------------
# Demux uBAMS
#------------------------------------

# pod5 view /path/to/your/dataset/ --include "read_id, channel" --output summary.tsv
if [ -f "${DEMUX_STAMP}" ]; then 
  echo "${DEMUX_STAMP} exists. Skipping 'dorado demux'"
else
  echo "Running 'dorado demux'"
  apptainer exec \
	${DORADO_SIF_PATH} \
	dorado demux \
		--verbose \
		--threads $SLURM_JOB_CPUS_PER_NODE \
		--output-dir $DEMUX_DIR \
		--kit-name $KIT_NAME \
		--sample-sheet $SAMPLE_SHEET \
		$MERGED_UBAM

  DEMUX_EXIT=$?

  if [ "$DEMUX_EXIT" -eq 0 ]; then
    echo "demux successful"
    date > $DEMUX_STAMP
  else
    echo "demux FAILED"
  fi



fi

