# CAFO_FarmDust_PromethION

This is a repository for analyzing CAFO farm dust samples that were generated on the PromethION long-read sequencing platform (Nanopore Technologies) for my dissertation. Please note that these samples did not have anywhere near the sequencing depth that I needed to draw any meaningful conclusions! The repository contains code to perform the following: 

- basecall and demultiplex `.POD5` files from Nanopore platforms into `.fastq` or BAM files (credit to Dr. Josh Granek for sharing his awesome code with me!)
- build contigs using `metaFlye` ([paper](https://www.nature.com/articles/s41592-020-00971-x), [GitHub]([url](https://github.com/mikolmogorov/Flye)))
