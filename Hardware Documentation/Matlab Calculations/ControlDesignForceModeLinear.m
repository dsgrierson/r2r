%% Control System Modeling for the compliant contact roller control system
% Written by Erick Oberstar 5/15/2014

clc; clear all; close all;
%%*************************************************************************
%% Physical System Definition

% Analog Input Gain
K_ADC_9381 = (4095-0)/(5-0) % Counts/Volt

% Compute Gain of Force System (DCM460 2/ HPB-20 Transducer
g = 9.81 % acceleration of gravity on earth (m/s^2)
mass = [ 0 20 ] % mass range in Kg
F = mass*g % Compute Force Range
VRange = [ 0 3.7] % Units of Volts
K_DCM460_HPB20 = (max(F)-min(F))/(max(VRange)-min(VRange)) % Units of Newton/Volt
K_ForceFB = K_DCM460_HPB20 / K_ADC_9381 % Newton/Volt / Counts/Volt = Newton/Count


% Compute Gain for Position Sensor
R_nom_per_mm = 2750 % Nominal Resistance in Ohms/mm
R_tol = 0.3 % Tolerance in % of the position feedback resistance
R_lin = 0.01 % Linearity of the Feedback potentiometer
R_Range = R_nom_per_mm*[1+R_tol 1 1-R_tol]
L_nom = 50 % lenght in mm
R_MaxPos_Range = R_Range*L_nom % 

% Actual Resistance doesn't matter - Position is Ratiometric from 0 Ohms to
% full scale Ohms over the reference voltage so the pot location is just a
% percentage from 0-100% over the length of the actuator across the ADC
% reference voltage
VPot_Range = [0 5] % Position Pot Source Voltage Range
L_Range = [0 50] % Position Range of actuator in mm
K_L12_Pos_mm_per_volt = (max(L_Range)-min(L_Range))/(max(VPot_Range)-min(VPot_Range)) % mm/Volt
K_L12_Pos_m_per_volt = K_L12_Pos_mm_per_volt/1000 %Convert to m/Volt

% Now lump in ADC Gain
K_L12_Pos = K_L12_Pos_m_per_volt/K_ADC_9381 % meter/Volt / Counts/Volt = meters/count

% Compute Gain for the PWM
PWM_res = 2000 % Number of counts for pwm
V_rail = 24
K_PWM = V_rail/PWM_res % Volts/Count

% Firgelli Actuator Force Model (Input Voltage - Output Force)
K_L12_Force = 2.29181 % mA/N (Slope on Force vs Current Response)
% *********  Change to units of A and check saturation block again
L12_Offset_I = 12.995 % mA (Current Offset on Force vs Current Response)
Ra_L12 = 60 % Armature Resistance in Ohms of Firgelli
Mar = 0.075 % Effective Mass of actuator & roller in Kg

%% Firgelli Actuator Position Model

%Simulation Model Configuration Parameters
StartTime = 0;
StopTime = 20;
MaxStepSize = 0.1;
PositionStepSize = 20 % Step Command in mm

Fs = 1000 % Sampling Rate Hz
Ts = 1/Fs % Sampling Rate
Kspring = 100; % Virtual Spring Constant (N/mm)
Kdamp = 100; % Virtual damper N-s/m (Force/Velocity)


% Other Parameters
i = 0;                  % Figure counter initialization

% The Transfer function (output position) / (input current)
% Since D/A converter, motor amp & encoder are treated as gain factors they
% can just be included in the continious tf model.
% already discrete nums = K_da*Ka*Kt*Ts^2*K_enc*[0 1 1 ]
% alreayd discrete dens = 2*Jt*[1 -2 1]
% numps = K_da*Ka*Kt*K_enc*[0 0 1]
% denps = Jt*[1 0 0]

% Need to decide if we should include PWM here or not.
numps = K_PWM/Ra_L12/1000/K_L12_Force*[0 0 1] % 1000 scales mA to A
numps = 1/Ra_L12/1000/K_L12_Force*[0 0 1] % 1000  scales mA to A
denps = Mar*[1 0 0]
OL_p_s = tf(numps,denps)
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

OL_v_z = series(OL_p_z, Vf_z) % Open Loop Velocity Transfer Function

i=i+1;
figure(i)
zgrid on
axis equal
rlocus(OL_v_z);
axis([-1.2 1.2 -1.2 1.2])
titlestring = ['TF - Root Locus, Discrete Open Loop Velocity System, Mass = ',num2str(Mar),' kg'];
title(titlestring);

% Use Rlocus to find Velocity Gain / Poles
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


% Now close a proportional position loop around the velocity loop
% find value of root to pick with rlocus
r=exp(-Ts/taup_cl)
i=i+1;
figure(i)
zgrid on
axis equal
rlocus(CL_v_z);
axis([-1.1 1.1 -1.1 1.1])
titlestring = ['Root Locus, Discrete Closed Loop Velocity System, Mass = ',num2str(Mar),' m'];
title(titlestring);

pause
[Kp,polesp]=rlocfind(CL_v_z)

CL_pv_z = feedback(Kp*CL_v_z,1)
i=i+1;
figure(i)
step(PositionStepSize*CL_pv_z) % Step stepsize counts
grid on

figure; bode(CL_pv_z)
h = gcr; % Get the handle for the "plot object root"
% which is a structure containing the plot properties
% Set frequency axis to Hz
h.AxesGrid.Xunits = 'Hz';
% Set mag axis to abs & phase axis to deg
h.AxesGrid.Yunits = {'abs','deg'};
% Turn on the grid
grid on; % or h.AxesGrid.Grid = "on"