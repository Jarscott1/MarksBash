use strict;
use warnings;

my $ARGC = $#ARGV + 1;
my $Filepath = $ARGV[0];
my $Classification = $ARGV[1];


sub class_Banner {
    my $Class_Type = $Classification;
    my $ClassifiedBanner = "/************************************************************************************************************
************************************************** CLASSIFIED **************************************************
************************************************************************************************************/\n";
    my $UnclassifiedBanner = "/************************************************************************************************************
************************************************ UNCLASSIFIED **************************************************
************************************************************************************************************/\n";
    my $SecretBanner = "/************************************************************************************************************
************************************************** SECRET ***************************************************
************************************************************************************************************/\n";
    my $TopSecretBanner = "/************************************************************************************************************
*********************************************** TOP SECRET **************************************************
************************************************************************************************************/\n";
    my $SecretRdFrdBanner = "/************************************************************************************************************
************************************************ SECRET RD/FRD *************************************************
************************************************************************************************************/\n";

    #Add Classification Banner
    if ($Class_Type eq ""){
    }
    else{
        if ($Class_Type eq "CLASSIFIED" || $Class_Type eq "Classified" || $Class_Type eq "classified"){
            print OUT $ClassifiedBanner;
        }
        elsif ($Class_Type eq "UNCLASSIFIED" || $Class_Type eq "Unclassified" || $Class_Type eq "unclassified"){
            print OUT $UnclassifiedBanner;
        }
        elsif ($Class_Type eq "SECRET" || $Class_Type eq "Secret" || $Class_Type eq "secret"){
            print OUT $SecretBanner;
        }
        elsif ($Class_Type eq "TOP_SECRET" || $Class_Type eq "Top_Secret" || $Class_Type eq "Top_secret" || $Class_Type eq "top_Secret" || $Class_Type eq "top_secret"){
            print OUT $TopSecretBanner;
        }
        elsif ($Class_Type eq "SECRET RD/FRD" || $Class_Type eq "Secret Rd/Frd" || $Class_Type eq "secret rd/frd"){
            print OUT $SecretRdFrdBanner;
        }
        else{
            print "WARNING: Couldn't determine classification rating. Please put classification in ALL CAPS by default.\n";
        }
    }
}

sub print_functions {
    my $ClassName = $_[0];
    my $EnumName = $_[1];

    my $enumToIntFcn = "\tconst int $ClassName\::enumToInt (const $ClassName\::$EnumName& toConvert) const{
        const int convertedVal = static_cast<int>(toConvert);
        return convertedVal;
    }\n";

    my $intToEnumFcn = "\tconst $ClassName\::$EnumName $ClassName\::intToEnum (const int& toConvert) const{
        const $ClassName\::$EnumName convertedVal = static_cast<$ClassName\::$EnumName>(toConvert);
        return convertedVal;
    }\n";

    my $enumToStringFcn = "\tconst string $ClassName\::enumToString (const $ClassName\::$EnumName& toConvert) const{
        const string convertedVal = static_cast<string>(toConvert);
        return convertedVal;
    }\n";

    my $stringToEnumFcn = "\tconst $ClassName\::$EnumName $ClassName\::stringToEnum (const std::string& toConvert) const{
        const $ClassName\::$EnumName convertedVal = static_cast<$ClassName\::$EnumName>(toConvert);
        return convertedVal;
    }\n";

    print OUT $enumToIntFcn;
    print OUT $intToEnumFcn;
    print OUT $enumToStringFcn;
    print OUT $stringToEnumFcn;
}

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
    class_Banner($Classification);
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
    print_functions($ClassName, $EnumName);
    print OUT "};\n";
    class_Banner($Classification);
    close(OUT);
}
close(FH);