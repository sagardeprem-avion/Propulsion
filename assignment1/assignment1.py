# -*- coding: utf-8 -*-
"""
Created on Sat Sep 24 20:37:35 2016

@author: prem
"""
import math
from math import *
import numpy as np
import matplotlib.pyplot as plt

T_inf=220                   # free stream temperature
P_inf=0.25                  # free stream pressure
M_inf=0.85                  # free stream mach number
gamma=1.4                   # ratio of specific heats
R=287                       #gas constant
u=M_inf*sqrt(gamma*R*T_inf)  # inlet velocity

Cp=gamma*R/(gamma-1)      #specific heat  
prc=np.linspace(2,50,50)  # compressor pressure ratio
prf=1.2                   # fan pressure ratio
B=5                         # fan bypass ratio
T04=1630
e_diff=0.93                 # efficiencies
e_fan=0.85
e_n_cold=0.98
e_n_hot=0.98
e_comp=0.85
e_turb=0.85
e_burner=1
e_nozzle=1
Q=45000000                      # fuel heat content
P03=[]
P04=[]
P05=[]
T03=[]
f=[]
T05=[]
T06=[]
t=[]
u_e=[]
#diffuser stage
T02=T_inf*(1+(gamma-1)*0.5*M_inf**2)   
P02=P_inf*(1+(T02/T_inf-1)/e_diff)**(gamma/(gamma-1))

 # fan outlet conditons
P08=P02*prf 
T08=(T02*(1+(prf**(gamma/(gamma-1))-1)/e_fan))
    
     # fan nozzle exit velocity
u_ef=sqrt(2*e_fan*Cp*T08*(1-(P_inf/P08)**((gamma-1)/gamma)))
    
    
for i in range(len(prc)):
    # compressor stage
    P03.append(P02*prc[i]*prf)
    T03.append(T02*(1+(prc[i]**(gamma/(gamma-1))-1)/e_comp))
    
    #burner fuel air ratio
    f.append(T04-T03[i])/(Q/(Cp*T02)*T03[i]-T04)
    
    #turbine inlet pressure
    P04.append(P03[i])  # given pressure loss is zero
    
        
    # compressor turbine power balance
    T05.append(T04-(T03[i]-T02)-B*(T08-T02))
    P05.append(P04[i]*(1-(1-T05[i]/T04)/e_turb)**(gamma/(gamma-1)))
    T06.append(T05[i])
    P06.append(P05[i])
    u_e.append(sqrt(2*e_nozzle*Cp*T06*(1-(P_inf/P06)**((gamma-1)/gamma))))
    
        # specific thrust
    t.append((1+f)*u_e+B*u_ef-(1+B)*u)


plt.plot(prc,t,'b*')
        