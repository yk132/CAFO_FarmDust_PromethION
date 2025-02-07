# General Information

This is a repository for analyzing CAFO farm dust samples that were generated on the PromethION long-read sequencing platform (Nanopore Technologies) for my dissertation. Please note that these samples did not have anywhere near the sequencing depth that I needed to draw any meaningful conclusions! The repository contains code to perform the following: 

- Basecall and demultiplex `.POD5` files from Nanopore platforms into `.fastq` or BAM files (credit to Dr. Josh Granek for sharing his awesome code with me!)
  - to make `dorado` run faster, the `.POD5` files are first split by the channels (i.e., pores of the Nanopore sequencing platform)
  - flowcells that are R10 or above create higher quality **duplex** reads. This code is for flowcells that are R10 or above!
  - the code will download the `dorado` model, split the `.POD5` files by channel, basecall, demultiplex, then get rid of the lower-quality simplex reads
- Use `fastqc` (from Babraham Bioinformatics, [website](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)) to check quality of basecalled `.fastq` files
- Download the database for `minimap2` and run `minimap2` to assign taxonomy using *raw sequencing data*, i.e., not contigs! 
  - this portion utilizes Nanopore's [epi2me-labs/wf-metagenomics/](https://github.com/epi2me-labs/wf-metagenomics) program.
  - Currently the database to be downloaded is `ncbi_16s_18s_28s_ITS` (please see above `wf-metagenomics` pipeline for more information)
  - this portion uses `nextflow`, and will thus need a `nextflow.config` file. This is also provided in this GitHub repository.
  - the output is a `.tsv` file of an abundance table. This table can then be imported into R to generate a `phyloseq` object for analysis. 
  - Refs: minimap2 [GitHub](https://github.com/lh3/minimap2) and [paper](https://academic.oup.com/bioinformatics/article/34/18/3094/4994778)
- Build contigs using `metaFlye` ([paper](https://www.nature.com/articles/s41592-020-00971-x), [GitHub](https://github.com/mikolmogorov/Flye))
- Check the quality of contigs using `QUAST` ([paper](https://pmc.ncbi.nlm.nih.gov/articles/PMC3624806/), [GitHub](https://github.com/ablab/quast))
- Polish contigs through Nanopore's `medaka`, [GitHub]([url](https://github.com/nanoporetech/medaka))
- Check the quality of polished contigs with `QUAST` 
- use `ABRicate` ([GitHub](https://github.com/tseemann/abricate)) to look for antibiotic resistange genes using the polished contigs 

# Images

Rather than building an environment or an Apptainer image myself, I am relying heavily on publicly available pre-made images. For `dorado`, I'm using Dr. Granek's Apptainer image available at `oras://gitlab-registry.oit.duke.edu/granek-lab/granek-container-images/dorado-simg:latest`. For other images, please check each file. The images / containers used are available through [Docker Hub](https://hub.docker.com/). The program versions were as follows on June 6th, 2024:

- dorado (v0.4.2)
- metaFlye (v2.9.4-b1799)
- QUAST (v5.2.0)
- abricate (v1.0.1)
- Minimap2 (v2.2.26)
- wf-metagenomics pipeline (v2.10.0)

# Acknowledgments

If you use this code, I would really appreciate it if you would consider adding Dr. Josh Granek and me (Yeon Ji Kim) as co-authors for relevant publications. 
