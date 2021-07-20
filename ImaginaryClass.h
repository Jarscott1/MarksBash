/*----------------------------------------------------------------------*/
/*---------------------------- UNCLASSIFIED ----------------------------*/
/*----------------------------------------------------------------------*/

// Probably a huge change log up here, for whatever reason
// Might be a class description up here as well
// A, B, C, and D are namespaces for the class ImaginaryClass

#ifndef A_B_C_D_ImaginaryClass
#define A_B_C_D_ImaginaryClass


#include <include1.h>
#include <include2.h>
#include <string>

#include "projectHeader1.h"
#include "projectHeader2.h"
#include "projectHeader3.h"


class CircularDependency1;
class CircularDependency2;
class CircularDependency3;


// This is the class definition of the file. It inherits public and protected
// members of DefinitelyRealSuper. A, B, C, and D are namespaces for both ImaginaryClass
// and DefinitelyRealSuper
class A::B::C::D::ImaginaryClass : protected A::B::C::D::DefinitelyRealSuper
{

  public :
    typedef int* INT_PTR;
    typedef double* DOUBLE_PTR;

    typedef struct_t
    {
      bool operator() { return (a == b); }
    } SomeNonsenseStructWhyIsItEvenHere;

    bool myBool;
    char myChar;
    short myShort;
    unsigned myUnsigned;
    unsigned char myUnsignedChar;
    unsigned short myUnsignedShort;
    unsigned int myUnsignedInt;
    unsigned long myUnsignedLong;
    volatile int myInt;
    float myFloat;
    double myDouble;
    ulong myULong;
    long myLong;
    std::string myString;
    OTHERCLASS myObject;
    OTHERCLASS* myPointer;
    OTHERCLASS& myReference;
    bool myBoolArray[20];
    char myCharArray[20];
    short myShortArray[20];
    unsigned myUnsignedArray[20];
    //in my case I had a list of 60ish variables, of all different types

    ImaginaryClass(OTHERCLASS* pointer);
    ~ImaginaryClass();

    bool changeObjectName (const std::string identifier);
    double changeObjectValue(const double& newValue, int valueWeWontUse);
    const std::string& getObjectName() const;
    const double& getObjectValue () const;
    //in my case I had a list of 60ish functions here


  protected :
    //typedefs


    //internal structs/classes


    //variables


    //constructors/destructor


    //functions


  private :
    //typedefs


    //internal structs/classes


    //variables


    //constructors/destructor
    ImaginaryClass(const ImaginaryClass &other) = delete;
    ImaginaryClass(const ImaginaryClass &&other) = delete;

    //functions


}


#endif
/*----------------------------------------------------------------------*/
/*---------------------------- UNCLASSIFIED ----------------------------*/
/*----------------------------------------------------------------------*/
