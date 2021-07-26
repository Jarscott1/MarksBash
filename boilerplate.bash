#!/bin/bash

####BOILERPLATE.BASH####
## This Bash Script creates an automatic boilerplate for files. ##

INPUT_FILE="$1"
echo "Running the Boilerplate Bash Script."
CLASS_NAME=$( echo $1 | cut -d "." -f 1 )
OUTPUT_FILE="$CLASS_NAME.cpp"
echo $OUTPUT_FILE


UNCLASS_SEARCH=$(grep -cw 'UNCLASSIFIED' $1)
CLASS_SEARCH=$(grep -cw 'CLASSIFIED' $1)
SECRET_RD_FRD=$(grep -cw 'SECRET RD/FRD' $1)

BUFFERLINE="\/\*----------------------------------------------------------------------\*\/"


#Header Ribbon
if [[ $UNCLASS_SEARCH -gt 1 ]]
then
    cat > $OUTPUT_FILE << EOF
/*----------------------------------------------------------------------*/
/*---------------------------- UNCLASSIFIED ----------------------------*/
/*----------------------------------------------------------------------*/


EOF

elif [[ $CLASS_SEARCH -gt 1 ]]
then
    cat > $OUTPUT_FILE << EOF
/*----------------------------------------------------------------------*/
/*------------------------------ CLASSIFIED ----------------------------*/
/*----------------------------------------------------------------------*/


EOF

elif [[ $SECRET_RD_FRD -gt 1 ]]
then
    cat > $OUTPUT_FILE << EOF
/*----------------------------------------------------------------------*/
/*--------------------------- SECRET RD/FRD ----------------------------*/
/*----------------------------------------------------------------------*/
EOF
fi

#Find description
cat >> $OUTPUT_FILE << EOF
/*----------------------------------------------------------------------*/
/*----------------------------- DESCRIPTION ----------------------------*/
/*----------------------------------------------------------------------*/
EOF

#Find Includes
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*------------------------------ INCLUDES ------------------------------*/
/*----------------------------------------------------------------------*/
EOF

echo "#include \"$1\"" >> $OUTPUT_FILE

#Find Forward Declarations
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*------------------------ FORWARD DECLARATIONS ------------------------*/
/*----------------------------------------------------------------------*/
EOF

#Find Usings here
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*------------------------------- USINGS -------------------------------*/
/*----------------------------------------------------------------------*/
using namespace std;
EOF

#METHOD 1: Cut result of grep search and see if we can parse it into an array
NAMESPACE=$(grep "class" $1 | grep "$CLASS_NAME" | grep ":" | cut -d " " -f 2 | sed "s/::/ /g" | rev |cut -d " " -f 2- | rev )
#METHOD 2: Use read to put the result into an array. Relies on METHOD 1
IFS=' ' read -ra usings_array <<< "$NAMESPACE"
#Print out the two results:
#Result 1
REVERSE_NAMESPACE=$(echo $NAMESPACE | rev)
IFS=' ' read -ra usings_array_reverse <<< "$REVERSE_NAMESPACE"
#Result 2
for i in "${usings_array[@]}"
do
    echo "namespace $i {" >> $OUTPUT_FILE
done

#Global Variables
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*-------------------------- GLOBAL VARIABLES --------------------------*/
/*----------------------------------------------------------------------*/
EOF


#Constructor/Destructor
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*----------------------- CONSTRUCTOR/DESTRUCTOR -----------------------*/
/*----------------------------------------------------------------------*/
EOF

