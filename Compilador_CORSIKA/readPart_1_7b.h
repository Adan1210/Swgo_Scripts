#include <vector>
#include <iostream>
#include <fstream>
#include <math.h>
#include <string>
#include <sstream>
#include "corsikaFile.h"

using namespace std;



class particle{
  fileinfo* file;
public:
  double description,p,energy,px,py,pz,x,y,z,r,t,weight,primtheta,primphi,zstart;//data for each particle
  double pp,penergy,ppx,ppy,ppz,Px,Py,pzint,pweight;//data for each parent particle
  double gpp,gpenergy,gppx,gppy,gppz,gpx,gpy,gpz,gpweight;//data for each grandparent particle
  double mup,muenergy,mupx,mupy,mupz,mux,muy,muz,muweight;//data for each muon initial particle
  int type,hadgen,obslev,mufate;
  int ptype,gptype;
  bool isdethinned;
  particle(fileinfo*,double,double,double);
  particle(void);
};

class event {
  double crap;
  fileinfo* file;
public:
double primpx,primpy,primpz,primtheta,primphi,primenergy,thinhad,thinem,wmaxhad,wmaxem,thinradius,muhist,primintz,zstart,gh1,gh2,gh3,gh4,gh5,gh6;
 int primtype,eventnum,runnum;
  event(fileinfo*);
  event (void);
  bool findnextparticle(void);
  particle getnextparticle(void);
  bool readevte(void);
};

class run {
  double crap;
  fileinfo* file;
public:
  int nobslevels;
  double OBSLEVELS[10];
  double h1,h2,h3,h4,h5,a1,a2,a3,a4,a5,b1,b2,b3,b4,b5,c1,c2,c3,c4,c5;//atmospheric parameters
  run(fileinfo*);
  run (void);
  double getdepth(double);
  double getheight(double);
  bool findnextevent(void);
  event getnextevent(void);
};

class corsikafile {
 private:
  double crap;
  fileinfo file;
 public:
 corsikafile(string filename) : file (filename) {}
  bool findnextrun(void);
  run getnextrun(void);
};


run::run (fileinfo* thefile)
{

  file=thefile;
  for (int i=1; i<=3;i++)//run header
    {
      crap=file->getnextnumber();
    }



  nobslevels=(int)(file->getnextnumber()+0.5);
  for (int i=0;i<10;i++)
    {
      OBSLEVELS[i]=file->getnextnumber();
    }



  for (int i=1; i<=234;i++)
    {
      crap=file->getnextnumber();
    }



  h1=file->getnextnumber();
  h2=file->getnextnumber();
  h3=file->getnextnumber();
  h4=file->getnextnumber();
  h5=file->getnextnumber();
  a1=file->getnextnumber();
  a2=file->getnextnumber();
  a3=file->getnextnumber();
  a4=file->getnextnumber();
  a5=file->getnextnumber();
  b1=file->getnextnumber();
  b2=file->getnextnumber();
  b3=file->getnextnumber();
  b4=file->getnextnumber();
  b5=file->getnextnumber();
  c1=file->getnextnumber();
  c2=file->getnextnumber();
  c3=file->getnextnumber();
  c4=file->getnextnumber();
  c5=file->getnextnumber();
}
event::event (fileinfo* thefile)
{
  file=thefile;
  crap=file->getnextnumber();
  eventnum=(int)(crap+0.5);
  crap=file->getnextnumber();
  primtype=(int)(crap+0.5);
  primenergy=file->getnextnumber();

  for (int i=1; i<=2;i++)//
    {
      crap=file->getnextnumber();
    }
  primintz=file->getnextnumber();
  primpx=file->getnextnumber();
  primpy=file->getnextnumber();
  primpz=file->getnextnumber();
  primtheta=file->getnextnumber();
  primphi=file->getnextnumber();


  for (int i=1; i<=31;i++)//
    {
      crap=file->getnextnumber();
    }
  crap=file->getnextnumber();
  runnum=(int)(crap+0.5);

  for (int i=1; i<=103;i++)//
    {
      crap=file->getnextnumber();
    }

  thinhad=file->getnextnumber();
  thinem=file->getnextnumber();
  wmaxhad=file->getnextnumber();
  wmaxem=file->getnextnumber();
  thinradius=file->getnextnumber();

  for (int i=1; i<=5;i++)//
    {
      crap=file->getnextnumber();
    }

  zstart=file->getnextnumber();//starting height in cm. this is where the clock starts


  for (int i=1; i<=154;i++)//next data after this should be first particle
    {
      crap=file->getnextnumber();
    }
}


