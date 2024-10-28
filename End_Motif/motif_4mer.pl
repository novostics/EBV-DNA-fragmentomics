#!/usr/bin/perl
use v5.16;
use strict;
use warnings;

# update: gnkang, 2024-10-28
# to get the 4-mer end motif distribution from EBV_DNA_fragment.bed
# Input: (1) filePath
# Output: Counts of 4-mer end motifs

my $refPath = 'chrE.fa'; # reference genome
my $filePath = "$ARGV[0]";

my %ref = &loadRef($refPath);
my @motif_4mers = &initialize();
my %motif;
foreach my $m4 (@motif_4mers){
        $motif{$m4} = 0;
}

&openFile($filePath);
while(<IN>){
        chomp;
        my @tmp = split /\t/;
        my $chr = $tmp[0];
        my $p1 = $tmp[1];
        my $p2 = $tmp[2];
        my $m4 = substr($ref{$chr},$p1,4);
        $motif{$m4} ++;
        $m4 = substr($ref{$chr},$p2-4,4);
        $m4 = reverse $m4;
        $m4 =~ tr/ACGT/TGCA/;
        $motif{$m4} ++;
}
close IN;

say "Motif\tCount";
foreach my $m4 (@motif_4mers){
        say "$m4\t$motif{$m4}";
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
        my @motif_4mers;
        my @nt = ('A','C','G','T');
        for(my $i1=0; $i1<4; $i1++){
                for(my $i2=0; $i2<4; $i2++){
                        for(my $i3=0; $i3<4; $i3++){
                                for(my $i4=0; $i4<4; $i4++){
                                        my $m4 = $nt[$i1].$nt[$i2].$nt[$i3].$nt[$i4];
                                        push @motif_4mers, $m4;
                                }
                        }
                }
        }
        return @motif_4mers;
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
