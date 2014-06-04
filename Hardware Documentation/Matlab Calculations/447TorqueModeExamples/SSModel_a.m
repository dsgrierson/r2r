clear all; close all;
echo  on
% This M-File simulates a State Space Model for a DC Brush motor & Inertia Disk
% For:   Professor Neil Duffie - M.E. Dept.
%        Professor William Sethares - ECE 717
% This Project replaces both Midterm and Final Exams for ECE717
% Written by Erick L. Oberstar
% oberstar@cae.wisc.edu
%
% Fall 2002

% Create a state space model for the Maxom motor system with various inertial wheels.

format long

% Physics Constants
rho_Al = 2.702 * 1000   % Density of aluminum g/cm^3 * 1kg/1000g * 1.0e6cm^3*1m^3 = (kg/m^3)

% Servo Amplifier Parameters
Ka = 4                  % Voltage Gain set by potentiometer on servo amplifier brick

% Maxon A-Max 26 Model 110953 
% Motor Parameters

Kt = 28.3 / 1000        % Motor Torque Constant mNm/A / 1000 = Nm/A
Kb = 1/(337 * (2*pi/60))% Motor Back EMF (Speed) Constant 1/((rpm/V) * (2*pi/60)) = (volt-sec)/radian
Ja = 10.6 * 1.0e-007    % Motor Armature Intertia (g*cm^2) *(1m^2/10000cm^2)*(1kg/1000g) = kg-m^2
b = 5.8e-006            % Motors Viscous damping Coefficient (kg-m2/sec)
% b = 1.8e-005            % Motors Viscous damping Coefficient (kg-m2/sec)
% b = 0                   % Motors Viscous damping Coefficient (kg-m2/sec)
% Ra = 17.9               % Motor Armature Resistance (Terminal Resistance) (Ohms)
% Ra = 18.3               % Actual Motor Armature Resistance (Terminal Resistance) (Ohms) (Measured)
Ra = 30               % Actual Motor Armature Resistance (Terminal Resistance) (Ohms) (Measured)
La = 1.69 / 1000        % Motor Armature Inductance (Terminal Inductance) mH / 1000 = H (Henrys)


% Load Parameters
rho = rho_Al            % Density of load disk (Aluminum)(kg/m^3)
h = 0.25 * 2.54/100     % Thickness of Load Disk (in * 2.54cm/in * 1m/100cm )= m
% rd = (3.0/2) * 2.54/100 % 3" Radius of Load Disk (in * 2.54cm/1in * 1m/100cm )= m
% rd = (2.5/2) * 2.54/100 % 2.5" Radius of Load Disk (in * 2.54cm/1in * 1m/100cm )= m
rd = (2.0/2) * 2.54/100 % 2" Radius of Load Disk (in * 2.54cm/1in * 1m/100cm )= m
% rd = 0                 % No disk
Jl = (rho*pi*h*rd^4)/2  % Load Inertia (1/2 Mass*radius^2) (kg/m^3*m*m^4 = kg-m^2)

% System Parameters
Jt = Ja + Jl            % System Inertia - Assume a simple rigidly coupled motor & 
                        % load (no shaft dynamics)
CPR = 2000              % Counts Per Armature Revolution Quadrature Decoded                        
K_enc = CPR/(2*pi)      % Encoder Gain Counts/Radian
% K_enc = CPR      % Encoder Gain Counts/Rev

DA_SPN = 10             % Voltage Span of D/A Converter
DA_RES = 8              % Bits of DAC Resolution
K_da = DA_SPN/(2^DA_RES)% D/A converter gain


%Controller Parameters
SR = 300                % Sampling rate for Discrete system (Hz)
Ts = 1/SR               % Sampling period for Discrete system (Sec)
stepsize = 10           % # of Revolutions for Step 


% Since D/A converter & encoder are treated as gain factors they
% can just be included in the continious state space model.
A_theta_s = [-Ra/La 0 -Kb/La; 0 0 1; Kt/Jt 0 -b/Jt]
B_theta_s = [K_da*Ka/La; 0; 0]
C_theta_s = [0 K_enc 0]
D_theta_s = 0

echo off
% Check to see if the system is controllable and observable 
% if not - I'd be wasting my time.
Ctrl_theta_s = ctrb(A_theta_s,B_theta_s)
if rank(Ctrl_theta_s) == min(size(Ctrl_theta_s))
    disp('Controllable');
