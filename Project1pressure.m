%% MATLAB code for optomizing Flash Chamber pressure
clear % clear variables
clc % clear command window

%% For loop block to establish values
for i = 1:1:40

    %Givens and pressure array
    mdot_warm = 100; % kg/s
    cp = 4.186; % kJ/kg
    T1= 27; % C Warm surface water temperature
    T2= 17; % C Flash chamber operating temperature
    T3 = T2;
    T5= 10; % C Condenser operating temperature
    T8 = T5;
    Pchamber = i/1000; %[bar] devided by 1000 becuase arrays must be integer
    PchamberArray(i) = Pchamber; % collecting array for graph

    %Solving Problem
    IdealPower = mdot_warm*cp*(T1-T5); %[kW]
    MaxPosPower = IdealPower * (1- (T5+273)/(T1+273)); %[kW]
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
    WorkT = h3-h5s;
    mdot_turbine = x2*mdot_warm; %[kg/s]
    ActualPower = WorkT*mdot_turbine; %[kW]
    vdotwater = mdot_turbine*XSteam('vL_T', T8); %[m3/s]
    freshwatervalue(i) = vdotwater * 2; %[$/h]
    powervalue(i) = ActualPower * 0.47; %[$/kWh]
end

%% Plotting Fresh Water and power generation
figure
plot(PchamberArray,freshwatervalue)
xlabel('Pressure [bar]')
ylabel('Dollar Value')

figure
plot(PchamberArray,powervalue)
xlabel('Pressure [bar]')
ylabel('Dollar Value')

%% Printing what the max value is for Fresh Water and Power
[maxvdot, Ivdot] = max(freshwatervalue);
[maxpower, Ipower] = max(powervalue);

fprintf('Maximum Fresh Water profit is at %f bar \n', Ivdot/1000)
fprintf('  Generating $ %f per second in fresh water. \n', maxvdot);
fprintf('Maximum Power Generating profit is at %f bar \n', Ipower/1000)
fprintf('  Generting $ %f in kW per hour', maxpower)

