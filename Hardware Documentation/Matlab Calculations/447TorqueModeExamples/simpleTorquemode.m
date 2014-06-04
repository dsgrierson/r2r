clear all; close all
echo  on
% This M-File simulates a Transfer Function Model for a DC Brush motor & Inertia Disk
% For:   Professor Neil Duffie - M.E. Dept.
% Written by Erick L. Oberstar
% oberstar@engr.wisc.edu
%
% Spring 2003

% Create a simple transfer function model for the Maxom motor system with various inertial wheels.

format long

% Physics Constants
rho_Al = 2.702 * 1000   % Density of aluminum g/cm^3 * 1kg/1000g * 1.0e6cm^3*1m^3 = (kg/m^3)

% Servo Amplifier Parameters
%Ka = 4                  % Voltage Gain set by potentiometer on servo amplifier brick V/V
Ka = 1                  % Current gain set by pot on servo amp brick Amps/Volt

% Maxon A-Max 26 Model 110953 
% Motor Parameters

Kt = 28.3 / 1000        % Motor Torque Constant mNm/A / 1000 = Nm/A
Kb = 1/(337 * (2*pi/60))% Motor Back EMF (Speed) Constant 1/((rpm/V) * (2*pi/60)) = (volt-sec)/radian
Ja = 10.6 * 1.0e-007    % Motor Armature Intertia (g*cm^2) *(1m^2/10000cm^2)*(1kg/1000g) = kg-m^2
% b = 5.8e-006            % Motors Viscous damping Coefficient (kg-m2/sec)
% b = 1.8e-005            % Motors Viscous damping Coefficient (kg-m2/sec)
b = 0                   % Motors Viscous damping Coefficient (kg-m2/sec)
Ra = 17.9               % Motor Armature Resistance (Terminal Resistance) (Ohms)
La = 1.69 / 1000        % Motor Armature Inductance (Terminal Inductance) mH / 1000 = H (Henrys)


% Load Parameters
rho = rho_Al            % Density of load disk (Aluminum)(kg/m^3)
h = 0.25 * 2.54/100     % Thickness of Load Disk (in * 2.54cm/in * 1m/100cm )= m
% rd = (3.0/2) * 2.54/100 % 3" Radius of Load Disk (in * 2.54cm/1in * 1m/100cm )= m
rd = (2.5/2) * 2.54/100 % 2.5" Radius of Load Disk (in * 2.54cm/1in * 1m/100cm )= m
% rd = (2.0/2) * 2.54/100 % 2" Radius of Load Disk (in * 2.54cm/1in * 1m/100cm )= m
% rd = 0                 % No disk
Jl = (rho*pi*h*rd^4)/2  % Load Inertia (1/2 Mass*radius^2) (kg/m^3*m*m^4 = kg-m^2)

% System Parameters
Jt = Ja + Jl            % System Inertia - Assume a simple rigidly coupled motor & 
                        % load (no shaft dynamics)
CPR = 2000              % Counts Per Armature Revolution Quadrature Decoded  
K_enc = CPR/(2*pi)      % Encoder Gain Counts/Radian
DA_SPN = 10             % Voltage Span of D/A Converter
DA_RES = 8              % Bits of DAC Resolution
K_da = DA_SPN/(2^DA_RES)% D/A converter gain

%Controller Parameters
Kp = .01              % PID continious time Proportional Gain 
Ki = 0                  % PID continious time Integral Gain
Kd = .001                  % PID continious time Differential Gain
stepsize = 1           % # of Revolutions for Step
% stepsize = 2000           % # of Counts for Step

SR = 300                % Sampling rate for Discrete system (Hz)
Ts = 1/SR               % Sampling period for Discrete system (Sec)

steptime = 1           % Seconds to calculate Step reponse over
numpts = steptime/Ts    % Calculate number of points for the length of time the step response is over


% Other Parameters
i = 0;                  % Figure counter initialization

% The Transfer function (output position) / (input current)
% Since D/A converter, motor amp & encoder are treated as gain factors they
% can just be included in the continious tf model.
% already discrete nums = K_da*Ka*Kt*Ts^2*K_enc*[0 1 1 ]
% alreayd discrete dens = 2*Jt*[1 -2 1]
nums = K_da*Ka*Kt*K_enc*[0 0 1]
dens = Jt*[1 0 0]
% Units on transfer function are Radians/Volt

syss = tf(nums,dens)
Poles=pole(syss)
[z p k] = tf2zp(nums,dens)
syss_zpk = zpk(z,p,k)

% Calculate the systems frequency response
i=i+1;
figure(i)
bode(syss);
grid on
titlestring = ['TF - Bode Plot of Continious Open Loop Position System, Rd = ',num2str(rd),' m'];
title(titlestring);

% Calculate the systems root locus
i=i+1;
figure(i)
rlocus(syss);
titlestring = ['TF - Root Locus, Continious Open Loop Position System, Rd = ',num2str(rd),' m'];
title(titlestring);
sgrid(.5,0)
sigrid(10)

% Covert the Continious time model to the discrete time model
sysz = c2d(syss,Ts,'zoh');
sysz.variable='z^-1';
sysz
zpk(sysz)

% Proportional Derivative controller transfer function
numcz = [Kp+Kd/Ts -(Kp+2*Kd/Ts) Kd/Ts]
dencz = [0 1 -1];
syscz = tf(numcz,dencz,Ts);
syscz.variable='z^-1';
syscz
zpk(syscz)

% Connect the Porportional Derivative Controller, D/A, Encoder & Motor models in series
OLsysz = series(syscz,sysz)

% Calculate the Closed Loop Transfer function
CLsysz = feedback(OLsysz,1)

% Calculate the Step Response
% Create time vector
t = 0:Ts:steptime;
i=i+1;
figure(i)
[y1,t] = step(stepsize*CLsysz,t);

subplot(2,1,1),plot(t,y1)
grid on
% xlabel('Time (seconds)')
ylabel('Position (Revs)')
titlestring = ['TF - Discrete Step Resp.: Compensated (CL), Rd = ',num2str(rd),' m, Kp = ',num2str(Kp)];
title(titlestring);


%y2 = y1*CPR./(2*pi); % Convert to Revs
y2 = y1*CPR;

subplot(2,1,2),plot(t,y2)
grid on
xlabel('Time (seconds)')
ylabel('Position (Counts)')
% titlestring = ['TF - Discrete Step Resp.: Compensated, Rd = ',num2str(rd),' m, Kp = ',num2str(Kp)];
% title(titlestring);

format

% Calculate the Discrete Closed Loop Systems frequency response
i=i+1;
figure(i)
bode(CLsysz)
grid on
titlestring = ['TF - Bode Plot of Discrete Closed Loop Position System, Rd = ',num2str(rd),' m, Kp = ',num2str(Kp)];
title(titlestring);