else
     disp('Uncontrollable');
end
Obs_theta_s = obsv(A_theta_s,C_theta_s)
if rank(Obs_theta_s) == min(size(Obs_theta_s))
    disp('Observable');
else
    disp('Unobservable');
end

% Just check to make sure the state space model is the same as the tf model
% generated by the Laplace method
[num_theta_s,den_theta_s] = ss2tf(A_theta_s, B_theta_s, C_theta_s, D_theta_s)
TF_theta_s = tf(num_theta_s,den_theta_s)
[z p k] = ss2zp(A_theta_s, B_theta_s, C_theta_s, D_theta_s)
ZPK_theta_s = zpk(z,p,k)

% Make a continious SS object
sys_theta_s = ss(A_theta_s, B_theta_s, C_theta_s, D_theta_s)

echo on

% The Velocity system for the motor and disk only (no dac/enc gains)
A_omega_s = [-Ra/La -Kb/La; Kt/Jt -b/Jt]
B_omega_s = [Ka/La; 0]
C_omega_s = [0 1]
D_omega_s = 0

echo off

[num_omega_s,den_omega_s] = ss2tf(A_omega_s, B_omega_s, C_omega_s, D_omega_s)

%sys_omega_s = tf(num_omega_s,den_omega_s)
sys_omega_s = ss(A_omega_s, B_omega_s, C_omega_s, D_omega_s)

% Calculate the systems frequency response
i = 0;
i=i+1;
figure(i)
%freqs(nums,dens);
bode(sys_theta_s);
grid on
titlestring = ['SS - Continious Bode Plot of Open Loop Position System: Rd = ',num2str(rd),' m'];
title(titlestring);

i=i+1;
figure(i)
[theta,t] = step(sys_theta_s/(K_da*(2*pi))); % multiply by 1/(K_da*2*pi) make step 1V Step with units Counts
% subplot(2,1,1), 
plot(t,theta) % Theta is in units of counts
grid on
xlabel('Time (seconds)')
ylabel('Position (Counts)')
titlestring = ['SS - Continious Open Loop Position System Step Resp.: Rd = ',num2str(rd),' m'];
title(titlestring);


i=i+1;
figure(i)
rlocus(sys_theta_s);
titlestring = ['SS - Continious Root Locus of Open Loop Position System: Rd = ',num2str(rd),' m'];
title(titlestring);
sgrid(.5,0)
sigrid(10)


% Velocity form of Transfer function
zeros_omega_s = roots(num_omega_s)
poles_omega_s = roots(den_omega_s)
%[Av,Bv,Cv,Dv] = tf2ss(numvs,denvs)

% Calculate the systems frequency response
i=i+1;
figure(i)
bode(sys_omega_s)
grid on
titlestring = ['SS - Continious Bode Plot of Open Loop Velocity System: Rd = ',num2str(rd),' m'];
title(titlestring);

i=i+1;
figure(i)
%zgrid('new')
rlocus(sys_omega_s);
titlestring = ['SS - Continious Root Locus of Open Loop Velocity System: Rd = ',num2str(rd),' m'];
title(titlestring);

i=i+1;
figure(i)
[w,t] = step(sys_omega_s);
w = w*60/(2*pi);
plot(t,w)
xlabel('Time (seconds)')
ylabel('Velocity (Rev/Min)')
titlestring = ['SS - Continious Open Loop Angular Velocity Step Resp.: Rd = ',num2str(rd),' m'];
title(titlestring)
grid on



% Covert the Continious time model to the discrete time model
[A_theta_z,B_theta_z,C_theta_z,D_theta_z] = c2dm(A_theta_s,B_theta_s,C_theta_s,D_theta_s,Ts,'zoh') % Position Model
% Fix B, D & C matrices to include D/A Gain and Encoder Gain
% if below comment out these terms were added into the continious model
% B_theta_z = K_da *2000/2/pi* B_theta_z
% D_theta_z = K_da * D_theta_z
% C_theta_z = K_enc * C_theta_z

%[A_omega_d, B_omega_d, C_omega_d, D_omega_d] = c2dm(A_omega_s, B_omega_s, C_omega_s, D_omega_s,Ts,'zoh') % Velocity Model

if rank(ctrb(A_theta_z,B_theta_z))==size(ctrb(A_theta_z,B_theta_z))
    disp('SS - The Open Loop Discrete Position State Space form IS Controllable')
