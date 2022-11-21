#include <vector>
#include <iostream>
#include <fstream>
#include <math.h>
#include <string>
#include <sstream>

using namespace std; //don't forget this!
const double kPi=3.14159265359;
const double eV=1.60217646E-19;
const double c=2.997924580E+08;
const double Me=5.10998928E+05;
const double Mmu=1.0565837E+08;
const double Mp=9.38272046E+08;
const double Mn=9.39565378E+08;
const double Mpi=1.3957018E+08;
const double Mpi0=1.349766E+08;
const double Mk=493.667000E+08;
const double Mk0=497.64800E+08;
const double Mhad=4.000000E+09; ///assumed mass for other hadrons. theres like 100 of them and im too fucking lazy to code for all of them

/* //for part files that are already a text file
class fileinfo {
  ifstream fin;
  double crap;
public:
  fileinfo(string filename) { fin.open(filename.c_str()); }
  double getnextnumber(void);
  double getcurrentnumber(void); 
  bool iseof(void);
};

double fileinfo::getnextnumber(void)
{
  fin >> crap;
  return crap;
}
double fileinfo::getcurrentnumber(void)
{
  return crap;
}
bool fileinfo::iseof(void)
{
  return fin.eof();
}
*/


class fileinfo {                                                                
  ifstream fin;                                                                 
  double crap;                                             
  int i;                                                                        
  char *crapdata;//=new char[4];                    
  float *floatdata;//=new float[6552];                                          
 public:       
  fileinfo(string filename); //{ fin.open(filename.c_str(), ios::in | ios::binary)}                                                                            
  double getnextnumber(void);                                                   
  double getcurrentnumber(void);
  double getnextblock(void);
  double getcurrentblock(void);
  bool iseof(void);
};                                                                              
                                                                                
fileinfo::fileinfo(string filename)                                             
{                                                                               
  crapdata=new char[4];                                                         
  floatdata=new float[6552];                                                    
  fin.open(filename.c_str(), ios::in | ios::binary);                            
  i=0;                                                                          
  fin.read(crapdata,4);                                                         
  fin.read((char*)floatdata,6552*4);                                            
  fin.read(crapdata,4);                                                         
}                                                                               
                                                                                
                                                                                
double fileinfo::getnextnumber(void)                                            
{                                                                               
  if (i<6552)                                                                   
    {                                                                           
      crap=floatdata[i];                                                        
      i+=1;                                                                     
    }                                                                           
  else                                                                          
    {                                                                           
      //      cout << endl << "  new block  ";
      fin.read(crapdata,4);
      fin.read((char*)floatdata,6552*4);
      fin.read(crapdata,4);                                                     
      crap=floatdata[0];                                                        
      i=1;                                                                      
    }                                                                           
  return crap;                                                                  
}                                                                               
double fileinfo::getcurrentnumber(void)                                         
{                                                                               
  return crap;                                                                  
}    
double fileinfo::getnextblock(void)                                            
{  
  i=i-i%312+312;
  if (i<6552)                                                                   
    {                                                                           
      crap=floatdata[i];                                                        
      i+=1;                                                                     
    }                                                                           
  else                                                                          
    {                                                                           
      //      cout << endl << "  new block  ";
      fin.read(crapdata,4);
      fin.read((char*)floatdata,6552*4);
      fin.read(crapdata,4);                                                     
      crap=floatdata[0];                                                        
      i=1;                                                                      
    }                                                                           
  return crap;                                                                  
}                                                                               
double fileinfo::getcurrentblock(void)                                         
{
  return (double)(floatdata[i-i%312]);
}
                                                                        
bool fileinfo::iseof(void)                                                      
{                                                                               
  return fin.eof();                                                             
}                                                                               
  
