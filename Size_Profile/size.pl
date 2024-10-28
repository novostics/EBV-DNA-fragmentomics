#!/usr/bin/perl
use v5.16;
use strict;
use warnings;

# update: gnkang, 2024-10-28
# to get size profile (20-600 bp) from DNA_fragment.bed
# Input: (1) filePath
# Output: size profile (20-600 bp)

my $filePath = $ARGV[0];
my %size;

for(my $i=20;$i<=600;$i++){
        $size{$i} = 0;
}

&openFile($filePath);
while(<IN>){
        chomp;
        my @tmp = split /\t/;
        my $p1 = $tmp[1];
        my $p2 = $tmp[2];
        my $len = $p2 -$p1;
        $size{$len} ++;
}

say "Size\tCount";
for(my $i=20;$i<=600;$i++){
        say "$i\t$size{$i}";
}

sub openFile{
        my $fn = $_[0]; # filePath
        if($fn =~ /\.gz2?$/){
                open IN, "zcat $fn |" or die "Can Not Open File: $fn";
        }elsif($fn =~ /\.bz2$/){
                open IN, "bzcat $fn |" or die "Can Not Open File: $fn";
        }else{
                open IN, "$fn" or die "Can Not Open File: $fn";
        }
}
