%clear all
close all

rho_Al = 2.702 * 1000;   % Density of aluminum g/cm^3 * 1kg/1000g * 1.0e6cm^3*1m^3 = (kg/m^3)

% Servo Amplifier Parameters
Ka = 4;                  % Voltage Gain set by potentiometer on servo amplifier brick

% Maxon A-Max 26 Model 110953 
% Motor Parameters

Kt = 28.3 / 1000;        % Motor Torque Constant mNm/A / 1000 = Nm/A
Kb = 1/(337 * (2*pi/60));% Motor Back EMF (Speed) Constant 1/((rpm/V) * (2*pi/60)) = (volt-sec)/radian
Ja = 10.6 * 1.0e-07;    % Motor Armature Intertia (g*cm^2) *(1m^2/10000cm^2)*(1kg/1000g) = kg-m^2
% Ja = 10.6 * 1.0e-08;    % Motor Armature Intertia (g*cm^2) *(1m^2/10000cm^2)*(1kg/1000g) = kg-m^2

%b = 5.8e-006;            % Motors Viscous damping Coefficient (kg-m2/sec)
b = 1.8e-005            % Motors Viscous damping Coefficient (kg-m2/sec)
% b = 0                   % Motors Viscous damping Coefficient (kg-m2/sec)
%Ra = 17.9               % Motor Armature Resistance (Terminal Resistance) (Ohms)
Ra = 18.3 ;              % Actual Motor Armature Resistance (Terminal Resistance) (Ohms) (Measured)
Ra = 30
La = 1.69 / 1000;        % Motor Armature Inductance (Terminal Inductance) mH / 1000 = H (Henrys)


% Load Parameters
rho = rho_Al;            % Density of load disk (Aluminum)(kg/m^3)
h = 0.25 * 2.54/100;     % Thickness of Load Disk (in * 2.54cm/in * 1m/100cm )= m
rd = (3.0/2) * 2.54/100 % 3" Radius of Load Disk (in * 2.54cm/1in * 1m/100cm )= m
%rd = (2.5/2) * 2.54/100 % 2.5" Radius of Load Disk (in * 2.54cm/1in * 1m/100cm )= m
rd = (2.0/2) * 2.54/100 % 2" Radius of Load Disk (in * 2.54cm/1in * 1m/100cm )= m
% rd = 0;                 % No disk
Jl = (rho*pi*h*rd^4)/2;  % Load Inertia (1/2 Mass*radius^2) (kg/m^3*m*m^4 = kg-m^2)
%Jl=0;

% System Parameters
Jt = Ja + Jl;            % System Inertia - Assume a simple rigidly coupled motor & 
                        % load (no shaft dynamics)
CPR = 2000;              % Counts Per Armature Revolution Quadrature Decoded                        

%Controller Parameters
Kp = 0.01;               % PID continious time Proportional Gain 
Ki = 0 ;                 % PID continious time Integral Gain
Kd = 0;                  % PID continious time Differential Gain
SR = 300;                % Sampling rate for Discrete system (Hz)
Ts = 1/SR;               % Sampling period for Discrete system (Sec)

EndTime = 10

% The Transfer function (output position) / (input voltage)
nums = [0 0 0 Kt*Ka];
dens = [(La*Jt) (Ra*Jt + La*b) (Ra*b+Kb*Kt) 0];
%nums=17860*0.0024;
%dens=[0.01786 1 0];
%dens = [(Ra*Jt + La*b) (Ra*b+Kb*Kt) 0];

sys = tf(nums,dens);
pole(sys);

% Covert the Continious time model to the discrete time model
sysd = c2d(sys,Ts,'zoh');
figure(2)
t = 0:Ts:EndTime;
[y1,x] = step(sysd,t);
plot(x,y1)

%Controller transfer function
%Discrete PID Controller
%numcz = [Kp+(Ki*Ts*0.5)+((2*Kd)/Ts) (Ki*Ts)-(4*(Kd/Ts)) -Kp+(Ki*Ts*0.5)+((2*Kd)/Ts)]
%dencz = [1 0 -1]

%[dencz, numcz] = c2dm([1 0], [Kd Kp Ki], Ts, 'zoh') 
dencz = 1;
numcz = Kp;


sys_pid_z = tf(numcz,dencz,Ts) % PID discrete transfer function

%sys_fb = tf(1,Ts) % Feedback is unity gain
%sys_fb = tf(1) % Feedback is unity gain


OLsysz = Kp*(10/256)*sysd;

% Calculate the Closed Loop Transfer function
CLsysz = 2000*feedback(OLsysz,2000/(2*pi))/(2*pi);
%CLsysz = feedback(OLsysz,1);

% continious closed loop response
CLsyss = 2000*feedback(Kp*(10/256)*sys,2000/(2*pi))/(2*pi);
%CLsyss = feedback(Kp*sys,1);

% Calculate the Step Response
i=1;
i=i+1;
figure(i)
t = 0:Ts:EndTime;
[y1,x] = step(CLsysz,t);
%[y1,x] = dstep(CLsysz);
%subplot(2,1,1),
plot(x,y1)
grid on
xlabel('Time (seconds)')
ylabel('Position (Radians)')
titlestring = ['Discrete Step Response: Compensated, Disk Radius = ',num2str(rd),' m'];
title(titlestring);


%y2 = y1*CPR./(2*pi); % Convert to Revs
y2 = y1*CPR/(2*pi); % Convert to Revs

i=i+1;
figure(i)
%subplot(2,1,2),
plot(x,y2)
grid on
xlabel('Time (seconds)')
ylabel('Position (Counts)')
titlestring = ['Discrete Step Response: Compensated, Disk Radius = ',num2str(rd),' m'];
title(titlestring);


i=i+1;
figure(i)
%Ts=0.002;
t = 0:Ts:EndTime;

[y1,x] = step(CLsyss,t);
plot(x,y1)
grid on
xlabel('Time (seconds)')
ylabel('Position (rad)')
title('Stairstep Response:Original')