particle::particle (void)
{
}
run::run (void)
{
}
event::event (void)
{
}




particle::particle (fileinfo* thefile,double primTheta,double primPhi,double ZStart)
{
  primtheta=primTheta;
  primphi=primPhi;
  zstart=ZStart;
  file=thefile;
  description=file->getcurrentnumber();
  type=(int)(fabs((description)/1000.0)+0.0001);
  hadgen=(int)((fabs(description)-type*1000.0)/10.0+0.01);
  obslev=(int)((fabs(description)-type*1000.0-hadgen*10.0)+0.01);
  isdethinned=false;



  if (type==75 || type==76 || type==85 || type==86)//additional muon info. first particle is muon at production point, then parent then grandparent if there is prehistory, then muon at ground or decay point.
    {
 
mupx=file->getnextnumber();//muon at production point
mupy=file->getnextnumber();
mupz=file->getnextnumber();
mux=file->getnextnumber();
muy=file->getnextnumber();
muz=file->getnextnumber();
muweight=file->getnextnumber();

      if (muweight<1.0) muweight=1.0;
      mup=sqrt(mupx*mupx+mupy*mupy+mupz*mupz)*1.0E+09;
      muenergy=sqrt(mup*mup+Mmu*Mmu)-Mmu;

      //////////////////////////////////////////////////////////////////////////////////
      description=file->getnextnumber();


      if (description<0.0)//if there is prehistory information
	{
	  ppx=file->getnextnumber();/////////////read parent
	  ppy=file->getnextnumber();
	  ppz=file->getnextnumber();
	  Px=file->getnextnumber();
	  Py=file->getnextnumber();
	  pzint=file->getnextnumber();
	  pweight=file->getnextnumber();

	  if (pweight<1.0) pweight=1.0;
	  pp=sqrt(ppx*ppx+ppy*ppy+ppz*ppz)*1.0E+09;
	  ptype=floor(description/1000.0);
	  ///find energy. energy is KE only. if not gamma, e, mu, pi, K, n, p then rest mass is assumed to be 1 GeV.
	  if (ptype==1)
	    {
	      penergy=pp*1;
	    }
	  else if (ptype==2 || ptype==3)
	    {
	      penergy=sqrt(pp*pp+Me*Me)-Me;
	    }
	  else if (ptype==5 || ptype==6 || ptype==75 || ptype==76 || ptype==85 || ptype==86 || ptype==95 || ptype==96)
	    {
	      penergy=sqrt(pp*pp+Mmu*Mmu)-Mmu;
	    }
	  else if (ptype==7)
	    {
	      penergy=sqrt(pp*pp+Mpi0*Mpi0)-Mpi0;
	    }
	  else if (ptype==8 || ptype==9)
	    {
	      penergy=sqrt(pp*pp+Mpi*Mpi)-Mpi;
	    }
	  else if (ptype==10)
	    {
	      penergy=sqrt(pp*pp+Mk0*Mk0)-Mk0;
	    }
	  else if (ptype==11 || ptype==12)
	    {
	      penergy=sqrt(pp*pp+Mk*Mk)-Mk;
	    }
	  else if (ptype==13 || ptype==25)
	    {
	      penergy=sqrt(pp*pp+Mn*Mn)-Mn;
	    }
	  else if (ptype==14 || ptype==15)
	    {
	      penergy=sqrt(pp*pp+Mp*Mp)-Mp;
	    }
	  else
	    {
	      penergy=sqrt(pp*pp+1.0E+18)-1.0E+09;
	    }
	  /////////////////////////////////////////////////////////////////////////////////

description=file->getnextnumber();/////////////read grandparent
gppx=file->getnextnumber();
gppy=file->getnextnumber();
gppz=file->getnextnumber();
gpx=file->getnextnumber();
gpy=file->getnextnumber();
gpz=file->getnextnumber();
gpweight=file->getnextnumber();


	  if (gpweight<1.0) gpweight=1.0;
	  gpp=sqrt(gppx*gppx+ppy*gppy+gppz*gppz)*1.0E+09;
	  gptype=floor(description/1000.0);
	  ///find energy. energy is KE only. if not gamma, e, mu, pi, K, n, p then rest mass is assumed to be 1 GeV.
	  if (gptype==1)
	    {
	      gpenergy=gpp*1.0;
	    }
	  else if (gptype==2 || gptype==3)
	    {
	      gpenergy=sqrt(gpp*gpp+Me*Me)-Me;
	    }
	  else if (gptype==5 || gptype==6 || gptype==75 || gptype==76 || gptype==85 || gptype==86 || gptype==95 || gptype==96)
	    {
	      gpenergy=sqrt(gpp*gpp+Mmu*Mmu)-Mmu;
	    }
	  else if (gptype==7)
	    {
	      gpenergy=sqrt(gpp*gpp+Mpi0*Mpi0)-Mpi0;
	    }
	  else if (gptype==8 || gptype==9)
	    {
	      gpenergy=sqrt(gpp*gpp+Mpi*Mpi)-Mpi;
	    }
	  else if (gptype==10)
	    {
	      gpenergy=sqrt(gpp*gpp+Mk0*Mk0)-Mk0;
	    }
	  else if (gptype==11 || gptype==12)
	    {
	      gpenergy=sqrt(gpp*gpp+Mk*Mk)-Mk;
	    }
	  else if (gptype==13 || gptype==25)
	    {
	      gpenergy=sqrt(gpp*gpp+Mn*Mn)-Mn;
	    }
	  else if (gptype==14 || type==15)
	    {
	      gpenergy=sqrt(gpp*gpp+Mp*Mp)-Mp;
	    }
	  else
	    {
	      gpenergy=sqrt(gpp*gpp+1.0E+18)-1.0E+09;
	    }
	  description=file->getnextnumber();
	}//end if there is prehistory



px=file->getnextnumber();//////////////read muon at ground or decay point
py=file->getnextnumber();
pz=file->getnextnumber();
x=file->getnextnumber()*0.01;
y=file->getnextnumber()*0.01;
t=file->getnextnumber();
r=sqrt(x*x+y*y);
weight=file->getnextnumber();

      if (type==85 || type==86)//if a decayed muon
	{
	  z=t;
	}
      mufate=floor((description-type*1000.0-hadgen*10.0));
      p=sqrt(px*px+py*py+pz*pz)*1.0E+09;
      energy=sqrt(p*p+Mmu*Mmu)-Mmu;


      /////////////////////////Muons Information/////////////////////////////////////
      ///px,py,pz in GeV/c, p in eV/c ,x,y in cm, 
      ///t is arrival time of muon at ground in ns since 1st interaction. 
      ///energy is KE of muon in eV. 
      ///muz is production height in cm
      ///hadgen is hadronic generation. 
      ///obslev is the observation level for muon at ground type is 75 (mu+) or 76(mu-). 
      ///for decayed muon, type is 85 or 86. in this case, there is no t. 
      ///z is height at decay in cm. 
      ////Decayed muons also have a fate index mufate. 1 is decay, 2 is fatal nuclear intercation, 3 is drop below energy threshold or angular cut 
      
      ///////////////////////////////////////////////////////////
      ///ppx... , ptype, Px, Py is info on parent particle.
      /// pzint is parent production height
      //////////////////////////////////////////////////////////
      ///gp... is info on grandparent particle
      ///mu... is info onn the muon at its production point
      ////////////////////////////////////////////////////////////
      ///types 1=photon, 2=e+, 3=e-, 5=mu+, 6=mu-, 7=pi0, 8=pi+, 
      ///9=pi-, 10=K0, 11=K+, 12=K-, 13=n, 14=proton, 15=antip
      ///bigger numbers are exotic hadrons
      ///////////////////////////////////////////////////////////

    }

  else
    {
      px=file->getnextnumber();
      py=file->getnextnumber();
      pz=file->getnextnumber();
      x=file->getnextnumber()*0.01;
      y=file->getnextnumber()*0.01;
      t=file->getnextnumber();
      r=sqrt(x*x+y*y);
      weight=file->getnextnumber();
      p=sqrt(px*px+py*py+pz*pz)*1.0E+09;
      if (weight<1.0) weight=1.0;
      ///find energy. energy is KE only. if not gamma, e, mu, pi, K, n, p then rest mass is assumed to be 1 GeV.
      if (type==1)
	{
	  energy=p*1;
	}

      else if (type==2 || type==3)
	{
	  energy=sqrt(p*p+Me*Me)-Me;
	}
      else if (type==5 || type==6 || type==75 || type ==76)
	{
	  energy=sqrt(p*p+Mmu*Mmu)-Mmu;
	}
      else if (type==7)
	{
	  energy=sqrt(p*p+Mpi0*Mpi0)-Mpi0;
	}
      else if (type==8 || type==9)
	{
	  energy=sqrt(p*p+Mpi*Mpi)-Mpi;
	}
      else if (type==10)
	{
	  energy=sqrt(p*p+Mk0*Mk0)-Mk0;
	}
      else if (type==11 || type==12)
	{
	  energy=sqrt(p*p+Mk*Mk)-Mk;
	}
      else if (type==13 || type==25)
	{
	  energy=sqrt(p*p+Mn*Mn)-Mn;
	}
      else if (type==14 || type==15)
	{
	  energy=sqrt(p*p+Mp*Mp)-Mp;
	}
      else
	{
	  energy=sqrt(p*p+1.0E+18)-1.0E+09;
	}
      
      //read info about electromaginetic and non-muons here (or also muons if no prehistory)
      //px,py,pz=momentum components in GeV/c
      //p=total momoentum in eV/c
      //x,y=position of particle in cm
      //t=arrival time at ground since first interaction in ns
      //energy=KE in eV
      //hadgen=hadronic generation
      //obslev=observation level
      //type=type of particle
      //types 1=photon, 2=e+, 3=e-, 5=mu+, 6=mu-, 7=pi0, 8=pi+, 
      ///9=pi-, 10=K0, 11=K+, 12=K-, 13=n, 14=proton 15=antip
      ///bigger numbers are exotic hadrons ***note that for exotic
      //hadrons the energy is calculated assuming 1GeV rest mass and
      //will be incorrect for particles with KE >/> mc^2
    }





}



