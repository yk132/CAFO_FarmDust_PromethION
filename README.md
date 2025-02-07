# CAFO_FarmDust_PromethION

This is a repository for analyzing CAFO farm dust samples that were generated on the PromethION long-read sequencing platform (Nanopore Technologies) for my dissertation. Please note that these samples did not have anywhere near the sequencing depth that I needed to draw any meaningful conclusions! The repository contains code to perform the following: 

- basecall and demultiplex `.POD5` files from Nanopore platforms into `.fastq` or BAM files (credit to Dr. Josh Granek for sharing his awesome code with me!)
  - to make `dorado` run faster, the `.POD5` files are first split by the channels (i.e., pores of the Nanopore sequencing platform)
  - flowcells that are R10 or above create higher quality **duplex** reads. This code is for flowcells that are R10 or above!
  - the code will download the `dorado` model, split the `.POD5` files by channel, basecall, demultiplex, then get rid of the lower-quality simplex reads
- Use `fastqc` (from Babraham Bioinformatics, [website](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)) to check quality of basecalled `.fastq` files
- build contigs using `metaFlye` ([paper](https://www.nature.com/articles/s41592-020-00971-x), [GitHub](https://github.com/mikolmogorov/Flye))
- Check the quality of contigs using `quast` ([paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC3624806/), [GitHub](https://github.com/ablab/quast))
- Download the database for `minimap2` and run `minimap2` to assign taxonomy
  - this code uses Nanopore's [epi2me-labs/wf-metagenomics/](https://github.com/epi2me-labs/wf-metagenomics) program just for downloading the database.
  - Currently the database to be downloaded is `ncbi_16s_18s_28s_ITS` (please see above `wf-metagenomics` pipeline for more information)
  - this portion uses `nextflow`, and will thus need a `nextflow.config` file. This is also provided in this GitHub repository. 
  - minimap2 [GitHub](https://github.com/lh3/minimap2) and [paper](https://academic.oup.com/bioinformatics/article/34/18/3094/4994778)
- 
