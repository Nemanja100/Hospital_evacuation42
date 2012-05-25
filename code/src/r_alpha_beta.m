function [rx_alpha_beta,ry_alpha_beta] = r_alpha_beta(rx_alpha,ry_alpha,rx_beta,ry_beta)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Vector distance between agent beta and alpha (going from beta to alpha)
% INPUT:
%     rx_alpha: position x of agent alpha
%     ry_alpha: position y of agent alpha
%     rx_beta: position x of agent beta
%     ry_beta: position y of agent beta
% OUTPUT:
%     rx_alpha_beta: distance between beta and alpha in direction x
%     ry_alpha_beta: distance between beta and alpha in direction y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rx_alpha_beta = rx_alpha - rx_beta;
ry_alpha_beta = ry_alpha - ry_beta;

end