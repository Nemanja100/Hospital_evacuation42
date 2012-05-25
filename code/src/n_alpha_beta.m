function [nx_alpha_beta,ny_alpha_beta] = n_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Unity directional vector from agent beta to alpha
% INPUT:
%     rx_alpha: position x of agent alpha
%     ry_alpha: position y of agent alpha
%     rx_beta: position x of agent beta
%     ry_beta: position y of agent beta
% OUTPUT:
%     nx_alpha_beta: x component of unity directional vector
%     ny_alpha_beta: y component of unity directional vector
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[rx_alpha_beta,ry_alpha_beta] = r_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta); % Directional vector from beta to alpha
d_alpha_beta = distance_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta); % Distance between alpha and beta
nx_alpha_beta = rx_alpha_beta./d_alpha_beta; % Normalization of the directional vector
ny_alpha_beta = ry_alpha_beta./d_alpha_beta; % Normalization of the directional vector

end