else
    disp('SS - The Open Loop Discrete Position State Space form is NOT Controllable')
end
if rank(obsv(A_theta_z,C_theta_z))==size(obsv(A_theta_z,C_theta_z))
    disp('SS - The Open Loop Discrete Position State Space form IS Observable')
else
    disp('SS - The Open Loop Discrete Position State Space form is NOT Observable')
end

NumPts = 3000;
% [x1]=dstep(A_theta_z,2*pi*B_theta_z,C_theta_z,2*pi*D_theta_z,1,NumPts); % multiply B&D by 2pi rad to make step 1 full rev &  not just 1 rad
[x1]=dstep(A_theta_z,B_theta_z,C_theta_z,D_theta_z,1,NumPts); % multiply B&D by 2pi rad to make step 1 full rev &  not just 1 rad

x2 = x1./(2*pi); % Convert Radians to Revs

t=0:Ts:(NumPts-1)*Ts;
i=i+1;
figure(i)
subplot(2,1,1),
stairs(t,x1)
grid on
xlabel('Time (seconds)')
ylabel('Position (Radians)')
titlestring = ['SS - Discrete Open Loop Position Stairstep Resp.: Rd = ',num2str(rd),' m'];
title(titlestring)

%i=i+1;
%figure(i)
subplot(2,1,2), 
stairs(t,x2)
grid on
xlabel('Time (seconds)')
ylabel('Position (Revs)')
titlestring = ['SS - Discrete Open Loop Position Stairstep Resp.: Rd = ',num2str(rd),' m'];
title(titlestring)

% Perform pole assignment by negative state feedback
% Poles from simplemodel.m with 2"disk & Kp = 0.01
p1 = 0.99550079422763 + 0.02006305837086i
p2 = 0.99550079422763 - 0.02006305837086i
p3 = -0.00000012130233 

% Do pole assignment using state feedback to achieve same respons as with
% the P controller
Kc=place(A_theta_z,B_theta_z,[p1,p2,p3]);
A_theta_z_bar = A_theta_z - B_theta_z*Kc;

i=i+1;
figure(i)
% Introduce the Reference Input
% Recall that we don't compare the output to the reference; instead we measure all the states, 
% multiply by the gain vector Kc, and then subtract this result from the reference. There is no 
% reason to expect that K*x will be equal to the desired output. To eliminate this problem, we 
% can scale the reference input to make it equal to K*x_steadystate. This scale factor is often 
% called Nbar - Nbar is calculated by using the function rscale(A,B,C,D,K)
% from the Controls Tutorials for Matlab web page at
% http://www.engin.umich.edu/group/ctm/extras/rscale.html

Nbar=rscale(A_theta_z,B_theta_z,C_theta_z,D_theta_z,Kc)

% Calculate the step response of the state feedback system
[y,t] = step(ss(A_theta_z - B_theta_z*Kc, Nbar* B_theta_z, C_theta_z, D_theta_z,Ts));
% plot(t,y/2/pi)
plot(t,y)
grid on
xlabel('Time (seconds)')
% ylabel('Position (Radians)')
ylabel('Position (Revs)')
titlestring = ['SS - Discrete State Feedback Position Step Resp. (Ref Input): Rd = ',num2str(rd),' m'];
title(titlestring);

CLsyszSS = ss(A_theta_z_bar, B_theta_z, C_theta_z, D_theta_z,Ts)
eig(A_theta_z - B_theta_z*Kc) %verify eigs were assigned as desired


% Observer Design

% Perform pole assignment for observer by negative state feedback methods
% Very Fast Observer Poles (relative to State Feedback pole assignments)
% These cause the state estimation error to go to zero rapidly
op1 = 0.5 + 0.0201i;
op2 = 0.5 - 0.0201i;
op3 = 0;

% Slower Observer Poles - only a little faster than the State Feedback pole assignments
% These cause the state estimation error to go to zero slower but before
% the state goes to zero
op1 = 0.9550079422763 + 0.02006305837086i
op2 = 0.9550079422763 - 0.02006305837086i
op3 = -0.00000012130233 

% Place the observer poles in a similar manner to state feedback assignment
L = place(A_theta_z',C_theta_z',[op1 op2 op3])'; 
eig(A_theta_z-L*C_theta_z) % check to see if they were assigned properly

