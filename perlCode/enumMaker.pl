#!/usr/bin/perl
use strict;
use warnings;


my $ARGC = $#ARGV + 1;
if($ARGC < 1){
    print "Input File not supplied. Exiting program.\n";
    exit;
}

my $filename = $ARGV[0];

print "Hello World\n";
print "$filename\n";
open(FH, '<', $filename) or die $!;

print <FH>;

close(FH);
exit;