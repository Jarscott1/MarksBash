use strict;
use warnings;

my $ARGC = $#ARGV + 1;
my $Filepath = $ARGV[0];
my $Classification = $ARGV[1];

print "Command line arguments:\n";
print "$ARGV[0]\n";
print "Number of Arguments: $ARGC\n";


#Read File Contents
print "Opening File to Read.\n";
open(FH, '<', $Filepath) or die $!;
while(<FH>){
    my ($ClassName, $Parameters) = split(' \(', $_);
    my ($FilteredParameters) = split('\)', $Parameters);
    my @ParameterList = split(', ', $FilteredParameters);
    my $EnumName = "$ClassName\_enum";
    my $OutHeaderFile = "$ClassName.h";

    print "Enum Name: $EnumName\n";
    print "Parameters: @ParameterList\n";

    open(OUT, '>', $OutHeaderFile) or die $!;
    print OUT "#include <iostream>\n\n";
    print OUT "using namespace std;\n\n";
    print OUT "class $ClassName {\n";
    print OUT "public:\n";
    print OUT "\tenum $EnumName {";

    #Print out the enum parameters
    my $index = 0;
    foreach (@ParameterList){
        if ($index >= ($#ParameterList)){
            print OUT "$_";
        }
        else{
            print OUT "$_, ";
        }
        $index = $index + 1;
    }

    print OUT "};\n\n";
    print OUT "\tconst int $ClassName\::enumToInt (const $ClassName\::$EnumName& toConvert) const;\n";
    print OUT "\tconst $ClassName\::$EnumName $ClassName\::intToEnum (const $ClassName\::$EnumName& toConvert) const;\n";
    print OUT "\tconst string $ClassName\::enumToString (const $ClassName\::$EnumName& toConvert) const;\n";
    print OUT "\tconst $ClassName\::$EnumName $ClassName\::stringToEnum (const std::string& toConvert) const;\n";
    print OUT "};\n";
    close(OUT);
}
close(FH);