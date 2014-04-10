%% Control System Modeling for the compliant contact roller control system

clc; clear all; close all;


% Design a low pass filter for the virtual compliance y* command signal

Ts = 40000/40e6 % from crio-FPGA-control\Globals\Global - Configuration Options.vi

fc = 500

filt = tf(1,[1/(2*pi*fc) 1])

figure; 
bode(filt)
h = gcr; % Get the handle for the "plot object root"
% which is a structure containing the plot properties
% Set frequency axis to Hz
h.AxesGrid.Xunits = 'Hz';
% Set mag axis to abs & phase axis to deg
h.AxesGrid.Yunits = {'abs','deg'};
% Turn on the grid
grid on; % or h.AxesGrid.Grid = "on"

filt_d = c2d(filt,Ts,'zoh')

figure; 
bode(filt_d)
h = gcr; % Get the handle for the "plot object root"
% which is a structure containing the plot properties
% Set frequency axis to Hz
h.AxesGrid.Xunits = 'Hz';
% Set mag axis to abs & phase axis to deg
h.AxesGrid.Yunits = {'abs','deg'};
% Turn on the grid
grid on; % or h.AxesGrid.Grid = "on"