echo "$CLASS_NAME::$CLASS_NAME(){" >> $OUTPUT_FILE
echo "***********************CONSTRUCTOR******************************"
#Find Ints
echo "--------------INTS----------------"
INT_VARIABLES=($(grep -w "int" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" ))
grep -w "int" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0;/g"
INT_ARRAYS=($(grep -w "int" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" ))
grep -w "int" $1 | sed "s/  //g" | grep "\[" | grep -v 'volatile\|unsigned\|typedef' | cut -d " " -f 2
echo "    //ints" >> $OUTPUT_FILE
echo "Int array size: ${#INT_VARIABLES[@]}"
for i in "${INT_VARIABLES[@]}"
do
    if [[ $i = "" ]] 
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi 
done
for i in "${INT_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i;" >> $OUTPUT_FILE 
    fi 
done

#Find Unsigned Ints
echo "    //Unsigned Ints" >> $OUTPUT_FILE
echo "----------UNSIGNED INTS-----------"
UNSIGNED_INT_VARIABLES=$(grep -w "unsigned int" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "unsigned int" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"
UNSIGNED_INT_ARRAYS=($(grep -w "unsigned int" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 3 | tr -d ";" | tr "\n" " " | tr -d "\r"))
grep -w "unsigned int" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 3
for i in "${UNSIGNED_INT_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi 
done
for i in "${UNSIGNED_INT_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i;" >> $OUTPUT_FILE 
    fi 
done
#Find Volatile Ints
echo "    //Volatile Ints" >> $OUTPUT_FILE
echo "----------VOLATILE INTS-----------"
VOLATILE_INT_VARIABLES=$(grep -w "volatile int" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "volatile int" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"
VOLATILE_INT_ARRAYS=$(grep -w "volatile int" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v "(" | grep "\[" | cut -d " " -f 3 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "volatile int" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v "(" | grep "\[" | cut -d " " -f 3
for i in "${VOLATILE_INT_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi 
done
for i in "${VOLATILE_INT_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i;" >> $OUTPUT_FILE 
    fi 
done
#Find Shorts
echo "    //Shorts" >> $OUTPUT_FILE
echo "--------------SHORTS--------------"
SHORT_VARIABLES=$(grep -w "short" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "short" $1 | grep -v 'volatile\|unsigned\|typedef'  | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0;/g"
SHORT_ARRAYS=($(grep -w "short" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" ))
grep -w "short" $1 | sed "s/  //g" | grep "\[" | cut -d " " -f 2
for i in "${SHORT_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi 
done
for i in "${SHORT_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i;" >> $OUTPUT_FILE 
    fi 
done
#Find Unsigned Shorts
echo "    //Unsigned Shorts" >> $OUTPUT_FILE
echo "---------UNSIGNED SHORTS----------"
UNSIGNED_SHORT_VARIABLES=$(grep -w "unsigned short" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "unsigned short" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"
UNSIGNED_SHORT_ARRAYS=$(grep -w "unsigned short" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep "\[" | cut -d " " -f 3 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "unsigned short" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep "\[" | cut -d " " -f 3 
for i in "${UNSIGNED_SHORT_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi 
done
for i in "${UNSIGNED_SHORT_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i;" >> $OUTPUT_FILE 
    fi 
done
#Find Volatile Shorts
echo "    //Volatile Shorts" >> $OUTPUT_FILE
echo "---------VOLATILE SHORTS----------"
VOLATILE_SHORT_VARIABLES=$(grep -w "volatile short" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "volatile short" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"
for i in "${VOLATILE_SHORT_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi
done
#Find Longs
echo "    //Longs" >> $OUTPUT_FILE
echo "--------------LONGS---------------"
LONG_VARIABLES=$(grep -w "long" $1 | grep -v 'volatile\|unsigned\|typedef' | grep -v "long long" | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "long" $1 | grep -v 'volatile\|unsigned\|typedef' | grep -v "long long"  | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0;/g"
for i in "${LONG_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi
done
#Find Unsigned Longs (Ulongs)
echo "    //Unsigned Longs" >> $OUTPUT_FILE
echo "----------UNSIGNED LONGS----------"
UNSIGNED_LONG_VARIABLES=$(grep -w "unsigned long" $1 | grep -v 'volatile\|typedef' | grep -v "long long" | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "unsigned long" $1 | grep -v 'volatile\|typedef' | grep -v "long long" | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"
for i in "${UNSIGNED_LONG_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi
done
#Find Volatile Longs
echo "    //Volatile Longs" >> $OUTPUT_FILE
echo "----------VOLATILE LONGS----------"
VOLATILE_LONG_VARIABLES=$(grep -w "volatile long" $1 | grep -v 'typedef' | grep -v "long long" | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "volatile long" $1 | grep -v 'typedef' | grep -v "long long" | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"
for i in "${VOLATILE_LONG_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi
done
#Find Long Longs
echo "    //Long Longs" >> $OUTPUT_FILE
echo "-----------LONG LONGS-------------"
LONG_LONG_VARIABLES=$(grep -w "long long" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "long long" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"
for i in "${LONG_LONG_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi
done
#Find Unsigned Long Longs
echo "    //Unsigned Long Longs" >> $OUTPUT_FILE
echo "-------UNSIGNED LONG LONGS--------"
UNSIGNED_LONG_LONG_VARIABLES=$(grep -w "unsigned long long" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 4 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "unsigned long long" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 4 | sed "s/;/ = 0;/g"
for i in "${UNSIGNED_LONG_LONG_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi 
done
#Find Ulongs
echo "    //Ulongs" >> $OUTPUT_FILE
echo "-------------ULONGS---------------"
ULONG_VARIABLES=$(grep -w "ulong" $1 | grep -v 'volatile\|unsigned\|typedef' | grep -v "long long" | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "ulong" $1 | grep -v 'volatile\|unsigned\|typedef' | grep -v "long long"  | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0;/g"
for i in "${ULONG_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi 
done
#Find Chars
echo "    //Chars" >> $OUTPUT_FILE
echo "--------------CHARS---------------"
CHAR_VARIABLES=$(grep -w "char" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "char" $1 | grep -v 'volatile\|unsigned\|typedef'  | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = \'\';/g"
CHAR_ARRAYS=($(grep -w "char" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r"))
grep -w "char" $1 | grep -v 'volatile\|unsigned\|typedef' |sed "s/  //g" | grep "\[" | cut -d " " -f 2
for i in "${CHAR_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = '';" >> $OUTPUT_FILE 
    fi 
done
for i in "${CHAR_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i;" >> $OUTPUT_FILE 
    fi
done
#Find Unsigned Chars
echo "    //Unsigned Chars" >> $OUTPUT_FILE
echo "----------UNSIGNED CHARS----------"
CHAR_VARIABLES=$(grep -w "unsigned char" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "unsigned char" $1 | grep -v 'volatile\|typedef'  | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = \'\';/g"
CHAR_ARRAYS=($(grep -w "unsigned char" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 3 | tr -d ";" | tr "\n" " " | tr -d "\r" ))
grep -w "unsigned char" $1 | grep -v 'volatile\|typedef' |sed "s/  //g" | grep "\[" | cut -d " " -f 3
for i in "${CHAR_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = '';" >> $OUTPUT_FILE 
    fi 
done
for i in "${CHAR_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i;" >> $OUTPUT_FILE 
    fi
done
#Find Strings
echo "    //Strings" >> $OUTPUT_FILE
echo "-------------STRINGS--------------"
STRING_VARIABLES=$(grep -w "string" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v '(\|<' | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "string" $1 | sed "s/  //g" | grep -v '(\|<' | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = \"\";/g"
for i in "${STRING_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = \"\";" >> $OUTPUT_FILE 
    fi 
done
#Find Floats
echo "    //Floats" >> $OUTPUT_FILE
echo "--------------FLOATS--------------"
FLOAT_VARIABLES=$(grep -w "float" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "float" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0.0;/g"
for i in "${FLOAT_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0.0;" >> $OUTPUT_FILE 
    fi
done
#Find Doubles
echo "    //Doubles" >> $OUTPUT_FILE
echo "-------------DOUBLES--------------"
DOUBLE_VARIABLES=$(grep -w "double" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" )
grep -w "double" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0.0;/g"
for i in "${DOUBLE_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0.0;" >> $OUTPUT_FILE 
    fi 
done
#Find Bools
echo "--------------BOOLS---------------"
BOOL_VARIABLES=$(grep "bool" $1 | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" ) 
grep "bool" $1 | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = false;/g"
BOOL_ARRAYS=($(grep "bool" $1 | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" ))
grep "bool" $1 | sed "s/  //g" | grep "\[" | cut -d " " -f 2
BOOL_FUNCTIONS=($(grep "bool" $1 | sed "s/  //g" | grep "(" | grep -v "{" | sed "s/;//g" | cut -d ";" -f 1- ))

echo "    //bools" >> $OUTPUT_FILE
for i in "${BOOL_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = false;" >> $OUTPUT_FILE 
    fi 
done
for i in "${BOOL_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i;" >> $OUTPUT_FILE 
    fi
done
#Find Unsigneds
echo "-----------UNSIGNEDS--------------"
UNSIGNED_VARIABLES=$(grep "unsigned" $1 | grep -v 'int\|char\|bool\|short\|long' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" ) 
grep "unsigned" $1 | grep -v 'int\|char\|bool\|short\|long' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0;/g"
UNSIGNED_ARRAYS=($(grep "unsigned" $1 | grep -v 'int\|char\|bool\|short\|long' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | tr "\n" " " | tr -d "\r" ))
grep "unsigned" $1 | grep -v 'int\|char\|bool\|short\|long' | sed "s/  //g" | grep -v "(" | grep "\[" | cut -d " " -f 2 
echo "    //unsigned" >> $OUTPUT_FILE
echo "Unsigned Array Size: ${#UNSIGNED_VARIABLES[@]}"
for i in "${UNSIGNED_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = 0;" >> $OUTPUT_FILE 
    fi 
done
for i in "${UNSIGNED_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i;" >> $OUTPUT_FILE 
    fi
done

echo "-------------POINTERS--------------"
POINTER_VARIABLES=($(grep -E "[A-Za-z]\*" $1 | grep -v "typedef" | sed "s/  //g" | grep -v "(" | grep -v "\[" | rev | cut -d " " -f 1 | rev | tr -d ";" | tr "\n" " " | tr -d "\r" ))
grep -E "[A-Za-z]\*" $1 | grep -v "typedef" | sed "s/  //g" | grep -v "(" | grep -v "\[" | rev | cut -d " " -f 1 | rev | sed "s/;/ = NULL;/g" 
echo "Array Length Size: ${#POINTER_VARIABLES[@]}"
for i in "${POINTER_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i = NULL;" >> $OUTPUT_FILE 
    fi
done
echo "-------------TYPEDEFS--------------"
TYPEDEF_VARIABLES=($(grep "typedef" $1 | grep -v "struct\|\/" | sed "s/  //g" | grep -v "(" | grep -v "\[" | rev | cut -d " " -f 1 | rev )) 
for i in "${TYPEDEF_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "$i"
        SPECIFIC_TYPEDEFS=($(grep "$i" $1 | grep -v "typedef" | sed "s/  //g" | cut -d " " -f 2))
        for j in "${SPECIFIC_TYPEDEFS[@]}"
        do
            if [[ $j = "" ]]
            then
                :
            else
                echo -n "    $j" >> $OUTPUT_FILE
            fi
        done
    fi
done

#Close the Bracket out.
echo "}" >> $OUTPUT_FILE


cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
EOF
echo "$CLASS_NAME::~$CLASS_NAME () {" >> $OUTPUT_FILE
echo "//Deleting Pointer Variables, setting them to NULL" >> $OUTPUT_FILE
for i in "${POINTER_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        TMP_EXPR=$(echo "$i != NULL")
        echo "    if ($TMP_EXPR) { delete $i; }" >> $OUTPUT_FILE
        echo "    $i = NULL;" >> $OUTPUT_FILE 
    fi
done
##########################################################################
#INSERT MORE CODE HERE#
##########################################################################
echo "}" >> $OUTPUT_FILE
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*------------------------------ FUNCTIONS -----------------------------*/
/*----------------------------------------------------------------------*/
EOF
cat << EOF

***********************FUNCTIONS********************************
EOF

#This grep will be saved in a variable and will later be printed out to a file.
#FUNCTIONS_LIST=$(grep -E '\(.*\)' $1 | grep -v "~\|operator\|$CLASS_NAME\|{" | sed "s/  //g" |  )
FUNCTIONS_LIST=$(grep -wE ".*\(.*\)" $1 | sed "s/  //g" | grep -v "~\|operator\|$CLASS_NAME\|{" | sed "s/;/ {}\n\n\n$BUFFERLINE\n$BUFFERLINE/g" )
#FUNCTIONS_LIST=$(grep -w "int" $1 | sed "s/  //g" )
#This grep is printing out to the terminal
grep "(" $1 | sed "s/  //g" | grep -v "~\|operator\|$CLASS_NAME\|{" 
#Print out the functions to the new file.
echo "Functions List Array Size: ${#FUNCTIONS_LIST[@]}"
for i in "${FUNCTIONS_LIST[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "$i" >> $OUTPUT_FILE
    fi 
done

cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*------------------------------ OPERATORS -----------------------------*/
/*----------------------------------------------------------------------*/
// I haven't gotten to testing on operators yet, leave this for the future


/*----------------------------------------------------------------------*/
/*------------------------------ TEMPLATES -----------------------------*/
/*----------------------------------------------------------------------*/
// I haven't gotten to testing on templates yet, leave this for the future
EOF

#Close Namespaces
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*------------------------- CLOSING NAMESPACES -------------------------*/
/*----------------------------------------------------------------------*/
EOF
#FIXME
for i in "${usings_array_reverse[@]}"
do
    echo "} //end namespace $i" >> $OUTPUT_FILE
done


#Footer Buffer
if [[ $UNCLASS_SEARCH -gt 1 ]]
then
    cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*---------------------------- UNCLASSIFIED ----------------------------*/
/*----------------------------------------------------------------------*/


EOF

elif [[ $CLASS_SEARCH -gt 1 ]]
then
    cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*------------------------------ CLASSIFIED ----------------------------*/
/*----------------------------------------------------------------------*/


EOF

elif [[ $SECRET_RD_FRD -gt 1 ]]
then
    cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*--------------------------- SECRET RD/FRD ----------------------------*/
/*----------------------------------------------------------------------*/
EOF
fi