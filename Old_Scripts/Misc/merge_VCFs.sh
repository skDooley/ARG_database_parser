#!/bin/bash

num_cols="$(python merge_VCFs.py NFPT1.vcf)"

join -1 1 -2 1 -o 0 <(awk '{print $1 "_" $2}' <(cat NFPT1.vcf | sed 1,41d)) <(awk '{print $1 "_" $2}' <(cat NFPT1.duped.vcf | sed 1,41d)) | wc -l

