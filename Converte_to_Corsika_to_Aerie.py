# -*- coding: utf-8 -*-
"""
Created on Mon Nov 14 22:54:25 2022

@author: Andrés Colán Sifuentes
@reference: Luis Morales
"""
import pandas as pd
import copy
#%%
df=pd.read_csv('Data1.txt', sep="\t")
#%%
df=df[df.R<=300]

#%%
df2=df[["Type","X","Y","Zdeca(cm)","Px(GeV/c)","Py(GeV/c)","Pz(GeV/c)"]]
df3=copy.deepcopy(df2)

#%%
#foton 1, positron 2, electron 3, muon+ 5, muon- 6, pion0 7, pion+ 8, pion- 9
#Kaon0L 10, antineutron 25, neutron 13, proton 14, print(df2["Type"].unique())
df2.loc[df2["Type"] ==1 , "Type"] = "gamma"
df2.loc[df2["Type"] ==2 , "Type"] = "e+"
df2.loc[df2['Type'] ==3 , 'Type']= "e-"
df2.loc[df2['Type'] ==5 , 'Type']= "mu+"
df2.loc[df2['Type'] ==7 , 'Type']= "mu-"
df2.loc[df2['Type'] ==8 , 'Type']= "pi+"
df2.loc[df2['Type'] ==9 , 'Type']= "pi-"
df2.loc[df2['Type'] ==13 , 'Type']= "neutron"
df2.loc[df2['Type'] ==14 , 'Type']= "proton"
df2.loc[df2['Type'] ==25 , 'Type']= "anti_neutron"
df2.loc[df2['Type'] ==75 , 'Type']= "mu+"
df2.loc[df2['Type'] ==76 , 'Type']= "mu-"
df2.loc[df2['Type'] ==10 , 'Type']= "kaon"
        
        
        
        