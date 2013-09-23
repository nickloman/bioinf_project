#!/bin/bash
tag=$1
f1=$2
f2=$3
olddir=`pwd`
~/hackathon/bin/metaphlan-1.7.6/metaphlan.py "$tag".fasta --bowtie2db ~/hackathon/bin/metaphlan-1.7.6/mpa > "$tag".assign.txt
