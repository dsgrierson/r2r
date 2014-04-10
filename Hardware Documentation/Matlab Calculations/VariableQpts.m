%% Control System variable q-point calculations

clc; clear all; close all;

K_Current_Sense = 0.00620268620268620268620268620269 % Amps/Count
K_Current_Sense_FxdPt = Float2SignedQpt(K_Current_Sense,0.00001);

CurrentFB = 2047;
CuCurrentFB_FxdPt = Float2SignedQpt(CurrentFB,1);