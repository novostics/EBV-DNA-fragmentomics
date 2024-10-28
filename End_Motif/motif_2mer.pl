#!/usr/bin/perl
use v5.16;
use strict;
use warnings;

# update: gnkang, 2024-10-28
# to get the 2-mer end motif distribution from EBV_DNA_fragment.bed
# Input: (1) filePath
# Output: Counts of 2-mer end motifs

my $refPath = 'EBV.fa'; # reference genome
my $filePath = "$ARGV[0]";

my %ref = &loadRef($refPath);
my @motif_2mers = &initialize();
my %motif;
foreach my $m2 (@motif_2mers){
        $motif{$m2} = 0;
}

&openFile($filePath);
while(<IN>){
        chomp;
        my @tmp = split /\t/;
        my $chr = $tmp[0];
        my $p1 = $tmp[1];
        my $p2 = $tmp[2];
        my $m2 = substr($ref{$chr},$p1,2);
        $motif{$m2} ++;
        $m2 = substr($ref{$chr},$p2-2,2);
        $m2 = reverse $m2;
        $m2 =~ tr/ACGT/TGCA/;
        $motif{$m2} ++;
}
close IN;

say "Motif\tCount";
foreach my $m2 (@motif_2mers){
        say "$m2\t$motif{$m2}";
}

sub loadRef{
        my $refPath = $_[0];
        my %ref;
        my $id;
        open REF,"$refPath";
        while(<REF>){
                chomp;
                if(/^>(.*)/){
                        $id = $1;
                        $ref{$id} = '';
                }else{
                        $ref{$id} .= uc($_);
                }
        }
        close REF;
        return %ref;
}

sub initialize{
        my @motif_2mers;
        my @nt = ('A','C','G','T');
        for(my $i1=0; $i1<2; $i1++){
                for(my $i2=0; $i2<2; $i2++){
                    my $m2 = $nt[$i1].$nt[$i2];
                    push @motif_2mers, $m2;
                }
        }
        return @motif_2mers;
}

sub openFile{
        my $fn = $_[0]; # fileName
        if($fn =~ /\.gz2?$/){
                open IN, "zcat $fn |" or die "Can Not Open File: $fn";
        }elsif($fn =~ /\.bz2$/){
                open IN, "bzcat $fn |" or die "Can Not Open File: $fn";
        }else{
                open IN, "$fn" or die "Can Not Open File: $fn";
        }
}
