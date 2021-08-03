#!/bin/bash

#### BOILERPLATE.BASH ####
## This Bash Script creates an automatic boilerplate for files. ##
#PARAMETERS: $1: The absolute file path

RELATIVE_PATH=($(echo $1 | rev | cut -d "/" -f 1 | rev )) #Relative Path stored here
echo "Running the Boilerplate Bash Script."
CLASS_NAME=$( echo $1 | cut -d "." -f 1 )
OUTPUT_FILE="$CLASS_NAME.cpp"

#Print File Path information to the terminal
echo "Absolute Path Name: $1"                                                                
echo "Relative Path Name: $RELATIVE_PATH"
echo "File to be created: $OUTPUT_FILE"

#Variables that return a number indicating the number of matches in a grep search
UNCLASS_SEARCH=$(grep -cw 'UNCLASSIFIED' $1) #Searching for 'unclassified' banner
CLASS_SEARCH=$(grep -cw 'CLASSIFIED' $1) #Searching for 'classified' banner
SECRET_RD_FRD=$(grep -cw 'SECRET RD/FRD' $1) #Searching for 'secret-rd/frd' banner

#This variable is for adding a buffer between function definitions.
BUFFERLINE="\/\*----------------------------------------------------------------------\*\/"


#Header Ribbon: Makes appropriate header based on the grep search results
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

#Write a description banner on the .cpp file
if [[ $UNCLASS_SEARCH -eq 0 && $CLASS_SEARCH -eq 0 && $SECRET_RD_FRD -eq 0 ]]
then 
    cat > $OUTPUT_FILE << EOF
/*----------------------------------------------------------------------*/
/*----------------------------- DESCRIPTION ----------------------------*/
/*----------------------------------------------------------------------*/
EOF
else 
    cat >> $OUTPUT_FILE << EOF
/*----------------------------------------------------------------------*/
/*----------------------------- DESCRIPTION ----------------------------*/
/*----------------------------------------------------------------------*/
EOF
fi

#Add Include Banner and some include statements.
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*------------------------------ INCLUDES ------------------------------*/
/*----------------------------------------------------------------------*/
EOF

echo "#include \"$RELATIVE_PATH\"" >> $OUTPUT_FILE

#Add a Forward Declarations Banner (May need work in the future)
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*------------------------ FORWARD DECLARATIONS ------------------------*/
/*----------------------------------------------------------------------*/
EOF

#Add a Usings banner here
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*------------------------------- USINGS -------------------------------*/
/*----------------------------------------------------------------------*/
using namespace std;
EOF

#Cut result of grep search and parse it into an array
NAMESPACE=$(grep "class" $1 | grep "$CLASS_NAME" | grep ":" | cut -d " " -f 2 | sed "s/::/ /g" | rev |cut -d " " -f 2- | rev )
#Use read to put the result into an array. 
IFS=' ' read -ra usings_array <<< "$NAMESPACE"
REVERSE_NAMESPACE=$(echo $NAMESPACE | rev)
IFS=' ' read -ra usings_array_reverse <<< "$REVERSE_NAMESPACE"
#Print out the namespaces to the output file with opening brackets
for i in "${usings_array[@]}"
do
    echo "namespace $i {" >> $OUTPUT_FILE
done

#Add a Global Variables Banner
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*-------------------------- GLOBAL VARIABLES --------------------------*/
/*----------------------------------------------------------------------*/
EOF

#Add a Constructor/Destructor banner and begin creating them both using the
#   variable declarations from the header file.
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*----------------------- CONSTRUCTOR/DESTRUCTOR -----------------------*/
/*----------------------------------------------------------------------*/
EOF

#Search for any parameters that may be included within the constructor definition
CONSTRUCTOR_PARAMS=$( grep $CLASS_NAME $1 | grep "(" | grep -v "~" | grep -v "delete" | cut -d "(" -f 2 | cut -d ")" -f 1 | tr -d "\n" )
#Get the name the class was inherited from
INHERITED_NAME=$( grep $CLASS_NAME $1 | grep -w "class" | grep -v "\/\/\|\/\*"| sed "s/::/ /g" | cut -d ":" -f 2 | rev | cut -d " " -f 1 | rev | tr -d "\n" | tr -d "\r" )

