%% Control System Modeling for the compliant contact roller control system
% Written by Erick Oberstar 5/15/2014
% Version 2 - Caleb Secrest 7/22/2014

clc; clear all; close all;
%%*************************************************************************
%% Physical System Definition

% Compute Gain for the PWM
PWM_res = 2000; % Number of counts for pwm
V_rail = 24;
K_PWM = PWM_res/V_rail; % Count/Volts

% Firgelli Actuator Force Model (Input Voltage - Output Force)
K_L12_Force = 0.00229181;          % A/N (Slope on Force vs Current Response)
% *********  Change to units of A and check saturation block again
L12_Offset_I = 0.012995; % A (Current Offset on Force vs Current Response)
Ra_L12 = 60; % Armature Resistance in Ohms of Firgelli

% SHOULD ADD PHYSICAL MASS TO THE SYSTEM TO IMPROVE NO-LOAD BEHAVIOR
% CALEB MULTIPLIED MASS BY 100.
Mar = 100*0.075; % Effective Mass of actuator & roller in Kg 
F_max = 60;  % Maximum Allowable Commanded Force [N]

% Compute Back-EMF Constant
voltage_applied = [1.5 4.5 7.5];
speed_at_voltage_applied = [0.6 2.16 3.7]; % mm/sec
i = [0.006 0.0085 0.011];
Vbackemf = (voltage_applied-(i*Ra_L12));
K_backemf_array = Vbackemf./speed_at_voltage_applied; % Units ov Volts-s/mm Volts/(mm/s}
K_backemf = 1000*mean( K_backemf_array ); %[Volt/(m/s)]

% Position Limits
Home = 0; % Home position (m)
L_Range = [0 0.050]; % Position Range of actuator (m)
ContactPoint = 0.005;%0.023; % Contact Position (m)
PositionCmdErr = -0.001;  % Modify command to see how controller behaves when
% the position command does not match the contact
% point

% Physical Damping (reducing model jitter)
bp = 1000;

% Contact Parameters
m_surf = 1e3;   %Contact Surface Mass [kg]
b_surf = 1e3;   %Contact Surface Damping [N-s/m]
k_surf = 1e7;   %Contact Surface Stiffness [N/m]

%% Position Sensor Stuff
POS = 0;
if POS
    % Compute Gain for Position Sensor
    R_nom_per_mm = 2750;                                        % Nominal Resistance in Ohms/mm
    R_tol = 0.3;                                                % Tolerance in % of the position feedback resistance
    R_lin = 0.01;                                               % Linearity of the Feedback potentiometer
    R_Range = R_nom_per_mm*[1+R_tol 1 1-R_tol];
    L_nom = 50;                                                 % length in mm
    R_MaxPos_Range = R_Range*L_nom;                             %
    
    % Actual Resistance doesn't matter - Position is Ratiometric from 0 Ohms to
    % full scale Ohms over the reference voltage so the pot location is just a
    % percentage from 0-100% over the length of the actuator across the ADC
    % reference voltage
    VPot_Range = [0 5]; % Position Pot Source Voltage Range
    
    L_Range_Const = [Home ContactPoint]; % Position Range of actuator is constrained by contact in mm
    K_L12_Pos_mm_per_volt = (max(L_Range)-min(L_Range))/...
        (max(VPot_Range)-min(VPot_Range)); % mm/Volt
    K_L12_Pos_m_per_volt = K_L12_Pos_mm_per_volt/1000; %Convert to m/Volt
    
    % Now lump in ADC Gain
    K_L12_Pos = K_L12_Pos_m_per_volt/K_ADC_9381; % meter/Volt / Counts/Volt = meters/count
end

% Analog Input Gain
K_ADC_9381 = (4095-0)/(5-0); % Counts/Volt

