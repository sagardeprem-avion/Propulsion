clear all
T04=857+273;
T_inf=220 ;              % free stream temperature
P_inf=0.25 ;              % free stream pressure
M_inf=0.85   ;              % free stream mach number
gamma=1.4;               % ratio of specific heats
R=287 ;                  % gas constant
u=M_inf*sqrt(gamma*R*T_inf);    %  inlet velocity

Cp=gamma*R/(gamma-1) ;          % specific heat  
prc=linspace(7, 7.2,3) ;        %  compressor pressure ratio
 
e_diff=0.93;                    %  efficiencies
 
 
e_n_hot=0.95;
e_comp=0.87;
e_turb=0.9;
e_burner=1;
e_nozzle=1;
Q=45000000 ;                %   fuel heat content

 
prc_critical= 1/(1-(gamma-1)/(e_n_hot*(gamma+1)))^(gamma/(gamma-1))  % to check if hot stream nozzle chokes or not

% diffuser stage
T02=T_inf*(1+(gamma-1)*0.5*M_inf^2) ;  
P02=P_inf*(1+(T02/T_inf-1)/e_diff)^(gamma/(gamma-1));

  
    
for i=1:length(prc)
   %  compressor stage
    P03(i)=(P02*prc(i));
    T03(i)=T02*(1+(prc(i)^((gamma-1)/gamma)-1)/e_comp);
    
    % burner fuel air ratio
    f(i)=(T04-T03(i))/(Q/(Cp)-T04);
    
    % turbine inlet pressure
    P04(i)=(P03(i)) ;% # given pressure loss is zero
    
        
   %  compressor turbine power balance
    T05(i)=T04-(T03(i)-T02)/0.99;%-B*(T08-T02);
    P05(i)=(P04(i)*(1-(1-T05(i)/T04)/e_turb)^(gamma/(gamma-1)));
    T06(i)=(T05(i));
    P06(i)=(P05(i));
    
    
    if P_inf/P06(i) >1/prc_critical 
        v7(i)=(sqrt(2*e_n_hot*Cp*T06(i)*(1-(P_inf/P06(i))^((gamma-1)/gamma))));
           t(i)=(1+f(i))*v7(i)-u ; 
    else
        
    T6(i)=2*T05(i)/(gamma+1);
    P5(i)=P05(i)/prc_critical;
    v7(i)=(gamma*R*T6(i))^0.5;
    rho7(i)=P5(i)/(R*T6(i));
    p7(i)=P5(i)/prc_critical;
    
     t(i)=(1+f(i))*v7(i)-u + (p7(i)-P_inf)/(rho7(i)*v7(i)) ;
    
       
    end
     e_prop(i)=2*t(i)*u/(t(i)*u*2+(1+f(i))*(v7(i)-u)^2);  % propulsive efficiency
     e_therm(i)=(t(i)*u*2+(1+f(i))*(v7(i)-u)^2)/(2*f(i)*Q); %thermal efficiency
end
s=f./t;
hold on
% plot(prc,t )
 plot(prc,e_prop,'o')
 plot(prc,e_therm,'*' ) 
 plot(prc,e_prop.*e_therm,'+' )
   title('T_{04}=1630 K & B=0')
 xlabel('  Compressor pressure ratio \pi_C')
  ylabel('\eta')