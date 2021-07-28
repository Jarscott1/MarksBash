/*----------------------------------------------------------------------*/
/*---------------------------- UNCLASSIFIED ----------------------------*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/*----------------------------- DESCRIPTION ----------------------------*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/*------------------------------ INCLUDES ------------------------------*/
/*----------------------------------------------------------------------*/
#include "ImaginaryClass.h"


/*----------------------------------------------------------------------*/
/*------------------------ FORWARD DECLARATIONS ------------------------*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/*------------------------------- USINGS -------------------------------*/
/*----------------------------------------------------------------------*/
using namespace std;
namespace A {
namespace B {
namespace C {
namespace D {


/*----------------------------------------------------------------------*/
/*-------------------------- GLOBAL VARIABLES --------------------------*/
/*----------------------------------------------------------------------*/


/*----------------------------------------------------------------------*/
/*----------------------- CONSTRUCTOR/DESTRUCTOR -----------------------*/
/*----------------------------------------------------------------------*/
ImaginaryClass::ImaginaryClass (OTHERCLASS* pointer) : 
    DefinitelyRealSuper(),
    //ints
    //Unsigned Ints
    myUnsignedInt(0),
    //Volatile Ints
    myInt(0),
    //Shorts
    myShort(0),
    myShortArray({0}),
    //Unsigned Shorts
    myUnsignedShort(0),
    //Volatile Shorts
    //Longs
    myLong(0),
    //Unsigned Longs
    myUnsignedLong(0),
    //Volatile Longs
    //Long Longs
    //Unsigned Long Longs
    //Ulongs
    myULong(0),
    //Chars
    myChar('\0'),
    myCharArray({'\0'}),
    //Unsigned Chars
    myUnsignedChar(0),
    //Strings
    myString(""),
    //Floats
    myFloat(0.0),
    //Doubles
    myDouble(0.0),
    //bools
    myBool(false),
    myBoolArray({false}),
    //unsigned
    myUnsigned(0),
    myUnsignedArray({0}),
    myPointer(NULL),
{

}


/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
ImaginaryClass::~ImaginaryClass () {
//Deleting Pointer Variables, setting them to NULL
    if (myPointer != NULL) { delete myPointer; }
    myPointer = NULL;
}


/*----------------------------------------------------------------------*/
/*------------------------------ FUNCTIONS -----------------------------*/
/*----------------------------------------------------------------------*/
bool ImaginaryClass::changeObjectName (const std::string identifier) {}

/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
double ImaginaryClass::changeObjectValue (const double& newValue, int valueWeWontUse) {}

/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
const std::string& ImaginaryClass::getObjectName () const {}

/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/
const double& ImaginaryClass::getObjectValue () const {}

/*----------------------------------------------------------------------*/
/*----------------------------------------------------------------------*/

/*----------------------------------------------------------------------*/
/*------------------------------ OPERATORS -----------------------------*/
/*----------------------------------------------------------------------*/
// I haven't gotten to testing on operators yet, leave this for the future


/*----------------------------------------------------------------------*/
/*------------------------------ TEMPLATES -----------------------------*/
/*----------------------------------------------------------------------*/
// I haven't gotten to testing on templates yet, leave this for the future


/*----------------------------------------------------------------------*/
/*------------------------- CLOSING NAMESPACES -------------------------*/
/*----------------------------------------------------------------------*/
} //end namespace D
} //end namespace C
} //end namespace B
} //end namespace A


/*----------------------------------------------------------------------*/
/*---------------------------- UNCLASSIFIED ----------------------------*/
/*----------------------------------------------------------------------*/


