#!/bin/bash
tag=$1
f1=$2
f2=$3
olddir=`pwd`
bwa mem -t16 refs/hs_ref_GRCh37_p10 $f1 $f2 | tee >(samtools view -h -f 4 -S - -o "$tag".sam) | samtools view -F 4 -S - | wc -l > "$tag".wc
python scripts/sam2fasta.py $tag.sam > "$tag".fasta
lastal -F15 refs/microbial.last "$tag".fasta | maf-sort.sh -n2 - > "$tag".sorted.maf
maf-convert.py blast "$tag".sorted.maf > "$tag".blast
rm "$tag".sorted.maf

#~/hackathon/bin/metaphlan-1.7.6/metaphlan.py "$tag".fasta --bowtie2db ~/hackathon/bin/metaphlan-1.7.6/mpa > "$tag".assign.txt

python scripts/sleepcat.py xvfb-run -a ~/hackathon/bin/megan/MEGAN +g false -E -fg '/home/nick/hackathon/gi_taxid_prot.bin' <<EOF
import blastFile=$tag.blast fastaFile=$tag.fasta meganFile=$tag.rma maxMatches=100 minScore=250.0 topPercent=10.0 minSupport=2 minComplexity=0.5 useseed=false usekegg=false paired=true suffix1='/1' suffix2='/2' useidentityfilter=false blastformat=BlastX
close
EOF

gzip -f "$tag".blast

python scripts/sleepcat.py xvfb-run -a ~/hackathon/bin/megan/MEGAN +g false -E -fg '/home/nick/hackathon/gi_taxid_prot.bin' -f $tag.rma <<EOF
select nodes=all
uncollapse subtrees
collapse rank=Species
select nodes=leaves
export what=CSV format=taxonpath_count separator=tab file=$tag.species.taxonsummary.txt
collapse rank=Genus
select nodes=leaves
export what=CSV format=taxonpath_count separator=tab file=$tag.genera.taxonsummary.txt
collapse rank=Family
select nodes=leaves
export what=CSV format=taxonpath_count separator=tab file=$tag.family.taxonsummary.txt
close
EOF

##Broken MEGAN5 stuff
#cat >megan.input <<EOF
#load taxGIFile=/home/nick/hackathon/gi_taxid_prot.bin
#set loadAllReadsIntoMemory=true
#import blastFile='$tag.blast' fastaFile='$tag.fasta' meganFile='$tag.rma' maxMatches=100 minScore=150.0 topPercent=10.0 minSupport=1 minComplexity=0.5 useseed=false usekegg=false useidentityfilter=false blastformat=BlastX mapping=GI
#close
#EOF
#bin/megan/MEGAN -g -E -c megan.input

#cat >megan.input <<EOF
#select nodes=all
#uncollapse nodes=selected
#select nodes=all
#export what=DSV format=taxonpath_count separator=tab file=$tag.taxonsummary.txt
#export what=DSV format=readname_taxonpath separator=tab file=$tag.reads.txt
#close
#EOF
#bin/megan/MEGAN -f `realpath $tag.rma` -g -E -c megan.input
