% Example for forces subroutine

clear all;
close all;
clc;

% Agent matrix
agent = [0 1 2 3;0 1 2 3;0 0 0 0;1 1 1 1;1 1 1 1]

% ID of chosen agent on which we calculate the forces
alpha = 2;

[Fx_tot_alpha,Fy_tot_alpha] = force_on_alpha(agent,alpha)