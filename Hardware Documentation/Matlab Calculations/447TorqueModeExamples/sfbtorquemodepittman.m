clear all; close all
echo  on
% This M-File simulates a StateFeedback Torque Mode Model for a Pittman 
% Model 9273S001 11.5 Oz-In / 0.081 N-m DC Brush Motor
% DC Brush motor & Inertia Disk
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
% Ka = 0.08346             % Current gain set by pot on servo amp brick Amps/Volt
% Ka = 0.16482            % Current gain set by pot on servo amp brick Amps/Volt
% Ka = 1.0338            % Current gain set by pot on servo amp brick Amps/Volt
% Ka = 1.2407            % Current gain set by pot on servo amp brick Amps/Volt
Ka = 1.331736            % Current gain set by pot on servo amp brick Amps/Volt

% Pittman Model 9273S001 11.5 Oz-In / 0.081 N-m DC Brush Motor
% Motor Parameters

Kt = 42.4 / 1000        % Motor Torque Constant mNm/A / 1000 = Nm/A
Kb = 42.4 / 1000        % Motor Back EMF (Speed) Constant volts/(radian/sec)
Ja = 7.06 * 1.0e-6      % Motor Armature Intertia (g*cm^2) *(1m^2/10000cm^2)*(1kg/1000g) = kg-m^2
% b = 1.8e-005            % Motors Viscous damping Coefficient (kg-m2/sec)
b = 0                   % Motors Viscous damping Coefficient (kg-m2/sec)
Ra = 2.82               % Motor Armature Resistance (Terminal Resistance) (Ohms)
La = 1.97 / 1000        % Motor Armature Inductance (Terminal Inductance) mH / 1000 = H (Henrys)


% Load Parameters
rho = rho_Al            % Density of load disk (Aluminum)(kg/m^3)
h = 0.25 * 2.54/100     % Thickness of Load Disk (in * 2.54cm/in * 1m/100cm )= m
rd = (3.0/2) * 2.54/100 % 3" Radius of Load Disk (in * 2.54cm/1in * 1m/100cm )= m
% rd = (2.5/2) * 2.54/100 % 2.5" Radius of Load Disk (in * 2.54cm/1in * 1m/100cm )= m
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
% Kp = .02              % PID continious time Proportional Gain 
% Ki = 0                  % PID continious time Integral Gain
% Kd = .001                  % PID continious time Differential Gain
stepsize = 500           % # of Counts for Step

SR = 250                % Sampling rate for Discrete system (Hz)
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
numps = K_da*Ka*Kt*K_enc*[0 0 1]
denps = Jt*[1 0 0]
% numvs = numps(:,2:3)
% denvs = denps(:,1:2)
% Units on transfer function are Radians/Amp

OL_p_s = tf(numps,denps)
% OL_v_s = tf(numvs,denvs)
Poles=pole(OL_p_s)
[z p k] = tf2zp(numps,denps)
OL_p_s_zpk = zpk(z,p,k)

% Calculate Discrete Model
OL_p_z = c2d(OL_p_s,Ts)
OL_p_z.variable = 'z^-1'
% OL_v_z = c2d(OL_v_s,Ts)
% OL_v_z.variable = 'z^-1'

% Calculate the systems root locus
% with the systhesized velocity feedback
numvfz = [1 -1]
% denvfz = [Ts 0]
denvfz = [1 0]
Vf_z = tf(numvfz,denvfz,Ts,'Variable','z^-1')
% Vf_z.variable = 'z^-1'

OL_v_z = series(OL_p_z, Vf_z)

% Part 4
i=i+1;
figure(i)
zgrid on
axis equal
rlocus(OL_v_z);
axis([-1.2 1.2 -1.2 1.2])
titlestring = ['TF - Root Locus, Continious Open Loop Velocity System, Rd = ',num2str(rd),' m'];
title(titlestring);
% sgrid(.7,0)
% sigrid(10)
pause
[Kv,polesv]=rlocfind(OL_v_z)

CL_v_z = feedback(OL_p_z, Kv*Vf_z)
i=i+1;
figure(i)
zgrid on
pzmap(CL_v_z)

[Wn,Z] = damp(CL_v_z)
% [numz,denz] = tfdata(CL_v_z,'v')
% residuez(numz,denz)
tau = max(1/(Z.*Wn))     % Dominant Time Constant
taup_cl = 5*tau     % Desired Closed loop proportional position control time constant.
W_cl = 1/taup_cl

% dt_z = minreal(series(CL_v_z,Kv*Vf_z))      % dt_z = delta_theta_z synthesized velocity transfer function
dt_z = minreal(feedback(CL_v_z*Vf_z,Kv))      % dt_z = delta_theta_z synthesized velocity transfer function
i=i+1;
figure(i)
step(dt_z)
grid on

% Part 5
[num_dt_z,den_dt_z] = tfdata(dt_z, 'v')
ZeroS = roots(num_dt_z)
PoleS = pole(dt_z)
i=i+1;
figure(i)
pzmap(dt_z)
grid on
K_Vel = sum(num_dt_z)/sum(den_dt_z)     %Units of Vel gain in Counts_Position/bit-second

% Part 6
M_ss = 2.5/((1+Kv)*K_da)
M_max = 5.0/K_da

% Part 7
% Now close a proportional position loop around the velocity loop
% find value of root to pick with rlocus
r=exp(-Ts/taup_cl)
i=i+1;
figure(i)
zgrid on
axis equal
rlocus(CL_v_z);
axis([-1.1 1.1 -1.1 1.1])
titlestring = ['Part 7 - Root Locus, Continious Closed Loop Velocity System, Rd = ',num2str(rd),' m'];
title(titlestring);

pause
[Kp,polesp]=rlocfind(CL_v_z)

CL_pv_z = feedback(Kp*CL_v_z,1)
i=i+1;
figure(i)
step(stepsize*CL_pv_z) % Step stepsize counts
grid on

i=i+1;
figure(i)
zgrid on
pzmap(CL_pv_z)
