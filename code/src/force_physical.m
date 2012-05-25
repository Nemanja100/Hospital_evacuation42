function [fpx,fpy] = force_physical(rx_alpha,ry_alpha,rx_beta,ry_beta,A_physical,B_physical,l_alpha,l_beta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Physical force between agent alpha and beta
% INPUT:
%     rx_alpha: position x of agent alpha
%     ry_alpha: position y of agent alpha
%     rx_beta: position x of agent beta
%     ry_beta: position y of agent beta
%     A_physical: interaction strength of physical force
%     B_physical: ragne of this repulsive force
%     l_alpha: radii of agent alpha
%     l_beta: radii of agent beta
% OUTPUT:
%     fpx: physical force in direction x
%     fpy: physical force in direction y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

l_alpha_beta = l_alpha + l_beta; % Total size of agent alpha and beta (sum of their raiis)

d_alpha_beta = distance_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta); % Distance between alpha and beta

[nx_alpha_beta,ny_alpha_beta] = n_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta); % Unity directional vector from beta to alpha

fp = A_physical.*exp((l_alpha_beta-d_alpha_beta)./B_physical); % Magnitude of the physical force
fpx = fp.*nx_alpha_beta; % x component of physical force
fpy = fp.*ny_alpha_beta; % y component of physical force

end