bool corsikafile::findnextrun(void)
{
  crap=file.getcurrentnumber();
  while (!file.iseof() && !(fabs(crap-211285.0)<1))
    {
      crap=file.getnextnumber();
    }
  return !file.iseof();
}

run corsikafile::getnextrun(void)
{
  run theRun(&file);
  return theRun;
}

double run::getheight(double depth)
{
  double height; //cm
      height=-c1*(log(depth-a1)-log(b1));//height(depth)
      if (height>h2) height=-c2*(log(depth-a2)-log(b2));
      if (height>h3) height=-c3*(log(depth-a3)-log(b3));
      if (height>h4) height=-c4*(log(depth-a4)-log(b4));
      if (height>h5) height=c5*(a5-depth)/b5;
      return height;
}

double run::getdepth(double z)//z in cm
{
  double depth;
      if (h1<=z && z<=h2)//function for depth(height)
	{
	  depth = a1+b1*exp(-z/c1);
	}
      else if (h2<=z && z<=h3) depth = a2+b2*exp(-z/c2);
      else if (h3<=z && z<=h4) depth = a3+b3*exp(-z/c3);
      else if (h4<=z && z<=h5) depth = a4+b4*exp(-z/c4);
      else if (h5<=z)
	{
	  depth = a5-b5*z/c5;
	  if (depth < 0.0)
	    {
	      depth = 0.0;
	    }
	}
      return depth;
}