% Compute Gain of Force System (DCM460 2/ HPB-20 Transducer
g = 9.81; % acceleration of gravity on earth (m/s^2)
mass = [ 0 20]; % mass range in Kg
F = mass*g; % Compute Force Range
VRange = [ 0 3.7]; % Units of Volts
K_DCM460_HPB20 = (max(F)-min(F))/(max(VRange)-min(VRange)); % Units of Newton/Volt
K_ForceFB = K_DCM460_HPB20 / K_ADC_9381; % Newton/Volt / Counts/Volt = Newton/Count

%% Controller

% Sampling Frequency
fs = 1e3;
Ts = 1/fs;

%% Discrete Time Motion Controller Model
MOTION_CTRL = 1;
if MOTION_CTRL
    %Desired Bandwidth
    f_1 = 20; s_1 = 2*pi*f_1; z_1 = exp(-s_1*Ts);
    f_2 = f_1/3; s_2 = 2*pi*f_2; z_2 = exp(-s_2*Ts);
    f_3 = f_2/3; s_3 = 2*pi*f_3; z_3 = exp(-s_3*Ts);
    
    % Calculate Gains
    % Mass of the Actuator for decoupling purposes
    Mar_hat = Mar; 
    % Controller Active Damping calculation
    ba = (-(z_1*z_2*z_3)*Mar_hat + Mar_hat)/Ts; 
    % Controller Active Stiffness gain calculation
    ksa = (-(z_1*z_2 + z_1*z_3 + z_2*z_3)*Mar_hat + 3*Mar_hat - 2*Ts*ba)/(Ts^2);
    % Controller Integrated Stiffness gain calculation 
    kisa = (-(z_1 + z_2 + z_3)*Mar_hat + 3*Mar_hat - Ts*ba - (Ts^2)*ksa)/(Ts^3);
end

%% Discrete Time Motion Controller Model
MOTION_OBSR = 1;
if MOTION_OBSR
    %Desired Bandwidth
    f_1 = 30; s_1 = 2*pi*f_1; z_1 = exp(-s_1*Ts);
    f_2 = f_1/3; s_2 = 2*pi*f_2; z_2 = exp(-s_2*Ts);
    f_3 = f_2/3; s_3 = 2*pi*f_3; z_3 = exp(-s_3*Ts);
    
    % Calculate Gains
    % Estimate of Mass of the Actuator for decoupling purposes
    Mar_hat; % from above
    % Observer Active Stiffness gain calculation
    bo = (-(z_1*z_2*z_3)*Mar_hat + Mar_hat)/Ts;
    % Observer Active Stiffness gain calculation
    kso = (-(z_1*z_2 + z_1*z_3 + z_2*z_3)*Mar_hat + 3*Mar_hat - 2*Ts*bo)/(Ts^2);
    % Observer Integrated Stiffness gain calculation 
    kiso = (-(z_1 + z_2 + z_3)*Mar_hat + 3*Mar_hat - Ts*bo - (Ts^2)*kso)/(Ts^3);
    
    % Computed Torque Command Feedforward
    bp_hat = bp;    % Estimated physical damping
    Mar_hat = Mar;  % Estimated physical equivalent mass
    
end

%% Command State Filter
SF = 1;
if SF
    %Desired Poles
    f_1 = 1; s_1 = 2*pi*f_1; z_1 = exp(-s_1*Ts);
    f_2 = 1; s_2 = 2*pi*f_2; z_2 = exp(-s_2*Ts);
    
    k_2 = (2-(z_1+z_2))/Ts;
    k_1 = (z_1*z_2-1+k_2*Ts)/(k_2*Ts^2);
    
    % Velocity Limit
    v_lim = 0.003;
    % Acceleration Limit
    a_lim = 0.008;%F_max/Mar_hat;
end

%% Force Control
FORCE_CTRL = 1;
if FORCE_CTRL
    
    % Actuator Force Command
    F_act_cmd = 1;
    
    % Slew Rate for Ramping on Force Command
    F_ramp_slope = 5;
    
    % Force Control Activation Time
    F_time = 5;
    
    % Virtual Spring Stiffness
    kvc = 0.1; %[N/m]
    
    % Modulator for Virtual Spring Compression Command
    ymod = 0.75e-3;%.0075;
    
end

%% Simulate
%Simulation Model Configuration Parameters
StartTime = 0;
StopTime = 20;
MinStepSize = 1e-6;%0.0005;
MaxStepSize = 0.001;
RelTol = 1e-3;

CalebsModel_v5
set_param('CalebsModel_v5','AlgebraicLoopSolver','LineSearch')
sim('CalebsModel_v5')

% find all scope blocks as MATLAB figures & Set to autoscale:
set(0, 'showhiddenhandles', 'on')
scope = findobj(0, 'Tag', 'SIMULINK_SIMSCOPE_FIGURE');
for i=1:length(scope)
    % this is the callback of the "autoscale" button:
    simscope('ScopeBar', 'ActionIcon', 'Find', scope(i))
end
set(0, 'showhiddenhandles', 'off')

