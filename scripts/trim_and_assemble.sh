#!/bin/sh
tag=$1
java -jar bin/Trimmomatic-0.30/trimmomatic-0.30.jar PE -threads 8 -phred33 -trimlog log "$tag"_R1_001.fastq.gz "$tag"_R2_001.fastq.gz "$tag"_1_trimmed.fastq.gz "$tag"_U1_trimmed.fastq.gz "$tag"_2_trimmed.fastq.gz "$tag"_U2_trimmed.fastq.gz ILLUMINACLIP:nextera.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:36
bin/SPAdes-2.5.1-Linux/bin/spades.py --pe1-1 "$tag"_1_trimmed.fastq.gz --pe1-2 "$tag"_2_trimmed.fastq.gz -k 21,33,55,77 -o assemblies/`basename $tag` --careful