#Print out the Constructor definition to the .cpp file dependent on inheritance status
if [[ $INHERITED_NAME = "" ]]
then
    echo "$CLASS_NAME::$CLASS_NAME ($CONSTRUCTOR_PARAMS) : " >> $OUTPUT_FILE
    echo "    $INHERITED_NAME()," >> $OUTPUT_FILE
else
    echo "$CLASS_NAME::$CLASS_NAME ($CONSTRUCTOR_PARAMS)," >> $OUTPUT_FILE
fi

#Constructor Banner echoed to terminal: Used for debugging.
###echo "***********************CONSTRUCTOR******************************"
#Find Ints
#Ints Banner echoed to terminal: Used for debugging.
###echo "--------------INTS----------------"
INT_VARIABLES=($(grep -w "int" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
###grep -w "int" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0;/g"
INT_ARRAYS=($(grep -w "int" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
###grep -w "int" $1 | sed "s/  //g" | grep "\[" | grep -v 'volatile\|unsigned\|typedef' | cut -d " " -f 2
###echo "Int array size: ${#INT_VARIABLES[@]}"

#Print a comment line to .cpp file
echo "    //ints" >> $OUTPUT_FILE

#Initialize variables for Int and Int Arrays in .cpp file
for i in "${INT_VARIABLES[@]}"
do
    if [[ $i = "" ]] 
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi 
done
for i in "${INT_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0})," >> $OUTPUT_FILE 
    fi 
done

#Find Unsigned Ints
#Unsigned Ints Banner echoed to terminal: Used for debugging.
###echo "----------UNSIGNED INTS-----------"

#Get Unsigned Int and Unsigned Int Arrays
UNSIGNED_INT_VARIABLES=($(grep -w "unsigned int" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
###grep -w "unsigned int" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"
UNSIGNED_INT_ARRAYS=($(grep -w "unsigned int" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 3 | tr -d ";" | tr -d "\n" | tr -d "\r"))
###grep -w "unsigned int" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 3

#Print a comment line to .cpp file
echo "    //Unsigned Ints" >> $OUTPUT_FILE

#Initialize variables for Unsigned Int and Unsigned Int Arrays in .cpp file
for i in "${UNSIGNED_INT_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi 
done
for i in "${UNSIGNED_INT_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0})," >> $OUTPUT_FILE 
    fi 
done


#Find Volatile Ints
#Volatile Ints Banner printed to the terminal: Used for debugging.
###echo "----------VOLATILE INTS-----------"
VOLATILE_INT_VARIABLES=($(grep -w "volatile int" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
###grep -w "volatile int" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"
VOLATILE_INT_ARRAYS=$(grep -w "volatile int" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v "(" | grep "\[" | cut -d " " -f 3 | tr -d ";" | tr -d "\n" | tr -d "\r" )
###grep -w "volatile int" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v "(" | grep "\[" | cut -d " " -f 3

#Print a comment line to .cpp file
echo "    //Volatile Ints" >> $OUTPUT_FILE

#Initialize variables for Volatile Int and Volatile Int Arrays in .cpp file
for i in "${VOLATILE_INT_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi 
done
for i in "${VOLATILE_INT_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi 
done



#Find Shorts
#Shorts banner printed to terminal: used for debugging.
###echo "--------------SHORTS--------------"

#Get Short and Short Array Variables
SHORT_VARIABLES=($(grep -w "short" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
###grep -w "short" $1 | grep -v 'volatile\|unsigned\|typedef'  | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0;/g"
SHORT_ARRAYS=($(grep -w "short" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r" ))
###grep -w "short" $1 | sed "s/  //g" | grep "\[" | cut -d " " -f 2

#Print comment line to .cpp file
echo "    //Shorts" >> $OUTPUT_FILE

#Initialize variables for Short and Short Arrays in .cpp file
for i in "${SHORT_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi 
done
for i in "${SHORT_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0})," >> $OUTPUT_FILE 
    fi 
done


#Find Unsigned Shorts
#Unsigned Shorts Banner Printed to Terminal: Used for Debugging
###echo "---------UNSIGNED SHORTS----------"

#Get Unsigned Short and Unsigned Short Array Variables
UNSIGNED_SHORT_VARIABLES=($(grep -w "unsigned short" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
###grep -w "unsigned short" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"
UNSIGNED_SHORT_ARRAYS=$(grep -w "unsigned short" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep "\[" | cut -d " " -f 3 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r" )
###grep -w "unsigned short" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep "\[" | cut -d " " -f 3 

#Print comment line to .cpp file
echo "    //Unsigned Shorts" >> $OUTPUT_FILE

#Initialize variables for Unsigned Short and Unsigned Short Arrays in .cpp file
for i in "${UNSIGNED_SHORT_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi 
done
for i in "${UNSIGNED_SHORT_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0})," >> $OUTPUT_FILE 
    fi 
done
#Find Volatile Shorts
#Volatile Shorts Banner Printed to Terminal: Used for Debugging
###echo "---------VOLATILE SHORTS----------"
VOLATILE_SHORT_VARIABLES=($(grep -w "volatile short" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
###grep -w "volatile short" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"

#Print Comment line to .cpp file
echo "    //Volatile Shorts" >> $OUTPUT_FILE

#Initialize variables for Volatile Short and Volatile Short Arrays in .cpp file
for i in "${VOLATILE_SHORT_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi
done


#Find Longs
#Longs Banner Printed to the Terminal: Used For Debugging.
###echo "--------------LONGS---------------"
LONG_VARIABLES=($(grep -w "long" $1 | grep -v 'volatile\|unsigned\|typedef' | grep -v "long long" | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
LONG_ARRAYS=($(grep -w "long" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r" ))
###grep -w "long" $1 | grep -v 'volatile\|unsigned\|typedef' | grep -v "long long"  | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0;/g"

#Print comment line to .cpp file
echo "    //Longs" >> $OUTPUT_FILE

#Initialize variables for Long and Long Arrays in .cpp file
for i in "${LONG_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi
done
for i in "${LONG_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0})," >> $OUTPUT_FILE 
    fi
done


#Find Unsigned Longs 
#Unsigned Longs Banner Printed to Terminal: Used for Debugging 
###echo "----------UNSIGNED LONGS----------"
UNSIGNED_LONG_VARIABLES=($(grep -w "unsigned long" $1 | grep -v 'volatile\|typedef' | grep -v "long long" | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
UNSIGNED_LONG_ARRAYS=($(grep -w "unsigned long" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r" ))
###grep -w "unsigned long" $1 | grep -v 'volatile\|typedef' | grep -v "long long" | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"

#Print Comment Line to .cpp File
echo "    //Unsigned Longs" >> $OUTPUT_FILE

#Initialize variables for Unsigned Long and Unsigned Long Arrays in .cpp file
for i in "${UNSIGNED_LONG_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi
done
for i in "${UNSIGNED_LONG_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0})," >> $OUTPUT_FILE 
    fi
done


#Find Volatile Longs
#Volatile Longs banner printed to terminal: Used for debugging
###echo "----------VOLATILE LONGS----------"

#Get Volatile Long and Volatile Long Arrays
VOLATILE_LONG_VARIABLES=($(grep -w "volatile long" $1 | grep -v 'typedef' | grep -v "long long" | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
VOLATILE_LONG_ARRAYS=($(grep -w "volatile long" $1 | grep -v 'unsigned\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r" ))
###grep -w "volatile long" $1 | grep -v 'typedef' | grep -v "long long" | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"

#Print a Comment Line to .cpp file
echo "    //Volatile Longs" >> $OUTPUT_FILE
#Initialize variables for Volatile Long and Volatile Long Arrays in .cpp file
for i in "${VOLATILE_LONG_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi
done
for i in "${VOLATILE_LONG_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0})," >> $OUTPUT_FILE 
    fi
done


#Find Long Longs
#Long Longs banner printed to terminal: Used for debugging
###echo "-----------LONG LONGS-------------"

#Get Long Long and Long Long Array Variables
LONG_LONG_VARIABLES=($(grep -w "long long" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
LONG_LONG_ARRAYS=($(grep -w "long long" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r" ))
###grep -w "long long" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = 0;/g"


#Print Comment Line to .cpp file
echo "    //Long Longs" >> $OUTPUT_FILE

#Initialize variables for Long Long and Long Long Arrays in .cpp file
for i in "${LONG_LONG_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi
done
for i in "${LONG_LONG_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0})," >> $OUTPUT_FILE 
    fi
done


#Find Unsigned Long Longs
#Unsigned long longs banner printed to terminal: Used for debugging
###echo "-------UNSIGNED LONG LONGS--------"

#Get Unsigned Long Long and Unsigned Long Long Array variables
UNSIGNED_LONG_LONG_VARIABLES=($(grep -w "unsigned long long" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 4 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
UNSIGNED_LONG_LONG_ARRAYS=($(grep -w "unsigned long long" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r" ))
###grep -w "unsigned long long" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 4 | sed "s/;/ = 0;/g"

#Print comment line to .cpp file
echo "    //Unsigned Long Longs" >> $OUTPUT_FILE

#Initialize variables for Unsigned Long Long and Unsigned Long Long Arrays in .cpp file
for i in "${UNSIGNED_LONG_LONG_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi 
done
for i in "${UNSIGNED_LONG_LONG_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0})," >> $OUTPUT_FILE 
    fi 
done


#Find Ulongs
#Ulongs banner printed to terminal: Used for debugging
###echo "-------------ULONGS---------------"
ULONG_VARIABLES=($(grep -w "ulong" $1 | grep -v 'volatile\|unsigned\|typedef' | grep -v "long long" | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
ULONG_ARRAYS=($(grep -w "ulong" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r" ))
###grep -w "ulong" $1 | grep -v 'volatile\|unsigned\|typedef' | grep -v "long long"  | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0;/g"

#Print comment line to .cpp file
echo "    //Ulongs" >> $OUTPUT_FILE

#Initialize variables for Unsigned Long Long and Unsigned Long Long Arrays in .cpp file
for i in "${ULONG_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi 
done
for i in "${ULONG_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0})," >> $OUTPUT_FILE 
    fi 
done


#Find Chars
#Chars banner printed to terminal: Used for debugging
###echo "--------------CHARS---------------"

#Get Char and Char Array Variables
CHAR_VARIABLES=($(grep -w "char" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
###grep -w "char" $1 | grep -v 'volatile\|unsigned\|typedef'  | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = \'\';/g"
CHAR_ARRAYS=($(grep -w "char" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r"))
###grep -w "char" $1 | grep -v 'volatile\|unsigned\|typedef' |sed "s/  //g" | grep "\[" | cut -d " " -f 2

#Print comment line to .cpp file
echo "    //Chars" >> $OUTPUT_FILE

#Initialize variables for Char and Char Arrays in .cpp file
for i in "${CHAR_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i('\0')," >> $OUTPUT_FILE 
    fi 
done
for i in "${CHAR_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({'\0'})," >> $OUTPUT_FILE 
    fi
done


#Find Unsigned Chars
#Unsigned Char Banner printed to terminal: Used for debugging
###echo "----------UNSIGNED CHARS----------"

#Get Unsigned Char and Unsigned Char Array Variables
UNSIGNED_CHAR_VARIABLES=($(grep -w "unsigned char" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
###grep -w "unsigned char" $1 | grep -v 'volatile\|typedef'  | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 3 | sed "s/;/ = \'\';/g"
UNSIGNED_CHAR_ARRAYS=($(grep -w "unsigned char" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 3 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r" ))
###grep -w "unsigned char" $1 | grep -v 'volatile\|typedef' |sed "s/  //g" | grep "\[" | cut -d " " -f 3


#Print Comment Line to .cpp file
echo "    //Unsigned Chars" >> $OUTPUT_FILE

#Initialize variables for Unsigned Char and Unsigned Char Arrays in .cpp file
for i in "${UNSIGNED_CHAR_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi 
done
for i in "${UNSIGNED_CHAR_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0})," >> $OUTPUT_FILE 
    fi
done


#Find Strings
#Strings banner printed to terminal: Used for debugging
###echo "-------------STRINGS--------------"

#Get String and String Array Variables
STRING_VARIABLES=($(grep -w "string" $1 | grep -v 'typedef' | sed "s/  //g" | grep -v '(\|<' | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
STRING_ARRAYS=($(grep -w "string" $1 | grep -v 'volatile\|unsigned\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r"))
###grep -w "string" $1 | sed "s/  //g" | grep -v '(\|<' | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = \"\";/g"

#Print Comment line to .cpp file
echo "    //Strings" >> $OUTPUT_FILE

#Initialize variables for String and String Arrays in .cpp file
for i in "${STRING_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(\"\")," >> $OUTPUT_FILE 
    fi 
done
for i in "${STRING_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({\"\"})," >> $OUTPUT_FILE 
    fi 
done


#Find Floats
#Floats banner line printed to terminal: Used for debugging
###echo "--------------FLOATS--------------"

#Get Float and Float Array Variables from header File
FLOAT_VARIABLES=($(grep -w "float" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
FLOAT_ARRAYS=($(grep -w "float" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r"))
###grep -w "float" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0.0;/g"

#Print comment line in .cpp file
echo "    //Floats" >> $OUTPUT_FILE

#Initialize variables for Float and Float Arrays in .cpp file
for i in "${FLOAT_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0.0)," >> $OUTPUT_FILE 
    fi
done
for i in "${FLOAT_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0.0})," >> $OUTPUT_FILE 
    fi
done


#Find Doubles
#Doubles banner printed to terminal: Used for Debugging
###echo "-------------DOUBLES--------------"

#Get Double and Double Array Variables from header file
DOUBLE_VARIABLES=($(grep -w "double" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr -d "\n" | tr -d "\r" ))
DOUBLE_ARRAYS=($(grep -w "double" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r"))
###grep -w "double" $1 | grep -v 'volatile\|typedef' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0.0;/g"

#Print Comment line to .cpp file
echo "    //Doubles" >> $OUTPUT_FILE

#Initialize variables for Doubles and Double Arrays in .cpp file
for i in "${DOUBLE_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0.0)," >> $OUTPUT_FILE 
    fi 
done
for i in "${DOUBLE_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0.0})," >> $OUTPUT_FILE 
    fi 
done


#Find Bools
#Bool Banner printed to terminal: Used for debugging
###echo "--------------BOOLS---------------"

#Get Bool and Bool array variables from header file
BOOL_VARIABLES=($(grep "bool" $1 | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr -d "\n" | tr -d "\r" )) 
###grep "bool" $1 | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = false;/g"
BOOL_ARRAYS=($(grep "bool" $1 | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r" ))
###grep "bool" $1 | sed "s/  //g" | grep "\[" | cut -d " " -f 2

#Print Comment line to .cpp file
echo "    //bools" >> $OUTPUT_FILE
#Initialize variables for bool and bool arrays in .cpp file
for i in "${BOOL_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(false)," >> $OUTPUT_FILE 
    fi 
done
for i in "${BOOL_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({false})," >> $OUTPUT_FILE 
    fi
done


#Find Unsigneds
#Unsigned banner printed to terminal: Used for Debugging
###echo "-----------UNSIGNEDS--------------"

#Get Unsigned and Unsigned Variables (expicitly "Unsigned") from header file
UNSIGNED_VARIABLES=($(grep "unsigned" $1 | grep -v 'int\|char\|bool\|short\|long' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | tr -d ";" | tr -d "\n" | tr -d "\r" )) 
###grep "unsigned" $1 | grep -v 'int\|char\|bool\|short\|long' | sed "s/  //g" | grep -v "(" | grep -v "\[" | cut -d " " -f 2 | sed "s/;/ = 0;/g"
UNSIGNED_ARRAYS=($(grep "unsigned" $1 | grep -v 'int\|char\|bool\|short\|long' | sed "s/  //g" | grep "\[" | cut -d " " -f 2 | tr -d ";" | cut -d "[" -f 1 | tr -d "\n" | tr -d "\r" ))
###grep "unsigned" $1 | grep -v 'int\|char\|bool\|short\|long' | sed "s/  //g" | grep -v "(" | grep "\[" | cut -d " " -f 2 
###echo "Unsigned Array Size: ${#UNSIGNED_VARIABLES[@]}"

#Print comment line to .cpp file
echo "    //unsigned" >> $OUTPUT_FILE

#Initialize variables for unsigned and unsigned arrays in .cpp file
for i in "${UNSIGNED_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(0)," >> $OUTPUT_FILE 
    fi 
done
for i in "${UNSIGNED_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({0})," >> $OUTPUT_FILE 
    fi
done

#Find Pointers
#Pointers banner printed to terminal: Used for debugging
###echo "-------------POINTERS--------------"

#Get Pointer and Pointer array variables from header file
POINTER_VARIABLES=($(grep -E "[A-Za-z]\*" $1 | grep -v "typedef" | sed "s/  //g" | grep -v "(" | grep -v "\[" | rev | cut -d " " -f 1 | rev | tr -d ";" | tr -d "\n" | tr -d "\r" ))
POINTER_ARRAYS=($(grep -E "[A-Za-z]\*" $1 | grep -v "typedef" | sed "s/  //g" | grep -v "(" | grep "\[" | rev | cut -d " " -f 1 | rev | tr -d ";" | tr -d "\n" | tr -d "\r" ))
###grep -E "[A-Za-z]\*" $1 | grep -v "typedef" | sed "s/  //g" | grep -v "(" | grep -v "\[" | rev | cut -d " " -f 1 | rev | sed "s/;/ = NULL;/g" 
###echo "Array Length Size: ${#POINTER_VARIABLES[@]}"

#Print Comment line to .cpp file
echo "    //pointers" >> $OUTPUT_FILE

#Initialize any pointers to NULL in .cpp file
for i in "${POINTER_VARIABLES[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i(NULL)," >> $OUTPUT_FILE 
    fi
done
for i in "${POINTER_ARRAYS[@]}"
do
    if [[ $i = "" ]]
    then
        :
    else
        echo "    $i({NULL})," >> $OUTPUT_FILE 
    fi
done

#Typedefs
#Typedefs banner printed to terminal: Used for debugging
###echo "-------------TYPEDEFS--------------"

#Get Typedef variables from header file
TYPEDEF_VARIABLES=($(grep "typedef" $1 | grep -v "struct\|\/" | sed "s/  //g" | grep -v "(" | grep -v "\[" | rev | cut -d " " -f 1 | rev )) 

#Print comment line to .cpp file
echo "    //typedef" >> $OUTPUT_FILE

#Initialize any typedef variables in .cpp file
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
cat >> $OUTPUT_FILE << EOF
{

}
EOF


#Add a buffer line or two to the .cpp file
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
EOF

#Make the Destructor definition
echo "$CLASS_NAME::~$CLASS_NAME () {" >> $OUTPUT_FILE
#Add a comment line to .cpp file explaining the Nullification of the pointers
echo "//Deleting Pointer Variables, setting them to NULL" >> $OUTPUT_FILE

#For each pointer, add this if/else statement nullifying and deleting pointers.
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

#Close Destructor
echo "}" >> $OUTPUT_FILE

#Write Functions Banner
cat >> $OUTPUT_FILE << EOF


/*----------------------------------------------------------------------*/
/*------------------------------ FUNCTIONS -----------------------------*/
/*----------------------------------------------------------------------*/
EOF
cat << EOF

***********************FUNCTIONS********************************
EOF

#Get the list of functions with their parameters
FUNCTIONS_LIST=$(grep -wE ".*\(.*\)" $1 | sed "s/  //g" | grep -v "~\|operator\|$CLASS_NAME\|{" | sed "s/(/ (/g" | sed "s/  (/ (/g" | sed "s/;/ {}\\n\\n${BUFFERLINE}\n${BUFFERLINE}/g" )
#Get the Function names themselves
FUNCTION_NAMES=($(grep -wE ".*\(.*\)" $1 | sed "s/  //g" | grep -v "~\|operator\|$CLASS_NAME\|{" | sed "s/unsigned //g" | sed "s/const //g" | sed "s/(/ (/g" | cut -d " " -f 2 | tr "\n" " " | tr -d "\r" ))
#This grep is printing out to the terminal: Used for debugging
###grep "(" $1 | sed "s/  //g" | grep -v "~\|operator\|$CLASS_NAME\|{" 
###echo "Functions List Array Size: ${#FUNCTIONS_LIST[@]}"

#Print out the functions to the .cpp file.
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


#Add the Class name in for formatting purposes
for i in "${FUNCTION_NAMES[@]}"
do
EXISTING_FORMAT=$(grep -c "$CLASS_NAME::$i" $OUTPUT_FILE)
    if [[ $EXISTING_FORMAT -gt 0 ]]
    then
       :
    else 
        if [[ $i = "" ]]
        then
            :
        else
            sed -i "s/$i/$CLASS_NAME::$i/g" $OUTPUT_FILE
        fi 
    fi
done

cat >> $OUTPUT_FILE << EOF

/*----------------------------------------------------------------------*/
/*------------------------------ OPERATORS -----------------------------*/
/*----------------------------------------------------------------------*/
// I haven't gotten to testing on operators yet, leave this for the future
EOF

#Add Templates Banner
cat >> $OUTPUT_FILE << EOF


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

#Close Namespace brackets
for i in "${usings_array_reverse[@]}"
do
    echo "} //end namespace $i" >> $OUTPUT_FILE
done



#Create Footer Buffer, dependent on search results from header file.
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