% The full system with state feedback using the is:
% This form is from the Controls Tutorials for Matlab website:
% http://www.engin.umich.edu/group/ctm/state/state.html
% Atz = [A_theta_z - B_theta_z*Kc      zeros(size(A_theta_z))
%      L*C_theta_z - B_theta_z*Kc     A_theta_z - L*C_theta_z];
% Btz = [B_theta_z*Nbar 
%       B_theta_z*Nbar];
% Ctz = [   C_theta_z        zeros(size(C_theta_z))];
% Dtz = D_theta_z

% This representation from Linear System Theory and Design
% by CHI-TSONG CHEN, State University of New York, Stony Brook P.254
dimA = length(A_theta_z); % A_theta_z is square so this is ok
Atz = [A_theta_z - B_theta_z*Kc  -B_theta_z*Kc
       zeros(dimA,dimA)          A_theta_z - L*C_theta_z];
Btz = [B_theta_z*Nbar 
       zeros(size(B_theta_z))];
Ctz = [C_theta_z  zeros(size(C_theta_z))];
Dtz = D_theta_z

FullSys = ss(Atz,Btz,Ctz,Dtz,Ts)

% Compute Full State Feedback / Observer system  Step repsonse and compare to transfer function method
i=i+1;
figure(i)
[y,t] = step(FullSys);  % Units are Revolutions
y_counts = y*CPR;
subplot(2,1,1), plot(t,y)
grid on
% xlabel('Time (seconds)')
ylabel('Position (Revs)')
titlestring = ['SS - Discrete State Feedback w/ Observer Position Step Resp.: Rd = ',num2str(rd),' m'];
title(titlestring);

subplot(2,1,2), plot(t,y_counts)
grid on
xlabel('Time (seconds)')
ylabel('Position (Counts)')
% titlestring = ['SS - State Feedback w/ Observer Position Step Resp.: Rd = ',num2str(rd),' m'];
% title(titlestring);

% Simulate State, State Estimation & State Estimation Error Convergence
i=i+1;
figure(i)
x0 = [0 1 0];

legend_pos = 0;  
% 0 = Automatic "best" placement (least conflict with data)
% 1 = Upper right-hand corner (default)
% 2 = Upper left-hand corner
% 3 = Lower left-hand corner
% 4 = Lower right-hand corner
% -1 = To the right of the plot

% Simulate State Convergence
FullSys2 = ss(Atz,Btz/Nbar,Ctz,Dtz,Ts)
[Y,T,X] = lsim(FullSys,zeros(size(t)),t,[x0 x0]);
plot(t,X(:,(1:3)))
grid on
xlabel('Time (seconds)')
ylabel('States')
legend('x0','x1','x2',legend_pos)
titlestring = ['SS - State Convergence V.S. Time: Rd = ',num2str(rd),' m'];
title(titlestring);

% Simulate State Error Convergence
i=i+1;
figure(i)
plot(t,X(:,(4:6)))
grid on
xlabel('Time (seconds)')
ylabel('State Errors')
legend('e0','e1','e2',legend_pos)
titlestring = ['SS - State Observer Error V.S. Time: Rd = ',num2str(rd),' m'];
title(titlestring);

% Simulate State Estimation Convergence
i=i+1;
figure(i)
plot(t,X(:,(1:3))-X(:,(4:6)))
xlabel('Time (seconds)')
ylabel('Estimated States')
legend('xhat0','xhat1','xhat2',legend_pos)
grid on
titlestring = ['SS - Observer Estimated States V.S. Time: Rd = ',num2str(rd),' m'];
title(titlestring);

% All State, State Estimation & State Estimation Error Convergences on same
% plot
i=i+1;
figure(i)
plot(t,[X (X(:,(1:3))-X(:,(4:6)))])
grid on
xlabel('Time (seconds)')
ylabel('States/State Error/Estimated States')
legend('x0','x1','x2','xhat0','xhat1','xhat2','e0','e1','e2',legend_pos)
titlestring = ['SS - Controller/Observer States & Errors V.S. Time: Rd = ',num2str(rd),' m'];
title(titlestring);


% Calculate the systems frequency response
i = 0;
i=i+1;
figure(i)
%freqs(nums,dens);
bode(FullSys);
grid on
titlestring = ['SS - Discrete Bode Plot of Closed Loop SFB/Obs System: Rd = ',num2str(rd),' m'];
title(titlestring);