bool run::findnextevent(void)
{
  crap=file->getcurrentnumber();
  while (!file->iseof() && (fabs(crap-217433.0)>1.0) && (fabs(crap-3301.0)>1.0))
    {
      crap=file->getnextblock();
    }
  if (fabs(crap-3301.0)<1.0)//runend
      {
	//cout << "runend: " << crap << endl;
	return false;
      }
  return !file->iseof();
}

event run::getnextevent(void)
{
  event theEvent(file);
  return theEvent;
}

bool event::findnextparticle(void)
{
  crap=file->getnextnumber();
  while (!file->iseof() && fabs(crap)<.001 && fabs(3397.0-crap)>1)
    {
      for (int i=1; i<=8; i++)
	{
	  crap=file->getnextnumber();
	}
    }
  if (!file->iseof() && fabs(3397.0-crap)>1.0)
    {
      return true;
    }
  else
    {
      return false;
    }

}

particle event::getnextparticle(void)
{
  particle theParticle(file,primtheta,primphi,zstart);
  return theParticle;
}

bool event::readevte(void)
{
  crap=file->getcurrentnumber();
  while (!file->iseof() && fabs(3397.0-crap)>1)
    {
      crap=file->getnextblock();
      //   cout << "newblock: " << crap << endl;
    }
  if (!file->iseof())
    {
  for (int i=2; i<=255;i++)//
    {
      crap=file->getnextnumber();
    }
  gh1=file->getnextnumber();
  gh2=file->getnextnumber();
  gh3=file->getnextnumber();
  gh4=file->getnextnumber();
  gh5=file->getnextnumber();
  gh6=file->getnextnumber();
  return true;
    }
  else
    {
      return false;
    }
}
