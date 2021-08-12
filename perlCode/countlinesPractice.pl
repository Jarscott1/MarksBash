#!/usr/bin/perl
# countlines.pl

use 5.18.0;
use strict;
use warnings;

my $filename = "linesfile.txt";

open(FH, $filename);            # open file     The $ makes the variable a scalar value
my @lines = <FH>;               # read file     The @ makes the datatype an array
close(FH);                      # closing file  

my $count = scalar @lines;      # The number of lines in the file
say "There are $count lines in $filename";

#####################################################################################################################################################################

##                                                                        Method 2

#!/usr/bin/perl
# count2.pl

use 5.18.0;
use warnings;
use IO::File;

my $fh = IO::File->new( $filename, "r");
if(! $fh){
    print("Cannot open $filename ($!)\n")
    exit;
}

my $count = 0;
while ($fh->getline){
    $count++;
}

$fh->close;
print("There are $count lines in $filename\n");
