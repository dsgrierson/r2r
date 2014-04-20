%% Control System variable q-point calculations

clc; clear all; close all; 
format long g

%% Current Sensor system gain
K_Current_Sense = 0.00620268620268620268620268620269 % Amps/Count
K_Current_Sense_FxdPt = Float2SignedQpt(K_Current_Sense,0.00001);

CurrentFB = 2047;
CurrentFB_FxdPt = Float2SignedQpt(CurrentFB,1);

K_ADC_9381 = (4095-0)/(5-0) % Counts/Volt

%% Compute Gain of Force System (DCM460 2/ HPB-20 Transducer
g = 9.81 % acceleration of gravity on earth (m/s^2)
mass = [ 0 20 ] % mass range in Kg
F = mass*g % Compute Force Range
VRange = [ 0 3.7] % Units of Volts
K_DCM460_HPB20 = (max(F)-min(F))/(max(VRange)-min(VRange)) % Units of Newton/Volt
K_ForceFB = K_DCM460_HPB20 / K_ADC_9381 % Newton/Volt / Counts/Volt = Newton/Count


%% Compute Gain for Position Sensor
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

%% Compute Gain for the PWM
PWM_res = 2000 % Number of counts for pwm
V_rail = 24
K_PWM = PWM_res/V_rail

