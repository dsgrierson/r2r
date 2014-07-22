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
Home = 0; % Home position (mm)
ContactPoint = 23 % Contact Position in (mm)
L_Range_Const = [Home ContactPoint] % Position Range of actuator is constrained by contact in mm
K_L12_Pos_mm_per_volt = (max(L_Range)-min(L_Range))/(max(VPot_Range)-min(VPot_Range)) % mm/Volt
K_L12_Pos_m_per_volt = K_L12_Pos_mm_per_volt/1000 %Convert to m/Volt

% Now lump in ADC Gain
K_L12_Pos = K_L12_Pos_m_per_volt/K_ADC_9381 % meter/Volt / Counts/Volt = meters/count

% Compute Gain for the PWM
PWM_res = 2000 % Number of counts for pwm
V_rail = 24
K_PWM = PWM_res/V_rail % Count/Volts

% Firgelli Actuator Force Model (Input Voltage - Output Force)
K_L12_Force = 2.29181 % mA/N (Slope on Force vs Current Response)
% *********  Change to units of A and check saturation block again
L12_Offset_I = 12.995 % mA (Current Offset on Force vs Current Response)
Ra_L12 = 60 % Armature Resistance in Ohms of Firgelli
Mar = 0.075 % Effective Mass of actuator & roller in Kg


%% backout backemf constant for the linear motor
voltage_applied = [1.5 4.5 7.5]
speed_at_voltage_applied = [0.6 2.16 3.7] % mm/sec
i = [0.006 0.0085 0.011]
Vbackemf = (voltage_applied-(i*Ra_L12))
K_backemf_array = Vbackemf./speed_at_voltage_applied % Units ov Volts-s/mm Volts/(mm/s}
K_backemf = min( K_backemf_array )

%% Firgelli Actuator Position Model

%Simulation Model Configuration Parameters
StartTime = 0;
StopTime = 15;
MaxStepSize = 0.1;

Kspring = 55; % Virtual Spring Constant (N/mm)
Kdamper = 5*1000; % Virtual damper N-s/mm (Force/Velocity) *1000 converts /m to /mm

% Kspring = 5.110718747826613e+06
% Kdamp = 3.497032275548465e+09
PulsePeakAmplitude = 5

% Open Simulink
simulink
% Open & sim the Model
R2RSystemModel
sim('R2RSystemModel');
% R2RSystemModel_PosControl
% sim('R2RSystemModel_PosControl');

% find all scope blocks as MATLAB figures & Set to autoscale:
set(0, 'showhiddenhandles', 'on')
scope = findobj(0, 'Tag', 'SIMULINK_SIMSCOPE_FIGURE');
for i=1:length(scope)
  % this is the callback of the "autoscale" button:
  simscope('ScopeBar', 'ActionIcon', 'Find', scope(i))
end
set(0, 'showhiddenhandles', 'off')

% %%*************************************************************************
% %% Design a low pass state filter for the virtual compliance y* command signal
% Ts = 40000/40e6 % from crio-FPGA-control\Globals\Global - Configuration Options.vi
% 
% fc = 500
% 
% filt = tf(1,[1/(2*pi*fc) 1])
% 
% figure; 
% bode(filt)
% h = gcr; % Get the handle for the "plot object root"
% % which is a structure containing the plot properties
% % Set frequency axis to Hz
% h.AxesGrid.Xunits = 'Hz';
% % Set mag axis to abs & phase axis to deg
% h.AxesGrid.Yunits = {'abs','deg'};
% % Turn on the grid
% grid on; % or h.AxesGrid.Grid = "on"
% 
% filt_d = c2d(filt,Ts,'zoh');
% filt_d.Variable = 'z^-1'
% filt_d
% 
% figure; 
% bode(filt_d)
% h = gcr; % Get the handle for the "plot object root"
% % which is a structure containing the plot properties
% % Set frequency axis to Hz
% h.AxesGrid.Xunits = 'Hz';
% % Set mag axis to abs & phase axis to deg
% h.AxesGrid.Yunits = {'abs','deg'};
% % Turn on the grid
% grid on; % or h.AxesGrid.Grid = "on"
% 
% 
