%% MATLAB code for Open OTEC system
clear % clear variables
clc % clear command window

%% Givens
cp = 4.186; % kJ/kg
T1= 27; % C Warm water temperature
T2= 17; % C Flash chamber operating temperature
T3 = T2;
T5= 4; % C cold water temp
T8 = T5;
Pchamber = 0.021; %[bar] Picked 0.021 based on optimal pressure
Density = 1029; % kg/m^3 for sea water
PipeL = 600; % m
CoolKw = 25; % kWh
CoolArea = 500000; % ft^2
Tair = 30; % C ambient Temp
TotalPower = 20000; % Kw

%% Notes
%COP = (h1 - h4) /(h2 - h1)     (you use this for each configuration)
%Compressor power for 1st MVC configuration: (500,000 x 25)
%Compressor power for 2nd MVC configuration: (COP1 / COP2) x Compressor power for 1st configuration
%Compressor power for 3rd MVC configuration: (COP1 / COP3) x Compressor power for 1st configuration
%Well, you use the values from the OTEC code for the 2nd and 3rd configuration. 3rd configuration uses water at 4degC to cool the condenser. Configuration 2 uses water at T5-TTD to cool the condenser. Obviously h4 and h1 will be at 0deg for the PH diagram
% Also..... those h values for COP are from the PH diagram, not the h values from your OTEC code


%% Solving Problem
h1= XSteam('hL_T', T1);
h2= h1;
h2f = XSteam('hL_p',Pchamber); 
h4 = h2f;
h2g = XSteam('hV_p', Pchamber);
h3 = h2g;
x2 = (h2-h2f)/(h2g-h2f);
h5f= XSteam('hL_T', T5);
h5g= XSteam('hV_T', T5);
s3 = XSteam('sV_p', Pchamber);
s5s = s3;
s5f= XSteam('sL_T', T5);
s5g= XSteam('sV_T', T5);
x5= (s5s-s5f)/(s5g-s5f);
h5s= h5f + x5*(h5g-h5f);
% I took a few different pipe diameters, all sched 40 SAE 316 Stainless
% Seeing which pipe is cheaper for 600m
% Costs per meter by dia are 4in = 330.49, 6in = 346.93, 8in = 486.93
Pipe4in = 330.49 * PipeL; % $
Pipe6in = 346.93 * PipeL; % $
Pipe8in = 486.93 * PipeL; % $
%COP = (h1-h4)/(h2f-h1) 
WorkT = h3-h5s * 0.65; %Assuming a 65% efficiency
mdot_warm = TotalPower/(WorkT*x2*0.75); %kg/s warm water mdot
mdot_cold = (TotalPower/0.05)/(cp*3); % kg/s cold water mdot deltaT = 3
mdot_turbine = x2*mdot_warm * 0.75; %[kg/s] Assuming a 75% efficiency
WarmPumpPower = (mdot_warm*Density*9.81*5)/3.6e6; % KW for warm water pump
ColdPumpPower = (mdot_cold*Density*9.81*5)/3.6e6; % kW for cold water pump
IdealPower = mdot_warm*cp*(T1-T5); %[kW]
MaxPosPower = IdealPower * (1- (T5+273)/(T1+273)); %[kW]
ActualPower = WorkT*mdot_turbine; %[kW]
vdotwater = mdot_turbine*XSteam('vL_T', T8); %[m3/s]
vdothour = vdotwater * 60 * 60; %[m3/h]
freshwatervalue = vdotwater * 2; %[$/s]
powervalue = ActualPower * 0.47; %[$/kWh]
freshwatervaluehour = vdothour * 2; %[$/h]
hourtotal = freshwatervaluehour + powervalue;

%% MVC Analysis
CompressorPower = CoolArea * Coolkw;
COP = (h1-h4)/(h2f-h1)


%% Printing the realistic but optimized profits

%fprintf('A Realistic profit for an optomized system\n')
%fprintf(' Would be about $%f per second in fresh water,\n', vdotwater);
%fprintf(' and about $%f per kWh in generated power.\n', powervalue)
%fprintf(' Or about $%f per hour of operation', hourtotal)
