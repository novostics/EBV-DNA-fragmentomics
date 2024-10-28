#!/usr/bin/perl
use v5.16;
use strict;
use warnings;

# update: gnkang, 2024-10-28
#       1) process reads that mapped to EBV genome (labelled as chrE);
#       2) QC > 30;
#       3) paired reads;
#       4) fragment length 20-600 bp;
# to get DNA_fragment.bed from BAM
# Input: (1) filePath
# Output: location of the whole-length-fragments (Watson strand)

if(@ARGV != 1){
        die "Please Assign (1) filePath!";
}
my $filePath = $ARGV[0];

open IN,"samtools view $filePath |";
while(<IN>){
        chomp;
        my @tmp = split /\t/;
        my $chr = $tmp[2];
        my $len = $tmp[8];
        next unless $chr =~ /^chrE$/;
        next unless $tmp[4] > 30;
        next unless $tmp[6] eq '=';
        next unless $len >=20 && $len<=600;
        my $p1 = $tmp[3] -1;
        my $p2 = $p1 + $len;
        say "$chr\t$p1\t$p2\t$len";
}
close IN;
