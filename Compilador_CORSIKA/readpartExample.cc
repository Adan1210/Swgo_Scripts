#include "readPart_1_7b.h"
#include <vector>
#include <iostream>
#include <fstream>
#include <math.h>
#include <string>
#include <sstream>
#include "TVector2.h"
#include "TROOT.h"
#include "TSystem.h"
#include "TStyle.h"
#include "TH1F.h"
#include "TH2F.h"
#include "TMultiGraph.h"
#include "TGraphErrors.h"
#include "TMarker.h"
#include "TGraph.h"
#include "TProfile.h"
#include "TCanvas.h"
#include "TCut.h"
#include "TLatex.h"
#include "TColor.h"

using namespace std; 

int main (){

 
 corsikafile file("DAT000001");

 while (file.findnextrun())
    {
     run theRun=file.getnextrun();
      cout << "Type" << "\t" << "Eventnum" << "\t" << "Weight" << "\t" << "R_m" << "\t" <<"X_m"<< "\t" <<"Y_m"<< "\t" << "Zdeca_cm" <<"\t" <<"Zstart_cm" <<"\t"<<"T_ns"<<"\t"<< "Obslev_cm"<<"\t"<<"Px_GeV/c" << "\t" <<"Py_GeV/c)" << "\t" <<"Pz_GeV/c" << "\t" << "P_eV/c" << "\t" << "Energy" << "\t" << "primTheta"<<"\t"<<"primPhi"<<endl;
      while (theRun.findnextevent())
	{
	  event theEvent=theRun.getnextevent();
	  //theEvent.primtype gives primary particle type. other quantities available are primpx,primpy,primpz,primtheta,primphi,primenergy,primintz
	  while (theEvent.findnextparticle())
	    {
	     particle theParticle=theEvent.getnextparticle();
	     cout << theParticle.type <<"\t" << theEvent.eventnum << "\t" << theParticle.weight << "\t" << theParticle.r  << "\t" <<theParticle.x <<"\t"<< theParticle.y << "\t" << theParticle.z <<"\t"<< theParticle.zstart << "\t"<< theParticle.t <<"\t"<< theParticle.obslev<<"\t"<<theParticle.px << "\t" << theParticle.py << "\t" << theParticle.pz << "\t" << theParticle.p << "\t" << theParticle.energy << "\t" << theParticle.primtheta <<"\t"<<theParticle.primphi<<"\n";
	     
	     //e.g. theParticle.type would give particle type. other quantities:
	     ///px,py,pz in GeV/c, p in eV/c ,x,y in cm, 
	     ////t is arrival time of particle at ground in ns since 1st interaction. 
	     /// Energy is KE in eV. 
	     /// muz is production height in cm (muons with add. info)
	     /// hadgen is hadronic generation. 
	     /// obslev is the observation level Follolwing is only for muons with additional info: for muon at ground type is 75 (mu+) or 76(mu-).  
	     ///for decayed muon, type is 85 or 86. in this case, there is no t. 
	     ///z is height at decay in cm. 
	     ///Decayed muons also have a fate index mufate. 
	     ///1 is decay, 2 is fatal nuclear intercation, 3 is drop below energy threshold or angular cut 
	     
	     ///////////////////////////////////////////////////////////
	     ///ppx... , ptype, Px, Py is info on parent particle.
	     /// pzint is parent production height
	     //////////////////////////////////////////////////////////
	     ///gp... is info on grandparent particle
	     ///mu... is info on the muon at its production point
	     ////////////////////////////////////////////////////////////
	     ///types 1=photon, 2=e+, 3=e-, 5=mu+, 6=mu-, 7=pi0, 8=pi+, 
	     ///9=pi-, 10=K0, 11=K+, 12=K-, 13=n, 14=proton, 15=antip
	     ///bigger numbers are exotic hadrons
	     ///////////////////////////////////////////////////////////

	     //probably useful quantities:
	     //theParticle.weight
	     // theParticle.x
	     //  theParticle.obslev
	     //theParticle.type
	     // if (theParticle.type==2 || theParticle.type==3 || theParticle.type==5 || theParticle.type==6 || theParticle.type==8 || theParticle.type==9 || theParticle.type==11 || theParticle.type==12 || theParticle.type==14 || theParticle.type==15)// charged paricles
	     //theEvent.primenergy//in GeV
	     //theEvent.primtheta//primary zenith angle
	     //theEvent.primphi//primary azimuth
	     // theEvent.primtype//p=14, gamma=1 Fe=5626
	     // theRun.nobslevels//number of obslevels
	     //theRun.OBSLEVELS[i]//height of ith obslev in cm (i starts at 0)

       	 //  useful functions:
	     // theRun.getdepth(height);//gets vertical depth for a given height in cm
	     // theRun.getheight(depth);


	    }//particle loop
	  theEvent.readevte();//must be after particle info read
	  ////theEvent.gh3 //Xmax. must be after readevte
	}//event loop
    }//run loop
}
